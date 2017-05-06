//
//  HQBaseNavigationBar.h
//  HQ
//
//  Created by 谢威 on 16/9/20.
//  Copyright © 2016年 成都卓牛科技. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^BtnClickBlock)(void);

/**
 *  自定义的导航栏 系统的导航栏被隐藏了
 */
@interface HQBaseNavigationBar : UIView

@property (nonatomic,strong) UILabel *titleLable;
@property (nonatomic,strong) UIButton *backBtn;

@property (nonatomic,copy)BtnClickBlock backBlock;

@property (nonatomic,strong)UIImage *backImage;
@end
