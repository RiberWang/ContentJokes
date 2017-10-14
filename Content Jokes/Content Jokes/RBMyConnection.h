//
//  RBMyConnection.h
//  Content Jokes
//
//  Created by qianfeng on 15-1-23.
//  Copyright (c) 2015年 Riber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RBMyRequest.h"

@interface RBMyConnection : NSObject

+ (void)connectionWithUrl:(NSString *)url andFinishBlock:(FinishBlock)finish andFailedBlock:(FailedBlock)failed;

@end
