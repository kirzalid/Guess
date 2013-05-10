//
//  URLConnection.h
//  Guess
//
//  Created by Chris on 5/2/13.
//  Copyright (c) 2013 Chris. All rights reserved.
//


/*
 下载图片进度条
 */
#import <Foundation/Foundation.h>

@interface URLConnection : NSObject

-(void)start:(NSString *)urlStr;

@end
