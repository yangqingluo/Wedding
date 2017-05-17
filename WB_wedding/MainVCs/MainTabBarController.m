//
//  MainTabBarController.m
//
//  Created by yangqingluo on 16/9/9.
//  Copyright © 2016年 yangqingluo. All rights reserved.
//

#import "MainTabBarController.h"
#import "OpenViewController.h"
#import "AccountViewController.h"
#import "WEMyChatController.h"
#import "WEYourMsgController.h"
#import "WESomeOneLikeController.h"

#import "UIImage+Color.h"

@interface MainTabBarController ()

@property (nonatomic, strong) NSArray *tabItemArray;
@property (nonatomic, strong) UIButton *centralButton;

@end

@implementation MainTabBarController

- (instancetype)init{
    self = [super init];

    if (self) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.viewControllers = @[[WEMyChatController new], [WEYourMsgController new],[OpenViewController new], [WESomeOneLikeController new], [[AccountViewController alloc] initWithStyle:UITableViewStyleGrouped]];
        self.tabBar.backgroundImage = [[UIImage imageWithColor:[UIColor whiteColor]] stretchableImageWithLeftCapWidth:25 topCapHeight:25];
        self.tabBar.tintColor = navigationBarColor;
        
        for (UIViewController *vc in self.viewControllers) {
            NSDictionary *dic = self.tabItemArray[[self.viewControllers indexOfObject:vc]];
            
            NSString *imageName = dic[@"imageName"];
            NSString *selectedImageName = [NSString stringWithFormat:@"%@_focus",dic[@"imageName"]];
            
            if ([self.viewControllers indexOfObject:vc] == 2) {
                vc.tabBarItem = [[UITabBarItem alloc]initWithTitle:dic[@"title"] image:[[UIImage imageNamed:@""] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@""] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
                
                [self addCenterButtonWithImage:[UIImage imageNamed:imageName] selectedImage:[UIImage imageNamed:selectedImageName]];
                
            }
            else {
                vc.tabBarItem = [[UITabBarItem alloc]initWithTitle:dic[@"title"] image:[[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:selectedImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
            }
            
            [self unSelectedTapTabBarItems:vc.tabBarItem];
            [self selectedTapTabBarItems:vc.tabBarItem];
            
            
        }
        
        [self setSelectedIndex:2];
        self.centralButton.selected = YES;
    }
    
    return self;
}

- (void)unSelectedTapTabBarItems:(UITabBarItem *)tabBarItem{
    [tabBarItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10.0]} forState:UIControlStateNormal];
}

- (void)selectedTapTabBarItems:(UITabBarItem *)tabBarItem{
    [tabBarItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10.0]} forState:UIControlStateSelected];
}

- (void)addCenterButtonWithImage:(UIImage*)buttonImage selectedImage:(UIImage*)selectedImage{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
    
    //  设定button大小为适应图片
    button.frame = CGRectMake(0.0, 0.0, buttonImage.size.width, buttonImage.size.height);
    [button setImage:buttonImage forState:UIControlStateNormal];
    [button setImage:selectedImage forState:UIControlStateSelected];
    
    //  这个比较恶心  去掉选中button时候的阴影
    button.adjustsImageWhenHighlighted = NO;
    
    /*
     *  核心代码：设置button的center 和 tabBar的 center 做对齐操作， 同时做出相对的上浮
     */
    CGFloat heightDifference = buttonImage.size.height - self.tabBar.frame.size.height;
    if (heightDifference > 0)
        button.center = self.tabBar.center;
    else{
        CGPoint center = self.tabBar.center;
        center.y = center.y + heightDifference;
        button.center = center;
    }
    
    self.centralButton = button;
    self.centralButton.userInteractionEnabled = NO;
    [self.view addSubview:button];
}

#pragma tabbar annimation
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    NSInteger index = [self.tabBar.items indexOfObject:item];
    
    self.centralButton.selected = (index == 2);
    
//    if (self.selectedIndex != index) {
//        [self animationWithIndex:index];
//    }
}

// 动画
- (void)animationWithIndex:(NSInteger) index {
    NSMutableArray *tabbarbuttonArray = [NSMutableArray array];
    for (UIView *tabBarButton in self.tabBar.subviews) {
        if ([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            [tabbarbuttonArray addObject:tabBarButton];
        }
    }
    CABasicAnimation *pulse = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    pulse.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pulse.duration = 0.08;
    pulse.repeatCount = 1;
    pulse.autoreverses = YES;
    pulse.fromValue = [NSNumber numberWithFloat:0.9];
    pulse.toValue = [NSNumber numberWithFloat:1.1];
    [[tabbarbuttonArray[index] layer] addAnimation:pulse forKey:nil];
    
}

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
