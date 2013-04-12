// The MIT License
// 
// Copyright (c) 2013 Ryan Davies
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

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
