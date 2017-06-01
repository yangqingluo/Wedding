//
//  UserInfoEditVC.m
//  WB_wedding
//
//  Created by yangqingluo on 2017/5/12.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import "UserInfoEditVC.h"
#import "UserQuestionEditVC.h"
#import "PublicSelectionVC.h"

#import "TitleAndDetailTextCell.h"
#import "QKBaseCollectionViewCell.h"
#import "AppPickerView.h"
#import "AppDatePickerView.h"

static NSString *identify = @"assetSelectedCell";

@interface UserInfoEditVC ()<UICollectionViewDataSource, UICollectionViewDelegate, UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate>

@property (strong, nonatomic) AppUserData *userData;
@property (strong, nonatomic) NSMutableArray *imageArray;
@property (strong, nonatomic) UIView *headerView;
@property (strong, nonatomic) UICollectionView *photoCollectionView;
@property (strong, nonatomic) UIImagePickerController *imagePicker;

@property (strong, nonatomic) NSArray *baseShowArray;

@end

@implementation UserInfoEditVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 300)];
    self.headerView.backgroundColor = [UIColor whiteColor];
    self.headerView.clipsToBounds = YES;
    [self.headerView addSubview:self.photoCollectionView];
    
    self.tableView.tableHeaderView = self.headerView;
}

- (void)setupNav {
    [self createNavWithTitle:@"完善资料" createMenuItem:^UIView *(int nIndex){
        if (nIndex == 0){
            UIButton *btn = NewBackButton(nil);
            [btn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
            return btn;
        }
        else if (nIndex == 1){
            UIButton *btn = NewTextButton(@"保存", [UIColor whiteColor]);
            [btn addTarget:self action:@selector(editAction) forControlEvents:UIControlEventTouchUpInside];
            return btn;
        }
        
        return nil;
    }];
}

- (void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)editAction{
    NSMutableDictionary *m_dic = [NSMutableDictionary new];
    for (UserInfoItemData *item in [AppPublic getInstance].infoItemLists) {
        if (![[[AppPublic getInstance].userData valueForKey:item.key] isEqualToString:[self.userData valueForKey:item.key]]) {
            [m_dic setObject:[self.userData valueForKey:item.key] forKey:item.key];
        }
    }
    
    for (NSDictionary *dic in self.baseShowArray) {
        if (![[[AppPublic getInstance].userData valueForKey:dic[@"key"]] isEqualToString:[self.userData valueForKey:dic[@"key"]]]) {
            [m_dic setObject:[self.userData valueForKey:dic[@"key"]] forKey:dic[@"key"]];
        }
    }
    
    if (m_dic.count) {
        [m_dic setObject:self.userData.telNumber forKey:@"telNumber"];
        
        [self showHudInView:self.view hint:nil];
        QKWEAKSELF;
        [[QKNetworkSingleton sharedManager] Post:m_dic HeadParm:nil URLFooter:@"/user/updatedoc" completion:^(id responseBody, NSError *error){
            [weakself hideHud];
            
            if (!error) {
                if (isHttpSuccess([responseBody[@"success"] intValue])) {
                    [[AppPublic getInstance] saveUserData:self.userData];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_Update_UserData object:nil];
                    
                    [weakself goBack];
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
    else {
        [self showHint:@"没有改动"];
    }
}

- (void)imageRemoveButtonClick:(UIButton *)sender{
    QKWEAKSELF;
    BlockAlertView *alert = [[BlockAlertView alloc] initWithTitle:nil message:@"确定删除？" cancelButtonTitle:@"取消" clickButton:^(NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            [weakself removeImageAtIndex:sender.tag];
        }
    }otherButtonTitles:@"确定", nil];
    [alert show];
}

- (void)removeImageAtIndex:(NSUInteger)index{
    if (index + 1 > self.imageArray.count) {
        return;
    }
    
    NSString *imagePath = self.imageArray[index];
    NSArray *pathArray = [imagePath componentsSeparatedByString:@"/"];
    if (pathArray.count < 2) {
        return;
    }
    
    [self showHudInView:self.view hint:nil];
    
    QKWEAKSELF;
    [[QKNetworkSingleton sharedManager] Post:@{@"userId":self.userData.ID, @"oldFileName":pathArray[pathArray.count - 1]} HeadParm:nil URLFooter:@"/user/deleteimg" completion:^(id responseBody, NSError *error){
        [weakself hideHud];
        
        if (!error) {
            if (isHttpSuccess([responseBody[@"success"] intValue])) {
                [weakself.imageArray removeObjectAtIndex:index];
                weakself.userData.imgArray = [NSArray arrayWithArray:weakself.imageArray];
                [[AppPublic getInstance] saveUserData:weakself.userData];
                
                [weakself.photoCollectionView reloadData];
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

- (void)updateMemberAvatar:(NSData *)data{
    [self showHudInView:self.view hint:nil];
    
    QKWEAKSELF
    [[QKNetworkSingleton sharedManager] pushImages:@[data] Parameters:@{@"userId":self.userData.ID, @"oldFileName":@"0"} URLFooter:@"/user/uploadimg" completion:^(id responseBody, NSError *error){
        [weakself hideHud];
        
        if (!error) {
            if (isHttpSuccess([responseBody[@"success"] intValue])) {
                NSString *pathString = [NSString stringWithFormat:@"%@/%@", self.userData.ID, responseBody[@"data"]];
                [[SDImageCache sharedImageCache] storeImageDataToDisk:data forKey:imageUrlStringWithImagePath(pathString)];
                
                [weakself.imageArray addObject:pathString];
                weakself.userData.imgArray = [NSArray arrayWithArray:weakself.imageArray];
                [[AppPublic getInstance] saveUserData:weakself.userData];
                
                [weakself.photoCollectionView reloadData];
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

- (void)reloadPhotoDataFinished:(NSUInteger)index{
    if (index + 1 >= self.imageArray.count) {
        self.headerView.height = self.photoCollectionView.contentSize.height + kEdge;
        self.tableView.tableHeaderView = nil;
        self.tableView.tableHeaderView = self.headerView;
    }
}

- (void)chooseHeadImage:(NSUInteger)buttonIndex{
    //指定源类型前，检查图片源是否可用
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        //指定源的类型
        self.imagePicker.sourceType = (buttonIndex == 0) ? UIImagePickerControllerSourceTypeCamera:UIImagePickerControllerSourceTypePhotoLibrary;
        //设定界面媒体属性
        self.imagePicker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:self.imagePicker.sourceType];
        
        [self presentViewController:self.imagePicker animated:YES completion:^{
            
        }];
    }
    else{
        UIAlertView *alert =[[UIAlertView alloc] initWithTitle:nil message:(buttonIndex == 0) ? @"相机不能用" : @"图片不可用" delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil];
        [alert show];
    }
}

#pragma getter
- (AppUserData *)userData{
    if (!_userData) {
        _userData = [[AppPublic getInstance].userData copy];
    }
    
    return _userData;
}

- (NSArray *)baseShowArray{
    if (!_baseShowArray) {
        _baseShowArray = @[@{@"key":@"nickname", @"name":@"昵称"},
                           @{@"key":@"realname", @"name":@"真实姓名"},
                           @{@"key":@"sex", @"name":@"性别"},
                           @{@"key":@"birthday", @"name":@"生日"},
                           @{@"key":@"height", @"name":@"身高"},
                           ];
    }
    
    return _baseShowArray;
}

- (UICollectionView *)photoCollectionView{
    if (!_photoCollectionView) {
        CGFloat width = screen_width - 2 * kEdgeMiddle;
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        flowLayout.headerReferenceSize = CGSizeMake(width, kEdge);//头部
        
        _photoCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(kEdgeMiddle, 0, width, width) collectionViewLayout:flowLayout];
        _photoCollectionView.scrollEnabled = NO;
        _photoCollectionView.backgroundColor = [UIColor clearColor];
        _photoCollectionView.dataSource = self;
        _photoCollectionView.delegate = self;
        
        //注册cell和ReusableView（相当于头部）
        [_photoCollectionView registerClass:[QKBaseCollectionViewCell class] forCellWithReuseIdentifier:identify];
        //        [_photoCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ReusableView"];
    }
    
    return _photoCollectionView;
}

- (NSMutableArray *)imageArray{
    if (!_imageArray) {
        _imageArray = [NSMutableArray arrayWithArray:self.userData.imgArray];
    }
    
    return _imageArray;
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.baseShowArray.count;
    }
    else if (section == 1) {
        return [AppPublic getInstance].infoItemLists.count;
    }
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 2) {
        return kEdgeMiddle;
    }
    
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:{
            
        }
            break;
            
        case 1:{
            UserInfoItemData *item = [AppPublic getInstance].infoItemLists[indexPath.row];
            
            return [TitleAndDetailTextCell tableView:tableView heightForRowAtIndexPath:indexPath withTitle:item.name andDetail:[self.userData subItemStringWithKey:item.key]];
        }
            break;
            
        case 2:{
            return [TitleAndDetailTextCell tableView:tableView heightForRowAtIndexPath:indexPath withTitle:@"我的提问" andDetail:[self.userData showStringOfMyQuestion]];
        }
            break;
            
        default:
            break;
    }
    
    return kCellHeightMiddle;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"userinfo_cell";
    TitleAndDetailTextCell *cell = (TitleAndDetailTextCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[TitleAndDetailTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    switch (indexPath.section) {
        case 0:{
            NSDictionary *dic = self.baseShowArray[indexPath.row];
            NSString *detail = @"";
            switch (indexPath.row) {
                case 0:
                case 1:{
                    detail = [self.userData valueForKey:dic[@"key"]];
                }
                    break;
                    
                case 2:{
                    //性别
                    detail = [self.userData showStringOfSex];
                }
                    break;
                    
                case 3:{
                    //生日
                    detail = [self.userData showStringOfBirthday];
                }
                    break;
                    
                case 4:{
                    //身高
                    if (self.userData.height) {
                        detail = [self.userData.height copy];
                    }
                }
                    break;
                    
                default:
                    break;
            }
            
            [cell setTitle:dic[@"name"] andDetail:detail];
        }
            break;
            
        case 1:{
            UserInfoItemData *item = [AppPublic getInstance].infoItemLists[indexPath.row];
            
            [cell setTitle:item.name andDetail:[self.userData subItemStringWithKey:item.key]];
        }
            break;
            
        case 2:{            
            [cell setTitle:@"我的提问" andDetail:[self.userData showStringOfMyQuestion]];
        }
            break;
            
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:{
            switch (indexPath.row) {
                case 0:{
                    //昵称
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"设置昵称" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
                    UITextField *alertTextField = [alert textFieldAtIndex:0];
                    alertTextField.clearButtonMode = UITextFieldViewModeAlways;
                    alertTextField.returnKeyType = UIReturnKeyDone;
                    alertTextField.delegate = self;
                    alertTextField.placeholder = @"请输入昵称";
                    alert.tag = indexPath.row;
                    [alert show];

                }
                    break;
                    
                case 1:{
                    //真实姓名
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"设置真实姓名" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
                    UITextField *alertTextField = [alert textFieldAtIndex:0];
                    alertTextField.clearButtonMode = UITextFieldViewModeAlways;
                    alertTextField.returnKeyType = UIReturnKeyDone;
                    alertTextField.delegate = self;
                    alertTextField.placeholder = @"请输入真实姓名";
                    alert.tag = indexPath.row;
                    [alert show];
                }
                    break;
                    
                case 2:{
                    //性别
                    QKWEAKSELF;
                    NSArray *sexShowArray = @[@"男", @"女"];
                    AppPickerView *view = [[AppPickerView alloc] initWithCallBack:^(NSObject *object) {
                        weakself.userData.sex = [NSString stringWithFormat:@"%@", object];
                        [weakself.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
                    } WithDataSource:sexShowArray];
                    [view show];
                }
                    break;
                    
                case 3:{
                    //生日
                    QKWEAKSELF;
                    AppDatePickerView *picker = [[AppDatePickerView alloc] initWithDate:[self.userData dateOfBirthday] andCallBack:^(NSObject *object) {
                        weakself.userData.birthday = (NSString *)object;
                        [weakself.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
                    }];
                    [picker show];
                }
                    break;
                    
                case 4:{
                    //身高
                    QKWEAKSELF;
                    NSMutableArray *heightArray = [NSMutableArray array];
                    for (int i = 220; i > 120; i--) {
                        [heightArray addObject:[NSString stringWithFormat:@"%d",i]];
                    }
                    
                    AppPickerView *view = [[AppPickerView alloc] initWithCallBack:^(NSObject *object) {
                        NSNumber *indexNumber = (NSNumber *)object;
                        weakself.userData.height = heightArray[[indexNumber integerValue]];
                        [weakself.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
                    } WithDataSource:heightArray];
                    [view show];
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
            
        case 1:{
            UserInfoItemData *item = [AppPublic getInstance].infoItemLists[indexPath.row];
            
            QKWEAKSELF;
            PublicSelectionVC *vc = [[PublicSelectionVC alloc] initWithDataSource:item.subItems selectedArray:[self.userData subItemsIndexWithKey:item.key andSeparatedByString:@","] maxSelectCount:item.subItemMaxNumber back:^(NSObject *object){
                if ([object isKindOfClass:[NSString class]]) {
                    NSString *selectedString = (NSString *)object;
                    if (selectedString.length) {
                        [weakself.userData setValue:selectedString forKey:item.key];
                        [weakself.tableView reloadData];
                    }
                }
            }];
            
            vc.title = [NSString stringWithFormat:@"选择%@", item.name];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        case 2:{
            UserQuestionEditVC *vc = [UserQuestionEditVC new];
            
            QKWEAKSELF;
            vc.doneBlock = ^(NSObject *object){
                if ([object isKindOfClass:[NSString class]]) {
                    NSString *selectedString = (NSString *)object;
                    if (selectedString.length) {
                        weakself.userData.myQuestion = selectedString;
                        [weakself.tableView reloadData];
                    }
                }
            };
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - collection view
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row >= self.imageArray.count) {
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"添加图片"
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                             destructiveButtonTitle:nil
                                                  otherButtonTitles:@"拍照", @"从手机相册选取", nil];
        
        sheet.tag = 0;
        
        [sheet showInView:self.view];
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.imageArray.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    QKBaseCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor clearColor];
    cell.removeButton.tag = indexPath.row;
    [cell.removeButton addTarget:self action:@selector(imageRemoveButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    if (indexPath.row < self.imageArray.count) {
        [cell.imgView sd_setImageWithURL:[NSURL URLWithString:imageUrlStringWithImagePath(self.imageArray[indexPath.row])] placeholderImage:[UIImage imageNamed:downloadImagePlace]];
        cell.removeButton.hidden = NO;
    }
    else{
        cell.imgView.image = [UIImage imageNamed:@"xw_post"];
        cell.removeButton.hidden = YES;
    }
    
    [self reloadPhotoDataFinished:indexPath.row];
    
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(collectionView.width / 4.0, collectionView.width / 4.0);
}
//定义每个UICollectionView 的间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
//定义每个UICollectionView 纵向的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

#pragma UIActionSheet
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex < 2) {
        if (buttonIndex == 0) {
            
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
        else{
            [self chooseHeadImage:buttonIndex];
        }
    }
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
        NSData *imageData = dataOfImageCompression(image, YES);
        
        //如果想之后立刻调用UIVideoEditor,animated不能是YES。最好的还是dismiss结束后再调用editor。
        [picker dismissViewControllerAnimated:YES completion:^{
            [self updateMemberAvatar:imageData];
        }];
    }
}

#pragma UIAlertView
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        UITextField *alertTextField = [alertView textFieldAtIndex:0];
        if (alertTextField.text.length) {
            switch (alertView.tag) {
                case 0:{
                    //昵称
                    self.userData.nickname = alertTextField.text;
                }
                    break;
                    
                case 1:{
                    //真实姓名
                    self.userData.realname = alertTextField.text;
                }
                    break;
                    
                default:
                    break;
            }
            
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
        }
        
    }
}

#pragma  mark - TextField
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    return (range.location < kNameLengthMax);
}

@end
