//
//  WELookDetailViewController.m
//  WB_wedding
//
//  Created by 谢威 on 17/1/12.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import "WELookDetailViewController.h"
#import "WELookDetailCell.h"
#import "WELookDetailModel.h"
#import "WELookDetailHeaderView.h"
#import "WECommetViewController.h"
#import "WEAskInfoController.h"
#import "WESomeOneLikeController.h"
#import "WESomeOneAnswerQuestionVC.h"
#import "WELookDetailFooterView.h"
#import "WEBianjiSelfInfoController.h"
#import "WESomeOneLikeTool.h"
#import "WECompletInfoController.h"
#import "WEYourMessageTool.h"

@interface WELookDetailViewController ()<WELookDetailFooterViewDelegate,WELookDetailHeaderViewDelegate,UIAlertViewDelegate,WELookDetailCellDelegate>

@property (nonatomic,strong)NSMutableArray      *dataSource;
@property (nonatomic,strong) WELookDetailFooterView *footer;
@property (nonatomic,strong)UIButton  *seleteBtn;
@property (nonatomic,assign)vcType        type;
@property (nonatomic,strong)UIAlertView     *aler;

@property (nonatomic,strong)  WELookDetailHeaderView *headeView ;
@end

@implementation WELookDetailViewController


- (instancetype)initWithType:(vcType)type{
    if (self = [super init]) {
        self.type = type;
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configDataSource];
    [self configUserInterface];
    
    
    
}
- (void)configDataSource{
    
    self.dataSource = [NSMutableArray array];
    
    if (self.type == vcTypeYourLike) {
    WELookDetailModel  *model0 = [[WELookDetailModel alloc]init];
    model0.title  = @"真实姓名";
    model0.content = self.dic[@"realname"];
    [self.dataSource addObject:model0];
    
    WELookDetailModel  *model1 = [[WELookDetailModel alloc]init];
    model1.title  = @"行业";
    model1.content = self.dic[@"profession"];
    [self.dataSource addObject:model1];
    

    WELookDetailModel  *model2 = [[WELookDetailModel alloc]init];
    model2.title  = @"工作领域";
    model2.content = self.dic[@"job"];
    [self.dataSource addObject:model2];
    

    WELookDetailModel  *model3 = [[WELookDetailModel alloc]init];
    model3.title  = @"经常出没";
    model3.content = self.dic[@"regularPlace"];
    [self.dataSource addObject:model3];
    

    WELookDetailModel  *model4 = [[WELookDetailModel alloc]init];
    model4.title  = @"学历";
    model4.content = self.dic[@"educationBackground"];
    [self.dataSource addObject:model4];
    

    WELookDetailModel  *model5 = [[WELookDetailModel alloc]init];
    model5.title  = @"自我评价";
    model5.content = self.dic[@"selfEvaluation"];
    [self.dataSource addObject:model5];
    

    WELookDetailModel  *model6 = [[WELookDetailModel alloc]init];
    model6.title  = @"业余爱好";
    model6.content = self.dic[@"hobby"];
    [self.dataSource addObject:model6];
    

    WELookDetailModel  *model7 = [[WELookDetailModel alloc]init];
    model7.title  = @"喜欢的运动";
    model7.content = self.dic[@"fSport"];
    [self.dataSource addObject:model7];
    

    WELookDetailModel  *model8 = [[WELookDetailModel alloc]init];
    model8.title  = @"喜欢的食物";
    model8.content = self.dic[@"fFood"];
    [self.dataSource addObject:model8];
    

    WELookDetailModel  *model9 = [[WELookDetailModel alloc]init];
    model9.title  = @"喜欢的电影";
    model9.content =self.dic[@"fMovie"];
    [self.dataSource addObject:model9];
    

    
    WELookDetailModel  *model10 = [[WELookDetailModel alloc]init];
    model10.title  = @"喜欢的书和动漫";
    model10.content = self.dic[@"fBookCartoon"];
    [self.dataSource addObject:model10];
    
    WELookDetailModel  *model11 = [[WELookDetailModel alloc]init];
    model11.title  = @"去过的地方";
    model11.content =self.dic[@"visitedPlace"];
    [self.dataSource addObject:model11];
        
        // 进来一次就把变为已读
        [WESomeOneLikeTool lookLikeYouDetailWithID:self.ID success:^(id model) {
            
        } failed:^(NSString *error) {
            
        }];
        
        
        
    }else if(self.type == vcTypeYourMsg){
        
        WELookDetailModel  *model0 = [[WELookDetailModel alloc]init];
        model0.title  = @"真实姓名";
        model0.content = self.dic[@"realname"];
        [self.dataSource addObject:model0];
        
        WELookDetailModel  *model1 = [[WELookDetailModel alloc]init];
        model1.title  = @"行业";
        model1.content = self.dic[@"profession"];
        [self.dataSource addObject:model1];
        
        
        WELookDetailModel  *model2 = [[WELookDetailModel alloc]init];
        model2.title  = @"工作领域";
        model2.content = self.dic[@"job"];
        [self.dataSource addObject:model2];
        
        
        WELookDetailModel  *model3 = [[WELookDetailModel alloc]init];
        model3.title  = @"经常出没";
        model3.content = self.dic[@"regularPlace"];
        [self.dataSource addObject:model3];
        
        
        WELookDetailModel  *model4 = [[WELookDetailModel alloc]init];
        model4.title  = @"学历";
        model4.content = self.dic[@"educationBackground"];
        [self.dataSource addObject:model4];
        
        
        WELookDetailModel  *model5 = [[WELookDetailModel alloc]init];
        model5.title  = @"自我评价";
        model5.content = self.dic[@"selfEvaluation"];
        [self.dataSource addObject:model5];
        
        
        WELookDetailModel  *model6 = [[WELookDetailModel alloc]init];
        model6.title  = @"业余爱好";
        model6.content = self.dic[@"hobby"];
        [self.dataSource addObject:model6];
        
        
        WELookDetailModel  *model7 = [[WELookDetailModel alloc]init];
        model7.title  = @"喜欢的运动";
        model7.content = self.dic[@"fSport"];
        [self.dataSource addObject:model7];
        
        
        WELookDetailModel  *model8 = [[WELookDetailModel alloc]init];
        model8.title  = @"喜欢的食物";
        model8.content = self.dic[@"fFood"];
        [self.dataSource addObject:model8];
        
        
        WELookDetailModel  *model9 = [[WELookDetailModel alloc]init];
        model9.title  = @"喜欢的电影";
        model9.content =self.dic[@"fMovie"];
        [self.dataSource addObject:model9];
        
        
        
        WELookDetailModel  *model10 = [[WELookDetailModel alloc]init];
        model10.title  = @"喜欢的书和动漫";
        model10.content = self.dic[@"fBookCartoon"];
        [self.dataSource addObject:model10];
        
        WELookDetailModel  *model11 = [[WELookDetailModel alloc]init];
        model11.title  = @"去过的地方";
        model11.content =self.dic[@"visitedPlace"];
        [self.dataSource addObject:model11];
        
        [WEYourMessageTool settingReplyYouWithID:self.ID success:^(id model) {
            
        } failed:^(NSString *error) {
            
        }];
        
        
    }else if(self.type == vcTypeHome){
        WELookDetailModel  *model0 = [[WELookDetailModel alloc]init];
        model0.title  = @"真实姓名";
        model0.content = self.dic[@"realname"];
        [self.dataSource addObject:model0];
        
        WELookDetailModel  *model1 = [[WELookDetailModel alloc]init];
        model1.title  = @"行业";
        model1.content = self.dic[@"profession"];
        [self.dataSource addObject:model1];
        
        
        WELookDetailModel  *model2 = [[WELookDetailModel alloc]init];
        model2.title  = @"工作领域";
        model2.content = self.dic[@"job"];
        [self.dataSource addObject:model2];
        
        
        WELookDetailModel  *model3 = [[WELookDetailModel alloc]init];
        model3.title  = @"经常出没";
        model3.content = self.dic[@"regularPlace"];
        [self.dataSource addObject:model3];
        
        
        WELookDetailModel  *model4 = [[WELookDetailModel alloc]init];
        model4.title  = @"学历";
        model4.content = self.dic[@"educationBackground"];
        [self.dataSource addObject:model4];
        
        
        WELookDetailModel  *model5 = [[WELookDetailModel alloc]init];
        model5.title  = @"自我评价";
        model5.content = self.dic[@"selfEvaluation"];
        [self.dataSource addObject:model5];
        
        
        WELookDetailModel  *model6 = [[WELookDetailModel alloc]init];
        model6.title  = @"业余爱好";
        model6.content = self.dic[@"hobby"];
        [self.dataSource addObject:model6];
        
        
        WELookDetailModel  *model7 = [[WELookDetailModel alloc]init];
        model7.title  = @"喜欢的运动";
        model7.content = self.dic[@"fSport"];
        [self.dataSource addObject:model7];
        
        
        WELookDetailModel  *model8 = [[WELookDetailModel alloc]init];
        model8.title  = @"喜欢的食物";
        model8.content = self.dic[@"fFood"];
        [self.dataSource addObject:model8];
        
        
        WELookDetailModel  *model9 = [[WELookDetailModel alloc]init];
        model9.title  = @"喜欢的电影";
        model9.content =self.dic[@"fMovie"];
        [self.dataSource addObject:model9];
        
        
        
        WELookDetailModel  *model10 = [[WELookDetailModel alloc]init];
        model10.title  = @"喜欢的书和动漫";
        model10.content = self.dic[@"fBookCartoon"];
        [self.dataSource addObject:model10];
        
        WELookDetailModel  *model11 = [[WELookDetailModel alloc]init];
        model11.title  = @"去过的地方";
        model11.content =self.dic[@"visitedPlace"];
        [self.dataSource addObject:model11];

        
        
    } else if (self.type == vcTypeSelfInfo) {
        
        /**
         *  如果是查看本人资料的话
         */
        self.dic = [[XWUserModel getUserInfoFromlocal] mj_keyValues];
        WELookDetailModel  *model0 = [[WELookDetailModel alloc]init];
        model0.title  = @"真实姓名";
        model0.content = self.dic[@"realname"];
        [self.dataSource addObject:model0];
        
        WELookDetailModel  *model1 = [[WELookDetailModel alloc]init];
        model1.title  = @"行业";
        model1.content = self.dic[@"profession"];
        [self.dataSource addObject:model1];
        
        
        WELookDetailModel  *model2 = [[WELookDetailModel alloc]init];
        model2.title  = @"工作领域";
        model2.content = self.dic[@"job"];
        [self.dataSource addObject:model2];
        
        
        WELookDetailModel  *model3 = [[WELookDetailModel alloc]init];
        model3.title  = @"经常出没";
        model3.content = self.dic[@"regularPlace"];
        [self.dataSource addObject:model3];
        
        
        WELookDetailModel  *model4 = [[WELookDetailModel alloc]init];
        model4.title  = @"学历";
        model4.content = self.dic[@"educationBackground"];
        [self.dataSource addObject:model4];
        
        
        WELookDetailModel  *model5 = [[WELookDetailModel alloc]init];
        model5.title  = @"自我评价";
        model5.content = self.dic[@"selfEvaluation"];
        [self.dataSource addObject:model5];
        
        
        WELookDetailModel  *model6 = [[WELookDetailModel alloc]init];
        model6.title  = @"业余爱好";
        model6.content = self.dic[@"hobby"];
        [self.dataSource addObject:model6];
        
        
        WELookDetailModel  *model7 = [[WELookDetailModel alloc]init];
        model7.title  = @"喜欢的运动";
        model7.content = self.dic[@"fSport"];
        [self.dataSource addObject:model7];
        
        
        WELookDetailModel  *model8 = [[WELookDetailModel alloc]init];
        model8.title  = @"喜欢的食物";
        model8.content = self.dic[@"fFood"];
        [self.dataSource addObject:model8];
        
        
        WELookDetailModel  *model9 = [[WELookDetailModel alloc]init];
        model9.title  = @"喜欢的电影";
        model9.content =self.dic[@"fMovie"];
        [self.dataSource addObject:model9];
        
        
        
        WELookDetailModel  *model10 = [[WELookDetailModel alloc]init];
        model10.title  = @"喜欢的书和动漫";
        model10.content = self.dic[@"fBookCartoon"];
        [self.dataSource addObject:model10];
        
        WELookDetailModel  *model11 = [[WELookDetailModel alloc]init];
        model11.title  = @"去过的地方";
        model11.content =self.dic[@"visitedPlace"];
        [self.dataSource addObject:model11];
    }
    
    
    
}

- (void)starAnimation{
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:1.5 animations:^{
            self.headeView.pipeLable.transform = CGAffineTransformMakeScale(1.3, 1.3);
        } completion:^(BOOL finished) {
            [self endAnimation];
        }];
        
    });
    
    
}
- (void)endAnimation{
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:1.5 animations:^{
            self.headeView.pipeLable.transform = CGAffineTransformMakeScale(1.0, 1.0);
        } completion:^(BOOL finished) {
            [self starAnimation];
        }];
    });
}


- (void)configUserInterface{
    self.title = @"查看资料";

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"WELookDetailCell" bundle:nil] forCellReuseIdentifier:WELookDetailCellID];

    
    WELookDetailHeaderView *headeView = [WELookDetailHeaderView xw_loadFromNib];
    headeView.frame = CGRectMake(0, 0,KScreenWidth, 320);
    self.tableView.tableHeaderView = headeView;
    headeView.scolView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    headeView.delegate = self;
    self.headeView = headeView;
    [self starAnimation];
    
    
    WELookDetailFooterView *footer = [WELookDetailFooterView xw_loadFromNib];
    footer.frame = CGRectMake(0, 0, KScreenWidth, 200);
    footer.delegate = self;
    self.tableView.tableFooterView = footer;
    self.footer = footer;
    footer.oneLable.text = @"Ta的问题";
    if (self.type != vcTypeYourLike && self.type !=vcTypeYourMsg&&self.type!=vcTypeHome) {
        
        /**
         *  获取到问题
         */
        NSString *questionStr = _dic[@"myQuestion"];
        NSArray *dicAr = [questionStr componentsSeparatedByString:@"&"];
        NSMutableString *questionAr = [NSMutableString string];
        if (dicAr.count > 0) {
            for (int i = 0; i < dicAr.count; i ++) {
                [questionAr appendString:[NSString stringWithFormat:@"%d.%@.\n",i + 1,dicAr[i]]];
            }
        }
        //  1.如果没有XXXXXXXXXXXXXXXX.\n 2.如果没有XXXXXXXXXXXXXX?\n
        footer.twoLable.text = questionAr;
        
        NSMutableArray *imgUrlmAr = [NSMutableArray array];
        NSString *imageSrtring = _dic[@"imgFileNames"];
        NSArray *imageOriginalArray = [imageSrtring componentsSeparatedByString:@","];
        for (NSString *imgUrlStr in imageOriginalArray) {
            NSURL *imagURL =[NSURL URLWithString: [NSString stringWithFormat:@"%@/%@/%@",ImageURL,_dic[@"id"],imgUrlStr]];
            [imgUrlmAr addObject:imagURL];
        }

        
        headeView.scolView.imageURLStringsGroup = imgUrlmAr;
        
        
        
    }else{
       // 有人喜欢你进来的
        footer.twoLable.text = self.dic[@"myQuestion"];
        NSString *sex;
        if (self.dic[@"sex"] == 0) {
            sex = @"男";
        }else{
            sex = @"女";
        }
        headeView.ageLable.text = [NSString stringWithFormat:@"%@ %@",sex,self.dic[@"age"]];
        headeView.pipeLable.text = [NSString stringWithFormat:@"%@",self.dic[@"matchDegree"]];
        headeView.xinzuoLable.text  = self.dic[@"xingZuo"];
        headeView.heightLable.text = [NSString stringWithFormat:@"%@cm",self.dic[@"height"]];
        headeView.name.text = self.dic[@"realname"];
        headeView.adress.text = self.dic[@"city"];
        
        NSString *imageSrtring = self.dic[@"imgFileNames"];
        
        if (![imageSrtring isEqualToString:@""]) {
            
            NSArray *array = [imageSrtring componentsSeparatedByString:@","];
            NSMutableArray *arrM = [NSMutableArray array];
            
            NSString *arrrrr;
            for (NSString  * ss in array) {
                if (self.type == vcTypeYourMsg) {
                    
                    arrrrr =  [NSString stringWithFormat:@"%@/%@/%@",ImageURL,self.dic[@"recieverId"],ss];
                }else{
                    
                    arrrrr =  [NSString stringWithFormat:@"%@/%@/%@",ImageURL,self.dic[@"senderId"],ss];
                    
                }
                
                
                [arrM addObject:arrrrr];
                
            }
            
            
            headeView.scolView.imageURLStringsGroup = arrM;
            
            
        }

        
        
    }
    
    
    
    if (self.type == vcTypeYourLike) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.backgroundColor =KNaviBarTintColor;
        btn.titleLabel.font = KFont(15);
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        self.seleteBtn = btn;
        [self.view addSubview:self.seleteBtn];
        [self.seleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self.view);
            make.bottom.mas_equalTo(self.view.mas_bottom);
            make.height.mas_equalTo(44);
        }];
        
        NSString *time = [NSString stringWithFormat:@"%@",self.dic[@"recieverAnswerTime"]];
        
        NSDate *d = [[NSDate alloc]initWithTimeIntervalSince1970:[time longLongValue]/1000.0];
        
        NSDateFormatter *df = [[NSDateFormatter alloc] init];//格式化
        
        [df setDateFormat:@"yy-MM-dd HH:mm"];
        
        [df setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"] ];
        
        NSString * timeStr =[df stringFromDate:d];
        
        
        if ([timeStr  isEqualToString:@""]) {
        
            [btn setTitle:@"选Ta" forState:UIControlStateNormal];

        }else{
            [btn setTitle:@"提醒" forState:UIControlStateNormal];

        }
        
        [self createNavWithTitle:@"查看对我的回答" createMenuItem:^UIView *(int nIndex){
            if (nIndex == 0){
                UIButton *btn = NewBackButton(nil);
                [btn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
                return btn;
            }
            
            return nil;
        }];
        
        
        
        
    }else if(self.type ==vcTypeYourMsg){
        
        
        
        for (int i = 0; i < 2; i ++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            if ( i == 0) {
                [btn setTitle:@"查看回答" forState:UIControlStateNormal];
                
            }else{
                
                [btn setTitle:@"选TA" forState:UIControlStateNormal];

            }
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            btn.backgroundColor =KNaviBarTintColor;
            btn.titleLabel.font = KFont(15);
            btn.tag = i +1000;
            [btn addTarget:self action:@selector(huida:) forControlEvents:UIControlEventTouchUpInside];
            btn.frame = CGRectMake((KScreenWidth/2)*i,KScreenHeight-44,KScreenWidth/2,44);
            [self.view addSubview:btn];
            if (i ==0) {
                UIView *line = [[UIView alloc]init];
                line.backgroundColor = [UIColor whiteColor];
                line.frame  = CGRectMake((KScreenWidth/2)-1,0,1,44);
                [btn addSubview:line];
                
            }
            
            
        }
        
        [self createNavWithTitle:self.title createMenuItem:^UIView *(int nIndex){
            if (nIndex == 0){
                UIButton *btn = NewBackButton(nil);
                [btn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
                return btn;
            }
            
            return nil;
        }];
        
        
    }else{// 个人中心进来的

        [self createNavWithTitle:self.title createMenuItem:^UIView *(int nIndex){
            if (nIndex == 0){
                UIButton *btn = NewBackButton(nil);
                [btn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
                return btn;
            }
            else if (nIndex == 1){
                UIButton *btn = NewTextButton(@"编辑", [UIColor whiteColor]);
                [btn addTarget:self action:@selector(editAction) forControlEvents:UIControlEventTouchUpInside];
                return btn;
            }
            
            return nil;
        }];
    }
    
}

- (void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)editAction{
    WECompletInfoController *vc = [WECompletInfoController new];
    vc.isUserSetting = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark-- 选他或者提醒
- (void)btnClick:(UIButton *)sender{
    
    NSString *time = [NSString stringWithFormat:@"%@",self.dic[@"recieverAnswerTime"]];
    
    NSDate *d = [[NSDate alloc]initWithTimeIntervalSince1970:[time longLongValue]/1000.0];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];//格式化
    
    [df setDateFormat:@"yy-MM-dd HH:mm"];
    
    [df setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"] ];
    
    
    NSString * timeStr =[df stringFromDate:d];
    
#warning 调试的时候加个非
    if ([timeStr isEqualToString:@""]) {
        // 选他
        UIAlertView *aler = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"认定ta了么？确认后立即建立一对一联系" delegate:self cancelButtonTitle:@"再想想" otherButtonTitles:@"是的", nil];
        [aler show];
        self.aler = aler;
        
        
    }else{
        // 提醒
        [self showHudInView:self.view hint:nil];
        [WESomeOneLikeTool remindYourLikeWithID:self.dic[@"id"] success:^(id model) {
            [self hideHud];
            [self showHint:@"提醒成功"];
        } failed:^(NSString *error) {
            [self hideHud];
            [self showHint:error];
            
        }];
        
        
    }

}

#pragma mark -- 查看回答 或者选他
- (void)huida:(UIButton *)sender{
    if (sender.tag == 1000) {
        // 查看回答
        
        
    }else{
        
      //
        XWUserModel *models = [XWUserModel getUserInfoFromlocal];
        [self showHudInView:self.view hint:nil];
        [WEYourMessageTool buildRelationShipWithUserID:models.xw_id hisOrHerId:self.ID success:^(id model) {
            [self hideHud];
            [self showHint:@"建立关系成功"];
            
            [KUserDefaults setObject:self.ID forKey:KHisHerID];
            

            
            [self.navigationController popToRootViewControllerAnimated:YES];
            
            
            
            
            
            [KNotiCenter postNotificationName:KMarchSuccess object:nil];
            
        } failed:^(NSString *error) {
            [self hideHud];
            [self showHint:error];
        }];
        
        
      
        
        
    }
    
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    
    if (alertView ==self.aler) {
        
        if (buttonIndex == 1) {
            
            NSString *time = [NSString stringWithFormat:@"%@",self.dic[@"recieverAnswerTime"]];
            
            NSDate *d = [[NSDate alloc]initWithTimeIntervalSince1970:[time longLongValue]/1000.0];
            
            NSDateFormatter *df = [[NSDateFormatter alloc] init];//格式化
            [df setDateFormat:@"yy-MM-dd HH:mm"];
            [df setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"] ];
            NSString * timeStr =[df stringFromDate:d];
            // 选他 回答问题
#warning 调试的时候加个了飞
            if ([timeStr isEqualToString:@""]) {
                WESomeOneAnswerQuestionVC *VC = [[WESomeOneAnswerQuestionVC alloc]init];
                NSArray *array;
                if ([self.dic[@"myQuestion"] rangeOfString:@"&"].location!=NSNotFound) {
                    array = [self.dic[@"myQuestion"] componentsSeparatedByString:@"&"];
                    
                }else{
                    array = @[];
                }
                VC.ID = self.dic[@"id"];
                VC.questionArray = array;
                VC.infoDic = self.dic;
                [self.navigationController pushViewController:VC
                                                     animated:YES];
                
            }else{

                
            }
        
        }
    }else{
        
        if (buttonIndex == 1) {
            WECommetViewController *vc = [[WECommetViewController alloc
                                           ]init];
            vc.ID = self.ID;
            [self.navigationController pushViewController:vc animated:YES];
            
            
        }
        
    }
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WELookDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:WELookDetailCellID];
    WELookDetailModel *model = self.dataSource[indexPath.row];
    cell.oneLable.text = model.title;
    cell.twoLable.text = model.content;
    cell.delegate = self;
    
    if (self.type == vcTypeYourLike) {
        
        if (indexPath.row == 0) {
            
            cell.wenjuanBtn.hidden = NO;
            cell.pingjia.hidden = NO;
        }else{
            cell.wenjuanBtn.hidden = YES;
            cell.pingjia.hidden = YES;
        }

        
        
    }else if(self.type ==vcTypeYourMsg){
    
        if (indexPath.row == 0) {
            cell.wenjuanBtn.hidden = NO;
            cell.pingjia.hidden = NO;
        }else{
            cell.wenjuanBtn.hidden = YES;
            cell.pingjia.hidden = YES;
        }

    
    }else if(self.type == vcTypeHome){
        
        
        if (indexPath.row == 0) {
            
            cell.wenjuanBtn.hidden = NO;
            cell.pingjia.hidden = NO;
        }else{
            cell.wenjuanBtn.hidden = YES;
            cell.pingjia.hidden = YES;
        }

        
        
    }else{
        
        // 编辑界面
        cell.wenjuanBtn.hidden = YES;
        cell.pingjia.hidden = YES;
        if (indexPath.row == 0) {
            cell.wenjuanBtn.hidden = NO;
        }
    }

    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        return 90;
    }else{
        WELookDetailModel *model = self.dataSource[indexPath.row];
        
        return [model xw_cellHeight];
        
    }
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}




#pragma mark -- 展开的点击
- (void)didOpenBtn:(UIButton *)sender{
    WELookDetailFooterView *footer = [WELookDetailFooterView xw_loadFromNib];
    footer.frame = CGRectMake(0, 0, KScreenWidth, 200);
    footer.delegate = self;
    self.tableView.tableFooterView = footer;
    self.footer = footer;
    footer.oneLable.text = @"Ta的问题";
    footer.twoLable.text = @" 1.如果没有XXXXXXXXXXXXXXXX.\n 2.如果没有XXXXXXXXXXXXXX?\n 3.如果没有XXXXXXXXXXXXXX?\n 4.如果没有XXXXXXXXXXXXXX?\n";
    footer.openBtn.hidden = YES;
    
    if (self.type != vcTypeYourLike && self.type !=vcTypeYourMsg) {
        
        footer.twoLable.text = @" 1.如果没有XXXXXXXXXXXXXXXX.\n 2.如果没有XXXXXXXXXXXXXX?\n 3.如果没有XXXXXXXXXXXXXX?\n 4.如果没有XXXXXXXXXXXXXX?\n";
        
    }else{
        // 有人喜欢你进来的
        footer.twoLable.text = self.dic[@"myQuestion"];
    }
            
    
}

#pragma mark -- 查看问卷
- (void)didWenJuan{
    
    WEAskInfoController *vc = [[WEAskInfoController alloc]init];
    NSString *s = self.dic[@"mySurvey"];
    vc.type = WEAskInfoControllerTypeChangeInfo;
    vc.anserArray = [s componentsSeparatedByString:@"&"];
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark - 查看评价
- (void)didPingjia{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"查看评价需要花费50喜币，确认查看么？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定" , nil];
    [alert show];
}


@end
