//
//  RBDBManager.m
//  Content Jokes
//
//  Created by Riber on 15/4/16.
//  Copyright (c) 2015年 Riber. All rights reserved.
//

#import "RBDBManager.h"
#import "FMDatabase.h"
#import "RBContentModel.h"
#import "RBImageModel.h"

#define DBNAME @"ContentJokes.db"
#define DBNAME_COPY @"ContentJokesBak.db"

@implementation RBDBManager

+ (id)defalutDBManager {
    static RBDBManager *manager = nil;
    static dispatch_once_t predicate;
    // 保证线程安全
   dispatch_once(&predicate, ^{
       if (manager == nil) {
           manager = [[self alloc] init];
       }
   });
    return manager;
}

//+ (instancetype)allocWithZone:(struct _NSZone *)zone {
//    dispatch_once(&predicate, ^{
//        if (manager == nil) {
//            manager = [super allocWithZone:zone];
//        }
//    });
//    return manager;
//}

/*
    第二种方式获取沙盒路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path1 = [[paths objectAtIndex:0] stringByAppendingPathComponent:DBNAME];
 */

// 数据库备份
- (void)createBackUpSQLTable {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths[0] stringByAppendingPathComponent:DBNAME];
    NSString *pathBak = [paths[0] stringByAppendingPathComponent:DBNAME_COPY];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:pathBak]) {
        [fileManager removeItemAtPath:pathBak error:nil];
    }
    [fileManager copyItemAtPath:path toPath:pathBak error:nil];
}

// 删除数据库
- (void)deleteAllSQLTable {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *path = [paths[0] stringByAppendingPathComponent:DBNAME];
    NSString *pathBak = [paths[0] stringByAppendingPathComponent:DBNAME_COPY];

    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        [fileManager removeItemAtPath:path error:nil];
        [fileManager removeItemAtPath:pathBak error:nil];
    }
}

/************************ContentJokes 表*****************************/
// 创建ContentJokes表
- (BOOL)createContentJokes {
    // 1.获取数据库存储的路径(沙盒路径)
    NSString *path = [NSHomeDirectory() stringByAppendingString:[NSString stringWithFormat:@"/Documents/%@", DBNAME]];
    // 2.初始化fmdbManager
    FMDatabase *fmDatabase = [[FMDatabase alloc] initWithPath:path];
    // 3.打开数据库
    BOOL isOpen = [fmDatabase open];
    if (!isOpen) {
        NSLog(@"数据库打开失败!");
    } else {
        NSLog(@"数据库打开成功!");
    }
    
    // 4.创建表ContentJokes
    NSString *sql = @"create table if not exists ContentJokes(ID integer primary key autoincrement, name varchar(256), avatar blob, userid integer, groupid integer, content varchar(1024), digcount integer, burycount integer, commentcount integer)";
    if (isOpen && [fmDatabase executeUpdate:sql]) {
        NSLog(@"表ContentJokes创建成功!");
        return YES;
    } else {
        NSLog(@"表ContentJokes创建失败!");
        return NO;
    }
}

// 向数据库表中插入数据
- (void)insertModel:(RBContentModel *)model {
    NSString *sql = @"insert into ContentJokes(name, avatar, userid, groupid, content, digcount, burycount, commentcount) values(?, ?, ?, ?, ?, ?, ?, ?)";

    // 将 image 对象转化为数据库可存储对象 data 数据
    // 在读取图片数据内容时,建议优先使用UIImageJPEGRepresentation,并可根据自己的实际使用场景,设置压缩系数,进一步降低图片数据量大小
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:model.avatar_url]]];
    NSData *data = UIImageJPEGRepresentation(image, 0.5);
    
    // 1.获取数据库存储的路径(沙盒路径)
    NSString *path = [NSHomeDirectory() stringByAppendingString:[NSString stringWithFormat:@"/Documents/%@", DBNAME]];
    // 2.初始化fmdbManager
    FMDatabase *fmDatabase = [FMDatabase databaseWithPath:path];
    [fmDatabase beginTransaction];
    if (![fmDatabase open]) {
        NSLog(@"failed");
    }
    NSLog(@"content:%@", fmDatabase.lastError);
    if ([fmDatabase executeUpdate:sql, model.name, data, model.user_id, model.group_id, model.content, model.digg_count, model.bury_count, model.comment_count]) {
        NSLog(@"数据插入成功!");
    } else {
        NSLog(@"数据插入失败!");
    }
}

- (void)deleteModel:(RBContentModel *)model {
    NSString *sql = [NSString stringWithFormat:@"delete from ContentJokes where userid = '%@'", model.user_id];
    // 1.获取数据库存储的路径(沙盒路径)
    NSString *path = [NSHomeDirectory() stringByAppendingString:[NSString stringWithFormat:@"/Documents/%@", DBNAME]];
    // 2.初始化fmdbManager
    FMDatabase *fmDatabase = [FMDatabase databaseWithPath:path];
    if (![fmDatabase open]) {
        NSLog(@"failed");
    }
    if ([fmDatabase executeUpdate:sql]) {
        NSLog(@"数据删除成功!");
    } else {
        NSLog(@"数据删除失败!");
    }
}

- (void)recoveryDBTables
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths[0] stringByAppendingPathComponent:DBNAME];
    NSString *pathBak = [paths[0] stringByAppendingPathComponent:DBNAME_COPY];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:path]){
        [fileManager removeItemAtPath:path error:nil];
        NSLog(@"数据清除成功");
    }
    
    [fileManager copyItemAtPath:pathBak toPath:path error:nil];
}

// 查询内容段子
- (NSArray *)selectContentJokes {
    NSString *sql = @"select *from ContentJokes";
    // 1.获取数据库存储的路径(沙盒路径)
    NSString *path = [NSHomeDirectory() stringByAppendingString:[NSString stringWithFormat:@"/Documents/%@", DBNAME]];
    // 2.初始化fmdbManager
    FMDatabase *fmDatabase = [FMDatabase databaseWithPath:path];

    if (![fmDatabase open]) {
        NSLog(@"failed");
    }
    FMResultSet *set = [fmDatabase executeQuery:sql];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    while ([set next]) {
        RBContentModel *contentModel = [[RBContentModel alloc] init];
        contentModel.name = [set stringForColumn:@"name"];
        contentModel.avatarImage = [UIImage imageWithData:[set dataForColumn:@"avatar"]];
        contentModel.user_id = [NSNumber numberWithDouble:[set doubleForColumn:@"userid"]];
        contentModel.group_id = [NSNumber numberWithDouble:[set doubleForColumn:@"groupid"]];
        contentModel.content = [set stringForColumn:@"content"];
        contentModel.digg_count = [NSNumber numberWithDouble:[set doubleForColumn:@"digcount"]];
        contentModel.bury_count = [NSNumber numberWithDouble:[set doubleForColumn:@"burycount"]];
        contentModel.comment_count = [NSNumber numberWithDouble:[set doubleForColumn:@"commentcount"]];
        
        [array addObject:contentModel];
    }
           
    if (array.count <= 0) {
        return 0;
    }
    
    @autoreleasepool {
        for (int i = 0; i < array.count-1; i++) {
            for (int j = 0; j < array.count-1-i; j++) {
                [array exchangeObjectAtIndex:j withObjectAtIndex:j+1];
            }
        }
        
        return array;
    }
}

/************************ImageJokes 表*****************************/
// 创建ImageJokes表
- (BOOL)createImageJokes {
    // 1.获取数据库存储的路径(沙盒路径)
    NSString *path = [NSHomeDirectory() stringByAppendingString:[NSString stringWithFormat:@"/Documents/%@", DBNAME]];
    // 2.初始化fmdbManager
    FMDatabase *fmDatabase = [[FMDatabase alloc] initWithPath:path];
    [fmDatabase beginTransaction];

    // 3.打开数据库
    BOOL isOpen = [fmDatabase open];
    if (!isOpen) {
        NSLog(@"数据库打开失败!");
    } else {
        NSLog(@"数据库打开成功!");
    }
    
    // 4.创建表ImageJokes
    NSString *sql = @"create table if not exists ImageJokes(ID integer primary key autoincrement, name varchar(256), avatar blob, userid integer, groupid integer, content varchar(1024), contentimageurl varchar(512), contentimage blob, width integer, height integer, contentlargeimage blob, largewidth integer, largeheight, digcount integer, burycount integer, commentcount integer)";
    if (isOpen && [fmDatabase executeUpdate:sql]) {
        NSLog(@"表ImageJokes创建成功!");
        return YES;
    } else {
        NSLog(@"表ImageJokes创建失败!");
        return NO;
    }
}

// 向数据库表中插入数据
- (void)insertImageModel:(RBImageModel *)model {
    NSString *sql = @"insert into ImageJokes(name, avatar, userid, groupid, content, contentimageurl, contentimage, width, height, contentlargeimage, largewidth, largeheight, digcount, burycount, commentcount) values(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

    // 将 image 对象转化为数据库可存储对象 data 数据
    // 在读取图片数据内容时,建议优先使用UIImageJPEGRepresentation,并可根据自己的实际使用场景,设置压缩系数,进一步降低图片数据量大小
    UIImage *avatarImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:model.avatar_url]]];
    NSData *avatarData = UIImageJPEGRepresentation(avatarImage, 0.5);
    
    // 小图片
    UIImage *contentImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:model.url]]];
    NSData *contentData = UIImageJPEGRepresentation(contentImage, 0.5);
    
    // 大图片
    UIImage *contentLargeImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:model.largeUrl]]];
    NSData *contentLargeData = UIImageJPEGRepresentation(contentLargeImage, 0.5);
    
    NSString *path = [NSHomeDirectory() stringByAppendingString:[NSString stringWithFormat:@"/Documents/%@", DBNAME]];
    // 2.初始化fmdbManager
    FMDatabase *fmDatabase = [FMDatabase databaseWithPath:path];

    // 3.打开数据库
    if (![fmDatabase open]) {
        NSLog(@"failed!");
    }
    NSLog(@"image:%@", fmDatabase.lastError);

    if ([fmDatabase executeUpdate:sql, model.name, avatarData, model.user_id, model.group_id, model.content, model.url,contentData, model.width, model.height,contentLargeData, model.largeWidth, model.largeHeight, model.digg_count, model.bury_count, model.comment_count]) {
        NSLog(@"数据插入成功!");
    } else {
        NSLog(@"数据插入失败!");
    }
}

- (void)deleteImageModel:(RBImageModel *)model {
    NSString *sql = [NSString stringWithFormat:@"delete from ImageJokes where userid = '%@'", model.user_id];
    
    NSString *path = [NSHomeDirectory() stringByAppendingString:[NSString stringWithFormat:@"/Documents/%@", DBNAME]];
    // 2.初始化fmdbManager
    FMDatabase *fmDatabase = [FMDatabase databaseWithPath:path];
    // 3.打开数据库
    if (![fmDatabase open]) {
        NSLog(@"failed!");
    }

    if ([fmDatabase executeUpdate:sql]) {
        NSLog(@"数据删除成功!");
    } else {
        NSLog(@"数据删除失败!");
    }
}


// 查询内容段子
- (NSArray *)selectImageJokes {
    NSString *sql = @"select *from ImageJokes";
    
    NSString *path = [NSHomeDirectory() stringByAppendingString:[NSString stringWithFormat:@"/Documents/%@", DBNAME]];
    // 2.初始化fmdbManager
    FMDatabase *fmDatabase = [FMDatabase databaseWithPath:path];
    [fmDatabase beginTransaction];
    // 3.打开数据库
    if (![fmDatabase open]) {
        NSLog(@"failed!");
    }
    
    FMResultSet *set = [fmDatabase executeQuery:sql];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    while ([set next]) {
        RBImageModel *imageModel = [[RBImageModel alloc] init];
        imageModel.name = [set stringForColumn:@"name"];
        imageModel.avatarImage = [UIImage imageWithData:[set dataForColumn:@"avatar"]];
        imageModel.user_id = [set stringForColumn:@"userid"];
        imageModel.group_id = [NSNumber numberWithDouble:[set doubleForColumn:@"groupid"]];
        imageModel.content = [set stringForColumn:@"content"];
        imageModel.url = [set stringForColumn:@"contentimageurl"];
        imageModel.contentImage = [UIImage imageWithData:[set dataForColumn:@"contentimage"]];
        imageModel.width = [NSNumber numberWithInt:[set intForColumn:@"width"]];
        imageModel.height = [NSNumber numberWithInt:[set intForColumn:@"height"]];
        imageModel.contentLargeImage = [UIImage imageWithData:[set dataForColumn:@"contentlargeimage"]];
        imageModel.largeWidth = [NSNumber numberWithInt:[set intForColumn:@"largewidth"]];
        imageModel.largeHeight = [NSNumber numberWithInt:[set intForColumn:@"largeheight"]];
        imageModel.digg_count = [NSNumber numberWithDouble:[set doubleForColumn:@"digcount"]];
        imageModel.bury_count = [NSNumber numberWithDouble:[set doubleForColumn:@"burycount"]];
        imageModel.comment_count = [NSNumber numberWithDouble:[set doubleForColumn:@"commentcount"]];
        
        [array addObject:imageModel];
    }
    
    if (array.count <= 0) {
        return 0;
    }
    
    for (int i = 0; i < array.count-1; i++) {
        for (int j = 0; j < array.count-1-i; j++) {
            [array exchangeObjectAtIndex:j withObjectAtIndex:j+1];
        }
    }
    
    return array;
}

/************************VideoJokes 表*****************************/
// 创建VideoJokes表
- (BOOL)createVideoJokes {
    // 1.获取数据库存储的路径(沙盒路径)
    NSString *path = [NSHomeDirectory() stringByAppendingString:[NSString stringWithFormat:@"/Documents/%@", DBNAME]];
    // 2.初始化fmdbManager
    FMDatabase *fmDatabase = [[FMDatabase alloc] initWithPath:path];
    // 3.打开数据库
    BOOL isOpen = [fmDatabase open];
    if (!isOpen) {
        NSLog(@"数据库打开失败!");
    } else {
        NSLog(@"数据库打开成功!");
    }
    
    // 4.创建表ContentJokes
    NSString *sql = @"create table if not exists VideoJokes(ID integer primary key autoincrement, name varchar(256), avatar blob, userid integer, groupid integer, content varchar(1024), contentvideo blob, digcount integer, burycount integer, commentcount integer)";
    if (isOpen && [fmDatabase executeUpdate:sql]) {
        NSLog(@"表VideoJokes创建成功!");
        return YES;
    } else {
        NSLog(@"表VideoJokes创建失败!");
        return NO;
    }
}

/************************FindDetail 表*****************************/
// 创建FindDetail表
- (BOOL)createImageJokesFindDetail {
    // 1.获取数据库存储的路径(沙盒路径)
    NSString *path = [NSHomeDirectory() stringByAppendingString:[NSString stringWithFormat:@"/Documents/%@", DBNAME]];
    // 2.初始化fmdbManager
    FMDatabase *fmDatabase = [[FMDatabase alloc] initWithPath:path];
    [fmDatabase beginTransaction];
    
    // 3.打开数据库
    BOOL isOpen = [fmDatabase open];
    if (!isOpen) {
        NSLog(@"数据库打开失败!");
    } else {
        NSLog(@"数据库打开成功!");
    }
    
    // 4.创建表FindDetail
    NSString *sql = @"create table if not exists FindDetail(ID integer primary key autoincrement, name varchar(256), avatar blob, userid integer, groupid integer, content varchar(1024), contentimage blob, width integer, height integer, contentlargeimage blob, largewidth integer, largeheight, digcount integer, burycount integer, commentcount integer)";
    if (isOpen && [fmDatabase executeUpdate:sql]) {
        NSLog(@"表FindDetail创建成功!");
        return YES;
    } else {
        NSLog(@"表FindDetail创建失败!");
        return NO;
    }
}

// 向数据库表中插入数据
- (void)insertFindModel:(RBImageModel *)model {
    NSString *sql = @"insert into FindDetail(name, avatar, userid, groupid, content, contentimage, width, height, contentlargeimage, largewidth, largeheight, digcount, burycount, commentcount) values(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
    
    // 将 image 对象转化为数据库可存储对象 data 数据
    // 在读取图片数据内容时,建议优先使用UIImageJPEGRepresentation,并可根据自己的实际使用场景,设置压缩系数,进一步降低图片数据量大小
    UIImage *avatarImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:model.avatar_url]]];
    NSData *avatarData = UIImageJPEGRepresentation(avatarImage, 0.5);
    
    // 小图片
    UIImage *contentImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:model.url]]];
    NSData *contentData = UIImageJPEGRepresentation(contentImage, 0.5);
    
    // 大图片
    UIImage *contentLargeImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:model.largeUrl]]];
    NSData *contentLargeData = UIImageJPEGRepresentation(contentLargeImage, 0.5);
    
    NSString *path = [NSHomeDirectory() stringByAppendingString:[NSString stringWithFormat:@"/Documents/%@", DBNAME]];
    // 2.初始化fmdbManager
    FMDatabase *fmDatabase = [FMDatabase databaseWithPath:path];
    
    // 3.打开数据库
    if (![fmDatabase open]) {
        NSLog(@"failed!");
    }
    NSLog(@"image:%@", fmDatabase.lastError);
    
    if ([fmDatabase executeUpdate:sql, model.name, avatarData, model.user_id, model.group_id, model.content, contentData, model.width, model.height,contentLargeData, model.largeWidth, model.largeHeight, model.digg_count, model.bury_count, model.comment_count]) {
        NSLog(@"数据插入成功!");
    } else {
        NSLog(@"数据插入失败!");
    }
}

- (void)deleteFindModel:(RBImageModel *)model {
    NSString *sql = [NSString stringWithFormat:@"delete from FindDetail where userid = '%@'", model.user_id];
    
    NSString *path = [NSHomeDirectory() stringByAppendingString:[NSString stringWithFormat:@"/Documents/%@", DBNAME]];
    // 2.初始化fmdbManager
    FMDatabase *fmDatabase = [FMDatabase databaseWithPath:path];
    // 3.打开数据库
    if (![fmDatabase open]) {
        NSLog(@"failed!");
    }
    
    if ([fmDatabase executeUpdate:sql]) {
        NSLog(@"数据删除成功!");
    } else {
        NSLog(@"数据删除失败!");
    }
}


// 查询FindDetail
- (NSArray *)selectFindDetail {
    NSString *sql = @"select *from FindDetail";
    
    NSString *path = [NSHomeDirectory() stringByAppendingString:[NSString stringWithFormat:@"/Documents/%@", DBNAME]];
    // 2.初始化fmdbManager
    FMDatabase *fmDatabase = [FMDatabase databaseWithPath:path];
    [fmDatabase beginTransaction];
    // 3.打开数据库
    if (![fmDatabase open]) {
        NSLog(@"failed!");
    }
    
    FMResultSet *set = [fmDatabase executeQuery:sql];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    while ([set next]) {
        RBImageModel *imageModel = [[RBImageModel alloc] init];
        imageModel.name = [set stringForColumn:@"name"];
        imageModel.avatarImage = [UIImage imageWithData:[set dataForColumn:@"avatar"]];
        imageModel.user_id = [set stringForColumn:@"userid"];
        imageModel.group_id = [NSNumber numberWithDouble:[set doubleForColumn:@"groupid"]];
        imageModel.content = [set stringForColumn:@"content"];
        imageModel.contentImage = [UIImage imageWithData:[set dataForColumn:@"contentimage"]];
        imageModel.width = [NSNumber numberWithInt:[set intForColumn:@"width"]];
        imageModel.height = [NSNumber numberWithInt:[set intForColumn:@"height"]];
        imageModel.contentLargeImage = [UIImage imageWithData:[set dataForColumn:@"contentlargeimage"]];
        imageModel.largeWidth = [NSNumber numberWithInt:[set intForColumn:@"largewidth"]];
        imageModel.largeHeight = [NSNumber numberWithInt:[set intForColumn:@"largeheight"]];
        imageModel.digg_count = [NSNumber numberWithDouble:[set doubleForColumn:@"digcount"]];
        imageModel.bury_count = [NSNumber numberWithDouble:[set doubleForColumn:@"burycount"]];
        imageModel.comment_count = [NSNumber numberWithDouble:[set doubleForColumn:@"commentcount"]];
        
        [array addObject:imageModel];
    }
    
    if (array.count <= 0) {
        return 0;
    }
    
    for (int i = 0; i < array.count-1; i++) {
        for (int j = 0; j < array.count-1-i; j++) {
            [array exchangeObjectAtIndex:j withObjectAtIndex:j+1];
        }
    }
    
    return array;
}

@end
