//
//  HQMainTabBarController.m
//  HQ
//
//  Created by 谢威 on 16/9/19.
//  Copyright © 2016年 成都卓牛科技. All rights reserved.
//

#import "HQMainTabBarController.h"
#import "XWTabBar.h"
#import "OpenViewController.h"
#import "WEMeViewController.h"
#import "WEMyChatController.h"
#import "WEYourMsgController.h"
#import "WESomeOneLikeController.h"

@interface HQMainTabBarController ()<UITabBarDelegate,UITabBarControllerDelegate,XWTabBarDelegate>
{
    WEMyChatController      *_homePage;
    WEYourMsgController     *_classfiy;
    WESomeOneLikeController     *_forum;
    WEMeViewController        *_me;
    OpenViewController        *_open;
    
}
@property (nonatomic,strong)XWTabBar   *xwTabBar;


@end


@implementation HQMainTabBarController


- (void)dealloc{
    [KNotiCenter removeObserver:self name:KMarchSuccess object:nil];
     [KNotiCenter removeObserver:self name:KCancleMarch object:nil];
    
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self setUpAllChildVC];
    
    self.xwTabBar = [XWTabBar xw_loadFromNib];
    self.xwTabBar.delegate = self;
    self.xwTabBar.frame = self.tabBar.frame;
//    self.tabBar.hidden = YES;
//    [self.tabBar removeFromSuperview];
//    for (UIView *loop in self.tabBar.subviews) {
//        if (![loop isKindOfClass:[XWTabBar class]]) {
//            [loop removeFromSuperview];
//        }
//    }
//    
    [self.view addSubview:self.xwTabBar];
    
    
    
    [self setSelectedIndex:2];
    
    [KNotiCenter addObserver:self selector:@selector(marchSuccess) name:KMarchSuccess object:nil];
    [KNotiCenter addObserver:self selector:@selector(marchCancel) name:KCancleMarch object:nil];
    
    
    
    
}

#pragma mark -- 匹配成功
- (void)marchSuccess{
    
    [self.xwTabBar marchSuccess];
    [KUserDefaults setObject:@"YES" forKey:@"isHidenBtn"];
    [KUserDefaults synchronize];
    

    
}

- (void)marchCancel{
       [self.xwTabBar cancelMarch];
        [KUserDefaults setObject:@"NO" forKey:@"isHidenBtn"];
        [KUserDefaults synchronize];
    

}


- (void)TabBarDidIndex:(NSInteger)index{
    NSLog(@"%ld",index);
     [super setSelectedIndex:index];
    
    
}

- (void)setUpAllChildVC{
    _homePage = [[WEMyChatController alloc]init];
    [self setUPChildVC:_homePage title:@"我的聊天" image:@"mytalk72" selectedImage:@"mytalk72_focus"];
    
    _classfiy = [[WEYourMsgController alloc]init];
    [self setUPChildVC:_classfiy title:@"你的回信" image:@"letter48" selectedImage:@"letter48_focus"];

    _open = [[OpenViewController alloc]init];
    [self setUPChildVC:_open title:@"开启" image:nil selectedImage:nil];
    
    
    _forum = [[WESomeOneLikeController alloc]init];
    [self setUPChildVC:_forum title:@"有人喜欢你" image:@"xihuan48" selectedImage:@"xihuan48_focus"];
    

    _me = [[WEMeViewController alloc]init];
    [self setUPChildVC:_me title:@"我的" image:@"account48" selectedImage:@"account48_focus"];

}


#pragma mark --  设置子控件
- (void)setUPChildVC:(HQBaseViewController *)childVC title:(NSString *)title image:(NSString *)imageName selectedImage:(NSString *)selectedImag{
    
    childVC.title                    = title;
    childVC.tabBarItem.image         = [UIImage imageNamed:imageName];
    childVC.tabBarItem.selectedImage = [UIImage xw_imageAlwaysOriginal:selectedImag]
    ;

    [self addChildViewController:childVC];
    
    
}

@end
