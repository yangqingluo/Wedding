//
//  UITextField+TFIndexPath.m
//  WB_wedding
//
//  Created by dadahua on 17/4/10.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import "UITextField+TFIndexPath.h"
#import <objc/runtime.h>
static char *TfIndexPath = "TfIndexPath";

@implementation UITextField (TFIndexPath)


- (void)setIndexPath:(NSIndexPath *)indexPath {
    
    objc_setAssociatedObject(self, TfIndexPath, indexPath, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSIndexPath *)indexPath {
    
    return objc_getAssociatedObject(self, TfIndexPath);
}
@end
