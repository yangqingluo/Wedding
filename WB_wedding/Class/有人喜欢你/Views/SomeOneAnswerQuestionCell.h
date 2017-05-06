//
//  SomeOneAnswerQuestionCell.h
//  WB_wedding
//
//  Created by 刘人华 on 17/2/12.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import <UIKit/UIKit.h>
static NSString *SomeOneAnswerQuestionCellId = @"SomeOneAnswerQuestionCellId";

@interface SomeOneAnswerQuestionCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UITextField *contentTf;

@end
