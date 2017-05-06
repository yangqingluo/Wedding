//
//  XWTabBar.m
//  WB_wedding
//
//  Created by 谢威 on 17/1/9.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import "XWTabBar.h"
#import "XWTitleBottomBtn.h"

@interface XWTabBar()
@property(nonatomic,assign)NSInteger    lastIndex;

@property (nonatomic,strong)NSMutableArray      *arrM;
@end
@implementation XWTabBar

- (void)awakeFromNib{
    self.lastIndex = 2;
    self.arrM = [NSMutableArray array];
    [self.arrM addObject:self.one];
    [self.arrM addObject:self.two];
    [self.arrM addObject:self.three];
    [self.arrM addObject:self.four];
    [self.arrM addObject:self.five];
    self.three.selected = YES;
    
    [super awakeFromNib];
}

#pragma mark -- 匹配成功
- (void)marchSuccess{
    
    self.two.userInteractionEnabled = NO;
    self.three.userInteractionEnabled = NO;
    self.four.userInteractionEnabled = NO;
    
//    
//    self.two.selected = NO;
//    self.three.selected = NO;
//    self.four.selected = NO;
}

- (void)cancelMarch{
    self.two.userInteractionEnabled = YES;
    self.three.userInteractionEnabled = YES;
    self.four.userInteractionEnabled = YES;
    
}



- (IBAction)btnClick:(UIButton *)sender {
    for (UIButton *btn in self.arrM) {
        
        if (btn == sender) {
            
            sender.selected = YES;
            
        }else{
            
            
            btn.selected =NO;
            
        }
        
        
    }
    [self.delegate TabBarDidIndex:sender.tag];
    
    
    
}







@end
