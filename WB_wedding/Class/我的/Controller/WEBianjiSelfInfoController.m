//
//  WEBianjiSelfInfoController.m
//  WB_wedding
//
//  Created by 谢威 on 17/1/17.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import "WEBianjiSelfInfoController.h"
#import "WELookDetailModel.h"
#import "WELookDetailCell.h"
#import "WELookDetailFooterView.h"
#import "PhotoPickerView.h"
#import "WEChooseCell.h"
#import "ImagePickerController.h"
#import "JKAlert.h"
@interface WEBianjiSelfInfoController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,WELookDetailFooterViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,WEChooseCellDelegate>


@property (nonatomic,strong)UITableView         *tableView;
@property (nonatomic,strong)NSMutableArray      *dataSource;
@property (nonatomic,strong)WELookDetailFooterView  *footer;
@property (nonatomic,strong)PhotoPickerView  *picView;
@property (nonatomic,strong)UIView          *prossView;


@property (nonatomic,strong)UICollectionView *collectionView ;
@property (nonatomic,strong)NSMutableArray  *picDataSource;

@end

@implementation WEBianjiSelfInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configDataSource];
    [self configUserInterface];
}


- (void)configDataSource{
    
    self.dataSource = [NSMutableArray array];
    self.picDataSource = [NSMutableArray array];
    WELookDetailModel  *model0 = [[WELookDetailModel alloc]init];
    model0.title  = @"真实姓名";
    
    model0.content = @"杨颖";
    [self.dataSource addObject:model0];
    
    WELookDetailModel  *model1 = [[WELookDetailModel alloc]init];
    model1.title  = @"行业";
    model1.content = @"文化,艺术";
    [self.dataSource addObject:model1];
    
    
    WELookDetailModel  *model2 = [[WELookDetailModel alloc]init];
    model2.title  = @"工作领域";
    model2.content = @"演员";
    [self.dataSource addObject:model2];
    
    
    WELookDetailModel  *model3 = [[WELookDetailModel alloc]init];
    model3.title  = @"经常出没";
    model3.content = @"工体，西单，798，家";
    [self.dataSource addObject:model3];
    
    
    WELookDetailModel  *model4 = [[WELookDetailModel alloc]init];
    model4.title  = @"学历";
    model4.content = @"本科";
    [self.dataSource addObject:model4];
    
    
    WELookDetailModel  *model5 = [[WELookDetailModel alloc]init];
    model5.title  = @"自我评价";
    model5.content = @"聪慧善良，善解人意，开朗活泼";
    [self.dataSource addObject:model5];
    
    
    WELookDetailModel  *model6 = [[WELookDetailModel alloc]init];
    model6.title  = @"业余爱好";
    model6.content = @"赋诗，作画";
    [self.dataSource addObject:model6];
    
    
    WELookDetailModel  *model7 = [[WELookDetailModel alloc]init];
    model7.title  = @"喜欢的运动";
    model7.content = @"排球，游泳，跑步，瑜伽，爬山，睡觉，舞蹈,跑步，瑜伽，爬山，睡觉，舞蹈跑步，瑜伽，爬山，睡觉，舞蹈跑步，瑜伽，爬山，睡觉，舞蹈";
    [self.dataSource addObject:model7];
    
    
    WELookDetailModel  *model8 = [[WELookDetailModel alloc]init];
    model8.title  = @"喜欢的食物";
    model8.content = @"烤串，麻辣烫，串串香，火锅，牛排，韩国烤肉，意大利面，巧克力，提拉米苏";
    [self.dataSource addObject:model8];
    
    
    WELookDetailModel  *model9 = [[WELookDetailModel alloc]init];
    model9.title  = @"喜欢的电影";
    model9.content = @"这个杀手不太冷，泰坦里克号，千与千寻，罗马假日，倩女幽魂，天使爱美丽，乱世佳人";
    [self.dataSource addObject:model9];
    
    
    
    WELookDetailModel  *model10 = [[WELookDetailModel alloc]init];
    model10.title  = @"喜欢的书和动漫";
    model10.content = @"这个杀手不太冷三体，红楼梦，西游记，火影忍者，海贼王";
    [self.dataSource addObject:model10];
    
    WELookDetailModel  *model11 = [[WELookDetailModel alloc]init];
    model11.title  = @"去过的地方";
    model11.content = @"北京，上海，深圳，成都，日本，韩国，德国，法国，意大利，西班牙，葡萄牙，瑞士，美国，澳大利亚";
    [self.dataSource addObject:model11];
}

- (void)configUserInterface{
    self.title = @"编辑资料";
    self.prossView = [UIView new];
    self.prossView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:self.prossView];
    [self.prossView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.baseNavigationBar.mas_bottom).offset(-1);
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(3);
    }];
    
    
    
    
    // table
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.tableFooterView = [UIView new];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"WELookDetailCell" bundle:nil] forCellReuseIdentifier:WELookDetailCellID];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.prossView.mas_bottom).offset(0);
        make.height.mas_equalTo(KScreenHeight-67);
    }];
    
    WELookDetailFooterView *footer = [WELookDetailFooterView xw_loadFromNib];
    footer.frame = CGRectMake(0, 0,KScreenWidth,125);
    footer.delegate = self;
    self.tableView.tableFooterView = footer;
    self.footer = footer;
    footer.oneLable.text = @"Ta的问题";
    footer.twoLable.text = @" 1.如果没有XXXXXXXXXXXXXXXX.\n 2.如果没有XXXXXXXXXXXXXX?\n ";

    [self setNavigationRightBtnWithTitle:@"保存" actionBack:^{
        
    }];
    // 图片选择
//    self.picView = [[PhotoPickerView alloc]initWithFrame:CGRectMake(15, 0, KScreenWidth-30,120) itemMargin:15 viewController:self maxChoose:9 holderImageName:@"xw_post"];
//    self.picView.frame = CGRectMake(0, 0, KScreenWidth, 120);
//    self.tableView.tableHeaderView = self.picView;
//    

    
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    CGFloat W = KScreenWidth/4;
    layout.itemSize = CGSizeMake(W-5,W-5);
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 5;
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0,KScreenWidth,80) collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor clearColor];
    
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"WEChooseCell" bundle:nil] forCellWithReuseIdentifier:WEChooseCellID];
    self.tableView.tableHeaderView = self.collectionView;

    
    

}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.picDataSource.count+1;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    WEChooseCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:
                         WEChooseCellID forIndexPath:indexPath];
    cell.delegate = self;
    cell.indexPath = indexPath;
    if (self.picDataSource.count==0) {
        cell.iamgeView.image = [UIImage imageNamed:@"xw_post"];
        cell.cancleBtn.hidden = YES;
    }else{
        if (indexPath.row == self.picDataSource.count) {
            cell.iamgeView.image = [UIImage imageNamed:@"xw_post"];
            cell.cancleBtn.hidden = YES;
        }else{
            cell.iamgeView.image = self.picDataSource[indexPath.row];
            cell.cancleBtn.hidden = NO;
        }
    }
    return cell;
    
}



- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.picDataSource.count >=9) {
        [self showMessage:@"最多9张" toView:self.view];
        return;
    }
    
    JKAlert *aler = [[JKAlert alloc]initWithTitle:@"提示" andMessage:@"选择" style:STYLE_ACTION_SHEET];
    
    [aler addButton:ITEM_OK withTitle:@"从相册选择" handler:^(JKAlertItem *item) {
        ImagePickerController *imageVC1 = [[ImagePickerController alloc]init];
        imageVC1.allowsEditing = YES;
        
        [imageVC1 cameraSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum onFinishingBlock:^(UIImagePickerController *picker, NSDictionary *info, UIImage *originalImage, UIImage *editedImage) {
            [self.picDataSource addObject:editedImage];
            [self.collectionView reloadData];
            
            if (self.picDataSource.count==3) {
                self.collectionView.frame =CGRectMake(0, 0,KScreenWidth,170);
                self.tableView.tableHeaderView = nil;
                self.tableView.tableHeaderView = self.collectionView;
                
            }else if (self.picDataSource.count == 8){
                
                self.collectionView.frame =CGRectMake(0, 0,KScreenWidth,260);
                self.tableView.tableHeaderView = nil;
                self.tableView.tableHeaderView = self.collectionView;

            
            }
            
        } onCancelingBlock:^{
            
        }];
        [self presentViewController:imageVC1 animated:YES completion:nil];
        
    }];
    
    [aler addButton:ITEM_OK withTitle:@"拍照" handler:^(JKAlertItem *item) {
        
        ImagePickerController *imageVC2222 = [[ImagePickerController alloc]init];
        imageVC2222.allowsEditing = YES;
        [imageVC2222 cameraSourceType:UIImagePickerControllerSourceTypeCamera onFinishingBlock:^(UIImagePickerController *picker, NSDictionary *info, UIImage *originalImage, UIImage *editedImage) {
            [self.picDataSource addObject:editedImage];
            [self.collectionView reloadData];
            
            if (self.picDataSource.count==3) {
             
                self.collectionView.frame =CGRectMake(0, 0,KScreenWidth,170);
                self.tableView.tableHeaderView = nil;
                self.tableView.tableHeaderView = self.collectionView;
                
            }else if (self.picDataSource.count == 8){
                
                self.collectionView.frame =CGRectMake(0, 0,KScreenWidth,260);
                self.tableView.tableHeaderView = nil;
                self.tableView.tableHeaderView = self.collectionView;
                
            }
            
            
        } onCancelingBlock:^{
            
        }];
        [self presentViewController:imageVC2222 animated:YES completion:nil];
        
        
    }];
    
    
    [aler addButton:ITEM_CANCEL withTitle:@"取消" handler:^(JKAlertItem *item) {
        
    }];
    [aler show];
    
    
    
}


#pragma mark -- 删除
- (void)didDeleteIndex:(NSIndexPath *)index{
    [self.picDataSource removeObjectAtIndex:index.row];
    [self.collectionView reloadData];
    
    if (self.picDataSource.count==3) {
  
        
        self.collectionView.frame =CGRectMake(0, 0,KScreenWidth,80);
        self.tableView.tableHeaderView = nil;
        self.tableView.tableHeaderView = self.collectionView;
        

        
    }else if (self.picDataSource.count == 8){
        
        
        self.collectionView.frame =CGRectMake(0, 0,KScreenWidth,170);
        self.tableView.tableHeaderView = nil;
        self.tableView.tableHeaderView = self.collectionView;
        
        
    }
    
    
    
    
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WELookDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:WELookDetailCellID];
    WELookDetailModel *model = self.dataSource[indexPath.row];
    cell.oneLable.text = model.title;
    cell.twoLable.text = model.content;
    cell.wenjuanBtn.hidden = YES;
    cell.pingjia.hidden = YES;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WELookDetailModel *model = self.dataSource[indexPath.row];
    
    return [model xw_cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



#pragma mark -- 展开的点击
- (void)didOpenBtn:(UIButton *)sender{
    WELookDetailFooterView *footer = [WELookDetailFooterView xw_loadFromNib];
    footer.frame = CGRectMake(0, 0, KScreenWidth, 200);
    footer.delegate = self;
    self.tableView.tableFooterView = footer;
    self.footer = footer;
    footer.oneLable.text = @"Ta的问题";
    footer.twoLable.text = @" 1.如果没有XXXXXXXXXXXXXXXX.\n 2.如果没有XXXXXXXXXXXXXX?\n 3.如果没有XXXXXXXXXXXXXX?\n 4.如果没有XXXXXXXXXXXXXX?\n";
    footer.openBtn.hidden = YES;
    
    
    
}





@end
