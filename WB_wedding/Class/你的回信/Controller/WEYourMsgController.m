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

@property (nonatomic,strong) UICollectionView  *collectionView;
@property (nonatomic,strong) NSMutableArray  *dataSource;
@property (nonatomic,strong) UIButton *editButton ;
@property (nonatomic,assign) NSInteger       page;
@end

@implementation WEYourMsgController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    
    self.dataSource = [NSMutableArray array];
    self.page = 1;
    
    [self configUserInterface];
    
    
}

- (void)setupNav {
    [self createNavWithTitle:@"丘比特的信" createMenuItem:^UIView *(int nIndex){
        if (nIndex == 0) {
            UIButton *btn = NewTextButton(@"编辑", [UIColor whiteColor]);
            [btn addTarget:self action:@selector(editButtonAction) forControlEvents:UIControlEventTouchUpInside];
            
            [btn setTitle:@"完成" forState:UIControlStateSelected];
            self.editButton = btn;
            return btn;
        }
        
        return nil;
    }];
    
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
        [self showHint:error];
        
        
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
        
        [self showHint:error];
        [self.collectionView.mj_footer endRefreshing];

        
    }];
    
}


- (void)editButtonAction{
     self.editButton.selected = !self.editButton.selected;
    
    [self.collectionView reloadData];
}

#pragma mark -- 删除
- (void)deleIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = self.dataSource[indexPath.row];

    NSArray *array = @[dic[@"id"]];
    NSString *s = [AppPublic convertArrayToJson:array];
    
    [self showHudInView:self.view hint:nil];
    [WEYourMessageTool deleteLikeYouWithID:s  success:^(id model) {
        [self hideHud];
        [self.dataSource removeObjectAtIndex:indexPath.row];
        [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
        [self.collectionView reloadData];
        
    } failed:^(NSString *error) {
        [self hideHud];
        [self showHint:error];
        
        
    }];
    
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.dataSource.count;
    
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
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
    
    cell.deleteBtn.hidden = !self.editButton.selected;
    
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
