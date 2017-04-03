//
//  TMMuiLazyScrollView.h
//  LazyScrollView
//
//  Copyright (c) 2015 tmall. All rights reserved.
//

#import <UIKit/UIKit.h>

#define DEFAULT_REUSE_IDENTIFIER        @"reuseIdentifier"

//If the view in LazyScrollView implement this protocol, view can do something in its lifecycle.
@protocol  TMMuiLazyScrollViewCellProtocol<NSObject>

@optional
// if call dequeueReusableItemWithIdentifier to get a reuseable view,the same as "prepareForReuse" in UITableViewCell
- (void)mui_prepareForReuse;
// When view enter the visible area of LazyScrollView ，call this method.
// First 'times' is 0
- (void)mui_didEnterWithTimes:(NSUInteger)times;
// When we need render the view, call this method.
// The difference between this method and 'mui_didEnterWithTimes' is there is a buffer area in LazyScrollView(RenderBufferWindow), first we will call 'mui_afterGetView'.
- (void)mui_afterGetView;

@end
////////////////////////////////////////////////////////////////////////////////////////////////////

/**
 * It is a view model that holding information of view. At least holding absoluteRect and muiID.
 */
@interface TMMuiRectModel: NSObject

// A rect that relative to the scroll view.
@property (nonatomic, assign) CGRect absoluteRect;

// A uniq string that identify a model.
@property (nonatomic, copy, nonnull) NSString *muiID;

@end

/**
 * A UIView category required by LazyScrollView.
 */
@interface UIView(TMMui)

// A uniq string that identify a view, require to be same as muiID of the model.
@property (nonatomic, copy, nonnull) NSString  *muiID;

// A string used to identify a view that is reusable.
@property (nonatomic, copy, nullable) NSString *reuseIdentifier;

- (nonnull instancetype)initWithFrame:(CGRect)frame
                      reuseIdentifier:(nullable NSString *)reuseIdentifier;

@end


// This protocol represents the data model object.
@class TMMuiLazyScrollView;
@protocol TMMuiLazyScrollViewDataSource <NSObject>

@required
- (NSUInteger)numberOfItemInScrollView:(nonnull TMMuiLazyScrollView *)scrollView; // 0 by default.

////////////////////////////////////////////////////////////////////////////////////////////////////

// Return the view model by spcial index.
- (nonnull TMMuiRectModel *)scrollView:(nonnull TMMuiLazyScrollView *)scrollView
                      rectModelAtIndex:(NSUInteger)index;

/**
 * You should render the item view here. And the view is probably . Item view display. You should
 * *always* try to reuse views by setting each view's reuseIdentifier and querying for available
 * reusable views with dequeueReusableItemWithIdentifier:
 */
- (nullable UIView *)scrollView:(nonnull TMMuiLazyScrollView *)scrollView itemByMuiID:(nonnull NSString *)muiID;

@end

@protocol TMMuiLazyScrollViewDelegate<NSObject, UIScrollViewDelegate>

@end


@interface TMMuiLazyScrollView : UIScrollView<NSCoding>

@property (nonatomic, weak, nullable)   id <TMMuiLazyScrollViewDataSource> dataSource;

// reloads everything from scratch and redisplays visible views.
- (void)reloadData;
// Get reuseable view by reuseIdentifier. If cannot find reuseable view by reuseIdentifier, here will return nil.
- (nullable UIView *)dequeueReusableItemWithIdentifier:(nonnull NSString *)reuseIdentifier;
// Remove all subviews and reuseable views.
- (void)removeAllLayouts;
// After call this method, the times of mui_didEnterWithTimes will start from 0
- (void)resetViewEnterTimes;
@end
