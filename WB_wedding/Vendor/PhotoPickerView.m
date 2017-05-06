//
//  PhotoPickerView.m
//  PhotoPicker
//
//  Created by liuDavid on 16/7/21.
//  Copyright © 2016年 刘未. All rights reserved.
//

#import "PhotoPickerView.h"
#import "TZImagePickerController.h"
#import "LxGridViewFlowLayout.h"
#import "PhotoPickerCollectionViewCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "TZImageManager.h"
#import "UIView+Layout.h"


#define ItemWidthAndHeight 75

@interface PhotoPickerView()<UICollectionViewDataSource,UICollectionViewDelegate,TZImagePickerControllerDelegate,UIImagePickerControllerDelegate>
@property (nonatomic, strong) UIImagePickerController *imagePickerVc;
@property (nonatomic, strong) UICollectionView *collectionView;

@end

static NSString *identifier = @"collectionCell";
@implementation PhotoPickerView{
    
    CGFloat itemWH;
    LxGridViewFlowLayout *layout;
    
    BOOL _isSelectOriginalPhoto;
}

- (instancetype)initWithFrame:(CGRect)frame itemMargin:(CGFloat)itemMargin viewController:(UIViewController *)viewController maxChoose:(int)maxChoose holderImageName:(NSString *)holderImageName{
    if (self = [super initWithFrame:frame]) {
        self.itemMargin = itemMargin;
        self.viewController = viewController;
        self.maxChoose = maxChoose;
        self.holderImageName = holderImageName;
        [self setUp];
    }
    return self;
}
- (void)setUp{
    layout = [[LxGridViewFlowLayout alloc] init];
    itemWH = ItemWidthAndHeight;
    layout.itemSize = CGSizeMake(itemWH, itemWH);
    layout.minimumInteritemSpacing = _itemMargin;
    layout.minimumLineSpacing = _itemMargin;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:layout];
//    self.collectionView.alwaysBounceHorizontal = YES;
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [self addSubview:_collectionView];
    [self.collectionView registerClass:[PhotoPickerCollectionViewCell class] forCellWithReuseIdentifier:identifier];
}

#pragma mark =========UICollectionView=============
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.selectedPhotos.count + 1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PhotoPickerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    if (indexPath.row == _selectedPhotos.count) {
        if (self.holderImageName && self.holderImageName.length) {
            cell.imageView.image = [UIImage imageNamed:self.holderImageName];
            cell.label.hidden = YES;
        } else {
            cell.imageView.image = [UIImage imageNamed:@"comment_addpic"];
            cell.label.hidden = NO;
        }
        
        cell.deleteBtn.hidden = YES;
    } else {
        cell.imageView.image = _selectedPhotos[indexPath.row];
        cell.label.hidden = YES;
        cell.deleteBtn.hidden = NO;
    }
    cell.deleteBtn.tag = indexPath.row;
    [cell.deleteBtn addTarget:self action:@selector(deleteBtnClik:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == _selectedPhotos.count) {
        if (_selectedPhotos.count >= self.maxChoose) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.viewController.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = [NSString stringWithFormat:@"您最多可以选择%d张照片",self.maxChoose];
            [hud hide:YES afterDelay:1];
            return;
        }
        
        UIAlertController *sheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction *snap = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self takePhoto];
        }];
        UIAlertAction *choosePhoto = [UIAlertAction actionWithTitle:@"去相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self pushImagePickerController];
        }];
        [sheet addAction:cancel];
        [sheet addAction:snap];
        [sheet addAction:choosePhoto];
        [self.viewController presentViewController:sheet animated:YES completion:nil];

    } else { // preview photos  预览照片
//        if (self.QiNiuKeysArray.count < self.selectedPhotos.count) {
//            [self showMessage:@"请等待图片上传完成"];
//            [collectionView reloadData];
//            return;
//        }
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithSelectedAssets:self.selectedAssets selectedPhotos:self.selectedPhotos index:indexPath.row];
        imagePickerVc.allowPickingOriginalPhoto = YES;
        imagePickerVc.isSelectOriginalPhoto = _isSelectOriginalPhoto;
        [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
            _selectedPhotos = [NSMutableArray arrayWithArray:photos];
            _selectedAssets = [NSMutableArray arrayWithArray:assets];
            //上传七牛
            [self.QiNiuKeysArray removeAllObjects];
            for (int i = 0; i < self.selectedPhotos.count; i++) {
                UIImage *image = self.selectedPhotos[i];
                [self uploadImageToQiNiu:image];
            }
            _isSelectOriginalPhoto = isSelectOriginalPhoto;
            layout.itemCount = _selectedPhotos.count;
            [_collectionView reloadData];
        }];
        [self.viewController presentViewController:imagePickerVc animated:YES completion:nil];
        
#warning -----
//        [self.viewController.navigationController pushViewController:imagePickerVc animated:YES];
        
        
    }
}
//- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath didMoveToIndexPath:(NSIndexPath *)destinationIndexPath {
//    
//    
////    if (sourceIndexPath.item >= _selectedPhotos.count || destinationIndexPath.item >= _selectedPhotos.count) return;
//////    if (self.QiNiuKeysArray.count < self.selectedPhotos.count) {
//////        [self showMessage:@"请等待图片上传完成"];
//////        [collectionView reloadData];
//////        return;
//////    }
////    UIImage *image = _selectedPhotos[sourceIndexPath.item];
////    if (image) {
////        [_selectedPhotos exchangeObjectAtIndex:sourceIndexPath.item withObjectAtIndex:destinationIndexPath.item];
////        [_selectedAssets exchangeObjectAtIndex:sourceIndexPath.item withObjectAtIndex:destinationIndexPath.item];
////        //上传七牛
////        [_QiNiuKeysArray exchangeObjectAtIndex:sourceIndexPath.item withObjectAtIndex:destinationIndexPath.item];
////        [_collectionView reloadData];
////    }
//    
//    
//    
//}
#pragma mark ===============懒加载============

- (NSMutableArray <NSString *> *)QiNiuKeysArray {
    if(_QiNiuKeysArray == nil) {
        _QiNiuKeysArray = [[NSMutableArray <NSString *> alloc] init];
    }
    return _QiNiuKeysArray;
}

- (NSMutableArray *)selectedPhotos {
    if(_selectedPhotos == nil) {
        _selectedPhotos = [NSMutableArray array];
    }
    return _selectedPhotos;
}

- (NSMutableArray *)selectedAssets {
    if(_selectedAssets == nil) {
        _selectedAssets = [NSMutableArray array];
    }
    return _selectedAssets;
}
- (UIImagePickerController *)imagePickerVc {
    if (_imagePickerVc == nil) {
        _imagePickerVc = [[UIImagePickerController alloc] init];
        _imagePickerVc.delegate = self;
        // set appearance / 改变相册选择页的导航栏外观
        _imagePickerVc.navigationBar.barTintColor = self.viewController.navigationController.navigationBar.barTintColor;
        _imagePickerVc.navigationBar.tintColor = self.viewController.navigationController.navigationBar.tintColor;
        UIBarButtonItem *tzBarItem, *BarItem;
        if (iOS9Later) {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[TZImagePickerController class]]];
            BarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIImagePickerController class]]];
        } else {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedIn:[TZImagePickerController class], nil];
            BarItem = [UIBarButtonItem appearanceWhenContainedIn:[UIImagePickerController class], nil];
        }
        NSDictionary *titleTextAttributes = [tzBarItem titleTextAttributesForState:UIControlStateNormal];
        [BarItem setTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];
    }
    return _imagePickerVc;
}
#pragma mark  ==============events===========
#pragma mark Click Event

- (void)deleteBtnClik:(UIButton *)sender {
//    if (self.QiNiuKeysArray.count < self.selectedPhotos.count) {
//        [self showMessage:@"请等待图片上传完成"];
//        return;
//    }
    [self.selectedPhotos removeObjectAtIndex:sender.tag];
    [self.selectedAssets removeObjectAtIndex:sender.tag];
    
    if (self.QiNiuKeysArray.count > sender.tag ) {
        [self.QiNiuKeysArray removeObjectAtIndex:sender.tag];
    }
    
    layout.itemCount = _selectedPhotos.count;
    
    [_collectionView performBatchUpdates:^{
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:sender.tag inSection:0];
        [_collectionView deleteItemsAtIndexPaths:@[indexPath]];
    } completion:^(BOOL finished) {
        [_collectionView reloadData];
    }];
}
#pragma mark - TZImagePickerController

- (void)pushImagePickerController {
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:self.maxChoose delegate:self];
    
#pragma mark - 四类个性化设置，这些参数都可以不传，此时会走默认设置
    imagePickerVc.isSelectOriginalPhoto = YES;
    
    // 1.如果你需要将拍照按钮放在外面，不要传这个参数
    imagePickerVc.selectedAssets = _selectedAssets; // optional, 可选的
    imagePickerVc.allowTakePicture = NO; // 在内部显示拍照按钮
    
    // 2. Set the appearance
    // 2. 在这里设置imagePickerVc的外观
    // imagePickerVc.navigationBar.barTintColor = [UIColor greenColor];
    // imagePickerVc.oKButtonTitleColorDisabled = [UIColor lightGrayColor];
    // imagePickerVc.oKButtonTitleColorNormal = [UIColor greenColor];
    
    // 3. Set allow picking video & photo & originalPhoto or not
    // 3. 设置是否可以选择视频/图片/原图
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingImage = YES;
    imagePickerVc.allowPickingOriginalPhoto = YES;
    
    // 4. 照片排列按修改时间升序
    imagePickerVc.sortAscendingByModificationDate = YES;
#pragma mark - 到这里为止
    
    [self.viewController presentViewController:imagePickerVc animated:YES completion:nil];
}
#pragma mark - UIImagePickerController

- (void)takePhoto {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if ((authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) && iOS8Later) {
        // 无权限 做一个友好的提示
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction *setting = [UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }];
        [alert addAction:cancel];
        [alert addAction:setting];
        [self.viewController presentViewController:alert animated:YES completion:nil];
    } else { // 调用相机
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
            self.imagePickerVc.sourceType = sourceType;
            if(iOS8Later) {
                _imagePickerVc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            }
            [self.viewController presentViewController:_imagePickerVc animated:YES completion:nil];
        } else {
            NSLog(@"模拟器中无法打开照相机,请在真机中使用");
        }
    }
}
- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    if ([type isEqualToString:@"public.image"]) {
        TZImagePickerController *tzImagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:self.maxChoose delegate:self];
        tzImagePickerVc.sortAscendingByModificationDate = YES;
        [tzImagePickerVc showProgressHUD];
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        
//        [[TZImageManager manager] savePhotoWithImage:image completion:^(NSError *error){
        
            [[TZImageManager manager] getCameraRollAlbum:NO allowPickingImage:YES completion:^(TZAlbumModel *model) {
                
                [[TZImageManager manager] getAssetsFromFetchResult:model.result allowPickingVideo:NO allowPickingImage:YES completion:^(NSArray<TZAssetModel *> *models) {
                    
                    [tzImagePickerVc hideProgressHUD];
                    
                    TZAssetModel *assetModel = [models firstObject];
                    
                    if (tzImagePickerVc.sortAscendingByModificationDate) {
                        assetModel = [models lastObject];
                    }
                    
                    [self.selectedAssets addObject:assetModel.asset];
                    [self.selectedPhotos addObject:image];
                    //上传七牛
                    [self uploadImageToQiNiu:image];
                    
                    [_collectionView reloadData];
                }];
            }];
//        }];
    }
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - TZImagePickerControllerDelegate
// 这个照片选择器会自己dismiss，当选择器dismiss的时候，会执行下面的代理方法
// 如果isSelectOriginalPhoto为YES，表明用户选择了原图
// 你可以通过一个asset获得原图，通过这个方法：[[TZImageManager manager] getOriginalPhotoWithAsset:completion:]
// photos数组里的UIImage对象，默认是828像素宽，你可以通过设置photoWidth属性的值来改变它
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
  
    self.selectedPhotos = [NSMutableArray arrayWithArray:photos];
    
    //遍历上传七牛
    [self.QiNiuKeysArray removeAllObjects];
    
    
    
//    
//    for (int i = 0; i < self.selectedPhotos.count; i++) {
//        UIImage *image = self.selectedPhotos[i];
//        [self uploadImageToQiNiu:image];
//    }
    
    self.selectedAssets = [NSMutableArray arrayWithArray:assets];
    
    _isSelectOriginalPhoto = isSelectOriginalPhoto;
    
    layout.itemCount = _selectedPhotos.count;
    
    [_collectionView reloadData];
}

#pragma mark ===============七牛============
- (void)uploadImageToQiNiu:(UIImage *)image{

    
    
    
    
    
}

- (void)showMessage:(NSString *)msg{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.viewController.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = msg;
    [hud hide:YES afterDelay:1];
//    [hud hideAnimated:YES afterDelay:1];
}

@end
