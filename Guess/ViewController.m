//
//  ViewController.m
//  Guess
//
//  Created by Chris on 4/28/13.
//  Copyright (c) 2013 Chris. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController


-(NSString *)timeOfToday:(NSString *)dateStr{
    NSLog(@"dateStr==%@",dateStr);
    //    dateStr = @"2013-05-18";
    //    NSString *dateStr=[dic objectForKey:@"date"];// 2012-05-17 11:23:23
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSUInteger unitFlags = NSMonthCalendarUnit | NSDayCalendarUnit;
    NSDateFormatter *format=[[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd HH"];
    NSDate *fromdate=[format dateFromString:dateStr];
    NSTimeZone *fromzone = [NSTimeZone systemTimeZone];
    NSInteger frominterval = [fromzone secondsFromGMTForDate: fromdate];
    NSDate *fromDate = [fromdate  dateByAddingTimeInterval: frominterval];
    NSLog(@"fromdate=%@",fromDate);
//    [format release];
    NSDate *date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    NSLog(@"enddate=%@",localeDate);
    NSDateComponents *components = [gregorian components:unitFlags fromDate:fromDate toDate:localeDate options:0];
    NSInteger months = [components month];
    NSInteger days = [components day];//年[components year]
    NSLog(@"month=%d",months);
    NSLog(@"days=%d",days);
//    [gregorian release];
    
    if (months==0&&days==1) {
        return @"昨天";
    }else if(months==0&&days==0) {
        return @"今天";
    }else{
        return  nil;
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSLog(@"start here");
    
    NSLog(@"color is %@",self.view.backgroundColor);
    
    NSLog(@" data is %@",[self timeOfToday:@"2013-05-18 18"]);
    
//    [Tools phoneNumber];
    
    
//    NSArray *array = [NSArray arrayWithObject:@"HaHa"];
//	NSLog(@"%@", [array objectAtIndex:1]);
    
//    URLConnection *urlConnection = [[URLConnection alloc]init];
//    [urlConnection start:nil];
    
    NSString *strText = @"问:我用Windows 8ReleasePreview（发布预览版），设置了虚拟WiFi，但iP...答:①：win键+R打开运行程序，输入cmd并回车打开命令指令符 ②：在命令指令符中输入 netsh wlan set hostednetwork mode=allow ssid=???????key=????????? 然后回车其中???内容可以自己设定，ssid是wifi名，key是你连接wifi所需的密码 ③：确保无线网络打开（一般笔记本上会有无线网络打开的指示灯） ④：打开控制面板---网络和Internet---网络和共享...";
    UIFont *font = [UIFont systemFontOfSize:15];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 50, 100, 60)];
    label.text = strText;
    label.backgroundColor = [UIColor blueColor];
    label.numberOfLines = 0;
    label.font = font;
//    label.lineBreakMode = UILineBreakModeCharacterWrap;
    [self.view addSubview:label];
    
    
    CGSize size = CGSizeMake( label.frame.size.width, 2000 );
    CGSize labelsize = [strText sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByTruncatingTail];
    CGRect rect = CGRectMake(0, 0, labelsize.width, labelsize.height);
    
    label.frame = CGRectMake(10, -rect.size.height + 430, 100, rect.size.height);
    NSLog(@" frame is %@",NSStringFromCGRect(rect));
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
