//
//  WELoveRecoderController.m
//  WB_wedding
//
//  Created by 谢威 on 17/1/17.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import "WELoveRecoderController.h"
#import "WELoveReocdeCell.h"
#import "WEMeTool.h"
@interface WELoveRecoderController ()<UITableViewDelegate,UITableViewDataSource,WELoveReocdeCellDelegate,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)NSMutableArray      *dataSource;
@property (nonatomic,assign)NSInteger       page;
@property (nonatomic,strong)NSIndexPath     *currentIndex;
@property (nonatomic,strong)  UIAlertView *Vipview;
@property (nonatomic,strong)  UIAlertView *normalVIew;

@end

@implementation WELoveRecoderController

- (void)viewDidLoad {
    
    
    /**
     *  
     */
    [super viewDidLoad];
    self.title = @"恋爱记录";
    self.page = 1;
    self.dataSource = [NSMutableArray array];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"WELoveReocdeCell" bundle:nil] forCellReuseIdentifier:WELoveReocdeCellID];
    self.tableView.rowHeight = 70;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(configNewData)];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(configMoreData)];
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    self.tableView.mj_footer.automaticallyHidden = YES;
    [self.tableView.mj_header beginRefreshing];

    
}


#pragma mark -- 最新
- (void)configNewData{

   XWUserModel  *model = [XWUserModel getUserInfoFromlocal];
    self.page  =1;
  [WEMeTool QueryMyLoveRecoderWithIDS:model.exloverIds page:@"1" size:@"10" success:^(NSArray  *model) {
      [self.dataSource removeAllObjects];
      [self.dataSource addObjectsFromArray:model];
      [self.tableView reloadData];
      [self.tableView.mj_header endRefreshing];
  
  } failed:^(NSString *error) {
      [self.tableView.mj_header endRefreshing];
      [self showMessage:error toView:self.view];
      
      
  }];
    
    
}


#pragma mark -- 更多
- (void)configMoreData{
    
    
    XWUserModel  *model = [XWUserModel getUserInfoFromlocal];
    NSInteger page = self.page+1;
    [WEMeTool QueryMyLoveRecoderWithIDS:model.exloverIds page:[NSString stringWithFormat:@"%ld",page] size:@"10" success:^(NSArray  *model) {
        
        [self.dataSource addObjectsFromArray:model];
        [self.tableView reloadData];
        self.page = page;
        [self.tableView.mj_footer endRefreshing];
        
    } failed:^(NSString *error) {
        [self.tableView.mj_header endRefreshing];
        [self showMessage:error toView:self.view];
         [self.tableView.mj_footer endRefreshing];
        
        
    }];

    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WELoveReocdeCell *cell =[tableView dequeueReusableCellWithIdentifier:WELoveReocdeCellID];
    cell.delegate = self;
    
    cell.indexPath = indexPath;
    
    NSDictionary *dic = self.dataSource[indexPath.row];
    NSString *imageSrtring = dic[@"imgFileNames"];
    if (![imageSrtring isEqualToString:@""]) {
        NSArray *array = [imageSrtring componentsSeparatedByString:@","];
        NSURL *imagURL =[NSURL URLWithString: [NSString stringWithFormat:@"%@/%@/%@",ImageURL,dic[@"id"],array[0]]];
        [cell.icon sd_setImageWithURL:imagURL placeholderImage:nil];
        
    }
    
    cell.name.text = dic[@"nickname"];
    NSArray *timeArray = [dic[@"exsRelationTime"] componentsSeparatedByString:@"-"];
    cell.time.text = [NSString stringWithFormat:@"共同经历了%@年%@月%@日",timeArray[0],timeArray[1],timeArray[2]];
    return cell;
    
}

#pragma mark -- 复合
- (void)didFuheClickWithIndex:(NSIndexPath *)index{
    self.currentIndex = index;
    XWUserModel *model = [XWUserModel getUserInfoFromlocal];
    NSDictionary *dic = self.dataSource[index.row];
    
    [self showActivity];
    [WEMeTool queryOppositeWithMyId:model.xw_id hisOrHerId:dic[@"id"] success:^(NSString *modelss) {
        if ([modelss isEqualToString:@"2"]) {
            [self cancleActivity];
             // 直接建立关系
            [self showMessage:@"直接建立关系" toView:self.view];
            
        }else{
            
            
        if ([model.userRight isEqualToString:@"1"]){
            
             [self cancleActivity];
           // vip
            UIAlertView *view = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"请输入理由" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"发送" , nil];
            view.alertViewStyle = UIAlertViewStylePlainTextInput;
            UITextField *txtName = [view textFieldAtIndex:0];
            txtName.placeholder = @"请输入理由";
            self.Vipview = view;
            [view show];
    
        }else{
             [self cancleActivity];
            UIAlertView *view = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"你不是vip，不能发送复合消息" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil , nil];
            self.normalVIew = view;
            [view show];
    
            
        }

            
            
            
        }
        
        
    } failed:^(NSString *error) {
        [self cancleActivity];

        
        
    }];
        
    
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView == self.Vipview) {
        if (buttonIndex == 1) {
            UITextField *txt = [alertView textFieldAtIndex:0];
            NSDictionary *dic = self.dataSource[self.currentIndex.row];
            XWUserModel *mdoel = [XWUserModel getUserInfoFromlocal];
            
            NSString *imageSrtring = dic[@"imgFileNames"];
            
            if (![imageSrtring isEqualToString:@""]){
                
                NSArray *array = [imageSrtring componentsSeparatedByString:@","];
                [self showActivity];
                
                [WEMeTool postFuheMessageWithContent:txt.text imgName:array[0] myId:dic[@"id"] otherId:mdoel.xw_id otherNickName:mdoel.nickname success:^(id model) {
                    [self cancleActivity];
                    [self showMessage:@"发送成功" toView:self.view];
                    
                } failed:^(NSString *error) {
                    [self cancleActivity];
                    [self showMessage:error toView:self.view];
                }];
                
            }
            
        }
        
    }
    
    
}




@end
