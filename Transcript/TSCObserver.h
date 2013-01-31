//
//  TSCObserver.h
//  Transcript
//
//  Created by Ryan Davies on 30/01/2013.
//  Copyright (c) 2013 Ryan Davies. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
@protocol TSCReporter;

/** Acts as an adapter for reporters. */
@interface TSCObserver : SenTestObserver

/** @return The currently active reporter which TSCObserver delegates messages to. */
+ (id <TSCReporter>)activeReporter;

/** @param reporter The active reporter to assign. */
+ (void)setActiveReporter:(id <TSCReporter>)reporter;

@end
