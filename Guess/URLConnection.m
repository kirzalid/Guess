//
//  URLConnection.m
//  Guess
//
//  Created by Chris on 5/2/13.
//  Copyright (c) 2013 Chris. All rights reserved.
//

#import "URLConnection.h"

@interface URLConnection () <NSURLConnectionDelegate,NSURLConnectionDataDelegate>
{
//    NSURLRequest *urlRequest;
//    NSURLConnection *urlConnection;
    long long int currentLength;
    long long int  totalLength;
}
-(void)start:(NSString *)urlStr;
@end

@implementation URLConnection

-(id)init
{
    self = [super init];
    if (self) {
//        urlRequest = [[NSURLRequest alloc]init];
//        urlConnection = [[NSURLConnection alloc]init];
    }
    return self;
}
-(void)start:(NSString *)urlStr
{
    if (!urlStr) {
        urlStr = @"http://pic.desk.chinaz.com/file/201211/5/shierybizi7.jpg";
    }
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    NSURLConnection *urlConnection = [[NSURLConnection alloc]initWithRequest:urlRequest delegate:self startImmediately:YES];
    if (urlConnection !=nil) {
        return;
    }
}


#pragma mark -
#pragma mark NSURLConnectionDataDelegate methods

// -------------------------------------------------------------------------------
//  connection:didReceiveResponse:response 通过response的响应，判断是否连接存在
// -------------------------------------------------------------------------------
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    NSLog(@"%s",__FUNCTION__);
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    if(httpResponse && [httpResponse respondsToSelector:@selector(allHeaderFields)]){
        NSDictionary *httpResponseHeaderFields = [httpResponse allHeaderFields];
        totalLength = [[httpResponseHeaderFields objectForKey:@"Content-Length"] longLongValue];
        NSLog(@"totalLength is %lld",totalLength);
    }
}


// -------------------------------------------------------------------------------
//  connection:didReceiveData:data，通过data获得请求后，返回的数据，数据类型NSData
// -------------------------------------------------------------------------------
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
//    NSLog(@"%s",__FUNCTION__);
//    NSLog(@" ~~ %d ",data.length);
    
    currentLength += data.length;
    float progress_f = currentLength/(double)totalLength;
    
    NSLog(@" %lld / %lld  进度 %f ",currentLength,totalLength,progress_f);
    
}
// -------------------------------------------------------------------------------
//  connection:didFailWithError:error 返回的错误信息
// -------------------------------------------------------------------------------

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    NSLog(@"%s",__FUNCTION__);
}

// -------------------------------------------------------------------------------
//  connectionDidFinishLoading:connection 数据请求完毕，这个时候，用法是多线程的时候，通过这个通知，关部子线程
// -------------------------------------------------------------------------------
-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    NSLog(@"%s",__FUNCTION__);
}

@end
