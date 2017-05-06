//
//  WETimeLineDetailController.m
//  WB_wedding
//
//  Created by 谢威 on 17/2/16.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import "WETimeLineDetailController.h"
#import "WETimeLineDetailCell.h"
#import "WETimeLineDetailHeaderView.h"
#import "WETimeLineFooterView.h"
@interface WETimeLineDetailController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView         *tableView;
@property (nonatomic,strong)NSMutableArray      *dataSource;

@end

@implementation WETimeLineDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUserInterface];
}
- (void)configUserInterface{
    self.title = @"时间轴详情";
    self.dataSource = [NSMutableArray array];
    if (![self.dic[@"imgs"]isEqualToString:@""]) {
        NSArray *arrya = [self.dic[@"imgs"] componentsSeparatedByString:@","];
        [self.dataSource addObjectsFromArray:arrya];
        
    }
    
    // table
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,64,KScreenWidth,KScreenHeight-64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.rowHeight = 200;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"WETimeLineDetailCell" bundle:nil] forCellReuseIdentifier:WETimeLineDetailCellID];
    [self.view addSubview:self.tableView];
    
    WETimeLineDetailHeaderView *headerView = [WETimeLineDetailHeaderView xw_loadFromNib];
    headerView.frame = CGRectMake(0, 0, KScreenWidth,70);
    self.tableView.tableHeaderView = headerView;

    headerView.evnet.text = self.dic[@"eventContent"];
    headerView.adress.text = [NSString stringWithFormat:@"%@ %@",self.dic[@"city"],self.dic[@"location"]];
    NSString *time = [NSString stringWithFormat:@"%@",self.dic[@"eventTime"]];
    
    NSDate *d = [[NSDate alloc]initWithTimeIntervalSince1970:[time longLongValue]/1000.0];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];//格式化
    [df setDateFormat:@"yy-MM-dd HH:mm"];
    [df setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"] ];
    NSString * timeStr =[df stringFromDate:d];
    headerView.time.text = timeStr;
    
    
    WETimeLineFooterView *footerView = [WETimeLineFooterView xw_loadFromNib];
    footerView.frame = CGRectMake(0, 0, KScreenWidth, 100);
    
      XWUserModel *model = [XWUserModel getUserInfoFromlocal];
    
    if ([model.sex isEqualToString:@"1"]) {
        
         footerView.textView.text = self.dic[@"boysNote"];
        
        
    }else{
        footerView.textView.text = self.dic[@"girlsNote"];

    }
    
   
    self.tableView.tableFooterView = footerView;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WETimeLineDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:WETimeLineDetailCellID];
    NSURL *ss = [NSURL URLWithString:[NSString stringWithFormat:@"%@/tec/%@/%@",ImageURL,self.dic[@"id"],self.dataSource[indexPath.row]]];
    [cell.imageViewss sd_setImageWithURL:ss  placeholderImage:nil];
    return cell;
}


@end
