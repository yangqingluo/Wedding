//
//  PhotoPickerCollectionViewCell.h
//  PhotoPicker
//
//  Created by liuDavid on 16/7/21.
//  Copyright © 2016年 刘未. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoPickerCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *deleteBtn;
@property (nonatomic, assign) NSInteger row;
@property (nonatomic, strong) UILabel *label;



- (UIView *)snapshotView;

@end
