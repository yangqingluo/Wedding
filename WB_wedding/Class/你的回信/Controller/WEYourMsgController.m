//
//  WEYourMsgController.m
//  WB_wedding
//
//  Created by 谢威 on 17/1/3.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import "WEYourMsgController.h"
#import "WEYourMessageCollectionCell.h"
#import "WELookDetailViewController.h"
#import "WEYourMessageTool.h"
@interface WEYourMsgController ()<UICollectionViewDelegate,UICollectionViewDataSource,WEYourMessageCollectionCellDelegate>
@property (nonatomic,strong)UICollectionView  *collectionView;
@property (nonatomic,strong)NSMutableArray  *dataSource;
@property (nonatomic,strong)NSMutableArray  *cellArray;
@property (nonatomic,strong)  UIButton *btn ;
@property (nonatomic,assign)NSInteger       page;
@end

@implementation WEYourMsgController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"丘比特的信";
    self.dataSource = [NSMutableArray array];
     self.cellArray = [NSMutableArray array];
    self.page = 1;
//    [self.dataSource addObject:@"1"];
//    [self.dataSource addObject:@"1"];
//    [self.dataSource addObject:@"1"];
//    [self.dataSource addObject:@"1"];
//    [self.dataSource addObject:@"1"];
//    [self.dataSource addObject:@"1"];
//    [self.dataSource addObject:@"1"];
//    [self.dataSource addObject:@"1"];
//    [self.dataSource addObject:@"1"];
//    [self.dataSource addObject:@"1"];
//    [self.dataSource addObject:@"1"];
    [self configUserInterface];
    
    
}

- (void)configUserInterface{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 64, KScreenWidth, KScreenHeight-64-44) collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    layout.itemSize = CGSizeMake((KScreenWidth)/2-0.5,(KScreenWidth)/2 + 35);
    self.collectionView.contentInset = UIEdgeInsetsZero;
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 1;
    [self.collectionView registerNib:[UINib nibWithNibName:@"WEYourMessageCollectionCell" bundle:nil] forCellWithReuseIdentifier:WEYourMessageCollectionCellID];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(configNewData)];
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(configMoreData)];
    self.collectionView.mj_header.automaticallyChangeAlpha = YES;
    self.collectionView.mj_footer.automaticallyHidden = YES;
    [self.collectionView.mj_header beginRefreshing];

    
    [self.view addSubview:self.collectionView];
    
    // 2.
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"编辑" forState:UIControlStateNormal];
    [btn setTitle:@"完成" forState:UIControlStateSelected];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.baseNavigationBar addSubview:btn];
    CGSize size = [@"编辑" boundingRectWithSize:CGSizeMake(KScreenWidth, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil].size;
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.baseNavigationBar);
        make.height.width.mas_equalTo(size.width);
        make.right.mas_equalTo(self.baseNavigationBar.mas_right).offset(-20);
    }];
    self.btn = btn;
    
    
}



#pragma mark -- 最新
- (void)configNewData{
    self.page = 1;
    
    XWUserModel *model = [XWUserModel getUserInfoFromlocal];
   [WEYourMessageTool findReplyYourWithID:model.xw_id page:@"1" size:@"10" success:^(NSArray *model) {
        [self.dataSource removeAllObjects];
        [self.dataSource addObjectsFromArray:model];
        [self.collectionView reloadData];
       [self.collectionView.mj_header endRefreshing];

    } failed:^(NSString *error) {
        [self.collectionView.mj_header endRefreshing];
        [self showMessage:error toView:self.view];
        
        
    }];

    
    
    
    
}


#pragma mark -- 更多
- (void)configMoreData{
    
    NSInteger page = self.page+1;
    
    XWUserModel *model = [XWUserModel getUserInfoFromlocal];
    [WEYourMessageTool findReplyYourWithID:model.xw_id page:[NSString stringWithFormat:@"%ld",page] size:@"10" success:^(NSArray *model) {

        [self.dataSource addObjectsFromArray:model];
        [self.collectionView reloadData];
        self.page = page;
        [self.collectionView.mj_footer endRefreshing];

        
    } failed:^(NSString *error) {
        
        [self showMessage:error toView:self.view];
        [self.collectionView.mj_footer endRefreshing];

        
    }];
    
}





-(void)rightBtnClick:(UIButton *)sender{
     sender.selected = !sender.selected;
    
    if (sender.selected == YES) {
        for (WEYourMessageCollectionCell *cell in self.cellArray) {
            cell.deleteBtn.hidden = NO;
//            CAKeyframeAnimation * keyAnimaion = [CAKeyframeAnimation animation];
//            keyAnimaion.keyPath = @"transform.rotation";
//            keyAnimaion.values = @[@(-5 / 180.0 * M_PI),@(5 /180.0 * M_PI),@(-5/ 180.0 * M_PI)];//度数转弧度
//            keyAnimaion.removedOnCompletion = NO;
//            keyAnimaion.fillMode = kCAFillModeForwards;
//            keyAnimaion.duration = 0.5;
//            keyAnimaion.repeatCount = MAXFLOAT;
//            [cell.layer addAnimation:keyAnimaion forKey:nil];
            
        }
    }else{
        
        for (WEYourMessageCollectionCell *cell in self.cellArray) {
            cell.deleteBtn.hidden = YES;
            [cell.layer removeAllAnimations];
        }

    }
    
}

#pragma mark -- 删除
- (void)deleIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = self.dataSource[indexPath.row];

    NSArray *array = @[dic[@"id"]];
    NSString *s = [self convertArrayToJson:array];
    
    [self showActivity];
    [WEYourMessageTool  deleteLikeYouWithID:s  success:^(id model) {
        [self cancleActivity];
        [self.dataSource removeObjectAtIndex:indexPath.row];
        [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
        [self.collectionView reloadData];
        
    
    } failed:^(NSString *error) {
        [self cancleActivity];
        [self showMessage:error toView:self.view];
        
        
    }];
    
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.dataSource.count;
    
    
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    WEYourMessageCollectionCell  *cell = [collectionView dequeueReusableCellWithReuseIdentifier:WEYourMessageCollectionCellID forIndexPath:indexPath];
    cell.indePath = indexPath;
    cell.delegate = self;
    NSDictionary *dic = self.dataSource[indexPath.row];
    cell.name.text = dic[@"realname"];
    CGFloat s   =[dic[@"matchDegree"] floatValue];
    cell.percent.text = [NSString stringWithFormat:@"%.f%@",s,@"%"];
    
    if ( dic[@"status"] == 0) {
        
        cell.fazan.text = @"可发展";
        
    }else{
        
        cell.fazan.text = @"名花有主";
    }
    
    
    NSString *imageSrtring = dic[@"imgFileNames"];
    
    
    
    
    if (![imageSrtring isEqualToString:@""]) {
        
        
        NSArray *array = [imageSrtring componentsSeparatedByString:@","];
        
        NSURL *imagURL =[NSURL URLWithString: [NSString stringWithFormat:@"%@/%@/%@",ImageURL,dic[@"recieverId"],array[0]]];
        
        [cell.imageVIew sd_setImageWithURL:imagURL placeholderImage:[UIImage imageNamed:@"baby"]];
        
    }
        
    [self.cellArray addObject:cell];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    WELookDetailViewController *vc = [[WELookDetailViewController alloc]initWithType:vcTypeYourMsg];
    vc.dic = self.dataSource[indexPath.row];
    NSDictionary *dic = self.dataSource[indexPath.row];
    vc.ID =dic[@"recieverId"];
    [self.navigationController pushViewController:vc animated:YES];
    
    
}



@end
