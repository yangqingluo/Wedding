//
//  WDMoneyPayView.m
//  WB_wedding
//
//  Created by 刘人华 on 17/1/17.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import "WDMoneyPayView.h"
#import "AppDelegate.h"

@interface WDMoneyPayView ()

@property (nonatomic, strong) UIView *childView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *moneyLab;
@property (weak, nonatomic) IBOutlet UIButton *alipayBtn;
@property (weak, nonatomic) IBOutlet UIButton *wechatBtn;

@property (nonatomic, copy) WDMoneyPayBlock blockSuccess;
@property (nonatomic, copy) void(^blockFaild)();

@end

@implementation WDMoneyPayView

- (instancetype)initWithTitle:(NSString *)title money:(double)money success:(WDMoneyPayBlock)successBlock cancle:(void (^)())cancleBlock {
    
    if (self = [super init]) {
        self.blockFaild = cancleBlock;
        self.blockSuccess = successBlock;
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.6];
        self.childView = [[NSBundle mainBundle] loadNibNamed:@"WDMoneyPayView" owner:self options:nil][0];
        self.childView.bounds = CGRectMake(0, 0, 200, 250);
        self.childView.layer.cornerRadius = 8;
        self.childView.center = self.center;
        [self addSubview:self.childView];
        self.titleLab.text = title;
        self.moneyLab.text = [NSString stringWithFormat:@"￥ %.2lf",money];
    }
    return self;
}

- (IBAction)closeClick:(UIButton *)sender {
    
    if (self.blockFaild) {
        self.blockFaild();
    }
    [self removeFromSuperview];
}

- (IBAction)alipyClick:(UIButton *)sender {
    
    sender.selected = YES;
    _wechatBtn.selected = NO;
}
- (IBAction)weChatClick:(UIButton *)sender {
    
    sender.selected = YES;
    _alipayBtn.selected = NO;
}
- (IBAction)nextStepClick:(UIButton *)sender {
    
    if (self.blockSuccess) {
        self.blockSuccess(_alipayBtn.isSelected?WDMoneyPayAlipay:WDMoneyPayWechat, self.moneyLab.text);
    }
    
    self.childView = nil;
    [self.childView removeFromSuperview];
    [self removeFromSuperview];
}

//- (nullable UIView *)hitTest:(CGPoint)point withEvent:(nullable UIEvent *)event {
//    //判断是否合格
//    if (!self.hidden && self.alpha > 0.01 && self.isUserInteractionEnabled) {
//        //判断点击位置是否在自己区域内部
//        if ([self pointInside: point withEvent:event]) {
//            UIView *attachedView;
//            for (int i = self.subviews.count - 1; i >= 0; i--) {
//                UIView *view  = self.subviews[i];
//                CGPoint coveredPoint = [view convertPoint:point fromView:self];
//                //对子view进行hitTest
//                attachedView = [view hitTest:coveredPoint withEvent:event];
//                if (attachedView)
//                    break;
//            }
//            if (attachedView && attachedView != self.childView)  {
//                return attachedView;
//            } else if (attachedView && attachedView == self.childView){
//                event = nil;
//                return nil;
//            }else {
//                return self;
//            }
//        }
//    }
//    return nil;
//}
//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    
//    [self removeFromSuperview];
//}
- (void)show {
    
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    [app.window addSubview:self];
}
@end
