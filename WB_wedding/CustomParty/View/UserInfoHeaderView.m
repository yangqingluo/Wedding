//
//  UserInfoHeaderView.m
//  WB_wedding
//
//  Created by yangqingluo on 2017/5/16.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import "UserInfoHeaderView.h"


@implementation UserInfoHeaderView

- (void)awakeFromNib{
    [super awakeFromNib];
    
    [AppPublic roundCornerRadius:self.constellationLable cornerRadius:5.0];
    [AppPublic roundCornerRadius:self.ageLable cornerRadius:5.0];
    [AppPublic roundCornerRadius:self.thirdLable cornerRadius:5.0];
    
    self.height = screen_width * self.height / self.width;
    self.width = screen_width;
}

@end
