//
//  RBMyRequest.h
//  Content Jokes
//
//  Created by qianfeng on 15-1-23.
//  Copyright (c) 2015年 Riber. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^FinishBlock)(NSData *data);
typedef void(^FailedBlock)();

@interface RBMyRequest : NSObject<NSURLConnectionDataDelegate>

- (void)startRequest;

@property(nonatomic, copy) NSString *url;
@property(nonatomic, copy) FinishBlock finish;
@property(nonatomic, copy) FailedBlock failed;

@end
