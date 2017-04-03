//
//  TMMuiLazyScrollView.m
//  LazyScrollView
//
//  Copyright (c) 2015 tmall. All rights reserved.
//

#define RenderBufferWindow              20.f

#import "TMMuiLazyScrollView.h"
#import <objc/runtime.h>

@implementation TMMuiRectModel

@end


//Here is a category implementation required by LazyScrollView.
@implementation UIView(TMMui)

- (instancetype)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [self initWithFrame:frame];
    if (self)
    {
        self.reuseIdentifier = reuseIdentifier;
    }
    return self;
}

- (void)setReuseIdentifier:(NSString *)reuseIdentifier
{
    objc_setAssociatedObject(self, @"reuseIdentifier", reuseIdentifier, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)reuseIdentifier
{
    NSString *reuseIdentifier = objc_getAssociatedObject(self, @"reuseIdentifier");
    return reuseIdentifier;
}

- (NSString *)muiID
{
    return objc_getAssociatedObject(self, @"muiID");
}

- (void)setMuiID:(NSString *)muiID
{
    objc_setAssociatedObject(self, @"muiID", muiID, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end

@interface TMMuiLazyScrollViewObserver: NSObject
@property (nonatomic, weak) TMMuiLazyScrollView *lazyScrollView;
@end


@interface TMMuiLazyScrollView()<UIScrollViewDelegate>

// Store Visible Views
@property (nonatomic, strong, readonly) NSMutableSet *visibleItems;

// Store reuseable cells by reuseIdentifier. The key is reuseIdentifier of views , value is an array that contains reuseable cells.
@property (nonatomic,strong)NSMutableDictionary *recycledIdentifierItemsDic;

// Store view models (TMMuiRectModel).
@property (nonatomic, strong) NSMutableArray *itemsFrames;

// ScrollView delegate,store outer scrollDelegate here.
// Because of lazyscrollview need calculate what views should be shown in scrollDidScroll.
@property (nonatomic,weak) id <TMMuiLazyScrollViewDelegate> lazyScrollViewDelegate;

// View Model sorted by Top Edge.
@property (nonatomic, strong) NSArray *modelsSortedByTop;

// View Model sorted by Bottom Edge.
@property (nonatomic, strong) NSArray *modelsSortedByBottom;

// Store view models below contentOffset of ScrollView
@property (nonatomic, strong) NSMutableSet *firstSet;

// Store view models above contentOffset + ScrollView.height of ScrollView
@property (nonatomic, strong)  NSMutableSet *secondSet;

// record contentOffset of scrollview in previous time that calculate views to show
@property (nonatomic, assign) CGPoint     lastScrollOffset;

// record current muiID of visible view for calculate.
@property (nonatomic, strong) NSString    *currentVisibleItemMuiID;

// It is used to store views need to assign new value after reload.
@property (nonatomic, strong) NSMutableSet    *shouldReloadItems;

// Record in screen visible muiID
@property (nonatomic, strong) NSSet *muiIDOfVisibleViews;
// Store the times of view entered the screen , the key is muiiD
@property (nonatomic, strong) NSMutableDictionary *enterDict;
// Store last time visible muiID
@property (nonatomic, strong) NSMutableSet *lastVisiblemuiID;
// Store in Screen Visible item
// The difference between 'visibleItems' and 'inScreenVisibleItems' is there is a buffer area in LazyScrollView(RenderBufferWindow), so 'visibleItems' contains view in 'RenderBufferWindow'
@property (nonatomic, strong) NSMutableSet *inScreenVisibleItems;

@end


@implementation TMMuiLazyScrollView

-(NSMutableDictionary *)enterDict
{
    if (nil == _enterDict) {
        _enterDict = [[NSMutableDictionary alloc]init];
    }
    return _enterDict;
}
- (NSMutableSet *)inScreenVisibleItems
{
    if (nil == _inScreenVisibleItems) {
        _inScreenVisibleItems = [[NSMutableSet alloc]init];
    }
    return _inScreenVisibleItems;
}
- (NSMutableSet *)shouldReloadItems
{
    if (nil == _shouldReloadItems) {
        _shouldReloadItems = [[NSMutableSet alloc] init];
    }
    return _shouldReloadItems;
}

- (void)setFrame:(CGRect)frame
{
    if (!CGRectEqualToRect(frame, self.frame))
    {
        [super setFrame:frame];
    }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.clipsToBounds = YES;
        self.autoresizesSubviews = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        _recycledIdentifierItemsDic = [[NSMutableDictionary alloc] init];
        _visibleItems = [[NSMutableSet alloc] init];
        _itemsFrames = [[NSMutableArray alloc] init];
        _firstSet = [[NSMutableSet alloc] initWithCapacity:30];
        _secondSet = [[NSMutableSet alloc] initWithCapacity:30];
        super.delegate = self;
        
    }
    return self;
}

- (void)dealloc
{
    _dataSource = nil;
    self.delegate = nil;
    [_recycledIdentifierItemsDic removeAllObjects],_recycledIdentifierItemsDic = nil;
    [_visibleItems removeAllObjects],_visibleItems = nil;
    [_itemsFrames removeAllObjects],_itemsFrames = nil;
    [_firstSet removeAllObjects],_firstSet = nil;
    [_secondSet removeAllObjects],_secondSet = nil;
    _modelsSortedByTop = nil;
    _modelsSortedByBottom = nil;

}

//replace UIScrollDelegate to TMMuiLazyScrollViewDelegate for insert code in scrollDidScroll .
-(void)setDelegate:(id<TMMuiLazyScrollViewDelegate>)delegate
{
    if (!delegate)
    {
        [super setDelegate:nil];
        _lazyScrollViewDelegate = nil;
    }
    else
    {
        [super setDelegate:self];
        _lazyScrollViewDelegate = delegate;
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // Scroll can trigger LazyScrollView calculate which views should be shown.
    // Calcuting Action will cost some time , so here is a butter for reducing times of calculating.
    CGFloat currentY = scrollView.contentOffset.y;
    CGFloat buffer = RenderBufferWindow / 2;
    if (buffer < ABS(currentY - self.lastScrollOffset.y)) {
        self.lastScrollOffset = scrollView.contentOffset;
        [self assembleSubviews];
        [self findViewsInVisibleRect];

    }
    if (self.lazyScrollViewDelegate && [self.lazyScrollViewDelegate conformsToProtocol:@protocol(UIScrollViewDelegate)] && [self.lazyScrollViewDelegate respondsToSelector:@selector(scrollViewDidScroll:)])
    {
        [self.lazyScrollViewDelegate scrollViewDidScroll:self];
    }
    
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView NS_AVAILABLE_IOS(3_2)
{
    if (self.lazyScrollViewDelegate && [self.lazyScrollViewDelegate conformsToProtocol:@protocol(UIScrollViewDelegate)] && [self.lazyScrollViewDelegate respondsToSelector:@selector(scrollViewDidZoom:)])
    {
        [self.lazyScrollViewDelegate scrollViewDidZoom:self];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (self.lazyScrollViewDelegate && [self.lazyScrollViewDelegate conformsToProtocol:@protocol(UIScrollViewDelegate)] && [self.lazyScrollViewDelegate respondsToSelector:@selector(scrollViewWillBeginDragging:)])
    {
        [self.lazyScrollViewDelegate scrollViewWillBeginDragging:self];
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset NS_AVAILABLE_IOS(5_0)
{
    if (self.lazyScrollViewDelegate && [self.lazyScrollViewDelegate conformsToProtocol:@protocol(UIScrollViewDelegate)] && [self.lazyScrollViewDelegate respondsToSelector:@selector(scrollViewWillEndDragging:withVelocity:targetContentOffset:)])
    {
        [self.lazyScrollViewDelegate scrollViewWillEndDragging:self withVelocity:velocity targetContentOffset:targetContentOffset];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (self.lazyScrollViewDelegate && [self.lazyScrollViewDelegate conformsToProtocol:@protocol(UIScrollViewDelegate)] && [self.lazyScrollViewDelegate respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)])
    {
        [self.lazyScrollViewDelegate scrollViewDidEndDragging:self willDecelerate:decelerate];
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    if (self.lazyScrollViewDelegate && [self.lazyScrollViewDelegate conformsToProtocol:@protocol(UIScrollViewDelegate)] && [self.lazyScrollViewDelegate respondsToSelector:@selector(scrollViewWillBeginDecelerating:)])
    {
        [self.lazyScrollViewDelegate scrollViewWillBeginDecelerating:self];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (self.lazyScrollViewDelegate && [self.lazyScrollViewDelegate conformsToProtocol:@protocol(UIScrollViewDelegate)] && [self.lazyScrollViewDelegate respondsToSelector:@selector(scrollViewDidEndDecelerating:)])
    {
        [self.lazyScrollViewDelegate scrollViewDidEndDecelerating:self];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if (self.lazyScrollViewDelegate && [self.lazyScrollViewDelegate conformsToProtocol:@protocol(UIScrollViewDelegate)] && [self.lazyScrollViewDelegate respondsToSelector:@selector(scrollViewDidEndScrollingAnimation:)])
    {
        [self.lazyScrollViewDelegate scrollViewDidEndScrollingAnimation:self];
    }
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    if (self.lazyScrollViewDelegate && [self.lazyScrollViewDelegate conformsToProtocol:@protocol(UIScrollViewDelegate)] && [self.lazyScrollViewDelegate respondsToSelector:@selector(viewForZoomingInScrollView:)])
    {
        return [self.lazyScrollViewDelegate viewForZoomingInScrollView:self];
    }
    return nil;
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view NS_AVAILABLE_IOS(3_2)
{
    if (self.lazyScrollViewDelegate && [self.lazyScrollViewDelegate conformsToProtocol:@protocol(UIScrollViewDelegate)] && [self.lazyScrollViewDelegate respondsToSelector:@selector(scrollViewWillBeginZooming:withView:)])
    {
        [self.lazyScrollViewDelegate scrollViewWillBeginZooming:self withView:view];
    }
}


- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    if (self.lazyScrollViewDelegate && [self.lazyScrollViewDelegate conformsToProtocol:@protocol(UIScrollViewDelegate)] && [self.lazyScrollViewDelegate respondsToSelector:@selector(scrollViewDidEndZooming:withView:atScale:)])
    {
        [self.lazyScrollViewDelegate scrollViewDidEndZooming:self withView:view atScale:scale];
    }
}


- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
    if (self.lazyScrollViewDelegate && [self.lazyScrollViewDelegate conformsToProtocol:@protocol(UIScrollViewDelegate)] && [self.lazyScrollViewDelegate respondsToSelector:@selector(scrollViewShouldScrollToTop:)])
    {
        return [self.lazyScrollViewDelegate scrollViewShouldScrollToTop:self];
    }
    return self.scrollsToTop;
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView
{
    if (self.lazyScrollViewDelegate && [self.lazyScrollViewDelegate conformsToProtocol:@protocol(UIScrollViewDelegate)] && [self.lazyScrollViewDelegate respondsToSelector:@selector(scrollViewDidScrollToTop:)])
    {
        [self.lazyScrollViewDelegate scrollViewDidScrollToTop:self];
    }
}
// Do Binary search here to find index in view model array.
-(NSUInteger) binarySearchForIndex:(NSArray *)frameArray baseLine:(CGFloat)baseLine isFromTop:(BOOL)fromTop
{
    NSInteger min = 0 ;
    NSInteger max = frameArray.count -1;
    NSInteger mid = ceilf((CGFloat)(min + max) / 2.f);
    while (mid > min && mid < max) {
        CGRect rect = [(TMMuiRectModel *)[frameArray objectAtIndex:mid] absoluteRect];
        // For top
        if(fromTop) {
            CGFloat itemTop = CGRectGetMinY(rect);
            if (itemTop <= baseLine) {
                CGRect nextItemRect = [(TMMuiRectModel *)[frameArray objectAtIndex:mid + 1] absoluteRect];
                CGFloat nextTop = CGRectGetMinY(nextItemRect);
                if (nextTop > baseLine) {
                    mid ++;
                    break;
                }
                min = mid;
            }
            else {
                max = mid;
            }
        }
        // For bottom
        else {
            CGFloat itemBottom = CGRectGetMaxY(rect);
            if (itemBottom >= baseLine) {
                CGRect nextItemRect = [(TMMuiRectModel *)[frameArray objectAtIndex:mid + 1] absoluteRect];
                CGFloat nextBottom = CGRectGetMaxY(nextItemRect);
                if (nextBottom < baseLine) {
                    mid ++;
                    break;
                }
                min = mid;
            }
            else {
                max = mid;
            }
        }
        mid = ceilf((CGFloat)(min + max) / 2.f);
    }
    
    return mid;
}

// Get which views should be shown in LazyScrollView.
// The kind of Inner Elements In NSSet is NSNumber , containing index of view model array;
-(NSSet *)showingItemIndexSetFrom :(CGFloat)startY to:(CGFloat)endY
{
    if ( !self.modelsSortedByBottom  || !self.modelsSortedByTop ) {
        [self creatScrollViewIndex];
    }
    NSUInteger endBottomIndex = [self binarySearchForIndex:self.modelsSortedByBottom baseLine:startY isFromTop:NO];
    [self.firstSet removeAllObjects];
    if (self.modelsSortedByBottom && self.modelsSortedByBottom.count > 0) {
        for (NSUInteger i = 0; i <= endBottomIndex; i++) {
            TMMuiRectModel *model = [self.modelsSortedByBottom objectAtIndex:i];
            if (model != nil) {
                [self.firstSet addObject:model.muiID];
            }
        }
    }
    NSUInteger endTopIndex = [self binarySearchForIndex:self.modelsSortedByTop baseLine:endY isFromTop:YES];
    [self.secondSet removeAllObjects];
    if (self.modelsSortedByTop && self.modelsSortedByTop.count > 0) {
        for (NSInteger i = 0; i <= endTopIndex; i++) {
            TMMuiRectModel *model = [self.modelsSortedByTop objectAtIndex:i];
            if (model != nil) {
                [self.secondSet addObject:model.muiID];
            }
        }
    }
    [self.firstSet intersectSet:self.secondSet];
    return [self.firstSet copy];
}

-(NSArray *)modelsSortedByTop
{
    if (!_modelsSortedByTop){
        _modelsSortedByTop = [[NSArray alloc] init];
    }
    return _modelsSortedByTop;
}

-(NSArray *)modelsSortedByBottom
{
    if (!_modelsSortedByBottom) {
        _modelsSortedByBottom = [[NSArray alloc]init];
    }
    return _modelsSortedByBottom;
}

// Get view models from delegate . Create to indexes for sorting.
- (void)creatScrollViewIndex
{
    NSUInteger count = 0;
    [self.itemsFrames removeAllObjects];
    if(self.dataSource && [self.dataSource conformsToProtocol:@protocol(TMMuiLazyScrollViewDataSource)] &&
       [self.dataSource respondsToSelector:@selector(numberOfItemInScrollView:)]) {
        count = [self.dataSource numberOfItemInScrollView:self];
    }
    
    for (NSUInteger i = 0 ; i< count ; i++) {
        TMMuiRectModel *rectmodel;
        if(self.dataSource
           &&[self.dataSource conformsToProtocol:@protocol(TMMuiLazyScrollViewDataSource)]
           &&[self.dataSource respondsToSelector:@selector(scrollView: rectModelAtIndex:)])
        {
            rectmodel = [self.dataSource scrollView:self rectModelAtIndex:i];
            if (rectmodel.muiID.length == 0)
            {
                rectmodel.muiID = [NSString stringWithFormat:@"%lu",(unsigned long)i];
            }
        }
        
        [self.itemsFrames addObject:rectmodel];
    }
    self.modelsSortedByTop = [self.itemsFrames sortedArrayUsingComparator:^NSComparisonResult(id obj1 ,id obj2)
                              {
                                  CGRect rect1 = [(TMMuiRectModel *) obj1 absoluteRect];
                                  CGRect rect2 = [(TMMuiRectModel *) obj2 absoluteRect];
                                  
                                  if (rect1.origin.y < rect2.origin.y) {
                                      return NSOrderedAscending;
                                  }
                                  else if (rect1.origin.y > rect2.origin.y) {
                                      return NSOrderedDescending;
                                  }
                                  else {
                                      return NSOrderedSame;
                                  }
                              }];
    
    self.modelsSortedByBottom = [self.itemsFrames sortedArrayUsingComparator:^NSComparisonResult(id obj1 ,id obj2)
                                 {
                                     CGRect rect1 = [(TMMuiRectModel *) obj1 absoluteRect];
                                     CGRect rect2 = [(TMMuiRectModel *) obj2 absoluteRect];
                                     CGFloat bottom1 = CGRectGetMaxY(rect1);
                                     CGFloat bottom2 = CGRectGetMaxY(rect2);
                                     
                                     if (bottom1 > bottom2) {
                                         return NSOrderedAscending ;
                                     }
                                     else if (bottom1 < bottom2) {
                                         return  NSOrderedDescending;
                                     }
                                     else {
                                         return NSOrderedSame;
                                     }
                                 }];
}
- (void)findViewsInVisibleRect
{
    NSMutableSet *itemViewSet = [self.muiIDOfVisibleViews mutableCopy];
    [itemViewSet minusSet:self.lastVisiblemuiID];
    for (UIView *view in self.visibleItems) {
        if (view && [itemViewSet containsObject:view.muiID]) {
            if ([view conformsToProtocol:@protocol(TMMuiLazyScrollViewCellProtocol)] && [view respondsToSelector:@selector(mui_didEnterWithTimes:)]) {
                NSUInteger times = 0;
                if ([self.enterDict objectForKey:view.muiID] != nil) {
                    times = [[self.enterDict objectForKey:view.muiID] unsignedIntegerValue] + 1;
                }
                NSNumber *showTimes = [NSNumber numberWithUnsignedInteger:times];
                [self.enterDict setObject:showTimes forKey:view.muiID];
                [(UIView<TMMuiLazyScrollViewCellProtocol> *)view mui_didEnterWithTimes:times];
            }
        }
    }
    self.lastVisiblemuiID = [self.muiIDOfVisibleViews copy];
}
// A simple method to make view that should be shown show in LazyScrollView
- (void)assembleSubviews
{
     CGRect visibleBounds = self.bounds;
     // Visible area adding buffer to form a area that need to calculate which view should be shown.
     CGFloat minY = CGRectGetMinY(visibleBounds) - RenderBufferWindow;
     CGFloat maxY = CGRectGetMaxY(visibleBounds) + RenderBufferWindow;
     [self assembleSubviewsForReload:NO minY:minY maxY:maxY];
}

- (void)assembleSubviewsForReload:(BOOL)isReload minY:(CGFloat)minY maxY:(CGFloat)maxY
{
  
    NSSet *itemShouldShowSet = [self showingItemIndexSetFrom:minY to:maxY];
    self.muiIDOfVisibleViews = [self showingItemIndexSetFrom:CGRectGetMinY(self.bounds) to:CGRectGetMaxY(self.bounds)];

    NSMutableSet  *recycledItems = [[NSMutableSet alloc] init];
    //For recycling . Find which views should not in visible area.
    NSSet *visibles = [self.visibleItems copy];
    for (UIView *view in visibles)
    {
        //Make sure whether the view should be shown.
        BOOL isToShow  = [itemShouldShowSet containsObject:view.muiID];
        //If this view should be recycled and the length of its reuseidentifier over 0
        if (!isToShow && view.reuseIdentifier.length > 0)
        {
            //Then recycle the view.
            NSMutableSet *recycledIdentifierSet = [self recycledIdentifierSet:view.reuseIdentifier];
            [recycledIdentifierSet addObject:view];
            view.hidden = YES;
            [recycledItems addObject:view];
        }
        else if (isReload && view.muiID) {
            [self.shouldReloadItems addObject:view.muiID];
        }
    }
    [self.visibleItems minusSet:recycledItems];
    [recycledItems removeAllObjects];
    //For creare new view.
    for (NSString *muiID in itemShouldShowSet)
    {
        BOOL shouldReload = isReload || [self.shouldReloadItems containsObject:muiID];
        if(![self isCellVisible:muiID] || [self.shouldReloadItems containsObject:muiID])
        {
            if (self.dataSource && [self.dataSource conformsToProtocol:@protocol(TMMuiLazyScrollViewDataSource)] &&
                [self.dataSource respondsToSelector:@selector(scrollView: itemByMuiID:)])
            {
                if (shouldReload) {
                    self.currentVisibleItemMuiID = muiID;
                }
                else {
                    self.currentVisibleItemMuiID = nil;
                }
                // Create view by delegate.
                UIView *viewToShow = [self.dataSource scrollView:self itemByMuiID:muiID];
                // Call afterGetView
                if ([viewToShow conformsToProtocol:@protocol(TMMuiLazyScrollViewCellProtocol)] &&
                    [viewToShow respondsToSelector:@selector(mui_afterGetView)]) {
                    [(UIView<TMMuiLazyScrollViewCellProtocol> *)viewToShow mui_afterGetView];
                }
                if (viewToShow)
                {
                    viewToShow.muiID = muiID;
                    viewToShow.hidden = NO;
                    if (![self.visibleItems containsObject:viewToShow]) {
                        [self.visibleItems addObject:viewToShow];
                    }
                }
            }
            [self.shouldReloadItems removeObject:muiID];
        }
    }
    [self.inScreenVisibleItems removeAllObjects];
    for (UIView *view in self.visibleItems) {
        if ([view isKindOfClass:[UIView class]] && view.superview) {
            CGRect absRect = [view.superview convertRect:view.frame toView:self];
            if ((absRect.origin.y + absRect.size.height >= CGRectGetMinY(self.bounds)) && (absRect.origin.y <= CGRectGetMaxY(self.bounds))) {
                [self.inScreenVisibleItems addObject:view];
            }
        }
    }
}

// Find NSSet accroding to reuse identifier , if not , then create one.
- (NSMutableSet *)recycledIdentifierSet:(NSString *)reuseIdentifier;
{
    if (reuseIdentifier.length == 0)
    {
        return nil;
    }
    
    NSMutableSet *result = [self.recycledIdentifierItemsDic objectForKey:reuseIdentifier];
    if (result == nil) {
        result = [[NSMutableSet alloc] init];
        [self.recycledIdentifierItemsDic setObject:result forKey:reuseIdentifier];
    }
    return result;
}

//reloads everything and redisplays visible views.
- (void)reloadData
{
    [self creatScrollViewIndex];
    if (self.itemsFrames.count > 0) {
        CGRect visibleBounds = self.bounds;
        //Add buffer for rendering
        CGFloat minY = CGRectGetMinY(visibleBounds) - RenderBufferWindow;
        CGFloat maxY = CGRectGetMaxY(visibleBounds) + RenderBufferWindow;
        [self assembleSubviewsForReload:YES minY:minY maxY:maxY];
        [self findViewsInVisibleRect];
    }
}

// To acquire an already allocated view that can be reused by reuse identifier.
// If can't find one , here will return nil.
- (nullable UIView *)dequeueReusableItemWithIdentifier:(NSString *)identifier
{
    UIView *view = nil;
    if (self.currentVisibleItemMuiID) {
        NSSet *visibles = self.visibleItems;
        for (UIView *v in visibles) {
            if ([v.muiID isEqualToString:self.currentVisibleItemMuiID]) {
                view = v;
                break;
            }
        }
    }
    if (nil == view) {
        NSMutableSet *recycledIdentifierSet = [self recycledIdentifierSet:identifier];
        view = [recycledIdentifierSet anyObject];
        if (view)
        {
            //if exist reusable view , remove it from recycledSet.
            [recycledIdentifierSet removeObject:view];
            //Then remove all gesture recognizers of it.
            view.gestureRecognizers = nil;
        }
    }
    if ([view conformsToProtocol:@protocol(TMMuiLazyScrollViewCellProtocol)] && [view respondsToSelector:@selector(mui_prepareForReuse)]) {
        [(UIView<TMMuiLazyScrollViewCellProtocol> *)view mui_prepareForReuse];
    }
    return view;
}

//Make sure whether the view is visible accroding to muiID.
-(BOOL)isCellVisible: (NSString *)muiID {
    
    BOOL result = NO;
    NSSet *visibles = [self.visibleItems copy];
    for (UIView *view in visibles)
    {
        if ([view.muiID isEqualToString:muiID])
        {
            result = YES;
            break;
        }
    }
    return result;
}

// Remove all subviews and reuseable views.
- (void)removeAllLayouts
{
    NSSet *visibles = self.visibleItems;
    for (UIView *view in visibles) {
        NSMutableSet *recycledIdentifierSet = [self recycledIdentifierSet:view.reuseIdentifier];
        [recycledIdentifierSet addObject:view];
        view.hidden = YES;
    }
    [_visibleItems removeAllObjects];
    [_recycledIdentifierItemsDic removeAllObjects];
}

-(void)resetViewEnterTimes
{
    [self.enterDict removeAllObjects];
    self.lastVisiblemuiID = nil;
}
@end


