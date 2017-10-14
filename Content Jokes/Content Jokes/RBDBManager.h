//
//  RBDBManager.h
//  Content Jokes
//
//  Created by Riber on 15/4/16.
//  Copyright (c) 2015年 Riber. All rights reserved.
//

#import <Foundation/Foundation.h>
@class RBContentModel;
@class RBImageModel;

@interface RBDBManager : NSObject

+ (id)defalutDBManager;
- (void)createBackUpSQLTable;
- (void)deleteAllSQLTable;
- (void)recoveryDBTables;

// ContentJokes
- (BOOL)createContentJokes;
- (void)insertModel:(RBContentModel *)model;
- (void)deleteModel:(RBContentModel *)model;
- (NSArray *)selectContentJokes;

// ImageJokes
- (BOOL)createImageJokes;
- (void)insertImageModel:(RBImageModel *)model;
- (void)deleteImageModel:(RBImageModel *)model;
- (NSArray *)selectImageJokes;

// VideoJokes
- (BOOL)createVideoJokes;

// FindDetail
- (BOOL)createImageJokesFindDetail;
- (void)insertFindModel:(RBImageModel *)model;
- (void)deleteFindModel:(RBImageModel *)model;
- (NSArray *)selectFindDetail;

@end
