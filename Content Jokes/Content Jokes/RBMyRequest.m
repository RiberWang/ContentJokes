//
//  RBMyRequest.m
//  Content Jokes
//
//  Created by qianfeng on 15-1-23.
//  Copyright (c) 2015年 Riber. All rights reserved.
//

#import "RBMyRequest.h"

@interface RBMyRequest () {
    NSMutableData *_mData;
}

@end

@implementation RBMyRequest

- (void)startRequest {
    _mData = [[NSMutableData alloc] init];
    // 将带有汉字的网址转化为NSUTF8StringEncoding
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[_url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] cachePolicy:0 timeoutInterval:10];
    [NSURLConnection connectionWithRequest:request delegate:self];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_mData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    if (self.finish) {
        self.finish(_mData);
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    if (self.failed) {
        self.failed();
    }
}

@end
