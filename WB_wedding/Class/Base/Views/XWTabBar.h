//
//  XWTabBar.h
//  WB_wedding
//
//  Created by 谢威 on 17/1/9.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XWImageBtn.h"
#import "XWTitleBottomBtn.h"
@protocol XWTabBarDelegate <NSObject>

- (void)TabBarDidIndex:(NSInteger)index;

@end

@interface XWTabBar : UIView

@property (nonatomic,weak)id<XWTabBarDelegate>delegate;
@property (weak, nonatomic) IBOutlet XWTitleBottomBtn *one;

@property (weak, nonatomic) IBOutlet XWTitleBottomBtn *two;

@property (weak, nonatomic) IBOutlet XWImageBtn *three;


@property (weak, nonatomic) IBOutlet XWTitleBottomBtn *four;

@property (weak, nonatomic) IBOutlet XWTitleBottomBtn *five;


- (void)marchSuccess;
- (void)cancelMarch;

@end
