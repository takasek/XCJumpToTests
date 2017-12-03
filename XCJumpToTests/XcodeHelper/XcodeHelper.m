//
//  XcodeHelper.m
//  XcodeHelper
//
//  Created by Yoshitaka Seki on 2017/12/03.
//  Copyright © 2017年 takasek. All rights reserved.
//

#import "XcodeHelper.h"

@implementation XcodeHelper

// This implements the example protocol. Replace the body of this class with the implementation of this service's protocol.
- (void)upperCaseString:(NSString *)aString withReply:(void (^)(NSString *))reply {
    NSString *response = [aString uppercaseString];
    reply(response);
}

@end
