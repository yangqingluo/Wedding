//
//  AppBasicWebViewController.m
//  WB_wedding
//
//  Created by yangqingluo on 2017/5/9.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import "AppBasicWebViewController.h"

@interface AppBasicWebViewController ()

@property (strong, nonatomic) NSString *urlString;

@end

@implementation AppBasicWebViewController

- (instancetype)initWithURLString:(NSString *)string{
    self = [super init];
    if (self) {
        _urlString = string;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.webView];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma getter
- (UIWebView *)webView{
    if (!_webView){
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT, self.view.width, self.view.height - STATUS_BAR_HEIGHT)];
        _webView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
        _webView.delegate = self;
    }
    
    return _webView;
}

@end
