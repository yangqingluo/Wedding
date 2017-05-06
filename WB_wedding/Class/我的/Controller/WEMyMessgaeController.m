//
//  WEMyMessgaeController.m
//  WB_wedding
//
//  Created by 谢威 on 17/1/22.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import "WEMyMessgaeController.h"
#import "WEMyMessageCell.h"
#import "WEMessageReslutController.h"
@interface WEMyMessgaeController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic,strong)NSMutableArray      *dataSource;

@end

@implementation WEMyMessgaeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSource = [NSMutableArray array];
    [self.tableview registerNib:[UINib nibWithNibName:@"WEMyMessageCell" bundle:nil] forCellReuseIdentifier:WEMyMessageCellID];
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.tableFooterView = [UIView new];
    self.tableview.rowHeight = 70;
    [self configDataSource];
}

- (void)configDataSource{
    NSDictionary *dic = @{
                          @"page":@"1",
                          @"size":@"200",
                          @"myId":[XWUserModel getUserInfoFromlocal].xw_id
                          };
    
    [HQBaseNetManager GET:BASEURL(@"/mymessage/find") parameters:dic completionHandler:^(id  responseObj, NSError *error) {
        
        if ([responseObj[@"msg"]isEqualToString:@"请求成功"]) {
            NSArray *array = responseObj[@"data"][@"content"];
            [self.dataSource removeAllObjects];
            [self.dataSource addObjectsFromArray:array];
            [self.tableview reloadData];
            
        }else{
            [self showMessage:responseObj[@"data"][@"content"] toView:self.view];
            

        }
        
    }];

    
    
}


//
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    WEMyMessageCell *vc = [tableView dequeueReusableCellWithIdentifier:WEMyMessageCellID];
    NSDictionary *dic = self.dataSource[indexPath.row];
    vc.name.text = dic[@"otherNickName"];
    NSURL *imagURL =[NSURL URLWithString: [NSString stringWithFormat:@"%@/%@/%@",ImageURL,dic[@"otherId"],dic[@"imgName"]]];
    [vc.iocn sd_setImageWithURL:imagURL placeholderImage:nil];
    
    if ([[NSString stringWithFormat:@"%@",dic[@"msgType"]]isEqualToString:@"0"]) {
        
        vc.two.text = [NSString stringWithFormat:@"%@",dic[@"content"]];
        
    }else if([[NSString stringWithFormat:@"%@",dic[@"msgType"]]isEqualToString:@"1"]){
        
            vc.two.text = [NSString stringWithFormat:@"%@想跟你表白",dic[@"otherNickName"]];
        
        
    }else if([[NSString stringWithFormat:@"%@",dic[@"msgType"]]isEqualToString:@"2"]){
        
        vc.two.text = [NSString stringWithFormat:@"%@想跟你复合",dic[@"otherNickName"]];
        
        
    }
    else if([[NSString stringWithFormat:@"%@",dic[@"msgType"]]isEqualToString:@"3"]){
        
        vc.two.text = [NSString stringWithFormat:@"%@想跟你发起定位",dic[@"otherNickName"]];
        
        
    }

    
    return vc;

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableview deselectRowAtIndexPath:indexPath animated:YES];
    
    WEMessageReslutController *vc = [[WEMessageReslutController alloc]init];
    
    NSDictionary *dic = self.dataSource[indexPath.row];
    
   if (![[NSString stringWithFormat:@"%@",dic[@"msgType"]]isEqualToString:@"0"]) {
       
          vc.dic = dic;
       
        [self.navigationController pushViewController:vc animated:YES];
       
        
    }
}

@end
