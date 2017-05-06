//
//  PhotoPickerView.h
//  PhotoPicker
//
//  Created by liuDavid on 16/7/21.
//  Copyright © 2016年 刘未. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoPickerView : UIView
@property (nonatomic,unsafe_unretained) CGFloat itemMargin;
@property (nonatomic,weak) UIViewController *viewController;

@property (nonatomic,unsafe_unretained) int maxChoose;

@property (nonatomic,strong) NSMutableArray *selectedPhotos;
@property (nonatomic,strong) NSMutableArray *selectedAssets;
@property (nonatomic,strong) NSString *holderImageName;

@property (nonatomic,strong) NSMutableArray <NSString *>*QiNiuKeysArray;

- (instancetype)initWithFrame:(CGRect)frame itemMargin:(CGFloat)itemMargin viewController:(UIViewController *)viewController maxChoose:(int)maxChoose holderImageName:(NSString *)holderImageName;






@end
