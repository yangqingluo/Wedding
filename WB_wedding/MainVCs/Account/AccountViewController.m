//
//  AccountViewController.m
//  WB_wedding
//
//  Created by yangqingluo on 2017/5/17.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import "AccountViewController.h"
#import "WELoveRecoderController.h"

#import "UserInfoVC.h"
#import "UserWalletViewController.h"
#import "UserLoveRecordVC.h"
#import "UserJudgementVC.h"
#import "UserMessageVC.h"
#import "PublicWebViewController.h"
#import "UserSettingVC.h"

#import "ImageViewCell.h"

@interface AccountViewController ()

@property (strong, nonatomic) NSArray *showArray;
@property (strong, nonatomic) UIView *headerView;
@property (strong, nonatomic) UILabel *headerLabel;
@property (strong, nonatomic) UIImageView *headerImage;

@end

@implementation AccountViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateSubviews];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    
    self.tableView.tableHeaderView = self.headerView;
}

- (void)setupNav {
    [self createNavWithTitle:@"我的" createMenuItem:^UIView *(int nIndex){
        
        return nil;
    }];
    
}

- (void)updateSubviews{
    self.headerLabel.text = [AppPublic getInstance].userData.nickname ? [AppPublic getInstance].userData.nickname : @"还没有昵称";
    
    if ([AppPublic getInstance].userData.imgArray.count) {
        [self.headerImage sd_setImageWithURL:[NSURL URLWithString:imageUrlStringWithImagePath([AppPublic getInstance].userData.imgArray[0])] placeholderImage:[UIImage imageNamed:downloadImagePlace]];
    }
    else {
        self.headerImage.image = [UIImage imageNamed:downloadImagePlace];
    }
    
    [self.tableView reloadData];
}

- (void)headerPress:(UIGestureRecognizer *)gesture{
    UserInfoVC *vc = [UserInfoVC new];
    vc.title = @"我的资料";
    vc.infoType = UserInfoTypeSelf;
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma getter
- (NSArray *)showArray{
    if (!_showArray) {
        _showArray = @[
                       @[@{@"title":@"我的钱包",@"subTitle":@"",@"headImage":@""},
                         @{@"title":@"恋爱记录",@"subTitle":@"",@"headImage":@"record"},
                         @{@"title":@"我的评价",@"subTitle":@"",@"headImage":@"comment"},
                         @{@"title":@"我的消息",@"subTitle":@"",@"headImage":@"message"},
                         @{@"title":@"时间轴记录",@"subTitle":@"",@"headImage":@"record"},
                         @{@"title":@"设置",@"subTitle":@"",@"headImage":@"settings"},
                         @{@"title":@"帮助与支持",@"subTitle":@"",@"headImage":@"help"},
                         ]
                       ];
    }
    
    return _showArray;
}

- (UIView *)headerView{
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 120)];
        _headerView.backgroundColor = [UIColor whiteColor];
        
        _headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(kEdgeMiddle, 0.35 * _headerView.height, 0.6 * _headerView.width, 20)];
        _headerLabel.font = [UIFont systemFontOfSize:appLabelFontSizeMiddle];
        [_headerView addSubview:_headerLabel];
        
        _headerImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 70, 70)];
        [AppPublic roundCornerRadius:_headerImage];
        _headerImage.centerY = 0.5 * _headerView.height;
        _headerImage.right = _headerView.width - 2 * kEdgeMiddle;
        [_headerView addSubview:_headerImage];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(_headerLabel.left, _headerLabel.bottom + kEdgeSmall, _headerLabel.width, 16)];
        label.font = [UIFont systemFontOfSize:appLabelFontSize];
        label.textColor = [UIColor grayColor];
        [_headerView addSubview:label];
        label.text = @"查看并编辑个人资料";
        
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerPress:)];
        [_headerView addGestureRecognizer:gesture];
    }
    
    return _headerView;
}

#pragma tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.showArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *array = self.showArray[section];
    
    return array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == self.showArray.count - 1) {
        return kEdgeMiddle;
    }
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return iPhone5AndEarlyDevice ? kCellHeight : kCellHeightMiddle;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"account_cell";
    ImageViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[ImageViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.showImageView.frame = CGRectMake(0, 0, 28.0, 28.0);
        cell.showImageView.right = screen_width - 3 * kEdgeMiddle;
        cell.showImageView.centerY = 0.5 * (iPhone5AndEarlyDevice ? kCellHeight : kCellHeightMiddle);
        
        cell.subTitleLabel.frame = CGRectMake(kEdgeMiddle, 0, screen_width - 4 * kEdgeMiddle, 20);
        cell.subTitleLabel.centerY = cell.showImageView.centerY;
        cell.subTitleLabel.textAlignment = NSTextAlignmentRight;
        cell.subTitleLabel.font = [UIFont systemFontOfSize:appLabelFontSize];
    }
    
    NSArray *array = self.showArray[indexPath.section];
    NSDictionary *dic = array[indexPath.row];
    cell.textLabel.text = [dic objectForKey:@"title"];
    
    if (indexPath.row == 0) {
        //我的钱包
        cell.subTitleLabel.hidden = NO;
        cell.showImageView.hidden = YES;
        
        cell.subTitleLabel.text = [NSString stringWithFormat:@"%d", [AppPublic getInstance].userData.money];
    }
    else {
        cell.subTitleLabel.hidden = YES;
        cell.showImageView.hidden = NO;
        cell.showImageView.image = [UIImage imageNamed:[dic objectForKey:@"headImage"]];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0){
        switch (indexPath.row) {
            case 0:{
                //我的钱包
                UserWalletViewController *vc = [UserWalletViewController new];
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 1:{
                //恋爱记录
                UserLoveRecordVC *vc = [UserLoveRecordVC new];
                [self.navigationController pushViewController:vc animated:YES];
                
            }
                break;
            case 2:{
                //我的评价
                UserJudgementVC *vc = [UserJudgementVC new];
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 3:{
                //我的消息
                UserMessageVC *vc = [UserMessageVC new];
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 4:{
                //时间轴
            }
                break;
            case 5:{
                //设置
                UserSettingVC *vc = [UserSettingVC new];
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 6:{
                //帮组和设置
                PublicWebViewController *vc = [[PublicWebViewController alloc] initWithURLString:@"http://123.207.120.62:8080/wanwanpage/pages/help.html"];
                vc.title = @"帮助与支持";
                
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
                
            default:
                break;
        }
    }
    
}

@end
