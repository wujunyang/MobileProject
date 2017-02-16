//
//  MPHomeViewController.m
//  MobileProject
//
//  Created by wujunyang on 16/7/1.
//  Copyright © 2016年 wujunyang. All rights reserved.
//

#import "MPHomeViewController.h"

@implementation MPHomeViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupTabBarController];
        
        self.tabBar.selectedImageTintColor =RGB(182, 65, 65);
        
        //显示未读
        UINavigationController  *discoverNav =(UINavigationController *)self.viewControllers[1];
        UITabBarItem *curTabBarItem=discoverNav.tabBarItem;
        [curTabBarItem setBadgeValue:@"2"];
    }
    return self;
}


- (void)setupTabBarController {
    /// 设置TabBar属性数组
    self.tabBarItemsAttributes =[self tabBarItemsAttributesForController];
    
    /// 设置控制器数组
    self.viewControllers =[self mpViewControllers];
    
    self.delegate = self;
    self.moreNavigationController.navigationBarHidden = YES;
}


//控制器设置
- (NSArray *)mpViewControllers {
    UMengSocialLoginViewController *firstViewController = [[UMengSocialLoginViewController alloc] init];
    UINavigationController *firstNavigationController = [[MPBaseNavigationController alloc]
                                                   initWithRootViewController:firstViewController];
    
    MPTheoryViewController *secondViewController = [[MPTheoryViewController alloc] init];
    UINavigationController *secondNavigationController = [[MPBaseNavigationController alloc]
                                                    initWithRootViewController:secondViewController];
    
    UMengSocialViewController *thirdViewController = [[UMengSocialViewController alloc] init];
    UINavigationController *thirdNavigationController = [[MPBaseNavigationController alloc]
                                                   initWithRootViewController:thirdViewController];
    
    MPMoreViewController *fourthViewController = [[MPMoreViewController alloc] init];
    UINavigationController *fourthNavigationController = [[MPBaseNavigationController alloc]
                                                    initWithRootViewController:fourthViewController];
    
    NSArray *viewControllers = @[
                                 firstNavigationController,
                                 secondNavigationController,
                                 thirdNavigationController,
                                 fourthNavigationController
                                 ];
    return viewControllers;
}

//TabBar文字跟图标设置
- (NSArray *)tabBarItemsAttributesForController {
    NSDictionary *firstTabBarItemsAttributes = @{
                                                 CYLTabBarItemTitle : @"首页",
                                                 CYLTabBarItemImage : @"home_normal",
                                                 CYLTabBarItemSelectedImage : @"home_highlight",
                                                 };
    NSDictionary *secondTabBarItemsAttributes = @{
                                                  CYLTabBarItemTitle : @"基础",
                                                  CYLTabBarItemImage : @"mycity_normal",
                                                  CYLTabBarItemSelectedImage : @"mycity_highlight",
                                                  };
    NSDictionary *thirdTabBarItemsAttributes = @{
                                                 CYLTabBarItemTitle : @"服务",
                                                 CYLTabBarItemImage : @"message_normal",
                                                 CYLTabBarItemSelectedImage : @"message_highlight",
                                                 };
    NSDictionary *fourthTabBarItemsAttributes = @{
                                                  CYLTabBarItemTitle : @"更多",
                                                  CYLTabBarItemImage : @"account_normal",
                                                  CYLTabBarItemSelectedImage : @"account_highlight"
                                                  };
    NSArray *tabBarItemsAttributes = @[
                                       firstTabBarItemsAttributes,
                                       secondTabBarItemsAttributes,
                                       thirdTabBarItemsAttributes,
                                       fourthTabBarItemsAttributes
                                       ];
    return tabBarItemsAttributes;
}


#pragma mark - UITabBarControllerDelegate

- (BOOL)tabBarController:(UITabBarController*)tabBarController shouldSelectViewController:(UINavigationController*)viewController {
    /// 特殊处理 - 是否需要登录
    BOOL isBaiDuService = [viewController.topViewController isKindOfClass:[MPDiscoveryViewController class]];
    if (isBaiDuService) {
        NSLog(@"你点击了TabBar第二个");
    }
    return YES;
}
@end
