//
//  UserLoveRecordVC.m
//  WB_wedding
//
//  Created by yangqingluo on 2017/5/18.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import "UserLoveRecordVC.h"

#import "ImageViewCell.h"
#import "BlockAlertView.h"

@interface UserLoveRecordVC()<UITextFieldDelegate>{
    NSUInteger currentPage;
    NSUInteger m_total;
}

@property (nonatomic, assign) NSUInteger indextag;

@property (strong, nonatomic) NSMutableArray *dataSource;

@end

@implementation UserLoveRecordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    
    //设置下拉刷新回调
    QKWEAKSELF;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakself loadFirstPageData];
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakself loadMoreData];
    }];
    
    [self.tableView.mj_header beginRefreshing];
}

- (void)setupNav {
    [self createNavWithTitle:@"恋爱记录" createMenuItem:^UIView *(int nIndex){
        if (nIndex == 0){
            UIButton *btn = NewBackButton(nil);
            [btn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
            return btn;
        }
        
        return nil;
    }];
}

- (void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)reloveButtonAction:(UIButton *)button{
    QKWEAKSELF;
    BlockAlertView *alert = [[BlockAlertView alloc] initWithTitle:nil message:@"确定复合？" cancelButtonTitle:@"取消" clickButton:^(NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            [weakself checkReloveAtIndex:button.tag];
        }
    }otherButtonTitles:@"确定", nil];
    [alert show];
}

- (void)refreshData{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        [self loadFirstPageData];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //update UI
        });
    });
}

- (void)loadFirstPageData{
    [self loadInfoData:1];
}


- (void)loadMoreData{
    [self loadInfoData:++currentPage];
}

- (void)loadInfoData:(NSUInteger)page{
    QKWEAKSELF;
    [[QKNetworkSingleton sharedManager] Post:@{@"ids":[AppPublic getInstance].userData.exloverIds, @"page":@(page), @"size":@20} HeadParm:nil URLFooter:@"/loverecord/findexlovers" completion:^(id responseBody, NSError *error){
        [weakself endRefreshing];
        
        if (!error) {
            if (isHttpSuccess([responseBody[@"success"] intValue])) {
                if (page == 1) {
                    [weakself.dataSource removeAllObjects];
                }
                currentPage = page;
                
                NSDictionary *data = responseBody[@"data"];
                if (data.count) {
                    [weakself.dataSource addObjectsFromArray:[AppUserData mj_objectArrayWithKeyValuesArray:data[@"content"]]];
                    
                    m_total = [data[@"totalElements"] integerValue];
                    if (weakself.dataSource.count >= m_total) {
                        [weakself.tableView.mj_footer endRefreshingWithNoMoreData];
                        
                    }
                }
                
                [weakself.tableView reloadData];
            }
            else {
                [weakself showHint:responseBody[@"msg"]];
            }
        }
        else{
            [weakself showHint:@"网络出错"];
        }
        
    }];
}

- (void)checkReloveAtIndex:(NSUInteger)index{
    AppUserData *userData = self.dataSource[index];
    
    [self showHudInView:self.view hint:nil];
    QKWEAKSELF;
    [[QKNetworkSingleton sharedManager] Post:@{@"myId":[AppPublic getInstance].userData.ID, @"hisOrHerId":userData.ID} HeadParm:nil URLFooter:@"/loverecord/relove" completion:^(id responseBody, NSError *error){
        [weakself hideHud];
        
        if (!error) {
            if (isHttpSuccess([responseBody[@"success"] intValue])) {
                switch ([responseBody[@"data"] intValue]) {
                    case 0:{
                        //没发过复合消息
                        if ([[AppPublic getInstance].userData isVip]) {
                            QKWEAKSELF;
                            BlockAlertView *alert = [[BlockAlertView alloc] initWithTitle:nil message:@"确定发送复合请求？" cancelButtonTitle:@"取消" callBlock:^(UIAlertView *view, NSInteger buttonIndex) {
                                if (buttonIndex == 1) {
                                    [weakself reloveAtIndex:index andContent:[view textFieldAtIndex:0].text];
                                }
                            }otherButtonTitles:@"确定", nil];
                            
                            alert.alertViewStyle = UIAlertViewStylePlainTextInput;
                            UITextField *alertTextField = [alert textFieldAtIndex:0];
                            alertTextField.clearButtonMode = UITextFieldViewModeAlways;
                            alertTextField.returnKeyType = UIReturnKeyDone;
                            alertTextField.delegate = self;
                            alertTextField.placeholder = @"请说点什么吧";
                            
                            [alert show];
                        }
                        else {
                            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"您不是vip，不能发送复合消息" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil , nil];
                            [alert show];
                        }
                    }
                        break;
                        
                    case 2:{
                        //发过复合消息
                        [self showHint:@"直接建立关系"];
                    }
                        break;
                        
                    default:
                        break;
                }
            }
            else {
                [weakself showHint:responseBody[@"msg"]];
            }
        }
        else{
            [weakself showHint:@"网络出错"];
        }
        
    }];
    
}

- (void)reloveAtIndex:(NSUInteger)index andContent:(NSString *)content{
    if (index < self.dataSource.count && content.length) {
        AppUserData *userData = self.dataSource[index];
        
        [self showHudInView:self.view hint:nil];
        
        NSArray *array = [[AppPublic getInstance].userData.imgFileNames componentsSeparatedByString:@","];
        NSDictionary *dic = @{@"content" : content,
                              @"imgName" : array.count ? array[0] : @"",
                              @"otherId" : [AppPublic getInstance].userData.ID,
                              @"otherNickName" : [AppPublic getInstance].userData.nickname,
                              @"myId" : userData.ID};
        
        
        QKWEAKSELF;
        [[QKNetworkSingleton sharedManager] Post:@{@"telNumber":[AppPublic getInstance].userData.telNumber, @"dto" : dic} HeadParm:nil URLFooter:@"/loverecord/sendrelovemsg" completion:^(id responseBody, NSError *error){
            [weakself hideHud];
            
            if (!error) {
                if (isHttpSuccess([responseBody[@"success"] intValue])) {
                    [weakself showHint:@"发送成功"];
                }
                else {
                    [weakself showHint:responseBody[@"msg"]];
                }
            }
            else{
                [weakself showHint:@"网络出错"];
            }
            
        }];
    }
}

- (void)endRefreshing{
    //记录刷新时间
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

#pragma getter
- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
    }
    
    return _dataSource;
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return kEdgeMiddle;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"love_record_cell";
    ImageViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[ImageViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.showImageView.frame = CGRectMake(kEdgeMiddle, 5, 50.0, 50.0);
        [AppPublic roundCornerRadius:cell.showImageView];
        
        cell.titleLabel.textAlignment = NSTextAlignmentCenter;
        cell.titleLabel.frame = CGRectMake(0, cell.showImageView.bottom, cell.showImageView.width + 2 * kEdgeMiddle, 20);
        
        cell.tagButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cell.tagButton.frame = CGRectMake(0, 0, 80, 30);
        cell.tagButton.right = screen_width - kEdgeMiddle;
        cell.tagButton.centerY = 0.5 * 80;
        [cell.tagButton setTitle:@"复合" forState:UIControlStateNormal];
        [cell.tagButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        cell.tagButton.titleLabel.font = [UIFont systemFontOfSize:appButtonTitleFontSize];
        [AppPublic roundCornerRadius:cell.tagButton cornerRadius:5.0];
        cell.tagButton.layer.borderColor = [UIColor redColor].CGColor;
        cell.tagButton.layer.borderWidth = 1.0;
        [cell.contentView addSubview:cell.tagButton];
        [cell.tagButton addTarget:self action:@selector(reloveButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.subTitleLabel.frame = CGRectMake(cell.titleLabel.right + kEdge, 0, cell.tagButton.left -  kEdgeMiddle - (cell.titleLabel.right + kEdge), 80);
        cell.subTitleLabel.font = [UIFont systemFontOfSize:appLabelFontSize];
    }
    
    cell.tagButton.tag = indexPath.row;
    
    AppUserData *userData = self.dataSource[indexPath.row];
    
    if (userData.imgArray.count) {
        [cell.showImageView sd_setImageWithURL:[NSURL URLWithString:imageUrlStringWithImagePath(userData.imgArray[0])] placeholderImage:[UIImage imageNamed:downloadImagePlace]];
    }
    else {
        cell.showImageView.image = [UIImage imageNamed:downloadImagePlace];
    }
    
    cell.titleLabel.text = userData.nickname;
    cell.subTitleLabel.text = @"";
    
    NSArray *exsRelationTimeArray = [[AppPublic getInstance].userData subItemsIndexWithKey:@"exsRelationTime" andSeparatedByString:@","];
    if (indexPath.row < exsRelationTimeArray.count) {
        NSString *exsRelationTime = exsRelationTimeArray[indexPath.row];
        NSString *timeString = [AppUserData showRelationTimeWithTimeString:exsRelationTime];
        if (timeString) {
            cell.subTitleLabel.text = [NSString stringWithFormat:@"共同经历了%@", timeString];
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma  mark - TextField
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    return (range.location < kInputLengthMax);
}

@end
