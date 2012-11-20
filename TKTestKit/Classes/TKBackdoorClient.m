//
//  TKBackdoorClient.m
//  TKTestKit
//
//  Created by Louis-Alban KIM on 15/11/12.
//
//

#import "TKBackdoorClient.h"

@implementation TKBackdoorClient

@synthesize inputStream;
@synthesize outputStream;

- (id)initWithHostname:(NSString *)hostname port:(NSUInteger)port {
    self = [super init];
    
    if (self) {
        CFReadStreamRef readStream;
        CFWriteStreamRef writeStream;
        CFStringRef host = (CFStringRef)CFBridgingRetain(hostname);
        CFStreamCreatePairWithSocketToHost(NULL, host, port, &readStream, &writeStream);
        CFRelease(host);
        self.inputStream = (NSInputStream *)CFBridgingRelease(readStream);
        self.outputStream = (NSOutputStream *)CFBridgingRelease(writeStream);
    }
    return self;
}

- (void)open {
    [self.inputStream open];
    [self.outputStream open];
}

- (void)close {
    [self.inputStream close];
    [self.outputStream close];
}

- (void)teardown {
    [self execute:@"clean"];
}

- (BOOL)execute:(NSString *)code {
    code = [NSString stringWithFormat:@"%@\n", code];
	NSData *data = [[NSData alloc] initWithData:[code dataUsingEncoding:NSASCIIStringEncoding]];
	[self.outputStream write:[data bytes] maxLength:[data length]];
    NSString *response = [self readResponse];
    if (response && [response isEqualToString:@"ok\n"]) {
        return YES;
    }
    return NO;
}

- (NSString *)readResponse {
    uint8_t buffer[1024];
    unsigned int len = 0;
    
    len = [(NSInputStream *)self.inputStream read:buffer maxLength:sizeof(buffer)];
    if (len > 0) {
        NSString *input = [[NSString alloc] initWithBytes:buffer length:len encoding:NSASCIIStringEncoding];
        
        if (input) {
            return input;
        }
    }
    return nil;
}

@end
