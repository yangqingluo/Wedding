//
//  AppDatePickerView.h
//

#import <UIKit/UIKit.h>

@interface AppDatePickerView : UIView

- (instancetype)initWithCallBack:(PopDoneBlock)callBack;
- (void)show;

@end
