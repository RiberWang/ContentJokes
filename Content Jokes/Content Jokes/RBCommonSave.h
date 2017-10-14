//
//  RBCommonSave.h
//  Content Jokes
//
//  Created by riber on 15/12/14.
//  Copyright (c) 2015年 Riber. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RBCommonSave : NSObject

+ (id)defaultCommonSave;

- (BOOL)writeMessageOfArray:(id)arrayOrDic toSandBoxWithFileName:(NSString *)fileName; // 写入文件 是 数组 否 字典
- (id)readMessageOfArray:(BOOL)isArray fromSandBoxWithFileName:(NSString *)fileName; // 读取文件
- (BOOL)deleteMessageWithFile; // 删除文件夹

@end
