//
//  UserQuestionnaireVC.h
//  WB_wedding
//
//  Created by yangqingluo on 2017/5/17.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import "AppBasicTableViewController.h"

typedef enum {
    UserQuestionnaireTypeSelf = 0,
    UserQuestionnaireTypeOthers,
}UserQuestionnaireType;

@interface UserQuestionnaireVC : AppBasicTableViewController

@property (nonatomic) UserQuestionnaireType questionnaireType;
@property (strong, nonatomic) AppUserData *userData;

@end
