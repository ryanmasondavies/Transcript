//
//  TSCReporter.h
//  Transcript
//
//  Created by Ryan Davies on 30/01/2013.
//  Copyright (c) 2013 Ryan Davies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SenTestingKit/SenTestingKit.h>
@class INLTest;

/** An interface to which reporters must conform. */
@protocol TSCReporter <NSObject>

/** Invoked by TSCObserver when a suite has started.
 @param notification The notification sent by OCUnit. */
- (void)suiteDidStart:(NSNotification *)notification;

/** Invoked by TSCObserver when a test has started.
 @param notification The notification sent by OCUnit. */
- (void)testDidStart:(NSNotification *)notification;

/** Invoked by TSCObserver when a test has failed.
 @param notification The notification sent by OCUnit. */
- (void)testDidFail:(NSNotification *)notification;

/** Invoked by TSCObserver when a test has ended.
 @param notification The notification sent by OCUnit. */
- (void)testDidEnd:(NSNotification *)notification;

/** Invoked by TSCObserver when a suite has ended.
 @param notification The notification sent by OCUnit. */
- (void)suiteDidEnd:(NSNotification *)notification;

@end
