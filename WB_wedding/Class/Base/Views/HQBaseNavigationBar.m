//
//  HQBaseNavigationBar.m
//  HQ
//
//  Created by 谢威 on 16/9/20.
//  Copyright © 2016年 成都卓牛科技. All rights reserved.
//

#import "HQBaseNavigationBar.h"

@implementation HQBaseNavigationBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = KNaviBarTintColor;
        
        // lable
        self.titleLable = [[UILabel alloc]init];
        self.titleLable.textAlignment = NSTextAlignmentCenter;
        self.titleLable.font = [UIFont systemFontOfSize:18];
        self.titleLable.textColor = [UIColor whiteColor];
        
        [self addSubview:self.titleLable];
        [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self);
            make.centerY.mas_equalTo(self);
            
        }];

        //设置返回Button
        self.backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.backBtn setImage:[UIImage imageNamed:@"return48_white"] forState:UIControlStateNormal];
        self.backBtn.frame = CGRectMake(0, 0, 64, 44);
        self.backBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -4, 0, 24);
        [self addSubview:self.backBtn];
        [self.backBtn addTarget:self action:@selector(leftBtnClick:) forControlEvents:UIControlEventTouchUpInside];

        
    }
    return self;
}

- (void)leftBtnClick:(UIButton *)sender{
    if (self.backBlock) {
        self.backBlock();
    }
    
    
    
    
}



@end
