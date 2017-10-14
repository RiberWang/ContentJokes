//
//  RBCommonSave.m
//  Content Jokes
//
//  Created by riber on 15/12/14.
//  Copyright (c) 2015年 Riber. All rights reserved.
//

#import "RBCommonSave.h"

@implementation RBCommonSave

static RBCommonSave *saveManager;
static dispatch_once_t predicate;

+ (id)defaultCommonSave {
    dispatch_once(&predicate, ^{
        if (saveManager == nil) {
            saveManager = [[RBCommonSave alloc] init];
        }
    });
    
    return saveManager;
}

- (BOOL)writeMessageOfArray:(id)arrayOrDic toSandBoxWithFileName:(NSString *)fileName {
    
    // 每个用户用一个文件夹 没登陆的默认一个文件夹
    NSArray *filePaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);

    NSString *filePath = [filePaths[0] stringByAppendingFormat:@"/Temp/%@", fileName];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:filePath];
    if (existed) {
        if ( [fileManager removeItemAtPath:filePath error:nil]) {
            if ([arrayOrDic writeToFile:filePath atomically:YES]) {
                return YES;
            }
            else{
                return NO;
            }
        }
    }
    else
    {
        if ([arrayOrDic writeToFile:filePath atomically:YES]) {
            return YES;
        }
        else{
            if ([NSKeyedArchiver archiveRootObject:arrayOrDic toFile:filePath]) {
                return YES;
            };
            return NO;
        }
    }
    return NO;
}

- (id)readMessageOfArray:(BOOL)isArray fromSandBoxWithFileName:(NSString *)fileName {
    NSArray *filePaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *file = [filePaths[0] stringByAppendingFormat:@"/Temp"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];

    [fileManager createDirectoryAtPath:file withIntermediateDirectories:YES attributes:nil error:nil];
    
    NSString *filePath = [filePaths[0] stringByAppendingFormat:@"/Temp/%@", fileName];

    BOOL existed = [fileManager fileExistsAtPath:filePath];
    if (existed) {
        
        if (isArray) {
            if ([NSArray arrayWithContentsOfFile:filePath]) {
                return [NSArray arrayWithContentsOfFile:filePath];
            }
            return  [NSArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithFile:filePath]];
        }
        else
        {
            return [NSDictionary dictionaryWithContentsOfFile:filePath];
        }
    }
    else
    {
        return nil;
    }
}

- (BOOL)deleteMessageWithFile {
    NSArray *filePaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *filePath = [filePaths[0] stringByAppendingFormat:@"/Temp"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:filePath];
    BOOL isDel;
    if (existed) {
       isDel = [fileManager removeItemAtPath:filePath error:nil];
    }
    
    return isDel;
}

@end
