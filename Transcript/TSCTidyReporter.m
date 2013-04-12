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
