//
//  QKBaseCollectionViewCell.m
//
//  Created by yangqingluo on 15/11/9.
//  Copyright © 2015年 yangqingluo. All rights reserved.
//

#import "QKBaseCollectionViewCell.h"

@implementation QKBaseCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        double radius = 10;
        double aveWH = CGRectGetWidth( self.frame ) - 5;
        
        self.imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, radius, aveWH - radius, aveWH - radius)];
        self.imgView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self addSubview:self.imgView];
        
        self.removeButton = [[UIButton alloc]initWithFrame:CGRectMake(aveWH - 2 * radius, 0, 2 * radius, 2 * radius)];
        [self.removeButton setImage:[UIImage imageNamed:@"cell_delete"] forState:UIControlStateNormal];
        [self addSubview:self.removeButton];
    }
    return self;
}

@end
