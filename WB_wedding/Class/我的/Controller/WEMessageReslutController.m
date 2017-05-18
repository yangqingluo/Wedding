//
//  WEMessageReslutController.m
//  WB_wedding
//
//  Created by 谢威 on 17/1/22.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import "WEMessageReslutController.h"

@interface WEMessageReslutController ()
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UIButton *receiveButton;

@end

@implementation WEMessageReslutController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    
    switch (self.messageData.msgType) {
        case UserMessageTypeNormal:{
            self.name.text = @"";
            self.receiveButton.hidden = YES;
        }
            break;
            
        case UserMessageTypeLove:
        case UserMessageTypeReLove:
        case UserMessageTypeLocate:{
            self.name.text = [NSString stringWithFormat:@"%@的心里话", self.messageData.otherNickName];
            self.receiveButton.hidden = NO;
        }
            break;
            
        default:
            break;
    }
    
    self.content.text = self.messageData.content;
    
    [self sendMessageReaded];
}

- (void)setupNav {
    [self createNavWithTitle:@"消息" createMenuItem:^UIView *(int nIndex){
        if (nIndex == 0){
            UIButton *btn = NewBackButton(nil);
            [btn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
            return btn;
        }
        
        return nil;
    }];
}

- (void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)sendMessageReaded{
    [[QKNetworkSingleton sharedManager] Get:@{@"messageId":self.messageData.ID} HeadParm:nil URLFooter:@"/mymessage/readmessage" completion:^(id responseBody, NSError *error){
        
        if (!error) {
            if (isHttpSuccess([responseBody[@"success"] intValue])) {
                self.messageData.isMessageRead = @"1";
            }
        }
    }];
}

- (IBAction)recivieBtnClick:(id)sender {
    
}


@end
