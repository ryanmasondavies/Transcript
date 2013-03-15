SpecBegin(TSCObserver)

__block id reporter;
__block id notification;

before(^{
    reporter = [OCMockObject mockForProtocol:@protocol(TSCReporter)];
    notification = [OCMockObject mockForClass:[NSNotification class]];
});

it(@"should override the default SenTestObserver class in NSUserDefaults in +load", ^{
    expect([[NSUserDefaults standardUserDefaults] objectForKey:SenTestObserverClassKey]).to.equal(@"TSCObserver");
});

describe(@"+activeReporter", ^{
    it(@"should be an instance of TSCTidyReporter", ^{
        expect([TSCObserver activeReporter]).to.beKindOf([TSCTidyReporter class]);
    });
});

describe(@"+testSuiteDidStart:", ^{
    __block id originalReporter;
    before(^{ originalReporter = [TSCObserver activeReporter]; [TSCObserver setActiveReporter:reporter]; });
    after(^{ [TSCObserver setActiveReporter:originalReporter]; });
    
    it(@"should forward to active reporter's -suiteDidStart:", ^{
        [[reporter expect] suiteDidStart:notification];
        [TSCObserver testSuiteDidStart:notification];
        [reporter verify];
    });
});

describe(@"+testStepDidStart:", ^{
    __block id originalReporter;
    before(^{ originalReporter = [TSCObserver activeReporter]; [TSCObserver setActiveReporter:reporter]; });
    after(^{ [TSCObserver setActiveReporter:originalReporter]; });
    
    it(@"should forward to active reporter's -testDidStart:", ^{
        [[reporter expect] testDidStart:notification];
        [TSCObserver testCaseDidStart:notification];
        [reporter verify];
    });
});

describe(@"+testStepDidFail:", ^{
    __block id originalReporter;
    before(^{ originalReporter = [TSCObserver activeReporter]; [TSCObserver setActiveReporter:reporter]; });
    after(^{ [TSCObserver setActiveReporter:originalReporter]; });
    
    it(@"should forward to active reporter's -testDidFail:", ^{
        [[reporter expect] testDidFail:notification];
        [TSCObserver testCaseDidFail:notification];
        [reporter verify];
    });
});

describe(@"+testStepDidStop:", ^{
    __block id originalReporter;
    before(^{ originalReporter = [TSCObserver activeReporter]; [TSCObserver setActiveReporter:reporter]; });
    after(^{ [TSCObserver setActiveReporter:originalReporter]; });
    
    it(@"should forward to active reporter's -testDidEnd:", ^{
        [[reporter expect] testDidEnd:notification];
        [TSCObserver testCaseDidStop:notification];
        [reporter verify];
    });
});

describe(@"+testSuiteDidStop:", ^{
    __block id originalReporter;
    before(^{ originalReporter = [TSCObserver activeReporter]; [TSCObserver setActiveReporter:reporter]; });
    after(^{ [TSCObserver setActiveReporter:originalReporter]; });
    
    it(@"should forward to active reporter's -suiteDidEnd:", ^{
        [[reporter expect] suiteDidEnd:notification];
        [TSCObserver testSuiteDidStop:notification];
        [reporter verify];
    });
});

SpecEnd
