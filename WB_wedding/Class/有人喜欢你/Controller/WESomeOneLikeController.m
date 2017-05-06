//
//  WESomeOneLikeController.m
//  WB_wedding
//
//  Created by 谢威 on 17/1/3.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import "WESomeOneLikeController.h"
#import "SomeOneLikeCell.h"
#import "WELookDetailViewController.h"
#import "WESomeOneLikeTool.h"
@interface WESomeOneLikeController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView         *tableView;

@property (nonatomic,strong)NSMutableArray      *dataSource;
@property (nonatomic,assign)NSInteger       page;
@end

@implementation WESomeOneLikeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.page = 1;
    self.dataSource = [NSMutableArray array];

    [self configUserInterface];
    
}
- (void)configUserInterface{
    self.title = @"有人喜欢你";
    // table
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.rowHeight = 70;
    [self.tableView registerNib:[UINib nibWithNibName:@"SomeOneLikeCell" bundle:nil] forCellReuseIdentifier:SomeOneLikeCellID];
    [self.view addSubview:self.tableView];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(configNewData)];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(configMoreData)];
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    self.tableView.mj_footer.automaticallyHidden = YES;
    [self.tableView.mj_header beginRefreshing];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.baseNavigationBar.mas_bottom).offset(0);
        make.height.mas_equalTo(KScreenHeight-64-44);
    }];

    
}

#pragma mark -- 最新
- (void)configNewData{
     self.page = 1;
    XWUserModel *model = [XWUserModel getUserInfoFromlocal];
    [WESomeOneLikeTool getSomeOneLikeYouListWithMID:model.xw_id page:@"1" size:@"10" success:^(NSArray * model) {
        [self.dataSource removeAllObjects];
        [self.dataSource addObjectsFromArray:model];
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        
    } failed:^(NSString *error) {
        [self cancleActivity];
        [self showMessage:error toView:self.view];
        [self.tableView.mj_header endRefreshing];
    }];

    
    
}


#pragma mark -- 更多
- (void)configMoreData{
    
    NSInteger page = self.page+1;

    XWUserModel *model = [XWUserModel getUserInfoFromlocal];
    [WESomeOneLikeTool getSomeOneLikeYouListWithMID:model.xw_id page:[NSString stringWithFormat:@"%ld",page] size:@"10" success:^(NSArray * model) {
        
        [self.dataSource addObjectsFromArray:model];
        [self.tableView reloadData];
        self.page = page;
        [self.tableView.mj_footer endRefreshing];

        
    } failed:^(NSString *error) {
        [self cancleActivity];
        [self showMessage:error toView:self.view];
        
        [self.tableView.mj_footer endRefreshing];

    }];

}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SomeOneLikeCell *cell = [tableView dequeueReusableCellWithIdentifier:SomeOneLikeCellID];
    NSDictionary *dic = self.dataSource[indexPath.row];
    NSString *imageSrtring = dic[@"imgFileNames"];
    if (![imageSrtring isEqualToString:@""]) {
        NSArray *array = [imageSrtring componentsSeparatedByString:@","];
        NSURL *imagURL =[NSURL URLWithString: [NSString stringWithFormat:@"%@/%@/%@",ImageURL,dic[@"senderId"],array[0]]];
        [cell.icon sd_setImageWithURL:imagURL placeholderImage:nil];
        
    }
    
    
    cell.name.text = dic[@"realname"];
    NSString *sex;
    if ([dic[@"sex"] integerValue]== 0) {
        sex = @"男";
    }else{
        sex = @"女";
    }
    if (dic[@"status"] == 0) {
        
        cell.fazhang.text = @"可发展";
        
    }else{
        
        cell.fazhang.text = @"名花有主";
    }
    
    
    cell.sexage.text = [NSString stringWithFormat:@"%@ %@",sex,dic[@"age"]];
    cell.adress.text = dic[@"city"];
    cell.xinzuo.text = dic[@"xingZuo"];
    cell.march.text = [NSString stringWithFormat:@"匹配度%@%@",dic[@"matchDegree"],@"%"];
    if (dic[@"isRecieverRead"] == 0) {
        cell.redPiont.hidden = NO;
    }else{
        cell.redPiont.hidden = YES;
    }
    return cell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    WELookDetailViewController *vc = [[WELookDetailViewController alloc]initWithType:vcTypeYourLike];
      NSDictionary *dic = self.dataSource[indexPath.row];
    vc.ID = dic[@"senderId"];
    vc.dic = dic;
    [self.navigationController pushViewController:vc animated:YES];
    
    
    
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
        return UITableViewCellEditingStyleDelete;
    
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete){
        NSDictionary *dic = self.dataSource[indexPath.row];
        
        [self showActivity];
        [WESomeOneLikeTool deleteLikeYouWithID:dic[@"id"] success:^(id model) {
        [self cancleActivity];
        [self.dataSource removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];

            
        } failed:^(NSString *error) {
            [self cancleActivity];
            [self showMessage:error toView:self.view];
            
        }];
        
    }
    
    
}


- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
        return @"删除";
}





@end
