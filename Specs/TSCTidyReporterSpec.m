//
//  TSCTidyReporterSpec.m
//  Transcript
//
//  Created by Ryan Davies on 31/01/2013.
//  Copyright (c) 2013 Ryan Davies. All rights reserved.
//

SpecBegin(TSCTidyReporter)

__block TSCTidyReporter *reporter;
__block NSMutableString *log;
__block id notification;
__block id run;

id (^mockNotification)(NSString*, NSException*) = ^(NSString *name, NSException *exception) {
    id notification = [OCMockObject niceMockForClass:[NSNotification class]];
    id run = [OCMockObject niceMockForClass:[SenTestRun class]];
    id test = [OCMockObject niceMockForClass:[SenTestCase class]];
    [(NSNotification *)[[notification stub] andReturn:run] run];
    [[[notification stub] andReturn:test] test];
    if (name) [[[test stub] andReturn:name] name];
    if (exception) [[[notification stub] andReturn:exception] exception];
    return notification;
};

before(^{
    reporter = [OCMockObject partialMockForObject:[TSCTidyReporter new]];
    log = [NSMutableString string];
    notification = mockNotification(@"name", nil);
    [[[(id)reporter stub] andCall:@selector(appendString:) onObject:log] log:OCMOCK_ANY];
});

when(@"a suite starts", ^{
    it(@"should report the suite has started", ^{
        [reporter suiteDidStart:notification];
        expect(log).to.contain(@"name started");
    });
    
    it(@"should end with a newline", ^{
        [reporter suiteDidStart:notification];
        expect([log hasSuffix:@"\n"]).to.beTruthy();
    });
});

when(@"a test passes", ^{
    before(^{
        id run = [(NSNotification *)notification run];
        [[[run stub] andReturnValue:OCMOCK_VALUE((BOOL){YES})] hasSucceeded];
    });
    
    void(^action)(void) = ^(void) {
        [reporter testDidStart:notification];
        [reporter testDidEnd:notification];
    };
    
    it(@"should indent test names", ^{
        action();
        expect(log).to.contain(@"\tname");
    });
    
    it(@"should end test names with a newline", ^{
        action();
        expect(log).to.contain(@"name\n");
    });
});

when(@"a test fails", ^{
    before(^{
        id run = [(NSNotification *)notification run];
        [[[run stub] andReturnValue:OCMOCK_VALUE((BOOL){NO})] hasSucceeded];
    });
    
    void (^action)(void) = ^(void) {
        [reporter testDidStart:notification];
        [reporter testDidEnd:notification];
    };
    
    it(@"should prefix failing tests with [F]", ^{
        action();
        expect([log hasPrefix:@"[F]"]).to.beTruthy();
    });
    
    it(@"should indent failing test names", ^{
        action();
        expect(log).to.contain(@"\tname");
    });
    
    it(@"should end with a newline", ^{
        action();
        expect([log hasSuffix:@"\n"]).to.beTruthy();
    });
});

when(@"a suite ends", ^{
    it(@"should report the suite has ended", ^{
        [reporter suiteDidEnd:notification];
        expect(log).to.contain(@"name ended");
    });
    
    it(@"should end with a newline", ^{
        [reporter suiteDidEnd:notification];
        expect([log hasSuffix:@"\n"]).to.beTruthy();
    });
    
    when(@"tests have failed", ^{
        __block NSArray *lines;
        
        void (^action)(void) = ^(void) {
            NSArray *exceptions = @[
                [NSException exceptionWithName:@"SomeException" reason:@"some reason" userInfo:@{SenTestFilenameKey:@(__FILE__), SenTestLineNumberKey:@(20)}],
                [NSException exceptionWithName:@"SomeOtherException" reason:@"some other reason" userInfo:nil]
            ];
            
            NSArray *notifications = @[
                mockNotification(@"some test", exceptions[0]),
                mockNotification(@"some other test", exceptions[1])
            ];
            
            [reporter testDidStart:notifications[0]];
            [reporter testDidFail:notifications[0]];
            [reporter testDidEnd:notifications[0]];
            
            [reporter testDidStart:notifications[1]];
            [reporter testDidFail:notifications[1]];
            [reporter testDidEnd:notifications[1]];
            
            [reporter suiteDidEnd:notification];
            
            lines = [log componentsSeparatedByString:@"\n"];
        };
        
        it(@"should prefix failed test names with `[F]`", ^{
            action();
            expect(log).to.contain(@"F\tsome test");
            expect(log).to.contain(@"F\tsome other test");
        });
        
        it(@"should indent failed test names", ^{
            action();
            expect(log).to.contain(@"\tsome test");
            expect(log).to.contain(@"\tsome other test");
        });
        
        it(@"should end test names with a newline", ^{
            action();
            expect(log).to.contain(@"some test\n");
            expect(log).to.contain(@"some other test\n");
        });
    });
});

SpecEnd
