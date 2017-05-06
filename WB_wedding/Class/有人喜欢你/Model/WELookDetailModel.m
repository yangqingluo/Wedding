//
//  WELookDetailModel.m
//  WB_wedding
//
//  Created by 谢威 on 17/1/12.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import "WELookDetailModel.h"

@implementation WELookDetailModel

+ (instancetype)modelWithTitle:(NSString *)title content:(NSString *)content {
    
    WELookDetailModel *model = [[WELookDetailModel alloc] init];
    model.title = title;
    model.content = content;
    return model;
}

- (CGFloat)xw_cellHeight{
    
    
    return [NSString xw_getStringHeightWithString:self.content  W:KScreenWidth-30 font:16]+46;
}
@end
