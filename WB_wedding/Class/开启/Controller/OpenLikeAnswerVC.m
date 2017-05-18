//
//  OpenLikeAnswerVC.m
//  WB_wedding
//
//  Created by dadahua on 17/4/7.
//  Copyright © 2017年 龙山科技. All rights reserved.
//
#import "WELookDetailModel.h"
#import "OpenLikeAnswerVC.h"
#import "SomeOneAnswerQuestionCell.h"
#import <UIImageView+WebCache.h>
#import "WEAnswerFansSureBtnCell.h"
#import "UITextField+TFIndexPath.h"

static NSInteger kHeaderHeight = 165;
static NSInteger kHeaderImgWidth = 60;
static NSInteger kBtnTag = 1000;

@interface OpenLikeAnswerVC ()<UITableViewDataSource, UITableViewDelegate,UIScrollViewDelegate,UITextFieldDelegate>
@property (strong, nonatomic)  UITableView *mTableView;//主表格
//@property (weak, nonatomic) IBOutlet UIButton    *sendBtn;//发送按钮

@property (nonatomic,strong)NSMutableArray  *dataSource;

@property (nonatomic, strong) NSMutableArray *totalcells;
@end

@implementation OpenLikeAnswerVC
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
    self.mTableView.sectionHeaderHeight = kHeaderHeight;
    self.title = @"请认真回复Ta的问题";
    // 设置数据源
    [self configDataSource];
    self.totalcells = [NSMutableArray array];
    
    self.mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_W, SCREEN_H - 64)
                                                   style:UITableViewStyleGrouped];
    self.mTableView.delegate = self;
    self.mTableView.dataSource = self;
    self.mTableView.rowHeight = 100;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.mTableView registerNib:[UINib nibWithNibName:@"SomeOneAnswerQuestionCell"
                                                bundle:nil]
          forCellReuseIdentifier:SomeOneAnswerQuestionCellId];
    self.mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.mTableView];
}

- (void)configDataSource {
    
    self.dataSource = [NSMutableArray array];
    for (NSDictionary *userInfo in self.modelsAr) {
        
        NSMutableArray *questionModelAr = [NSMutableArray array];
        NSString *myQuestionStr = userInfo[@"myQuestion"];
        NSArray *userQuestions = [myQuestionStr componentsSeparatedByString:@"&"];
        
        for (int i = 0; i < userQuestions.count; i ++) {
            WELookDetailModel *model = [WELookDetailModel modelWithTitle:userQuestions[i]
                                                                 content:nil];
            [questionModelAr addObject:model];
        }
        
        [self.dataSource addObject:questionModelAr];
    }
    
    // 添加一个提交按钮
    [self.dataSource addObject:@[@1]];
    

}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.dataSource.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.dataSource[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.section == self.dataSource.count - 1) {
        WEAnswerFansSureBtnCell *cell = [WEAnswerFansSureBtnCell xw_loadFromNib];
        return cell;
    }
    
    SomeOneAnswerQuestionCell *cell = [tableView dequeueReusableCellWithIdentifier:SomeOneAnswerQuestionCellId];
    cell.contentTf.delegate = self;
    cell.contentTf.indexPath = indexPath;
    
    [cell.contentTf addTarget:self action:@selector(tfChange:) forControlEvents:UIControlEventEditingChanged];
    
    WELookDetailModel *model = self.dataSource[indexPath.section][indexPath.row];
    cell.titleLab.text = model.title;
    cell.contentTf.text = model.content;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == self.dataSource.count - 1) {
        return 0;
    }
    return kHeaderHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == self.dataSource.count - 1) {
        return nil;
    }
    
    
    UIView *header = [UIView new];
    header.frame = CGRectMake(0, 0, SCREEN_W, kHeaderHeight);
    
    // 头像
    UIImageView *headerImageView = [UIImageView new];
    headerImageView.frame = CGRectMake(20, (kHeaderHeight - kHeaderImgWidth) / 2, kHeaderImgWidth, kHeaderImgWidth);
    headerImageView.layer.cornerRadius = kHeaderImgWidth / 2;
    headerImageView.clipsToBounds = YES;

    NSString *imageSrtring = self.modelsAr[section][@"imgFileNames"];
    NSArray *array = [imageSrtring componentsSeparatedByString:@","];
    NSURL *imagURL =[NSURL URLWithString: [NSString stringWithFormat:@"%@/%@/%@",ImageURL,self.modelsAr[section][@"id"],array[0]]];
    [headerImageView sd_setImageWithURL:imagURL placeholderImage:[UIImage imageNamed:downloadImagePlace]];
    
    // 名字
    UILabel *lab = [[UILabel alloc] init];
    lab.frame = CGRectMake(headerImageView.x + headerImageView.width + 20, 0, SCREEN_W - 20 - kHeaderHeight - 60, kHeaderHeight);
    lab.text = self.modelsAr[section][@"nickname"];
    lab.textColor = [UIColor blackColor];
    lab.font = [UIFont systemFontOfSize:22.f];

    // 删除按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(SCREEN_W - 60, 10, 50, 50);
    [btn setImage:[UIImage imageNamed:@"删除144"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(deleteSections:) forControlEvents:UIControlEventTouchUpInside];
    btn.tag = kBtnTag + section;

    [header addSubview:btn];
    [header addSubview:lab];
    [header addSubview:headerImageView];
    return header;
}


#pragma mark - tableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == self.dataSource.count - 1) {
#pragma mark 发送
        // 1.先判断是否填写完整
        NSMutableArray *postAr = [NSMutableArray array]; //要发送的数组
        
        for (int i = 0; i < self.dataSource.count - 1; i ++) { // 回到的某个人
            
            NSMutableString *answerFromSender = [NSMutableString string];
            NSArray *ar = self.dataSource[i];
            if (ar.count > 0) { // 先判断用户的问题是否为空
                for (int j = 0; j < ar.count; j ++) {
                    WELookDetailModel *model = ar[j];
                    // 判断答案是否为空
                    NSString *content = model.content;
                    if (content.length < 1 || !content) {
                        SVPERROR(@"请输入完整");
                        return;
                    }
                    [answerFromSender appendFormat:@"%@|%@&",model.title,model.content];
                }
                // 删除answerFromSender最后一个&
                [answerFromSender deleteCharactersInRange:NSMakeRange((answerFromSender.length - 1, 1), 1)];
                
            }
            
            // 2.得到每个用户回答问题的字典
            NSMutableDictionary *answerDic = [NSMutableDictionary dictionary];
            answerDic[@"matchDegree"] = self.modelsAr[i][@"matchDegree"];
            answerDic[@"recieverId"] = self.modelsAr[i][@"id"];
            answerDic[@"senderId"] = [XWUserModel getUserInfoFromlocal].xw_id;
            answerDic[@"answerFromSender"] = answerFromSender;
            
            // 3.把字典装到数组里面
            [postAr addObject:answerDic];
        }
        
        // 4.发送数据
        [[HQBaseNetManager sharedAFManager] POST:BASEURL(@"/match/send") parameters:postAr
    
                                        progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"发送是否成功--->%@",responseObject);
                                            if ([responseObject[@"success"] boolValue]) {
                                                SVPSUCCESS(@"发送成功");
                                                [self.navigationController popViewControllerAnimated:YES];
                                            } else{
                                                SVPERROR(responseObject[@"msg"]);
                                            }
    }
    
                                         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                             SVPERROR(@"网络错误");
    }];
//        [HQBaseNetManager POST:BASEURL(@"/match/send")
//                    parameters:postAr completionHandler:^(id responseObj, NSError *error) {
//                        NSLog(@"发送是否成功--->%@",responseObj);
//                NSLog(@"发送失败--->%@",error);
//                    }];
//
    }
}
#pragma mark - tf编辑
- (void)tfChange:(UITextField *)tf {
    NSIndexPath *indexPath = tf.indexPath;
    WELookDetailModel *model = self.dataSource[indexPath.section][indexPath.row];
    model.content = [NSString stringWithFormat:@"%@",tf.text];
    NSMutableArray *sectionDataSource = self.dataSource[indexPath.section];
    [sectionDataSource replaceObjectAtIndex:indexPath.row withObject:model];
}

#pragma mark - textField delegate
//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
//    
//    
//}
//- (void)textFieldDidBeginEditing:(UITextField *)textField {
//    
//}
//- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
//    
//    return YES;
//}
//- (void)textFieldDidEndEditing:(UITextField *)textField {
//    
//    
//}
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//    
//}
//
//- (BOOL)textFieldShouldReturn:(UITextField *)textField {
//    
//    
//}
#pragma mark - 删除section
- (void)deleteSections:(UIButton *)sender {
    
    if (self.dataSource.count <= 2) {
        return;
    }
    NSInteger section = sender.tag - kBtnTag;
    [self.dataSource removeObjectAtIndex:section];
    [self.mTableView deleteSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationTop];
}

@end
