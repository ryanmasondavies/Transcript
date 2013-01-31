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

- (NSString *)prefixForRun:(SenTestRun *)run
{
    if ([run hasSucceeded] == NO) return @"[F]";
    return @"";
}

- (void)log:(NSString *)message
{
    printf("%s\n", [message cStringUsingEncoding:NSASCIIStringEncoding]);
}

- (void)suiteDidStart:(NSNotification *)notification
{
    [self log:[NSString stringWithFormat:@"%@ started.", [notification test]]];
    [self log:@""];
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
    [self log:[NSString stringWithFormat:@"%@\t%@", [self prefixForRun:[notification run]], [notification test]]];
}

- (void)suiteDidEnd:(NSNotification *)notification
{
    if ([self.failures count] > 0) {
        [self log:@""];
        [self.failures enumerateObjectsUsingBlock:^(NSNotification *notification, NSUInteger idx, BOOL *stop) {
            NSException *exception = [notification exception];
            [self log:[NSString stringWithFormat:@"[F] %@", [notification test]]];
            [self log:[NSString stringWithFormat:@"\t%@:%@: %@", [exception filePathInProject], [exception lineNumber], [exception reason]]];
        }];
    }
    
    [self log:@""];
    [self log:[NSString stringWithFormat:@"%@ ended.", [notification test]]];
    
    [[self failures] removeAllObjects];
}

@end
