//
//  TSCObserver.m
//  Transcript
//
//  Created by Ryan Davies on 30/01/2013.
//  Copyright (c) 2013 Ryan Davies. All rights reserved.
//

#import "TSCObserver.h"
#import "TSCReporter.h"
#import "TSCTidyReporter.h"

@implementation TSCObserver

+ (void)load
{
    [[NSUserDefaults standardUserDefaults] setObject:NSStringFromClass(self) forKey:SenTestObserverClassKey];
}

+ (id)activeReporter
{
    if ([[self reporters] count] > 0) {
        return [self reporters][0];
    } else {
        id reporter = [[TSCTidyReporter alloc] init];
        [self reporters][0] = reporter;
        return reporter;
    }
}

+ (void)setActiveReporter:(id <TSCReporter>)reporter
{
    if (reporter) self.reporters[0] = reporter; else [self.reporters removeAllObjects];
}

+ (NSMutableArray *)reporters
{
    // An array is used to potentially allow for muliple active reporters, though only one at a time is currently implemented.
    // It is also used so that setActiveReporter: and activeReporter have a shared, mutable access point to the same reporter instance.
    
    static NSMutableArray *reporters = nil;
    if (reporters == nil) reporters = [NSMutableArray array];
    return reporters;
}

+ (void)testSuiteDidStart:(NSNotification *)notification
{
    [[self activeReporter] suiteDidStart:notification];
}

+ (void)testCaseDidStart:(NSNotification *)notification
{
    [[self activeReporter] testDidStart:notification];
}

+ (void)testCaseDidStop:(NSNotification *)notification
{
    [[self activeReporter] testDidEnd:notification];
}

+ (void)testCaseDidFail:(NSNotification *)notification
{
    [[self activeReporter] testDidFail:notification];
}

+ (void)testSuiteDidStop:(NSNotification *)notification
{
    [[self activeReporter] suiteDidEnd:notification];
}

@end
