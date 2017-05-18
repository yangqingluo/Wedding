//
//  AppPickerView.h
//

#import <UIKit/UIKit.h>


@interface AppPickerView : UIView


- (instancetype)initWithCallBack:(PopDoneBlock)callBack WithDataSource:(NSArray *)dataSource;
- (void)show;

@end
