//
//  TKTestCase.m
//  TactilizeKit
//
//  Created by Arnaud Coomans on 04/07/12.
//  Copyright (c) 2012 Tactilize. All rights reserved.
//

#import "TKAsyncTestCase.h"

static NSUInteger TKAsyncTestCaseLoopInterval = 1;

@implementation TKAsyncTestCase

- (void)asyncPrepare {
	_semaphore = dispatch_semaphore_create(0);
}

- (void)asyncContinue {
	dispatch_semaphore_signal(_semaphore);
}

- (void)asyncFailAfterDelay:(NSUInteger)seconds message:(NSString*)failMessage {	
	[self asyncWaitForDelay:seconds 
					 before:^{
						 // do nothing
					 } 
					  after:^{
						  STFail(failMessage);		
					  }
	 ];
}

- (void)asyncFailAfterDelay:(NSUInteger)seconds {
	[self asyncFailAfterDelay:seconds message:@"Async test failed to finish before delay"];
}

- (void)asyncWaitForDelay:(NSUInteger)seconds {
	[self asyncWaitForDelay:seconds 
					 before:^{
						// do nothing
					 	} 
					  after:^{
						// do nothing		
						}
	 ];
}

- (void)asyncWaitForDelay:(NSUInteger)seconds before:(void(^)())before after:(void(^)())after {
	NSDate *date = [NSDate date];
	while (dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_NOW)) {
		[[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode 
								 beforeDate:[NSDate dateWithTimeIntervalSinceNow:TKAsyncTestCaseLoopInterval]];
		if ([[NSDate date] timeIntervalSinceDate:date] > seconds) {
			after();
			return;
		}
	}
	before();
}

@end
