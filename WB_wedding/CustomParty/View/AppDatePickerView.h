//
//  AppDatePickerView.h
//

#import <UIKit/UIKit.h>

@interface AppDatePickerView : UIView

- (instancetype)initWithDate:(NSDate *)date andCallBack:(PopDoneBlock)callBack;
- (void)show;

@end
