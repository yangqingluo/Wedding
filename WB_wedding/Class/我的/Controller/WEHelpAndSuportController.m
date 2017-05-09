//
//  WEHelpAndSuportController.m
//  WB_wedding
//
//  Created by 谢威 on 17/1/18.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import "WEHelpAndSuportController.h"
#import "UIImage+Color.h"

@interface WEHelpAndSuportController ()

@property (strong, nonatomic) UIButton *closeButton;

@end

@implementation WEHelpAndSuportController

- (void)viewDidLoad {
    [self setupNav];
    
    [super viewDidLoad];
}

- (void)setupNav {
    [self createNavWithTitle:@"帮助与支持" createMenuItem:^UIView *(int nIndex){
        if (nIndex == 0) {
            UIButton *btn = NewBackButton([UIColor whiteColor]);
            [btn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
            return btn;
        }
        else if (nIndex == 1) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            UIImage *i = [UIImage imageNamed:@"nav_close"];
            [btn setImage:[i imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
            [btn setFrame:CGRectMake(0, 0, 64, 44)];
            btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            btn.left = 35;
            btn.width = 50;
            
            btn.imageEdgeInsets = UIEdgeInsetsMake(12, kEdgeMiddle, 12, kEdgeMiddle);
            [btn addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
            
            btn.hidden = true;
            self.closeButton = btn;
            
            return btn;
        }
        
        return nil;
    }];
    
}

- (void)goBack{
    if (self.webView.canGoBack) {
        [self.webView goBack];
        
        if (self.closeButton.hidden) {
            self.closeButton.hidden = false;
            self.titleLabel.width = screen_width - 2 * self.closeButton.right;
            self.titleLabel.centerX = 0.5 * screen_width;
        }
        
        return;
    }
    
    [self close];
}

- (void)close{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"webViewDidStartLoad");
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"webViewDidFinishLoad");
//    self.titleLabel.text = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [self showHint:@"加载失败"];
}


@end
