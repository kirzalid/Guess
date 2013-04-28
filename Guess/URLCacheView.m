//
//  URLCacheView.m
//  Guess
//
//  Created by Chris on 4/28/13.
//  Copyright (c) 2013 Chris. All rights reserved.
//

#import "URLCacheView.h"

@implementation URLCacheView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.frame = CGRectMake(20, 100, 100, 60);
        [button setTitle:@"开始请求" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma mark - Mark Begin

-(void) buttonPress:(id) sender
{
    NSString *paramURLAsString= @"http://www.baidu.com/";
    if ([paramURLAsString length] == 0){
        NSLog(@"Nil or empty URL is given");
        return;
    }
    NSURLCache *urlCache = [NSURLCache sharedURLCache];
    /* 设置缓存的大小为1M*/
    [urlCache setMemoryCapacity:1*1024*1024];
    //创建一个nsurl
    NSURL *url = [NSURL URLWithString:paramURLAsString];
    //创建一个请求
    NSMutableURLRequest *request =
    [NSMutableURLRequest
     requestWithURL:url
     cachePolicy:NSURLRequestUseProtocolCachePolicy
     timeoutInterval:60.0f];
    //从请求中获取缓存输出
    NSCachedURLResponse *response =
    [urlCache cachedResponseForRequest:request];
    //判断是否有缓存
    if (response != nil){
        NSLog(@"如果有缓存输出，从缓存中获取数据");
        [request setCachePolicy:NSURLRequestReturnCacheDataDontLoad];
    }
    _connection = nil;
    /* 创建NSURLConnection*/
    NSURLConnection *newConnection =
    [[NSURLConnection alloc] initWithRequest:request
                                    delegate:self
                            startImmediately:YES];
    _connection = newConnection;
    //    [newConnection release];
}

- (void)  connection:(NSURLConnection *)connection
  didReceiveResponse:(NSURLResponse *)response{
    NSLog(@"将接收输出");
}
- (NSURLRequest *)connection:(NSURLConnection *)connection
             willSendRequest:(NSURLRequest *)request
            redirectResponse:(NSURLResponse *)redirectResponse{
    NSLog(@"即将发送请求");
    return(request);
}
- (void)connection:(NSURLConnection *)connection
    didReceiveData:(NSData *)data{
    NSLog(@"接受数据");
    NSLog(@"数据长度为 = %lu", (unsigned long)[data length]);
}
- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse *)cachedResponse{
    NSLog(@"将缓存输出");
    return(cachedResponse);
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    NSLog(@"请求完成");
}
- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error{
    NSLog(@"请求失败");
}

#pragma mark End

@end
