//
//  WESomeOneAnswerQuestionVC.m
//  WB_wedding
//
//  Created by 刘人华 on 17/1/26.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import "WESomeOneAnswerQuestionVC.h"
#import "WEAnswerFansSureBtnCell.h"
#import "WEAnswerFanseHeader.h"
//#import "WELookDetailCell.h"
#import "WELookDetailModel.h"
#import "XWPickerView.h"
#import "WESeletedController.h"
#import "WESomeOneLikeTool.h"
#import "SomeOneAnswerQuestionCell.h"
@interface WESomeOneAnswerQuestionVC ()<UITableViewDataSource, UITableViewDelegate,UIScrollViewDelegate>
//@property (weak, nonatomic) IBOutlet UIImageView *headerImgView;//头像
//@property (weak, nonatomic) IBOutlet UILabel     *nameLab;//姓名
@property (weak, nonatomic) IBOutlet UITableView *mTableView;//主表格
//@property (weak, nonatomic) IBOutlet UIButton    *sendBtn;//发送按钮

@property (nonatomic,strong)NSMutableArray  *dataSource;
@property (nonatomic,strong)NSMutableArray        *arrSet;

@end

@implementation WESomeOneAnswerQuestionVC

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.navBarColor = [UIColor whiteColor];
    [self.baseNavigationBar.backBtn setImage:[UIImage imageNamed:@"return48"] forState:UIControlStateNormal];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    self.navBarColor = KNaviBarTintColor;
    [self.baseNavigationBar.backBtn setImage:[UIImage imageNamed:@"return48_white"] forState:UIControlStateNormal];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.arrSet = [NSMutableArray array];
    self.mTableView.sectionHeaderHeight = 162;
    
    // 设置数据源
    [self configDataSource];

    self.mTableView.delegate = self;
    self.mTableView.dataSource = self;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.mTableView registerNib:[UINib nibWithNibName:@"SomeOneAnswerQuestionCell" bundle:nil] forCellReuseIdentifier:SomeOneAnswerQuestionCellId];
    self.mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    NSLog(@"%@",self.array);
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
}

- (void)configUIWithView:(WEAnswerFanseHeader *)header {
    
    // 头像
    if (self.infoDic[@"imgFileNames"]) {
        NSDictionary *dic = self.infoDic;
        NSString *imageSrtring = dic[@"imgFileNames"];
        
        NSArray *array = [imageSrtring componentsSeparatedByString:@","];
        //
        NSURL *imagURL =[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/%@",ImageURL,dic[@"senderId"],array[0]]];
        NSLog(@"====！===%@",array);
        [header.headerImgView sd_setImageWithURL:imagURL placeholderImage:[UIImage imageNamed:@"3"]];
    }
    
    // 名称
    header.nameLab.text = self.infoDic[@"nickname"];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count + 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.row == self.dataSource.count) {
        WEAnswerFansSureBtnCell *cell = [WEAnswerFansSureBtnCell xw_loadFromNib];
        return cell;
    }
    SomeOneAnswerQuestionCell *cell = [tableView dequeueReusableCellWithIdentifier:SomeOneAnswerQuestionCellId];
    WELookDetailModel *model = self.dataSource[indexPath.row];
    cell.titleLab.text = model.title;
    cell.contentTf.text = model.content;
    return cell;
    
    
}


#pragma mark - tableview的头部
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == self.dataSource.count) {
        return 50;
    }
    
    return 90.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    WEAnswerFanseHeader *header = [WEAnswerFanseHeader xw_loadFromNib];
    header.frame = CGRectMake( 0, 0, SCREEN_W, 162);
    [self configUIWithView:header];
    return header;
}

/**
 *  取消header 的悬停
 *
 *  @param scrollView
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat sectionHeaderHeight = 162;
    //    NSLog(@"滑动的%lf",scrollView.contentOffset.y);
    if (scrollView.contentOffset.y <= sectionHeaderHeight && scrollView.contentOffset.y >= 0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y >= sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
    NSLog(@"滑动的%lf",scrollView.contentOffset.y);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.mTableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.row == self.dataSource.count) {
        [self.mTableView deselectRowAtIndexPath:indexPath animated:NO];
        [self sendMsg];
    }
}

#pragma mark - 设置数据源
- (void)configDataSource{

    self.dataSource = [NSMutableArray array];
    for (int i = 0; i < self.questionArray.count; i ++) {
        WELookDetailModel *model = [WELookDetailModel modelWithTitle:self.questionArray[i]
                                                             content:nil];
        [self.dataSource addObject:model];
    }
}


#pragma mark --- 回答完了
- (void)sendMsg {
    
    if (self.dataSource.count == 0) {
        return;
    }
    SVPSTATUS(@"发送中...")
    NSMutableString *sendStr = [NSMutableString string];
    for (int i = 0; i < self.dataSource.count; i ++) {
        NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:0];
        SomeOneAnswerQuestionCell *cell = [self.mTableView cellForRowAtIndexPath:path];
        if (cell.contentTf.text.length < 1) {
            SVPERROR(@"请填写完整");
            return;
        } else {
            [sendStr appendFormat:@"%@&",cell.contentTf.text];
        }
    }
    if (sendStr && sendStr.length > 0) {
        [sendStr deleteCharactersInRange:NSMakeRange(sendStr.length - 1, 1)];
    }
    /**
     *  网络请求
     */
    [BANetManager ba_requestWithType:BAHttpRequestTypePost
                           urlString:BASEURL(@"/likeu/chooseanswer")
                          parameters:@{@"id":self.infoDic[@"id"],
                                    @"answers":sendStr}
                        successBlock:^(id response) {
                            NSLog(@"--回答粉丝%@",response);
                            if ([response[@"success"] boolValue]) {
                                SVPSUCCESS(@"发送成功");
                                [self.navigationController popViewControllerAnimated:YES];
                            } else{
                                NSString *errorStr = response[@"msg"];
                                SVPERROR(errorStr);
                            }
                        }
                        failureBlock:^(NSError *error) {
                            SVPERROR(@"网络错误");
                        }
                            progress:nil];
}



@end
