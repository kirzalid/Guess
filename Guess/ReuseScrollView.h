//
//  ReuseScrollView.h
//  hengxingJewelryShow
//
//  Created by lijun on 13-5-20.
//  Copyright (c) 2013年 lijun. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ReuseScrollViewDataSource;
@protocol ReuseScrollViewDelegate;

@interface ReuseScrollView : UIScrollView
{
    id<ReuseScrollViewDataSource> _dataSource;
}
@property (assign, nonatomic) NSUInteger currentPageIndex;
@property (nonatomic, assign) id<ReuseScrollViewDataSource> dataSource;
- (id)dequeueReusablePage;
- (void)reloadPages;

@end

@protocol ReuseScrollViewDataSource <NSObject>

- (NSUInteger)numberOfPagesInScrollView:(ReuseScrollView *)scrollView;
- (UIView *)scrollView:(ReuseScrollView *)scrollView pageAtIndex:(NSUInteger)index;

@end

@protocol ReuseScrollViewDelegate <UIScrollViewDelegate>

- (void)scrollView:(ReuseScrollView *)scrollView didMoveToPageAtIndex:(NSUInteger)index;

@end
