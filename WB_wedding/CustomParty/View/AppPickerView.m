//
//  AppPickerView.m
//

#import "AppPickerView.h"

@interface AppPickerView ()<UIPickerViewDataSource,UIPickerViewDelegate>


@property (nonatomic, strong) UIButton     *cancleBtn;
@property (nonatomic, strong) UIButton     *sureBtn;
@property (nonatomic, strong) UIView       *topBar;
@property (nonatomic, strong) UIPickerView *piker;
@property (nonatomic, strong) UIView       *contentView;
@property (nonatomic, copy  ) PopDoneBlock     back;

@property (nonatomic, strong) NSArray      *dataSource;

@property (nonatomic, strong) NSNumber     *selectIndex;
@property (nonatomic, assign) NSInteger    index;

@end


@implementation AppPickerView




- (instancetype)initWithCallBack:(PopDoneBlock)callBack WithDataSource:(NSArray *)dataSource{
    self = [super init];
    if (self) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
        self.back = callBack;
        self.selectIndex = @0;
        self.dataSource = dataSource;
        [self config];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissAnimation)];
        [self addGestureRecognizer:tap];
    }
    
    return self;
}


- (void)cancle{
    [self dismissAnimation];
}

- (void)sure{
    if (self.back) {
        self.back(self.selectIndex);
    }
    [self dismissAnimation];
    
    
}
- (void)show{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.frame = [UIScreen mainScreen].bounds;
    [window addSubview:self];
    
    [self toAnimationWithView:self.contentView];
    
    
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
    
    self.piker = [[UIPickerView alloc]init];
    self.piker.backgroundColor = [UIColor whiteColor];
    self.piker.delegate = self;
    self.piker.dataSource = self;
    [self.contentView addSubview:self.piker];
    [self.piker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.topBar.mas_bottom);
        make.left.right.bottom.mas_equalTo(self.contentView);
        
    }];
    
    // 先移动contenView
    self.contentView.transform = CGAffineTransformMakeTranslation(0, self.contentView.bounds.size.height);

    [self.piker selectedRowInComponent:0];
    
}

#pragma UIPickerView
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.dataSource.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return self.dataSource[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    self.selectIndex = @(row);
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 35;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 40)];
    label.font = [UIFont systemFontOfSize:appLabelFontSize];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    return label;
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
- (void)dismissAnimation{
    [UIView animateWithDuration:0.3 animations:^{
        self.contentView.transform = CGAffineTransformMakeTranslation(0, self.contentView.bounds.size.height);
        self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.1];
    } completion:^(BOOL finished) {
        [self.contentView removeFromSuperview];
        [self             removeFromSuperview];
    }];
}

- (CGFloat)randomRange:(NSInteger)range offset:(NSInteger)offset{
    return (CGFloat)(arc4random()%range + offset);
}

@end
