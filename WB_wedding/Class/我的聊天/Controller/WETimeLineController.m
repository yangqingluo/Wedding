//
//  WETimeLineController.m
//  WB_wedding
//
//  Created by 谢威 on 17/1/16.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import "WETimeLineController.h"
#import "WETimeLineCell.h"
#import "WETimeLineHeaderView.h"
#import "WERecoderView.h"
#import "WEMyChatTool.h"
#import "WEPostTimeLineController.h"
#import "WELocationViewController.h"
#import "WETimeLineDetailController.h"
#import "JKAlert.h"
#import "ImagePickerController.h"
@interface WETimeLineController ()<UITableViewDelegate,UITableViewDataSource,WETimeLineHeaderViewDelegate,WERecoderViewDelegate,UIAlertViewDelegate>

@property (nonatomic,strong)UITableView     *tableView;
@property (nonatomic,strong) UIView         *contenView;
@property (nonatomic,strong)NSDictionary        *infoDic;
@property (nonatomic,strong)NSMutableArray      *dataSource;
@property (nonatomic,strong)  WETimeLineHeaderView *headrView;

@end

@implementation WETimeLineController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUserInterface];
//    [self configDataSource];
    // 发布成功 刷新数据
    [KNotiCenter addObserver:self selector:@selector(configNewData) name:@"PostSuccess" object:nil];
}



-(void)configNewData{
    self.dataSource = [NSMutableArray array];
   
    
    
    if ([KUserDefaults objectForKey:KHisHerID]==nil) {
        [self showMessage:@"你还没有匹配的人" toView:self.view];
        return;
    }
    NSDictionary *dic = @{
                          @"myId":[XWUserModel getUserInfoFromlocal].xw_id,
                          @"hisOrHerId":[KUserDefaults objectForKey:KHisHerID]
                          
                          };
    
     [self showActivity];
    [HQBaseNetManager GET:BASEURL(@"/timeevent/find") parameters:dic completionHandler:^(id responseObj, NSError *error) {
        if ([responseObj[@"msg"]isEqualToString:@"请求成功"]) {
            // 这里设置背景图片
            [self cancleActivity];
            self.infoDic  = responseObj[@"data"];
            
            
            NSURL *imagURL =[NSURL URLWithString: [NSString stringWithFormat:@"%@/tebg/%@/%@",ImageURL,self.infoDic[@"id"],self.infoDic[@"backgroundUrl"]]];
            
            
            [self.headrView.bgInamegView sd_setImageWithURL:imagURL placeholderImage:nil];

            
            NSDictionary *dicc = @{
                                   @"timeEventId":self.infoDic[@"id"],
                                   @"page":@"1",
                                   @"size":@"200"
                                   };
            [HQBaseNetManager GET:BASEURL(@"/timeevent/findevent") parameters:dicc completionHandler:^(id responseObjsss, NSError *error) {
                [self.dataSource removeAllObjects];
                NSArray  *array = responseObjsss[@"data"][@"content"];
                [self.dataSource addObjectsFromArray:array];
                [self.tableView reloadData];
                [self cancleActivity];
                [self.tableView.mj_header endRefreshing];
                
            }];
            
        }else{
            [self cancleActivity];
            [self.tableView.mj_header endRefreshing];
            
        }
          [self.tableView.mj_header endRefreshing];
        
        
    }];
    
    

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

    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(configNewData)];
   
    
    
    self.tableView.mj_header.automaticallyChangeAlpha = YES;

    
    [self.tableView.mj_header beginRefreshing];
    

    
    
    
    self.baseNavigationBar.backgroundColor = [[UIColor colorWithRed:251.0/255 green:114.0/255.0 blue:114/255.0 alpha:1.0]colorWithAlphaComponent:0];
    self.statusView.backgroundColor = [[UIColor colorWithRed:251.0/255 green:114.0/255.0 blue:114/255.0 alpha:1.0]colorWithAlphaComponent:0];
    
    [self.baseNavigationBar.backBtn setImage:[UIImage imageNamed:@"return48"] forState:UIControlStateNormal];

    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = KNaviBarTintColor;
    [btn setTitle:@"记录" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    btn.frame = CGRectMake(KScreenWidth - 45, headrView.bottom - 20, 40, 40);
    [AppPublic roundCornerRadius:btn];
    [self.view addSubview:btn];
    

    
}

#pragma mark -- 记录时间轴
- (void)btnClick:(UIButton *)sender{
    
    if ([KUserDefaults objectForKey:KHisHerID]==nil) {
        [self showMessage:@"你还没有匹配的人" toView:self.view];
        return;
    }
    WEPostTimeLineController  *vc = [[WEPostTimeLineController alloc]init];
    vc.infoDic = self.infoDic;
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
        
            
            
            if (self.infoDic) {
                [self showActivity];
                [WEMyChatTool postBgPicWithtimeEventId:self.infoDic[@"id"] imag:originalImage success:^(id model) {
                    self.headrView.bgInamegView.image = originalImage;
                    [self cancleActivity];
                    [self showMessage:@"上传成功" toView:self.view];
                    
                } failed:^(NSString *error) {
                    [self cancleActivity];
                    [self showMessage:error.description toView:self.view];
                    
                    
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
            
            
            
            if (self.infoDic) {
                [self showActivity];
                [WEMyChatTool postBgPicWithtimeEventId:self.infoDic[@"id"] imag:originalImage success:^(id model) {
                    self.headrView.bgInamegView.image = originalImage;
                    [self cancleActivity];
                    [self showMessage:@"上传成功" toView:self.view];
                    
                } failed:^(NSString *error) {
                    [self cancleActivity];
                    [self showMessage:error.description toView:self.view];
                    
                    
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
    
    if ([KUserDefaults objectForKey:KHisHerID]==nil) {
        [self showMessage:@"你还没有匹配的人" toView:self.view];
        return;
    }

    
    
    UIAlertView  *view = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您同意开放定位么？如果Ta也同意即可互看定位！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [view show];
  
    
}

#pragma mark ----
- (void)didBack{
    [self.navigationController popViewControllerAnimated:YES];
}





- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [self showActivity];
        XWUserModel  *mdoel = [XWUserModel getUserInfoFromlocal];
        
        NSString *hisrID = [KUserDefaults objectForKey:KHisHerID];
        
        
        [WEMyChatTool openLocationWithMyId:mdoel.xw_id hisOrHerId:hisrID success:^(NSString  *model) {
            [self cancleActivity];
            if ([model isEqualToString:@"2"] ) {
                [self showMessage:@"已经向对方申请" toView:self.view];
            }else if([model isEqualToString:@"1"]){
                  [self showMessage:@"你们双方已经开启" toView:self.navigationController.view];
                   //  进入下一届界面
                WELocationViewController *vc = [[WELocationViewController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
            }
            
            
        } failed:^(NSString *error) {
            [self cancleActivity];
            [self showMessage:error toView:self.view];
        }];

    }
}


#pragma tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [WETimeLineCell tableView:tableView heightForRowAtIndexPath:indexPath withData:self.dataSource[indexPath.row]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIndentifier = @"timelineCell";
    WETimeLineCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    
    if (!cell) {
        cell = [[WETimeLineCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.data = self.dataSource[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WETimeLineDetailController *vc = [[WETimeLineDetailController alloc]init];
    
    NSDictionary *dic =  self.dataSource[indexPath.row];
    vc.dic = dic;
    
    [self.navigationController pushViewController:vc animated:YES];
}




@end
