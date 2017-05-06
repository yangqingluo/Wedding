//
//  XWDatePickerView.m
//  HQ
//
//  Created by 谢威 on 16/9/28.
//  Copyright © 2016年 成都卓牛科技. All rights reserved.
//

#import "XWDatePickerView.h"
#import "AppDelegate.h"
@interface XWDatePickerView ()

@property (nonatomic,strong)UIButton    *cancleBtn;
@property (nonatomic,strong)UIButton    *sureBtn;
@property (nonatomic,strong)UIView      *topBar;
@property (nonatomic,strong)UIDatePicker  *piker;
@property (nonatomic,strong)UIView      *contentView;
@property (nonatomic,copy)CallBack      back;


@end
@implementation XWDatePickerView

-(instancetype)initWithCallBack:(CallBack)callBack{
    if (self = [super init]) {
        self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.1];
        self.back = callBack;
        [self config];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissAnimation)];
        [self addGestureRecognizer:tap];
        
    }
    return self;
}
#pragma mark -- 配置
- (void)config{
      // contenView
    self.contentView = [UIView new];
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self);
        make.height.mas_equalTo(200);
    }];
    // topBar
    self.topBar = [UIView new];
    self.topBar.backgroundColor = KNaviBarTintColor;
    [self.contentView addSubview:self.topBar];
    [self.topBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self.contentView);
        make.height.mas_equalTo(40);
        
    }];
    // 按钮
    self.cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.cancleBtn addTarget:self action:@selector(cancle) forControlEvents:UIControlEventTouchUpInside];
    [self.topBar addSubview:self.cancleBtn];
    [self.cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_equalTo(self.topBar);
        make.width.mas_equalTo(60);

    }];
    
    self.sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [self.sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.sureBtn addTarget:self action:@selector(sure) forControlEvents:UIControlEventTouchUpInside];
    [self.topBar addSubview:self.sureBtn];
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.mas_equalTo(self.topBar);
        make.width.mas_equalTo(60);
        
    }];
    
    
    self.piker=[[UIDatePicker alloc] init];
    self.piker.datePickerMode=UIDatePickerModeDate;
    //设置时间范围
    NSDate*minDate=[NSDate date];
    
    self.piker.minimumDate=[NSDate dateWithTimeIntervalSinceNow:3600 * 24 * 365 * 70];

    self.piker.backgroundColor=[UIColor whiteColor];
    [self.contentView addSubview:self.piker];
    [self.piker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.topBar.mas_bottom);
        make.left.right.bottom.mas_equalTo(self.contentView);
        
    }];

    // 先移动contenView
    self.contentView.transform = CGAffineTransformMakeTranslation(0,200);
    
    
    
}
#pragma mark -- 取消
- (void)cancle{
    [self dismissAnimation];
}
#pragma mark -- 确定
- (void)sure{
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    //这里设置输出格式
    [outputFormatter setDateFormat:@"YYYY-MM-dd"];
    if (self.back) {
        self.back([outputFormatter stringFromDate:self.piker.date]);
    }
    [self dismissAnimation];

    
}
- (void)show{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.frame = [UIScreen mainScreen].bounds;
    [window addSubview:self];
    
    [self toAnimationWithView:self.contentView];
    
    
}


#pragma mark ---- 动画
#pragma mark -- 出现
- (void)toAnimationWithView:(UIView *)view{
    [UIView animateWithDuration:0.3 animations:^{
        self.contentView.transform = CGAffineTransformIdentity;
          self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.3];
    } completion:^(BOOL finished) {
        
    }];
}


#pragma mark -- 消失
-(void)dismissAnimation{
    
    // 先截图
    UIView *snapView = [self.contentView snapshotViewAfterScreenUpdates:YES];
    
    // 隐藏容器中的子控件
    for (UIView *view in self.contentView.subviews) {
        view.hidden = YES;
    }
    self.contentView.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0];
    // 保存x坐标的数组
    NSMutableArray *xArray = [[NSMutableArray alloc] init];
    // 保存y坐标
    NSMutableArray *yArray = [[NSMutableArray alloc] init];
    
    for (NSInteger i = 0; i < self.contentView.bounds.size.width; i = i + 10) {
        [xArray addObject:@(i)];
    }
    for (NSInteger i = 0; i < self.contentView.bounds.size.height; i = i + 10) {
        [yArray addObject:@(i)];
    }
    
    
    //这个保存所有的碎片
    NSMutableArray *snapshots = [[NSMutableArray alloc] init];
    for (NSNumber *x in xArray) {
        
        for (NSNumber *y in yArray) {
            CGRect snapshotRegion = CGRectMake([x doubleValue], [y doubleValue], 10, 10);
            
            // resizableSnapshotViewFromRect 这个方法就是根据frame 去截图
            UIView *snapshot      = [snapView resizableSnapshotViewFromRect:snapshotRegion afterScreenUpdates:NO withCapInsets:UIEdgeInsetsZero];
            snapshot.frame        = snapshotRegion;
            [self.contentView  addSubview:snapshot];
            [snapshots         addObject:snapshot];
        }
    }
    
    
    [UIView animateWithDuration:0.6
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.1];
                         for (UIView *view in snapshots) {
                             view.frame = CGRectOffset(view.frame, [self randomRange:200 offset:-100], [self randomRange:200 offset:self.frame.size.height/2]);
                         }
                     }
                     completion:^(BOOL finished) {
                         for (UIView *view in snapshots) {
                             [view removeFromSuperview];
                         }
                         [self.contentView removeFromSuperview];
                         [self             removeFromSuperview];
                         
                     }];
    
}



- (CGFloat)randomRange:(NSInteger)range offset:(NSInteger)offset{
    
    return (CGFloat)(arc4random()%range + offset);
}







@end
