//
//  RBMyConnection.m
//  Content Jokes
//
//  Created by qianfeng on 15-1-23.
//  Copyright (c) 2015年 Riber. All rights reserved.
//

#import "RBMyConnection.h"

@implementation RBMyConnection

+ (void)connectionWithUrl:(NSString *)url andFinishBlock:(FinishBlock)finish andFailedBlock:(FailedBlock)failed {
    RBMyRequest *request = [[RBMyRequest alloc] init];
    request.url = url;
    request.finish = finish;
    request.failed = failed;
    [request startRequest];
}

@end
