//
//  TKAsyncTestCaseTests.m
//  TKTestKit
//
//  Created by Arnaud Coomans on 19/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TKAsyncTestCaseTests.h"

@implementation TKAsyncTestCaseTests

- (void)testAsyncWaitForDelay {
	
	NSDate *date = [NSDate date];
	
	[self asyncWaitForDelay:3];
	
	STAssertTrue([[NSDate date] timeIntervalSinceDate:date] < 5, @"Async test waited for too long");
	STAssertTrue([[NSDate date] timeIntervalSinceDate:date] > 2, @"Async test didn't wait long enough");
}

- (void)testAsyncWaitForLongDelay {
	
	[self performSelector:@selector(unblock) withObject:nil afterDelay:3];
	
	[self asyncWaitForDelay:10 before:^{
		
	} after:^{
		STFail(@"Async test didn't wait long enough");
	}];
}


- (void)testAsyncWaitForShortDelay {
	
	[self performSelector:@selector(unblock) withObject:nil afterDelay:10];
	
	[self asyncWaitForDelay:3 before:^{
		STFail(@"Async test didn't wait long enough");
	} after:^{
		
	}];
}

- (void)testAsyncMultipleWaitForDelay {
	
	NSDate *date = [NSDate date];
	[self asyncWaitForDelay:3];
	STAssertTrue([[NSDate date] timeIntervalSinceDate:date] < 5, @"Async test waited for too long");
	STAssertTrue([[NSDate date] timeIntervalSinceDate:date] > 2, @"Async test didn't wait long enough");
	
	date = [NSDate date];
	[self asyncWaitForDelay:3];
	STAssertTrue([[NSDate date] timeIntervalSinceDate:date] < 5, @"Async test waited for too long");
	STAssertTrue([[NSDate date] timeIntervalSinceDate:date] > 2, @"Async test didn't wait long enough");
	
	date = [NSDate date];
	[self asyncWaitForDelay:3];
	STAssertTrue([[NSDate date] timeIntervalSinceDate:date] < 5, @"Async test waited for too long");
	STAssertTrue([[NSDate date] timeIntervalSinceDate:date] > 2, @"Async test didn't wait long enough");
}


#pragma mark - helpers

- (void)unblock {
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(unblock) object:nil];
	[self asyncContinue];
}

@end
