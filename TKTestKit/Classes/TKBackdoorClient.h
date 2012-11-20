//
//  TKFactorapiClient.h
//  TKTestKit
//
//  Created by Louis-Alban KIM on 15/11/12.
//
//

#import <Foundation/Foundation.h>

@interface TKBackdoorClient : NSObject

@property (nonatomic, strong) NSInputStream *inputStream;
@property (nonatomic, strong) NSOutputStream *outputStream;

- (id)initWithHostname:(NSString *)hostname port:(NSUInteger)port;
- (void)open;
- (void)close;
- (void)teardown;
- (BOOL)execute:(NSString *)code;
- (NSString *)readResponse;

@end
