//
//  MainTabBarController.m
//  SafetyOfMAS
//
//  Created by yangqingluo on 16/9/9.
//  Copyright © 2016年 yangqingluo. All rights reserved.
//

#import "MainTabBarController.h"
#import "OpenViewController.h"
#import "WEMeViewController.h"
#import "WEMyChatController.h"
#import "WEYourMsgController.h"
#import "WESomeOneLikeController.h"

@interface MainTabBarController ()

@property (nonatomic, strong) NSArray *tabItemArray;

@end

@implementation MainTabBarController

+ (MainTabBarController *)defaultMainTab{
    static dispatch_once_t pred = 0;
    __strong static MainTabBarController *_singleManger = nil;
    
    dispatch_once(&pred, ^{
        _singleManger = [[MainTabBarController alloc]init];
    });
    return _singleManger;
}

- (instancetype)init{
    self = [super init];
    
    if (self) {
        self.viewControllers = @[[WEMyChatController new], [WEYourMsgController new],[OpenViewController new], [WESomeOneLikeController new], [WEMeViewController new]];
        self.tabBar.backgroundImage = [[UIImage imageWithColor:[UIColor whiteColor]] stretchableImageWithLeftCapWidth:25 topCapHeight:25];
        self.tabBar.tintColor = [UIColor redColor];
        for (UIViewController *vc in self.viewControllers) {
            NSDictionary *dic = self.tabItemArray[[self.viewControllers indexOfObject:vc]];
            vc.tabBarItem = [[UITabBarItem alloc]initWithTitle:dic[@"title"] image:[[UIImage imageNamed:dic[@"imageName"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:[NSString stringWithFormat:@"%@_focus",dic[@"imageName"]]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
            
            [self unSelectedTapTabBarItems:vc.tabBarItem];
            [self selectedTapTabBarItems:vc.tabBarItem];
        }
    }
    
    return self;
}

- (void)unSelectedTapTabBarItems:(UITabBarItem *)tabBarItem{
    [tabBarItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10.0]} forState:UIControlStateNormal];
}

- (void)selectedTapTabBarItems:(UITabBarItem *)tabBarItem{
    [tabBarItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10.0]} forState:UIControlStateSelected];
}

//#pragma tabbar annimation
//- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
//    NSInteger index = [self.tabBar.items indexOfObject:item];
//    
//    if (self.selectedIndex != index) {
//        [self animationWithIndex:index];
//    }
//}
//// 动画
//- (void)animationWithIndex:(NSInteger) index {
//    NSMutableArray *tabbarbuttonArray = [NSMutableArray array];
//    for (UIView *tabBarButton in self.tabBar.subviews) {
//        if ([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
//            [tabbarbuttonArray addObject:tabBarButton];
//        }
//    }
//    CABasicAnimation *pulse = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
//    pulse.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    pulse.duration = 0.08;
//    pulse.repeatCount = 1;
//    pulse.autoreverses = YES;
//    pulse.fromValue = [NSNumber numberWithFloat:0.9];
//    pulse.toValue = [NSNumber numberWithFloat:1.1];
//    [[tabbarbuttonArray[index] layer] addAnimation:pulse forKey:nil];
//    
//}

#pragma getter
- (NSArray *)tabItemArray{
    if (!_tabItemArray) {
        _tabItemArray = @[@{@"title":@"我的聊天",@"imageName":@"mytalk72"},
                          @{@"title":@"你的回信",@"imageName":@"letter72"},
                          @{@"title":@"开启",@"imageName":@"heart72"},
                          @{@"title":@"有人喜欢你",@"imageName":@"xihuan72"},
                          @{@"title":@"我的",@"imageName":@"account72"}];
    }
    
    return _tabItemArray;
}

@end
