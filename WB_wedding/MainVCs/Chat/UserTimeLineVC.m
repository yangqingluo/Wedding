//
//  UserTimeLineVC.m
//  WB_wedding
//
//  Created by yangqingluo on 2017/6/1.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import "UserTimeLineVC.h"
#import "WEPostTimeLineController.h"
#import "WETimeLineDetailController.h"

#import "UIImageView+WebCache.h"
#import "TimeLineCell.h"
#import "UDImageLabelButton.h"
#import "UIImage+Color.h"

#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>

@interface UserTimeLineVC ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>{
    NSUInteger currentPage;
    NSUInteger m_total;
}

@property (strong, nonatomic) UDImageLabelButton *headView;

@property (strong, nonatomic) UserTimeLineData *data;
@property (strong, nonatomic) NSMutableArray *dataSource;

@property (strong, nonatomic) UIImagePickerController *imagePicker;

@end

@implementation UserTimeLineVC

- (void)dealloc{
    [KNotiCenter removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    
    // 发布成功 刷新数据
    [KNotiCenter addObserver:self selector:@selector(refreshData) name:kNotification_PushTimeLine object:nil];
    
    [self pullTimeEvent];
}

- (void)setupNav {
    [self createNavWithTitle:@"时间轴" createMenuItem:^UIView *(int nIndex){
        if (nIndex == 0){
            UIButton *btn = NewBackButton(nil);
            [btn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
            return btn;
        }
        else if (nIndex == 1) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            UIImage *i = [UIImage imageNamed:@"bottom_location"];
            [btn setImage:[i imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
            [btn setFrame:CGRectMake(screen_width - 64, 0, 64, 44)];
            [btn addTarget:self action:@selector(locateButtonAction) forControlEvents:UIControlEventTouchUpInside];
            
            return btn;
        }
        
        return nil;
    }];
}

- (void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)locateButtonAction{
    
}

- (void)recordButtonAction{
    WEPostTimeLineController  *vc = [[WEPostTimeLineController alloc]init];
    vc.data = self.data;
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)headButtonAction{
    QKWEAKSELF;
    BlockActionSheet *sheet = [[BlockActionSheet alloc] initWithTitle:@"更改背景" delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil clickButton:^(NSInteger buttonIndex){
        if (buttonIndex == 1) {
            [weakself requestAccessForMedia:buttonIndex];
        }
        else if (buttonIndex == 2) {
            [weakself chooseHeadImage:buttonIndex];
        }
    } otherButtonTitles:@"拍照", @"从手机相册选取", nil];
    [sheet showInView:self.view];
}

- (void)requestAccessForMedia:(NSUInteger)buttonIndex{
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (granted) {
                [self chooseHeadImage:buttonIndex];
            }
            else{
                AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
                if (authStatus != AVAuthorizationStatusAuthorized){
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"请在iPhone的\"设置-隐私-相机\"选项中，允许%@访问您的相机",[AppPublic getInstance].appName] message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                    
                    return;
                }
            }
            
        });
    }];
}

- (void)chooseHeadImage:(NSUInteger)buttonIndex{
    UIImagePickerControllerSourceType type = (buttonIndex == 1) ? UIImagePickerControllerSourceTypeCamera : UIImagePickerControllerSourceTypePhotoLibrary;
    if ([UIImagePickerController isSourceTypeAvailable:type]){
        self.imagePicker.sourceType = type;
        [self presentViewController:self.imagePicker animated:YES completion:^{
            
        }];
    }
    else{
        NSString *name = (buttonIndex == 1) ? @"相机" : @"照片";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@不可用", name] message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
}

- (void)updateMemberAvatar:(NSData *)data{
    [self showHudInView:self.view hint:nil];
    
    QKWEAKSELF
    [[QKNetworkSingleton sharedManager] pushImages:@[data] Parameters:@{@"timeEventId":self.data.ID} URLFooter:@"/timeevent/uploadimg" completion:^(id responseBody, NSError *error){
        [weakself hideHud];
        
        if (!error) {
            if (isHttpSuccess([responseBody[@"success"] intValue])) {
                NSString *pathString = [NSString stringWithFormat:@"%@/%@", self.data.ID, responseBody[@"data"]];
                [[SDImageCache sharedImageCache] storeImageDataToDisk:data forKey:imageUrlStringWithImagePath(pathString)];
                weakself.data.backgroundUrl = pathString;
                [weakself refreshHeaderView];
            }
            else {
                [weakself showHint:responseBody[@"msg"]];
            }
        }
        else{
            [weakself showHint:@"网络出错"];
        }
        
    } withUpLoadProgress:^(float progress){
        
    }];
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
                [weakself refreshSubviews];
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


- (void)refreshSubviews{
    self.tableView.tableHeaderView = self.headView;
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //设置下拉刷新回调
    QKWEAKSELF;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakself loadFirstPageData];
    }];
    
    [self refreshHeaderView];
}

- (void)refreshHeaderView{
    [self.headView.upImageView sd_setImageWithURL:imageURLWithPath([NSString stringWithFormat:@"%@", self.data.backgroundUrl]) placeholderImage:[UIImage imageNamed:downloadImagePlace]];
}

- (void)refreshTableViewFooter{
    QKWEAKSELF;
    if (!self.tableView.mj_footer) {
        self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [weakself loadMoreData];
        }];
    }
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
                    else {
                        [weakself refreshTableViewFooter];
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

#pragma getter
- (UDImageLabelButton *)headView{
    if (!_headView) {
        _headView = [[UDImageLabelButton alloc]initWithFrame:CGRectMake(0, 0, screen_width, screen_width * 210.0 / 375.0)];
        _headView.upImageView.image = [UIImage imageNamed:downloadImagePlace];
        _headView.upImageView.frame = _headView.bounds;
        [_headView addTarget:self action:@selector(headButtonAction) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@"记录" forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.frame = CGRectMake(_headView.width - 45, _headView.height - 20, 40, 40);
        btn.backgroundColor = KNaviBarTintColor;
        [AppPublic roundCornerRadius:btn];
        [btn addTarget:self action:@selector(recordButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [_headView addSubview:btn];
    }
    
    return _headView;
}

- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
    }
    
    return _dataSource;
}

- (UIImagePickerController *)imagePicker{
    if (!_imagePicker) {
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.modalPresentationStyle = UIModalTransitionStyleCoverVertical;
        _imagePicker.allowsEditing = YES;
        _imagePicker.delegate = self;
    }
    
    return _imagePicker;
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

#pragma mark UIImagePickerControllerDelegate协议的方法
//用户点击图像选取器中的“cancel”按钮时被调用，这说明用户想要中止选取图像的操作
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
//用户点击选取器中的“choose”按钮时被调用，告知委托对象，选取操作已经完成，同时将返回选取图片的实例
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    // 图片类型
    if([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:(NSString*)kUTTypeImage]) {
        //编辑后的图片
        UIImage* image = [info objectForKey:UIImagePickerControllerEditedImage];
        //压缩图片
        NSData *imageData = dataOfImageCompression(image, NO);
        
        //如果想之后立刻调用UIVideoEditor,animated不能是YES。最好的还是dismiss结束后再调用editor。
        [picker dismissViewControllerAnimated:YES completion:^{
            [self updateMemberAvatar:imageData];
        }];
    }
}

@end
