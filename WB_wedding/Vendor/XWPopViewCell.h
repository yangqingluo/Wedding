//
//  XWPopViewCell.h
//  SpeedDoctorPatient
//
//  Created by 谢威 on 16/11/15.
//  Copyright © 2016年 chenhong. All rights reserved.
//

#import <UIKit/UIKit.h>


static NSString *XWPopViewCellID = @"XWPopViewCellID";
@interface XWPopViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lable;

@property (weak, nonatomic) IBOutlet UIView *line;


@end
