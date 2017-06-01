//
//  LettersViewController.m
//  WB_wedding
//
//  Created by yangqingluo on 2017/5/18.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import "LettersViewController.h"
#import "UserInfoVC.h"

#import "LettersCollectionViewCell.h"

static NSString *identify_letters = @"lettersCell";

@interface LettersViewController (){
    NSUInteger currentPage;
    NSUInteger m_total;
}

@property (nonatomic, assign) NSUInteger indextag;

@property (strong, nonatomic) NSMutableArray *dataSource;
@property (strong, nonatomic) NSString *dateKey;

@property (strong, nonatomic) UIButton *editButton;

@end

@implementation LettersViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self becomeListed];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    
    [self.collectionView registerClass:[LettersCollectionViewCell class] forCellWithReuseIdentifier:identify_letters];
    
    //设置下拉刷新回调
    QKWEAKSELF;
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakself loadFirstPageData];
    }];
    
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakself loadMoreData];
    }];
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

- (void)editButtonAction{
    self.editButton.selected = !self.editButton.selected;
    [self.collectionView reloadData];
}

- (void)removeButtonClick:(UIButton *)sender{
    QKWEAKSELF;
    BlockAlertView *alert = [[BlockAlertView alloc] initWithTitle:nil message:@"确定删除？" cancelButtonTitle:@"取消" clickButton:^(NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            [weakself removeLettersAtIndex:sender.tag];
        }
    }otherButtonTitles:@"确定", nil];
    [alert show];
}

- (void)becomeListed{
    NSDate *lastRefreshTime = [[NSUserDefaults standardUserDefaults] objectForKey:self.dateKey];
    if (!self.dataSource.count || !lastRefreshTime || [lastRefreshTime timeIntervalSinceNow] < -appRefreshTime) {
        [self.collectionView.mj_header beginRefreshing];
    }
}

- (void)becomeUnListed{
    
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
    [[QKNetworkSingleton sharedManager] Get:@{@"myId":[AppPublic getInstance].userData.ID, @"page":@(page), @"size":@20} HeadParm:nil URLFooter:@"/urreply/find" completion:^(id responseBody, NSError *error){
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
                        [weakself.collectionView.mj_footer endRefreshingWithNoMoreData];
                    }
                }
                
                [weakself.collectionView reloadData];
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
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:self.dateKey];
    [self.collectionView.mj_header endRefreshing];
    [self.collectionView.mj_footer endRefreshing];
}

- (void)removeLettersAtIndex:(NSUInteger)index{
    if (index < self.dataSource.count) {
        AppUserData *userData = self.dataSource[index];
        
        [self showHudInView:self.view hint:nil];
        QKWEAKSELF;
        [[QKNetworkSingleton sharedManager] Post:@{@"id":userData.ID} HeadParm:nil URLFooter:@"/urreply/delete" completion:^(id responseBody, NSError *error){
            [weakself hideHud];
            
            if (!error) {
                if (isHttpSuccess([responseBody[@"success"] intValue])) {
                    [self.dataSource removeObjectAtIndex:index];
                    [weakself.collectionView reloadData];
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

#pragma getter
- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
    }
    
    return _dataSource;
}

- (NSString *)dateKey{
    if (!_dateKey) {
        _dateKey = [NSString stringWithFormat:@"letters_dateKey_%d",(int)self.indextag];
    }
    
    return _dateKey;
}

#pragma mark - collection view
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    LettersCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify_letters forIndexPath:indexPath];
    
    AppUserData *userData = self.dataSource[indexPath.row];
    
    cell.userData = userData;
    cell.removeButton.hidden = !self.editButton.selected;
    cell.removeButton.tag = indexPath.row;
    [cell.removeButton addTarget:self action:@selector(removeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = self.dataSource[indexPath.row];
    
    UserInfoVC *vc = [UserInfoVC new];
    vc.infoType = UserInfoTypeMsg;
    vc.userData = [AppUserData mj_objectWithKeyValues:dic];
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(collectionView.width / 2.0, collectionView.width / 2.0 + 30);
}
//定义每个UICollectionView 的间距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
//定义每个UICollectionView 纵向的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

@end
