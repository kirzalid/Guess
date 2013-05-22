//
//  Tools.h
//  Test
//
//  Created by Chris on 4/28/13.
//  Copyright (c) 2013 Chris. All rights reserved.
//

#import <Foundation/Foundation.h>


//定义DMLOG只在调试的时候输出,发布版本不显示输出
#ifdef DEBUG

#define DMLog(...) NSLog(@"%s %@", __PRETTY_FUNCTION__, [NSString stringWithFormat:__VA_ARGS__])

#else

#define DMLog(...) do { } while (0)

#endif



@interface Tools : NSObject

//获取手机号码(私有方法) ,需要 CoreTelephony framework
+ (NSString *) phoneNumber;

//判断邮箱地址是否正确
+ (BOOL) validateEmail: (NSString*) email;

//16进制颜色(html颜色值)字符串转为UIColor   例如:#FF9900、0XFF9900 等颜色字符串
+ (UIColor *) colorWithHexString: (NSString *) stringToConvert;
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@end
