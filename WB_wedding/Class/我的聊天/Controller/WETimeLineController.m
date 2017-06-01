//
//  WETimeLineController.m
//  WB_wedding
//
//  Created by 谢威 on 17/1/16.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import "WETimeLineController.h"
#import "TimeLineCell.h"
#import "WETimeLineHeaderView.h"
#import "WERecoderView.h"
#import "WEMyChatTool.h"
#import "WEPostTimeLineController.h"
#import "WELocationViewController.h"
#import "WETimeLineDetailController.h"
#import "JKAlert.h"
#import "ImagePickerController.h"
#import "UIImage+Color.h"

@interface WETimeLineController ()<UITableViewDelegate,UITableViewDataSource,WETimeLineHeaderViewDelegate,WERecoderViewDelegate,UIAlertViewDelegate>{
    NSUInteger currentPage;
    NSUInteger m_total;
}

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIView *contenView;

@property (strong, nonatomic) NSMutableArray *dataSource;
@property (strong, nonatomic) WETimeLineHeaderView *headrView;

@property (strong, nonatomic) UserTimeLineData *data;

@end

@implementation WETimeLineController

- (void)dealloc{
    [KNotiCenter removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    
    // 发布成功 刷新数据
    [KNotiCenter addObserver:self selector:@selector(refreshData) name:@"PostSuccess" object:nil];
    [self pullTimeEvent];
}

- (void)setupNav {
    [self createNavWithTitle:nil createMenuItem:^UIView *(int nIndex){
        if (nIndex == 0){
            UIButton *btn = NewBackButton(navigationBarColor);
            [btn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
            return btn;
        }
        else if (nIndex == 1) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            UIImage *i = [UIImage imageNamed:@"bottom_location"];
            [btn setImage:[i imageWithColor:navigationBarColor] forState:UIControlStateNormal];
            [btn setFrame:CGRectMake(screen_width - 64, 0, 64, 44)];
            
            return btn;
        }
        
        return nil;
    }];
    
    self.navBottomLine.backgroundColor = [UIColor clearColor];
    self.navigationBarView.backgroundColor = [UIColor clearColor];
}

- (void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)pullTimeEvent{
    NSDictionary *m_dic = @{@"myId" : [AppPublic getInstance].userData.ID,
                            @"hisOrHerId" : [AppPublic getInstance].userData.loverId
                            };
    
    [self showHudInView:self.view hint:nil];
    
    QKWEAKSELF;
    [[QKNetworkSingleton sharedManager] Get:m_dic HeadParm:nil URLFooter:@"/timeevent/find" completion:^(id responseBody, NSError *error){
        [weakself hideHud];
        
        if (!error) {
            if (isHttpSuccess([responseBody[@"success"] intValue])) {
                weakself.data = [UserTimeLineData mj_objectWithKeyValues:responseBody[@"data"]];
                [weakself configUserInterface];
                [weakself refreshData];
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

- (void)refreshData{
    [self.tableView.mj_header beginRefreshing];
}

- (void)loadFirstPageData{
    [self loadInfoData:1];
}


- (void)loadMoreData{
    [self loadInfoData:++currentPage];
}

- (void)loadInfoData:(NSUInteger)page{
    QKWEAKSELF;
    [[QKNetworkSingleton sharedManager] Get:@{@"timeEventId" : self.data.ID, @"page" : @(page), @"size" : @20} HeadParm:nil URLFooter:@"/timeevent/findevent" completion:^(id responseBody, NSError *error){
        [weakself endRefreshing];
        
        if (!error) {
            if (isHttpSuccess([responseBody[@"success"] intValue])) {
                if (page == 1) {
                    [weakself.dataSource removeAllObjects];
                }
                currentPage = page;
                
                NSDictionary *data = responseBody[@"data"];
                if (data.count) {
                    [weakself.dataSource addObjectsFromArray:[UserTimeLineEventData mj_objectArrayWithKeyValuesArray:data[@"content"]]];
                    
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

- (void)endRefreshing{
    //记录刷新时间
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

- (void)configUserInterface{
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0,KScreenWidth, KScreenHeight) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 100;
    
    
    WETimeLineHeaderView *headrView = [WETimeLineHeaderView xw_loadFromNib];
    
    headrView.frame = CGRectMake(0,0 ,KScreenWidth, 250);
    
    self.tableView.tableHeaderView = headrView;
    
    headrView.delegate = self;
    
    self.headrView  = headrView;
    
    [self.view addSubview:self.tableView];

    
    //设置下拉刷新回调
    QKWEAKSELF;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakself loadFirstPageData];
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakself loadMoreData];
    }];
    self.tableView.mj_header.automaticallyChangeAlpha = YES;

    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = KNaviBarTintColor;
    [btn setTitle:@"记录" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    btn.frame = CGRectMake(KScreenWidth - 45, headrView.bottom - 20, 40, 40);
    [AppPublic roundCornerRadius:btn];
    [self.view addSubview:btn];
    
    [self.headrView.bgInamegView sd_setImageWithURL:imageURLWithPath([NSString stringWithFormat:@"tebg/%@", self.data.backgroundUrl]) placeholderImage:[UIImage imageNamed:downloadImagePlace]];

}

#pragma mark -- 记录时间轴
- (void)btnClick:(UIButton *)sender{
    WEPostTimeLineController  *vc = [[WEPostTimeLineController alloc]init];
    vc.data = self.data;
    
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (void)didSureBtnClick:(NSString *)adress event:(NSString *)envent{
    
     [self.contenView removeFromSuperview];
    
}

- (void)didCancle{
    [self.contenView removeFromSuperview];
    
    
    
}

#pragma mark-- 换背景
- (void)didChangeBgBtn:(UIButton *)sender{
    JKAlert *alert = [[JKAlert alloc]initWithTitle:@"温馨提示" andMessage:@"选择一张照片" style:STYLE_ACTION_SHEET];
    [alert addButton:ITEM_OK withTitle:@"从相册选择" handler:^(JKAlertItem *item) {
        ImagePickerController *vc = [[ImagePickerController alloc]init];
        [vc cameraSourceType:UIImagePickerControllerSourceTypePhotoLibrary onFinishingBlock:^(UIImagePickerController *picker, NSDictionary *info, UIImage *originalImage, UIImage *editedImage) {
        
            
            if (self.data) {
                [self showHudInView:self.view hint:nil];
                [WEMyChatTool postBgPicWithtimeEventId:self.data.ID imag:originalImage success:^(id model) {
                    self.headrView.bgInamegView.image = originalImage;
                    [self hideHud];
                    [self showHint:@"上传成功"];
                    
                } failed:^(NSString *error) {
                    [self hideHud];
                    [self showHint:error.description];
                    
                    
                }];
                
            }
            
            

            
            
            
        } onCancelingBlock:^{
            
        }];
        [self presentViewController:vc animated:YES completion:^{
            
        }];
    }];
    [alert addButton:ITEM_OK withTitle:@"现在拍一张" handler:^(JKAlertItem *item) {
        
        ImagePickerController *vc = [[ImagePickerController alloc]init];
        [vc cameraSourceType:UIImagePickerControllerSourceTypeCamera onFinishingBlock:^(UIImagePickerController *picker, NSDictionary *info, UIImage *originalImage, UIImage *editedImage) {
            
            
            
            if (self.data) {
                [self showHudInView:self.view hint:nil];
                [WEMyChatTool postBgPicWithtimeEventId:self.data.ID imag:originalImage success:^(id model) {
                    self.headrView.bgInamegView.image = originalImage;
                    [self hideHud];
                    [self showHint:@"上传成功"];
                    
                } failed:^(NSString *error) {
                    [self hideHud];
                    [self showHint:error.description];
                    
                    
                }];
                
            }
            

            
        
        } onCancelingBlock:^{
            
        }];
        [self presentViewController:vc animated:YES completion:^{
            
        }];
        
        
    }];
    [alert addButton:ITEM_CANCEL withTitle:@"取消" handler:^(JKAlertItem *item) {
        
        
    }];
    [alert show];
    
    
    
    
}

#pragma mark-- 定位
- (void)didLocationBtn:(UIButton *)sender{
    NSLog(@"点击了定位");
    
    UIAlertView  *view = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您同意开放定位么？如果Ta也同意即可互看定位！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [view show];
  
    
}

#pragma mark ----
- (void)didBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [self showHudInView:self.view hint:nil];
        
        NSString *hisrID = [AppPublic getInstance].userData.loverId;
        
        
        [WEMyChatTool openLocationWithMyId:[AppPublic getInstance].userData.ID hisOrHerId:hisrID success:^(NSString  *model) {
            [self hideHud];
            if ([model isEqualToString:@"2"] ) {
                [self showHint:@"已经向对方申请"];
            }else if([model isEqualToString:@"1"]){
                  [self showHint:@"你们双方已经开启"];
                   //  进入下一届界面
                WELocationViewController *vc = [[WELocationViewController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
            }
            
            
        } failed:^(NSString *error) {
            [self hideHud];
            [self showHint:error];
        }];

    }
}


#pragma tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [TimeLineCell tableView:tableView heightForRowAtIndexPath:indexPath withData:self.dataSource[indexPath.row]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIndentifier = @"timelineCell";
    TimeLineCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    
    if (!cell) {
        cell = [[TimeLineCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.data = self.dataSource[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WETimeLineDetailController *vc = [[WETimeLineDetailController alloc]init];
    
    NSDictionary *dic =  [self.dataSource[indexPath.row] mj_keyValues];
    vc.dic = dic;
    
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma getter
- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
    }
    
    return _dataSource;
}

@end
