//
//  XWPopView.m
//  SpeedDoctorPatient
//
//  Created by 谢威 on 16/11/15.
//  Copyright © 2016年 chenhong. All rights reserved.
//

#import "XWPopView.h"
#import "XWPopViewCell.h"
#import "XWContentView.h"
@interface XWPopView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,copy)NSArray           *dataSource;
@property (nonatomic,copy)popViewActionBack back;
@property (nonatomic,strong)UIImageView     *bgImageView;
@property (nonatomic,strong)UITableView     *tableView;
@property (nonatomic,strong)XWContentView   *contentView;

@end

@implementation XWPopView

- (instancetype)initWithItmes:(NSArray *)items popViewActionBack:(popViewActionBack)back{
    if (self == [super init]) {
         self.back =back;
         self.dataSource = items;
         self.frame = [UIScreen mainScreen].bounds;
         self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.001];
        CGFloat H = 40 * self.dataSource.count;
        CGFloat W = 100;
        CGFloat X = [UIScreen mainScreen].bounds.size.width-W-15;
        self.contentView  = [[XWContentView alloc]initWithFrame:CGRectMake(X,66,W, H)];
        [self addSubview:self.contentView];
        [self.contentView addSubview:self.bgImageView];
        
    }
    return self;
    
}
- (void)showInView:(UIView *)view{
    [view addSubview:self];
    self.bgImageView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    [self showAnimationToView:self.bgImageView];
}
- (void)showAnimationToView:(UIView *)view{
     [UIView animateWithDuration:0.26 animations:^{
        
         view.transform = CGAffineTransformIdentity;

     } completion:^(BOOL finished) {
         
     }];
    
}
- (void)close{
    
    [UIView animateWithDuration:0.26 animations:^{
        
        self.bgImageView.transform = CGAffineTransformMakeScale(0.01, 0.01);
        
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [self.bgImageView removeFromSuperview];
    }];

}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    XWPopViewCell *cell = [tableView dequeueReusableCellWithIdentifier:XWPopViewCellID];
    cell.lable.text = self.dataSource[indexPath.row];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
    
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.transform = CGAffineTransformMakeTranslation(150,0);
    [UIView animateWithDuration:0.4 delay:indexPath.row *0.03 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        cell.transform = CGAffineTransformIdentity;
        
    } completion:^(BOOL finished) {
        
    }];
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  
    
    if (self.back) {
        self.back(indexPath.row);
        [self close];
    }
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self close];
    
}


- (UIImageView *)bgImageView{
    
    if (!_bgImageView) {
          _bgImageView = ({
              CGFloat H = 40 * self.dataSource.count;
              CGFloat W = 100;
              UIImageView *view = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,W, H)];
              view.image = [UIImage imageNamed:@"popView_Bg"];
              view.userInteractionEnabled= YES;
              [view addSubview:self.tableView];
              view;
        });
    }
    
    return _bgImageView;
}
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = ({
            CGFloat H = 40 * self.dataSource.count;
            CGFloat W = 100;
            UITableView *view = [[UITableView alloc]initWithFrame:CGRectMake(0, 0,W,H)  style:UITableViewStylePlain];
            view.delegate = self;
            view.dataSource = self;
            view.rowHeight = 40;
            view.contentInset = UIEdgeInsetsMake(2, 0, 0, 0);
            view.separatorStyle = UITableViewCellSeparatorStyleNone;
            view.backgroundColor = [UIColor clearColor];
            [view registerNib:[UINib nibWithNibName:@"XWPopViewCell" bundle:nil] forCellReuseIdentifier:XWPopViewCellID];
            view;
        });
    }
    
    return _tableView;
}



@end
