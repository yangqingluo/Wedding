//
//  WESomeOneAnswerQuestionVC.h
//  WB_wedding
//
//  Created by 刘人华 on 17/1/26.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import "HQBaseViewController.h"

/**
 *   回答问题控制器
 */
@interface WESomeOneAnswerQuestionVC : HQBaseViewController

/**
 *  要回答人的id，暂时没有用
 */
@property (nonatomic,copy)NSString  *ID;
/**
 *  问题的数组
 */
@property (nonatomic,copy)NSArray    *questionArray;
@property (nonatomic, strong) NSDictionary *infoDic;


/**
 *  几个人的信息
 */
@property (nonatomic,copy)NSArray       *array;

@end
