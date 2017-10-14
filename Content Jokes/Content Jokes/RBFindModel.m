//
//  RBFindModel.m
//  Content Jokes
//
//  Created by qianfeng on 15-1-30.
//  Copyright (c) 2015年 Riber. All rights reserved.
//

#import "RBFindModel.h"

@implementation RBFindModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.placeholder = [aDecoder decodeObjectForKey:@"placeholder"];
        self.icon = [aDecoder decodeObjectForKey:@"icon"];

        self.name = [aDecoder decodeObjectForKey:@"name"];

        self.categoryId = [NSNumber numberWithInteger:[aDecoder decodeIntegerForKey:@"categoryId"]];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.placeholder forKey:@"placeholder"];
    
    [aCoder encodeObject:self.icon forKey:@"icon"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeInteger:self.categoryId.integerValue  forKey:@"categoryId"];
}

@end
