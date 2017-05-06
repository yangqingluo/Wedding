//
//  MyEvaluateCell.h
//  WB_wedding
//
//  Created by 刘人华 on 17/1/19.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MyEvaluateCell;

//@protocol MyEvaluateCellDelegate <NSObject>
//
//@optional
//- (void)deleteComment: (MyEvaluateCell *)cell; //协议方法：删除评论
//- (void)closeOtherCellLeftSwipe;  //关闭其他单元格的左滑
//
//@end
static NSString *const MyEvaluateCellID = @"MyEvaluateCellID";

@interface MyEvaluateCell : UITableViewCell
//静态构造方法
+ (instancetype)cellWithTableView: (UITableView *)tableView;

@property (nonatomic, strong) UIImageView *headerImgeView;
@property (nonatomic, strong) UILabel *nameLab;
@property (nonatomic, strong) UILabel *showLbl; //展示信息
//@property (nonatomic, weak) id<MyEvaluateCellDelegate> delegate; //代理


//- (void)closeSwipe; //关闭滑动，恢复原样（用于在滑动当前单元格时，把其他已经左滑的单元格关闭）

@end
