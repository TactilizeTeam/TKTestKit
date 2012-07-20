//
//  TKTestCase.h
//  TactilizeKit
//
//  Created by Arnaud Coomans on 04/07/12.
//  Copyright (c) 2012 Tactilize. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>


/** TKTestCase is a class to do asynchronous testing. It may be used to test delay-prone operations like network requests or blocks.
 *
 * To use, call _asyncContinue_ in any asynchronous code. Finally, put either _asyncFailAfterDelay:message:_ or _asyncFailAfterDelay:_ or _asyncWaitForDelay:_ at the end of your test case. Example:
 *
 * 		- (void)testAsync {
 *			[someObject doSomethingAndOnSuccess:^(NSArray *pages) {
 *				STAssertTrue(..., @"oops, this is wrong");
 *				[self asyncContinue];
 *			}
 *			onFailure:^(NSError *error) {
 *				NSLog(@"%@", error);
 *				STFail(@"Woops, couldn't be worse");
 *				[self asyncContinue];
 *			}
 *			];
 *			[self asyncFailAfterDelay:60];
 *		}
 */

@interface TKAsyncTestCase : SenTestCase {
	dispatch_semaphore_t _semaphore;
}


/** @name Async test setup */

/** Prepare for a asynchronous test.
 */
- (void)asyncPrepare;

/** @name Async test signaling */

/** Continue a asynchronous test, unblocking the thread.
 */
- (void)asyncContinue;

/** @name Async test waiting */

/** Block the thread and make an assertion fail after a delay with a custom message.
 */
- (void)asyncFailAfterDelay:(NSUInteger)seconds message:(NSString*)failMessage;

/** Block the thread and make an assertion fail after a delay.
 */
- (void)asyncFailAfterDelay:(NSUInteger)seconds;

/** Block the thread and unblock it after a delay.
 */
- (void)asyncWaitForDelay:(NSUInteger)seconds;

/** Block the thread and unblock it after a delay. 
 * Run _before_ if the thread is unblocked before the delay (by _asyncContinue_).
 * Run _after_ if the thread unblocks after the delay.
 */
- (void)asyncWaitForDelay:(NSUInteger)seconds before:(void(^)())before after:(void(^)())after;

@end
