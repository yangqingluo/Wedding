//
//  EMChoicePriceSliderView.m
//  EMSliderPrice
//
//  Created by xiaoka on 16/11/22.
//  Copyright © 2016年 xiaoka. All rights reserved.
//

#import "EMChoicePriceSliderView.h"

@interface EMChoicePriceSliderView ()
{
    CGFloat piceMoney;
    NSString *maxMoney;
    NSString *minMoney;
}
@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) UIView *leftView;
@property (nonatomic, strong) UIView *rightView;

@property (nonatomic, strong) UIView *left;
@property (nonatomic, strong) UIView *right;

@property (nonatomic, strong) NSArray *moneyArr;
@end

@implementation EMChoicePriceSliderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initWithSubView];
    }
    return self;
}

- (void) initWithSubView{
    
    _moneyArr = @[@"20",@"30",@"40",@"50",@"60",@"70"];
    maxMoney = @"70";
    minMoney = @"18";
    
    [self addSubview:self.lineView];
    
    [self setpUI];
    
    [self addSubview:self.leftView];
    [self addSubview:self.rightView];
    
    [self addSubview:self.left];
    [self addSubview:self.right];
}

- (void)setpUI{
    CGFloat num = [[NSString stringWithFormat:@"%@",[_moneyArr lastObject]] doubleValue];
    piceMoney =  num / self.lineView.frame.size.width;
    
    CGFloat width = self.lineView.frame.size.width / _moneyArr.count;
    
    UIView *viewT = [UIView new];
    viewT.frame = CGRectMake(5, self.lineView.frame.origin.y - 5, 2, 5);
    viewT.backgroundColor = [UIColor orangeColor];
    [self addSubview:viewT];
    
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0,0 , 60, 30)];
    lable.text = @"0";
    lable.textColor = [UIColor redColor];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.font = [UIFont systemFontOfSize:12];
    lable.center = CGPointMake(viewT.center.x, viewT.center.y - 10);
    [self addSubview:lable];

    for (int i = 1; i <= _moneyArr.count ; i ++) {
        
        UIView *view = [UIView new];
        if (i ==  _moneyArr.count) {
            view.frame =  CGRectMake(i *width+3, self.lineView.frame.origin.y - 5, 2, 5);
            view.backgroundColor = [UIColor orangeColor];
            [self addSubview:view];
            
            UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0,0 , 60, 30)];
//            lable.text = @"不限";
            lable.textColor = [UIColor redColor];
            lable.textAlignment = NSTextAlignmentCenter;
            lable.font = [UIFont systemFontOfSize:12];
            lable.center = CGPointMake(view.center.x, view.center.y - 10);
            [self addSubview:lable];
        }else{
             view.frame = CGRectMake(i *width+5, self.lineView.frame.origin.y - 5, 2, 5);
            view.backgroundColor = [UIColor orangeColor];
            [self addSubview:view];
            
            UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0,0 , 60, 30)];
            lable.text = _moneyArr[i -1];
            lable.textColor = [UIColor redColor];
            lable.textAlignment = NSTextAlignmentCenter;
            lable.font = [UIFont systemFontOfSize:12];
            lable.center = CGPointMake(view.center.x, view.center.y - 10);
            [self addSubview:lable];
        }
        
    }
}

#pragma mark - 懒加载
- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(5, self.frame.size.height - 10, self.frame.size.width -10, 2)];
        _lineView.backgroundColor  = [UIColor blueColor];
    }
    
    return _lineView;
}


- (UIView *)left{
    if (!_left) {
        _left = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
        _left.center = CGPointMake(self.lineView.frame.origin.x, self.lineView.frame.origin.y);
        _left.layer.cornerRadius = 5;
        _left.layer.masksToBounds = YES;
        _left.backgroundColor = [UIColor redColor];
        
        _left.alpha = 1;
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(leftPanEvent:)];
        [_left addGestureRecognizer:pan];
    }
    return _left;
}
- (UIView *)leftView{
    if (!_leftView) {
        _leftView = [[UIView alloc] initWithFrame:CGRectMake(self.lineView.frame.origin.x, self.lineView.frame.origin.y, 0, 2)];
        _leftView.backgroundColor = [UIColor blackColor];
    }
    return _leftView;
}

- (UIView *)right{
    if (!_right) {
        _right = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
        _right.layer.cornerRadius = 5;
        _right.layer.masksToBounds = YES;
        _right.center = CGPointMake(self.lineView.frame.size.width + self.lineView.frame.origin.x,  self.lineView.frame.origin.y);
        _right.backgroundColor = [UIColor redColor];
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(rightPanEvent:)];
        _right.alpha = 1;
        [_right addGestureRecognizer:pan];
    }
    return _right;
}

- (UIView *)rightView{
    if (!_rightView) {
        _rightView = [[UIView alloc] initWithFrame:CGRectMake(self.lineView.frame.size.width + self.lineView.frame.origin.x, self.lineView.frame.origin.y, 0,2)];
        _rightView.backgroundColor = [UIColor blackColor];
    }
    return _rightView;
}

#pragma mark - 滑动事件
- (void)leftPanEvent:(UIPanGestureRecognizer *)gesture{
    
    if (gesture.state == UIGestureRecognizerStateChanged) {
        CGPoint offset = [gesture translationInView:self];
        CGFloat y = gesture.view.center.y;
        CGFloat x = gesture.view.center.x +offset.x;
        
        if (x <self.lineView.frame.origin.x) {
            x = self.lineView.frame.origin.x;
        }
        
        if (x > self.right.center.x - 10) {
            x =  self.right.center.x - 10;
        }
        gesture.view.center = CGPointMake(x, y);
        [gesture setTranslation:CGPointMake(0, 0) inView:self];
        self.leftView.frame = CGRectMake(self.leftView.frame.origin.x, self.leftView.frame.origin.y, x, self.leftView.frame.size.height);
        
        minMoney = [NSString stringWithFormat:@"%.2f",(x - 5)*piceMoney];
    }else if(gesture.state == UIGestureRecognizerStateEnded){
        if (self.delegate && [self.delegate respondsToSelector:@selector(choicePriceViewGetMinMoney:maxMoney:)]) {
            [self.delegate choicePriceViewGetMinMoney:minMoney maxMoney:maxMoney];
        }
    }
}
- (void)rightPanEvent:(UIPanGestureRecognizer *)gesture{
    if (gesture.state == UIGestureRecognizerStateChanged) {
        CGPoint offset = [gesture translationInView:self];
        
        CGFloat y = gesture.view.center.y;
        CGFloat x = gesture.view.center.x + offset.x;
        
        if (x < self.left.center.x + 10) {
            x =  self.left.center.x + 10;
        }
        
        if (x > self.lineView.frame.origin.x + self.lineView.frame.size.width ) {
            x = self.lineView.frame.origin.x + self.lineView.frame.size.width;
        }
        gesture.view.center = CGPointMake(x, y);
        
        [gesture setTranslation:CGPointMake(0, 0) inView:self];
        self.rightView.frame = CGRectMake(x , self.rightView.frame.origin.y, self.lineView.frame.size.width - x, self.rightView.frame.size.height);
        
        maxMoney = [NSString stringWithFormat:@"%.2f",(x - 5)*piceMoney];
    }else if(gesture.state == UIGestureRecognizerStateEnded){
        if (self.delegate && [self.delegate respondsToSelector:@selector(choicePriceViewGetMinMoney:maxMoney:)]) {
            [self.delegate choicePriceViewGetMinMoney:minMoney maxMoney:maxMoney];
        }
    }
}



@end
