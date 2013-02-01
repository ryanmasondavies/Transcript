//
//  TSCTidyReporter.m
//  Transcript
//
//  Created by Ryan Davies on 31/01/2013.
//  Copyright (c) 2013 Ryan Davies. All rights reserved.
//

#import "TSCTidyReporter.h"

@interface TSCTidyReporter ()
@property (strong, nonatomic) NSMutableArray *failures;
@end

@implementation TSCTidyReporter

- (id)init
{
    if (self = [super init]) {
        self.failures = [NSMutableArray array];
    }
    return self;
}

- (void)log:(NSString *)message
{
    printf("%s", [message cStringUsingEncoding:NSASCIIStringEncoding]);
}

- (NSString *)prefixForRun:(SenTestRun *)run
{
    if ([run hasSucceeded] == NO) return @"[F]";
    return @"";
}

- (void)suiteDidStart:(NSNotification *)notification
{
    [self log:[NSString stringWithFormat:@"%@ started.\n", [[notification test] name]]];
}

- (void)testDidStart:(NSNotification *)notification
{
}

- (void)testDidFail:(NSNotification *)notification
{
    [self.failures addObject:notification];
}

- (void)testDidEnd:(NSNotification *)notification
{
    [self log:[NSString stringWithFormat:@"%@\t%@\n", [self prefixForRun:[notification run]], [[notification test] name]]];
}

- (void)suiteDidEnd:(NSNotification *)notification
{
    if ([self.failures count] > 0) {
        [self log:@"\n"];
        [self.failures enumerateObjectsUsingBlock:^(NSNotification *notification, NSUInteger idx, BOOL *stop) {
            NSException *exception = [notification exception];
            [self log:[NSString stringWithFormat:@"[F] %@\n", [[notification test] name]]];
            [self log:[NSString stringWithFormat:@"\t%@:%@: %@\n", [exception filePathInProject], [exception lineNumber], [exception reason]]];
        }];
        [self log:@"\n"];
    }
    
    [self log:[NSString stringWithFormat:@"%@ ended.\n", [[notification test] name]]];
    [self log:@"\n"];
    
    [[self failures] removeAllObjects];
}

@end
