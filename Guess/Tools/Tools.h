//
//  Tools.h
//  Test
//
//  Created by Chris on 4/28/13.
//  Copyright (c) 2013 Chris. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tools : NSObject

//获取手机号码(私有方法) ,需要 CoreTelephony framework
+(NSString *) phoneNumber;

//判断邮箱地址是否正确
+(BOOL)validateEmail:(NSString*)email;

@end
