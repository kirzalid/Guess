//
//  ReuseScrollView.m
//  hengxingJewelryShow
//
//  Created by lijun on 13-5-20.
//  Copyright (c) 2013年 lijun. All rights reserved.
//

#import "ReuseScrollView.h"

static const NSInteger kSidePages = 1;

@interface ReuseScrollView () {
    
    BOOL _rearangePages;
    NSInteger _prevPageIndex;
    NSInteger _maxPages;
    NSInteger _centerPageIndex;
    NSInteger _noOfPages;
}

@property (strong, nonatomic) NSMutableArray *pages;
@property (strong, nonatomic) NSMutableArray *pagesQueue;

- (void *)performSelector:(SEL)aSelector withValue:(void *)value1 withValue:(void *)value2 onTarget:(id)target;
- (void)commonInit;
- (BOOL)dataSourceRespondsToProtocol;
- (BOOL)delegateRespondsToProtocol;
- (NSInteger)pageIndexForArrayIndex:(NSUInteger)index centerPageIndex:(NSUInteger)centerPage;
- (NSInteger)arrayIndexForPageIndex:(NSUInteger)index centerPageIndex:(NSUInteger)centerPage;
- (void)cachePagesFrom:(NSInteger)from to:(NSInteger)to;
- (void)addPagesFrom:(NSInteger)from to:(NSInteger)to withShift:(NSInteger)shift;
- (void)rearangePagesWithCurrentPageIndex:(NSInteger)newCenterPage;
- (void)rearangePages;
- (void)pageDidChange:(NSNotification *)notification;

@end

@implementation ReuseScrollView
@synthesize dataSource = _dataSource;
@synthesize pages = _pages;
@synthesize pagesQueue = _pagesQueue;

//@private
- (void *)performSelector:(SEL)aSelector withValue:(void *)value1 withValue:(void *)value2 onTarget:(id)target
{
    NSInvocation *inv = [NSInvocation invocationWithMethodSignature:[target methodSignatureForSelector:aSelector]];
    [inv setSelector:aSelector];
    [inv setTarget:target];
    [inv setArgument:value1 atIndex:2];
    [inv setArgument:value2 atIndex:3];
    [inv invoke];
    
    NSUInteger length = [[inv methodSignature] methodReturnLength];
    
    // If method is non-void:
    if (length > 0) {
        void *buffer = (void *)malloc(length);
        [inv getReturnValue:buffer];
        return buffer;
    }
    
    // If method is void:
    return NULL;
}
- (void)commonInit
{
    self.pagingEnabled = YES;
    _rearangePages = YES;
    _maxPages = (kSidePages*2)+1;
    self.pages = [[NSMutableArray alloc] initWithCapacity:_maxPages];
    self.pagesQueue = [[NSMutableArray alloc] initWithCapacity:_maxPages];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pageDidChange:) name:nil object:self];
}

- (BOOL)dataSourceRespondsToProtocol
{
    return
    ([self.dataSource respondsToSelector:@selector(numberOfPagesInScrollView:)]
     &&
     [self.dataSource respondsToSelector:@selector(scrollView:pageAtIndex:)])
    ? YES : NO;
}

- (BOOL)delegateRespondsToProtocol
{
    return
    ([self.delegate respondsToSelector:@selector(scrollView:didMoveToPageAtIndex:)])
    ? YES : NO;
}

- (NSInteger)pageIndexForArrayIndex:(NSUInteger)index centerPageIndex:(NSUInteger)centerPage
{
    return centerPage-kSidePages+index;
}

- (NSInteger)arrayIndexForPageIndex:(NSUInteger)index centerPageIndex:(NSUInteger)centerPage
{
    return index-centerPage+kSidePages;
}

- (void)cachePagesFrom:(NSInteger)from to:(NSInteger)to
{
    NSMutableIndexSet *pagesToRemoveIndexes = [[NSMutableIndexSet alloc] init];
    
    NSInteger arrayIndexFrom = [self arrayIndexForPageIndex:from centerPageIndex:_centerPageIndex];
    NSInteger arrayIndexTo = [self arrayIndexForPageIndex:to centerPageIndex:_centerPageIndex];
    
    for (NSInteger i=arrayIndexFrom; i<=arrayIndexTo; i++)
    {
        if (i>=0 && i<self.pages.count)
        {
            id page = [self.pages objectAtIndex:i];
            if ((NSNull *)page != [NSNull null]) {
                
                [self.pagesQueue addObject:page];
                [page removeFromSuperview];
            }
            [pagesToRemoveIndexes addIndex:i];
        }
    }
    
    [self.pages removeObjectsAtIndexes:pagesToRemoveIndexes];
}

- (void)addPagesFrom:(NSInteger)from to:(NSInteger)to withShift:(NSInteger)shift
{
    NSInteger arrayIndexFrom = [self arrayIndexForPageIndex:from centerPageIndex:_centerPageIndex+shift];
    NSInteger arrayIndexTo = [self arrayIndexForPageIndex:to centerPageIndex:_centerPageIndex+shift];
    
    for (NSInteger i=arrayIndexFrom; i<=arrayIndexTo; i++)
    {
        if (i>=0 && i<=self.pages.count)
        {
            NSInteger pageIndex = [self pageIndexForArrayIndex:i centerPageIndex:_centerPageIndex+shift];
            if (pageIndex>=0 && pageIndex<_noOfPages)
            {
                //                NSLog(@"Adding page at page index %d", pageIndex);
                ReuseScrollView *v = self;
                NSUInteger value = pageIndex;
                NSUInteger *pointerToValue = &(value);
                void **p = [self performSelector:@selector(scrollView:pageAtIndex:) withValue:&v withValue:pointerToValue onTarget:self.dataSource];
                UIView *page = (UIView *)*p;
                free(p);
                //                UIView *page = (UIView *)[self.dataSource performSelector:@selector(scrollView:pageAtIndex:) withObject:self withObject:[NSNumber numberWithInt:pageIndex]];
                [page setFrame:CGRectMake(self.frame.size.width*pageIndex, 0, page.frame.size.width, page.frame.size.height)];
                [self.pages insertObject:page atIndex:i];
                [self addSubview:page];
            }
            else
            {
                //                NSLog(@"Adding [NSNull null] at array index %d", i);
                [self.pages insertObject:[NSNull null] atIndex:i];
            }
        }
    }
    //    NSLog(@"\n");
}

- (void)rearangePagesWithCurrentPageIndex:(NSInteger)currentPage
{
    if (!self.dataSourceRespondsToProtocol) return;
    
    NSInteger shift = currentPage - _centerPageIndex;
    if (shift == 0) return;
    
    NSInteger cacheFrom = 0, cacheTo = 0, addFrom = 0, addTo = 0;
    
    NSInteger firstObjectIndex = _centerPageIndex-kSidePages;
    NSInteger lastObjectIndex = _centerPageIndex+kSidePages;
    
    if (shift > 0) {
        
        cacheFrom = firstObjectIndex;
        cacheTo = cacheFrom+shift-1;
        addFrom = currentPage-kSidePages-1 <= lastObjectIndex ? lastObjectIndex+1 : firstObjectIndex+shift;
        addFrom = firstObjectIndex+shift > lastObjectIndex ? firstObjectIndex+shift : lastObjectIndex+1;
        addTo = lastObjectIndex + shift;
    }
    else if (shift < 0) {
        
        cacheFrom = lastObjectIndex-abs(shift)+1;
        cacheTo = cacheFrom+abs(shift)-1;
        addFrom = firstObjectIndex-abs(shift);
        addTo = lastObjectIndex-abs(shift) < firstObjectIndex ? lastObjectIndex-abs(shift) : firstObjectIndex-1;
    }
    
    //caching existing pages
    [self cachePagesFrom:cacheFrom to:cacheTo];
    
    //adding new pages
    [self addPagesFrom:addFrom to:addTo withShift:shift];
    
    [self.pagesQueue removeAllObjects];
}

- (void)rearangePages
{
    [self rearangePagesWithCurrentPageIndex:self.currentPageIndex];
}

- (void)pageDidChange:(NSNotification *)notification
{
    if (![self delegateRespondsToProtocol]) return;
    //    NSLog(@"%d %d %d", self.currentPageIndex, _centerPageIndex, _prevPageIndex);
    if (self.currentPageIndex != _centerPageIndex && self.currentPageIndex != _prevPageIndex) {
        
        ReuseScrollView *v = self;
        NSUInteger value = self.currentPageIndex;
        NSUInteger *pointerToValue = &(value);
        [self performSelector:@selector(scrollView:didMoveToPageAtIndex:) withValue:&v withValue:pointerToValue onTarget:self.delegate];
        //        free(pointerToValue);
        
        //        NSLog(@"currentPageIndex %d", [self currentPageIndex]);
        if (_rearangePages == YES) [self rearangePages];
        _rearangePages = YES;
        _centerPageIndex = self.currentPageIndex;
        _prevPageIndex = self.currentPageIndex;
    }
}

//@public
- (id)init
{
    self = [super init];
    if (self) [self commonInit];
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) [self commonInit];
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) [self commonInit];
    return self;
}

- (NSUInteger)currentPageIndex
{
    return (int)(self.contentOffset.x / self.frame.size.width);
}

-(void)setCurrentPageIndex:(NSUInteger)currentPageIndex
{
    [self rearangePagesWithCurrentPageIndex:currentPageIndex];
    _rearangePages = NO;
    [self setContentOffset:CGPointMake(self.frame.size.width*currentPageIndex, 0) animated:NO];
}

- (void)setDataSource:(id<ReuseScrollViewDataSource>)dataSource
{
    _dataSource = dataSource;
    [self reloadPages];
}

- (id)dequeueReusablePage
{
    if ([self.pagesQueue count] > 0) {
        
        id page = [self.pagesQueue lastObject];
        [self.pagesQueue removeLastObject];
        return page;
    }
    return nil;
}

- (void)reloadPages
{
    if (![self dataSourceRespondsToProtocol]) return;
    
    _centerPageIndex = self.currentPageIndex;
    
    //caching existing pages
    [self cachePagesFrom:[self pageIndexForArrayIndex:0 centerPageIndex:_centerPageIndex] to:[self pageIndexForArrayIndex:self.pages.count-1 centerPageIndex:_centerPageIndex]];
    
    _noOfPages = (NSInteger)[self.dataSource performSelector:@selector(numberOfPagesInScrollView:) withObject:self];
    
    if (self.currentPageIndex >= _noOfPages) self.currentPageIndex = _noOfPages-1;
    
    [self setContentSize:CGSizeMake(self.frame.size.width*_noOfPages, self.frame.size.height)];
    
    //adding new pages
    [self addPagesFrom:_centerPageIndex-kSidePages to:_centerPageIndex+kSidePages withShift:0];
    
    [self.pagesQueue removeAllObjects];
}

- (void)setFrame:(CGRect)frame
{
    //    NSInteger oldWidth = (NSInteger)self.frame.size.width;
    [super setFrame:frame];
    
    //    _noOfPages = (NSInteger)[self.dataSource performSelector:@selector(numberOfPagesInScrollView:) withObject:self];
    //    _rearangePages = NO;
    //
    //    for (UIView *page in self.pages)
    //    {
    //        if ((NSNull *)page != [NSNull null])
    //        {
    //            NSInteger pageIndex = [self pageIndexForArrayIndex:[self.pages indexOfObject:page] centerPageIndex:_centerPageIndex];
    //            [page setFrame:CGRectMake(self.frame.size.width*pageIndex, 0, self.frame.size.width, self.frame.size.height)];
    //        }
    //    }
    //    NSLog(@"%d : %d = %f", (NSInteger)self.contentOffset.x, oldWidth, (NSInteger)((NSInteger)self.contentOffset.x/oldWidth)*self.frame.size.width);
    //    _rearangePages = NO;
    //
    //    [self setContentSize:CGSizeMake(self.frame.size.width*_noOfPages, self.frame.size.height)];
    //
    //    [self setContentOffset:CGPointMake((NSInteger)((NSInteger)self.contentOffset.x/oldWidth)*self.frame.size.width, self.contentOffset.y) animated:NO];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

@end
