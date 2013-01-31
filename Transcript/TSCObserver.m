//
//  TSCObserver.m
//  Transcript
//
//  Created by Ryan Davies on 30/01/2013.
//  Copyright (c) 2013 Ryan Davies. All rights reserved.
//

#import "TSCObserver.h"
#import "TSCReporter.h"
#import "INLInvocation.h"
#import "INLTest.h"

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
        return nil;
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

+ (INLTest *)testFromNotification:(NSNotification *)notification
{
    SenTestRun *run = [notification run];
    SenTestCase *testCase = (SenTestCase *)[run test];
    INLInvocation *invocation = (INLInvocation *)[testCase invocation];
    return [invocation test];
}

+ (NSMutableArray *)notifications
{
    static NSMutableArray *notifications = nil;
    if (notifications == nil) notifications = [NSMutableArray array];
    return notifications;
}

+ (void)testSuiteDidStart:(NSNotification *)notification
{
    NSLog(@"Active reporter: %s, %@", __PRETTY_FUNCTION__, [self activeReporter]);
    [[self activeReporter] suiteDidStart:[notification run]];
}

+ (void)testCaseDidStart:(NSNotification *)notification
{
    NSLog(@"Active reporter: %s, %@", __PRETTY_FUNCTION__, [self activeReporter]);
    [[self activeReporter] testDidStart:[self testFromNotification:notification] run:[notification run]];
}

+ (void)testCaseDidStop:(NSNotification *)notification
{
    NSLog(@"Active reporter: %s, %@", __PRETTY_FUNCTION__, [self activeReporter]);
    [[self activeReporter] testDidEnd:[self testFromNotification:notification] run:[notification run]];
}

+ (void)testCaseDidFail:(NSNotification *)notification
{
    NSLog(@"Active reporter: %s, %@", __PRETTY_FUNCTION__, [self activeReporter]);
    [[self activeReporter] testDidFail:[self testFromNotification:notification] run:[notification run]];
}

+ (void)testSuiteDidStop:(NSNotification *)notification
{
    NSLog(@"Active reporter: %s, %@", __PRETTY_FUNCTION__, [self activeReporter]);
    [[self activeReporter] suiteDidEnd:[notification run]];
}

@end
