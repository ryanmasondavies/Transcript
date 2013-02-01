//
//  TSCTidyReporter.h
//  Transcript
//
//  Created by Ryan Davies on 31/01/2013.
//  Copyright (c) 2013 Ryan Davies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TSCReporter.h"

/** The default reporter class. Outputs test results in a more readable format than the SenTestingKit default, by indenting tests and displaying failures after each suite has ended. */
@interface TSCTidyReporter : NSObject <TSCReporter>

/** Writes a message to the debugger.
 @param message The message to write to the debugger. */
- (void)log:(NSString *)message;

@end
