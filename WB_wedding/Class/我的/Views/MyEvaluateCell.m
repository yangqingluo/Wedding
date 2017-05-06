//
//  MyEvaluateCell.m
//  WB_wedding
//
//  Created by 刘人华 on 17/1/19.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import "MyEvaluateCell.h"
#define CELLHEIGHT 80.f  //设置行高

@interface MyEvaluateCell ()



//@property (nonatomic, weak) UIView *containerView; //容器view
@property (nonatomic, weak) UIView *underlineView; //下划线


//@property (nonatomic, weak) UIButton *telBtn; //底层打电话按钮
//@property (nonatomic, weak) UIButton *deleteBtn; //底层删除按钮
//@property (nonatomic, assign) BOOL isOpenLeft; //是否已经打开左滑动
@end

@implementation MyEvaluateCell

//- (void)awakeFromNib {
//    // Initialization code
//    self.headerImgView.layer.cornerRadius = 20;
//    self.headerImgView.clipsToBounds = YES;
//    [self initSubControls]; //初始化子控件
//}

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *reuseIdentity = @"tanCell";
    
    MyEvaluateCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentity];
    
    if (cell == nil){
        cell = [[MyEvaluateCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentity];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self initSubControls]; //初始化子控件
    }
    return self;
}

//初始化子控件
- (void)initSubControls{
//    //1、添加底层层的电话和删除按钮
//    UIButton *telBtn = [[UIButton alloc] init];
//    [self.contentView addSubview:telBtn];
//    self.telBtn = telBtn;
//    [self.telBtn setTitle:@"删除" forState:UIControlStateNormal];
//    [self.telBtn setBackgroundColor:[UIColor orangeColor]];
//    //绑定打电话事件
//    [self.telBtn addTarget:self action:@selector(toTelephone:) forControlEvents:UIControlEventTouchUpInside];
//    
//    UIButton *deleteBtn = [[UIButton alloc] init];
//    [self.contentView addSubview:deleteBtn];
//    self.deleteBtn = deleteBtn;
//    [self.deleteBtn setTitle:@"投诉" forState:UIControlStateNormal];
//    [self.deleteBtn setBackgroundColor:[UIColor redColor]];
//    //绑定删除会员事件
//    [self.deleteBtn addTarget:self action:@selector(deleteMember:) forControlEvents:UIControlEventTouchUpInside];
//    
//    //2、添加外层显示控件
//    UIView *containerView = [[UIView alloc] init];
//    [self.contentView addSubview:containerView];
//    self.containerView = containerView;
//    self.containerView.backgroundColor = [UIColor whiteColor];
    
    UILabel *showLbl = [[UILabel alloc] init];
    [self.contentView addSubview:showLbl];  //将showLbl添加到容器containerView上
    self.showLbl = showLbl;
    [self.showLbl setTextColor:[UIColor blackColor]];
    self.showLbl.font = KFont(14);
    self.showLbl.text = @"说：这是个渣男，玩弄感情";
    
    UIView *underlineView = [[UIView alloc] init];
    [self.contentView addSubview:underlineView]; //将下划线添加到容器containerView上
    self.underlineView = underlineView;
    self.underlineView.backgroundColor = [UIColor lightGrayColor];
    
    UIImageView *headerImgeView = [[UIImageView alloc] init];
    headerImgeView.backgroundColor = [UIColor redColor];
    self.headerImgeView = headerImgeView;
    self.headerImgeView.image = [UIImage imageNamed:@"baby"];
    self.headerImgeView.layer.cornerRadius = 20;
    self.headerImgeView.layer.masksToBounds = YES;
    
    [self.contentView addSubview:headerImgeView];
    
    
    self.nameLab = [UILabel new];
    self.nameLab.text = @"angle";
    [self.contentView addSubview:self.nameLab];
    
    //3、给容器containerView绑定左右滑动清扫手势
//    UISwipeGestureRecognizer *leftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
//    leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft; //设置向左清扫
//    [self.containerView addGestureRecognizer:leftSwipe];
//    
//    UISwipeGestureRecognizer *rightSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
//    rightSwipe.direction = UISwipeGestureRecognizerDirectionRight;//设置向右清扫
//    [self.containerView addGestureRecognizer:rightSwipe];
//    
//    self.selectionStyle = UITableViewCellSelectionStyleNone; //设置单元格选中样式
//    [self.contentView bringSubviewToFront:self.containerView]; //设置containerView显示在最上层
}

//子控件布局
- (void)layoutSubviews{
//    CGFloat telWidth = SCREEN_W * 0.3; //设置电话按钮宽度
//    CGFloat deleteWidth = SCREEN_W * 0.2; //设置删除按钮宽度
//    
//    self.telBtn.frame = CGRectMake(SCREEN_W * 0.5, 0, telWidth, CELLHEIGHT);
//    self.deleteBtn.frame = CGRectMake(SCREEN_W * 0.8, 0, deleteWidth, CELLHEIGHT);
//    
//    self.containerView.frame = self.contentView.bounds;
    self.showLbl.frame = CGRectMake(100, 20, SCREEN_W - 100, 40);
    
    self.nameLab.frame = CGRectMake(20, 50, 80, 20);
    self.headerImgeView.frame = CGRectMake(20, 5, 40, 40);
    self.underlineView.frame = CGRectMake(0, 79, SCREEN_W, 1);
}



@end
