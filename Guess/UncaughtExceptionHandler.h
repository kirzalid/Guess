//
//  UncaughtExceptionHandler.h
//  Guess
//
//  Created by Chris on 5/9/13.
//  Copyright (c) 2013 Chris. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UncaughtExceptionHandler : NSObject
{
	BOOL dismissed;
}
@end

void InstallUncaughtExceptionHandler();
