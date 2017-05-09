//
//  AppBasicWebViewController.h
//  WB_wedding
//
//  Created by yangqingluo on 2017/5/9.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import "AppBasicViewController.h"

@interface AppBasicWebViewController : AppBasicViewController<UIWebViewDelegate>


- (instancetype)initWithURLString:(NSString *)string;

@property (nonatomic, strong) UIWebView *webView;

@end
