//
//  HQBaseViewController.m
//  HQ
//
//  Created by 谢威 on 16/9/19.
//  Copyright © 2016年 成都卓牛科技. All rights reserved.
//

#import <MBProgressHUD.h>
#import "HQBaseViewController.h"

@interface HQBaseViewController ()<UIGestureRecognizerDelegate>

@property (nonatomic,strong)MBProgressHUD  *xw_hud;
@property (nonatomic,copy)actionBack       back;

@property (nonatomic,copy)actionBack       rightBack;
@property (nonatomic,copy)actionBack       leftBack;

@end

@implementation HQBaseViewController


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.scaleX = KScreenWidth/320;
        self.scaleY = KScreenHeight/568;
   

    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.scaleX = KScreenWidth/320;
        self.scaleY = KScreenHeight/568;
        

    }
    return self;
}
- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = kRGBColor(238, 238, 238);
    /**
     *  房子自定义转场动画导致右滑失效
     */
//    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    [self setUpNavigationBar];

}
#pragma mark -- 配置导航栏
- (void)setUpNavigationBar{
    self.navigationController.navigationBar.hidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
      // 添加状态栏
    self.statusView = [UIView new];
    self.statusView.backgroundColor = KNaviBarTintColor;
    [self.view addSubview:self.statusView];
    [self.statusView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(self.view);
        make.height.mas_equalTo(20);
    }];
    
    // 添加导航栏
    self.baseNavigationBar = [[HQBaseNavigationBar alloc]init];
    [self.view addSubview:self.baseNavigationBar];
    [self.baseNavigationBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.statusView.mas_bottom);
        make.height.mas_equalTo(44);
        
    }];
    //判断子视图控制器的数量，如果为1，则隐藏返回按钮，其它的就给按钮添加方法
    __weak typeof(self)weakSelf = self;
    NSInteger count = self.navigationController.childViewControllers.count;
    if (count > 1) {
        self.baseNavigationBar.backBlock = ^(void){
            [weakSelf.navigationController popViewControllerAnimated:YES];
            weakSelf.baseNavigationBar.backBtn.hidden = NO;
        
        };
        
    }else{
        self.baseNavigationBar.backBtn.hidden = YES;
    }
    [self.view bringSubviewToFront:self.baseNavigationBar];
    
    

    
}

- (void)setTitle:(NSString *)title{
    [super setTitle:title];
     self.baseNavigationBar.titleLable.text = title;
    
}

- (void)setNavBarColor:(UIColor *)navBarColor {
    
    _navBarColor = navBarColor;
    self.baseNavigationBar.backgroundColor = navBarColor;
    self.statusView.backgroundColor = navBarColor;
}

#pragma mark -- 子类实现
- (void)configDataSource{
    
}

- (void)configUserInterface{
    
    
}

- (void)refreshData{
    
}

- (void)hidenNavigationBar{
    self.baseNavigationBar.hidden = YES;
    self.statusView.hidden = YES;
    
}
- (void)showNavigationBar{
    
    self.baseNavigationBar.hidden = NO ;
    self.statusView.hidden = NO ;
    

}


- (void)showMessage:(NSString *)msg toView:(UIView *)view{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabelText = msg;
    hud.detailsLabelFont = [UIFont systemFontOfSize:13];
    [hud hide:YES afterDelay:1];
    
}

- (void)showNoNetError{
    [self showMessage:@"亲,您的网络不稳定哦" toView:self.view];
    
}
- (void)showActivity{
    self.xw_hud = [MBProgressHUD showHUDAddedTo:kAppDelegate.window animated:YES];
    
    self.xw_hud.mode =  MBProgressHUDModeIndeterminate;
    self.xw_hud.removeFromSuperViewOnHide = YES;
}
- (void)cancleActivity{
//    [self.xw_hud hid];
//    [self.xw_hud hideAnimated:YES];
    [self.xw_hud removeFromSuperview];
}
-(void)setNavigationRightBtnWithImageName:(NSString *)imageName actionBack:(actionBack)back{
    self.rightBack = back;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *Image = [UIImage imageNamed:imageName];
    [btn setImage:Image forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.baseNavigationBar addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.baseNavigationBar);
        make.height.mas_equalTo(Image.size.height);
        make.width.mas_equalTo(Image.size.width);
        make.right.mas_equalTo(self.baseNavigationBar.mas_right).offset(-20);
    }];
    
}

#pragma mark -- 设置导航栏右边的文字按钮
- (void)setNavigationRightBtnWithTitle:(NSString *)title actionBack:(actionBack)back{
    
    self.rightBack = back;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    [btn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.baseNavigationBar addSubview:btn];
    CGSize size = [title boundingRectWithSize:CGSizeMake(KScreenWidth, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size;
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.baseNavigationBar);
        make.height.width.mas_equalTo(size.width);
        make.right.mas_equalTo(self.baseNavigationBar.mas_right).offset(-20);
    }];
}

- (void)setNavigationRightBtnWithTitle:(NSString *)title selecterBack:(SEL)sel {
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
    [self.baseNavigationBar addSubview:btn];
    CGSize size = [title boundingRectWithSize:CGSizeMake(KScreenWidth, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil].size;
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.baseNavigationBar);
        make.height.width.mas_equalTo(size.width);
        make.right.mas_equalTo(self.baseNavigationBar.mas_right).offset(-20);
    }];
}


#pragma mark -- 右边按钮的响应
- (void)rightBtnClick:(UIButton *)btn{
    if (self.rightBack) {
        self.rightBack();
    }
}


//检测是否是手机号码
- (BOOL)isMobileNumber:(NSString *)mobileNum
{
    //  手机号正则
    NSString *mobileRegex = @"[1][34578][0-9]{9}";
    NSPredicate *mobilePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", mobileRegex];
    
    if (![mobilePredicate evaluateWithObject:mobileNum]) {
        return NO;
    }
    return YES;
}

/** 将数组转化为json字符串 */
- (NSString *)convertArrayToJson:(NSArray *)array{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:&error];
    if (!error) {
        if (jsonData && jsonData.length > 0) {
            NSString *jsonStr = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
            
            return jsonStr;
        }
        return nil;
    } else {
        return nil;
    }
}


/** 将字典转化为json字符串 *///
- (NSString *)convertDictionaryToJson:(NSDictionary *)dictionary{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:&error];
    if (!error) {
        if (jsonData && jsonData.length > 0) {
            NSString *jsonStr = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
            
            return jsonStr;
        }
        return nil;
    } else {
        return nil;
    }
}




@end
