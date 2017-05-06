//
//  WECompletInfoController.m
//  WB_wedding
//
//  Created by 谢威 on 17/1/17.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import "WECompletInfoController.h"
#import "PhotoPickerView.h"
#import "WEWriteInfoViewController.h"
#import "XWDatePickerView.h"
#import "XWPickerView.h"
#import "WEMYAskViewController.h"
#import "WEChooseCell.h"
#import "ImagePickerController.h"
#import "JKAlert.h"
#import "WESeletedController.h"
#import "QJCLLocationTool.h"
#import "STPickerArea.h"
#import "NSString+WETime.h"


@interface WECompletInfoController ()<UICollectionViewDataSource,
UICollectionViewDelegate,
WEChooseCellDelegate,
STPickerAreaDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *H;
@property (weak, nonatomic) IBOutlet UIView *picContenView;
@property (nonatomic,strong)PhotoPickerView   *piView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *height;
@property (nonatomic,strong)UICollectionView *collectionView ;
@property (nonatomic,strong)NSMutableArray  *dataSource; // 图片数组
@property (nonatomic, strong) NSMutableArray *imgUrls; // 图片url数组

@property (weak, nonatomic) IBOutlet UITextField *nickName;


@property (weak, nonatomic) IBOutlet UITextField *realname;


@property (weak, nonatomic) IBOutlet UIButton *sexBtn; // 0女1男

@property (weak, nonatomic) IBOutlet UIButton *birdayBtn;

@property (weak, nonatomic) IBOutlet UIButton *hangYeBtn; //行业
@property (weak, nonatomic) IBOutlet UIButton *lingYubtn; //领域

@property (weak, nonatomic) IBOutlet UIButton *comeBtn; //经常出没

@property (weak, nonatomic) IBOutlet UITextField *jingChangChuMoTextFile; //经常出没
@property (weak, nonatomic) IBOutlet UITextField *ziwoPingJiaTextFiled;
@property (weak, nonatomic) IBOutlet UIButton *hibbitBtn;

@property (weak, nonatomic) IBOutlet UIButton *sportsbtn;
@property (weak, nonatomic) IBOutlet UIButton *musicBtn;
@property (weak, nonatomic) IBOutlet UIButton *footBtn;
@property (weak, nonatomic) IBOutlet UIButton *movirBtn;
@property (weak, nonatomic) IBOutlet UIButton *dongManBtn;
@property (weak, nonatomic) IBOutlet UIButton *xueliBtn;
@property (weak, nonatomic) IBOutlet UIButton *yuLeiBtn; //娱乐休闲
@property (weak, nonatomic) IBOutlet UIButton *fumuOne;  //愿意和父母同住吗？
@property (weak, nonatomic) IBOutlet UIButton *fumuTwo; //父母情况
@property (weak, nonatomic) IBOutlet UIButton *ziwBtn; //自我评价
@property (weak, nonatomic) IBOutlet UIButton *salaryBtn; //薪水
@property (weak, nonatomic) IBOutlet UIButton *statureBtn; //身高
@property (weak, nonatomic) IBOutlet UIButton *myQuestionsBtn; //问题

@property (nonatomic, strong) QJCLLocationTool *locationTool;

@property (nonatomic, assign) BOOL isAllowPost; //是否允许post消息
@property (nonatomic, assign) BOOL isSuccess; //是否成功请求到内容


@end

@implementation WECompletInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"完善资料";
    self.H.constant = 120+20*60+100;
    self.height.constant = KScreenWidth/4;
    self.dataSource = [NSMutableArray array];
    self.imgUrls = [NSMutableArray array];
    if (self.isUserSetting) {
        self.userId = [XWUserModel getUserInfoFromlocal].xw_id;
    }
    /**
     如果是修改资料
     */
    if (self.isUserSetting) {
        //1.获取图片数组
        NSArray *originalImgUrlAr = [[XWUserModel getUserInfoFromlocal].imgFileNames componentsSeparatedByString:@","];
        
        if (originalImgUrlAr.count > 0) {
            self.dataSource = [NSMutableArray arrayWithArray:originalImgUrlAr];
            [self changeHeightOfCollectionView];
        }

        //2.添加资料
        XWUserModel *model = [XWUserModel getUserInfoFromlocal];
        _telPhone = model.telNumber;
        [_birdayBtn setTitle:[NSString rightTimeNoHourFromTimestamp:model.birthday] forState:UIControlStateNormal];
        [_comeBtn setTitle:model.city forState:UIControlStateNormal];
        [_xueliBtn setTitle:model.educationBackground forState:UIControlStateNormal];
        [_yuLeiBtn setTitle:model.entertainment forState:UIControlStateNormal];
        [_dongManBtn setTitle:model.fBookCartoon forState:UIControlStateNormal];
        [_footBtn setTitle:model.fFood forState:UIControlStateNormal];
        [_movirBtn setTitle:model.fMovie forState:UIControlStateNormal];
        [_sportsbtn setTitle:model.fSport forState:UIControlStateNormal];
        [_statureBtn setTitle:model.height forState:UIControlStateNormal];
        [_hibbitBtn setTitle:model.hobby forState:UIControlStateNormal];
        [_hangYeBtn setTitle:model.job forState:UIControlStateNormal];
        [_myQuestionsBtn setTitle:model.myQuestion forState:UIControlStateNormal];
        [_nickName setText:model.nickname];
        [_lingYubtn setTitle:model.profession forState:UIControlStateNormal];
        [_realname setText:model.realname];
        
        [_jingChangChuMoTextFile setText:model.regularPlace];
        [_salaryBtn setTitle:model.salary forState:UIControlStateNormal];
        [_ziwBtn setTitle:model.selfEvaluation forState:UIControlStateNormal];
        [_sexBtn setTitle:model.sex forState:UIControlStateNormal];
        [_musicBtn setTitle:model.visitedPlace forState:UIControlStateNormal];

        [_fumuOne setTitle:model.liveWithParent forState:UIControlStateNormal];
        [_fumuOne setTitle:model.parentSituation forState:UIControlStateNormal];

        
    } else { //注册资料

        
    }
    
    [self setNavigationRightBtnWithTitle:_isUserSetting?@"保存":@"下一步" selecterBack:@selector(nextStep)];
    [self configColelctionView];
}

#pragma mark - 下一步
- (void)nextStep {
    

    /**
     *  测试
     */
    //    WEWriteInfoViewController *vc = [WEWriteInfoViewController new];
    //    vc.telPhone = @"19190019728";
    //    [self.navigationController pushViewController:vc animated:YES];
    //    return;
    
    /**
     *  测试
     */
    [self saveInfo];

    

}



- (void)saveInfo {
    
    if ([self isCompleteInfo] == NO) return;
    
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
    [postDic setObject:_telPhone forKey:@"telNumber"];
    [postDic setObject:_birdayBtn.titleLabel.text forKey:@"birthday"];
    [postDic setObject:_comeBtn.titleLabel.text forKey:@"city"];
    [postDic setObject:_xueliBtn.titleLabel.text forKey:@"educationBackground"];
    [postDic setObject:_yuLeiBtn.titleLabel.text forKey:@"entertainment"];
    [postDic setObject:_dongManBtn.titleLabel.text forKey:@"fBookCartoon"];
    [postDic setObject:_footBtn.titleLabel.text forKey:@"fFood"];
    [postDic setObject:_movirBtn.titleLabel.text forKey:@"fMovie"];
    [postDic setObject:_sportsbtn.titleLabel.text forKey:@"fSport"];
    [postDic setObject:_statureBtn.titleLabel.text forKey:@"height"];
    [postDic setObject:_hibbitBtn.titleLabel.text forKey:@"hobby"];
    [postDic setObject:_hangYeBtn.titleLabel.text forKey:@"job"];
    [postDic setObject:@(self.locationTool.getLatitude) forKey:@"latitude"];
    [postDic setObject:@(self.locationTool.getLongitude) forKey:@"longitude"];
    [postDic setObject:_myQuestionsBtn.titleLabel.text forKey:@"myQuestion"];
    [postDic setObject:_nickName.text forKey:@"nickname"];
    [postDic setObject:_lingYubtn.titleLabel.text forKey:@"profession"];
    [postDic setObject:_realname.text forKey:@"realname"];
    [postDic setObject:_jingChangChuMoTextFile.text forKey:@"regularPlace"];
    [postDic setObject:_salaryBtn.titleLabel.text forKey:@"salary"];
    [postDic setObject:_ziwBtn.titleLabel.text forKey:@"selfEvaluation"];
    [postDic setObject:[_sexBtn.titleLabel.text isEqualToString:@"男"]?@"1":@"0" forKey:@"sex"];
    [postDic setObject:_musicBtn.titleLabel.text forKey:@"visitedPlace"];
    [postDic setObject:_fumuOne.titleLabel.text forKey:@"liveWithParent"];
    [postDic setObject:_fumuTwo.titleLabel.text forKey:@"parentSituation"]; //父母情况
    
    NSString *url = _isUserSetting ? BASEURL(@"/user/updatedoc"):BASEURL(@"/user/completedoc");
    [BANetManager ba_requestWithType:BAHttpRequestTypePost
                           urlString:url
                          parameters:postDic
                        successBlock:^(id response) {
                            NSLog(@"上传资料---->%@",response);
                            if ([response[@"success"] intValue] == 1) {
                                SVPSUCCESS(@"上传成功");
                                if (_isUserSetting) {
                                    
                                    
                                    
#warning 可以请求数据刷新好一些
                                    
                                    
                                    
                                    // 刷新下本地缓存
                                    XWUserModel *model = [XWUserModel getUserInfoFromlocal];
                                    model.telNumber = _telPhone;
                                    model.birthday = _birdayBtn.titleLabel.text;
                                    model.city = _comeBtn.titleLabel.text;
                                    model.educationBackground = _xueliBtn.titleLabel.text;
                                    model.entertainment = _yuLeiBtn.titleLabel.text;
                                    model.fBookCartoon = _dongManBtn.titleLabel.text;
                                    model.fFood = _footBtn.titleLabel.text;
                                    model.fMovie = _movirBtn.titleLabel.text;
                                    model.fSport = _sportsbtn.titleLabel.text;
                                    model.height = _statureBtn.titleLabel.text;
                                    model.job = _hangYeBtn.titleLabel.text;
                                    model.myQuestion = _myQuestionsBtn.titleLabel.text;
                                    model.nickname = _nickName.text;
                                    model.profession = _lingYubtn.titleLabel.text;
                                    model.realname = _realname.text;
                                    model.regularPlace = _jingChangChuMoTextFile.text;
                                    model.salary = _salaryBtn.titleLabel.text;
                                    model.selfEvaluation = _ziwBtn.titleLabel.text;
                                    model.sex = [_sexBtn.titleLabel.text isEqualToString:@"男"]?@"1":@"0";
                                    model.visitedPlace = _musicBtn.titleLabel.text;
                                    model.liveWithParent = _fumuOne.titleLabel.text;
                                    model.parentSituation = _fumuTwo.titleLabel.text;
                                    
                                    
                                    [model saveUserInfo] ? [self.navigationController popViewControllerAnimated:YES] : nil;
                                    
                                    
                                } else {
                                    WEWriteInfoViewController *vc = [WEWriteInfoViewController new];
                                    vc.telPhone = self.telPhone;
                                    [self.navigationController pushViewController:vc animated:YES];

                                }
                                
                            } else{
                                
                                SVPERROR(response[@"msg"]);
                            }
                        }
                        failureBlock:^(NSError *error) {
                            
                        }
                            progress:nil];
}

#pragma mark - 判断是否填写完整
- (BOOL)isCompleteInfo {
    
    if (_realname.text.length < 1) {
        SVPERROR(@"真实姓名未填写");
        return NO;
    }
    if (_sexBtn.titleLabel.text.length < 1 ) {
        SVPERROR(@"性别未选择");
        return NO;
    }
    if (_birdayBtn.titleLabel.text.length < 1) {
        SVPERROR(@"生日未选择");
        return NO;
    }
    if (_hangYeBtn.titleLabel.text.length < 1) {
        SVPERROR(@"行业未选择");
        return NO;
    }
    if (_comeBtn.titleLabel.text.length < 1) {
        SVPERROR(@"你来自哪里");
        return NO;
    }
    if (_statureBtn.titleLabel.text.length < 1) {
        SVPERROR(@"身高未选择");
        return NO;
    }
    if (_salaryBtn.titleLabel.text.length < 1) {
        SVPERROR(@"你一个月赚多少钱");
        return NO;
    }
    if (_ziwBtn.titleLabel.text.length < 1) {
        SVPERROR(@"做个自我评价吧");
        return NO;
    }
    if (_xueliBtn.titleLabel.text.length < 1) {
        SVPERROR(@"学历未选择");
        return NO;
    }
    if (_myQuestionsBtn.titleLabel.text.length < 1) {
        SVPERROR(@"给未来的Ta提几个问题吧");
        return NO;
    }
    return YES;
}

- (void)configColelctionView{
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    CGFloat W = KScreenWidth/4;
    layout.itemSize = CGSizeMake(W-5,W-5);
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 5;
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0,KScreenWidth,CGRectGetHeight(self.picContenView.frame)) collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor clearColor];
    
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"WEChooseCell" bundle:nil] forCellWithReuseIdentifier:WEChooseCellID];
    [self.picContenView addSubview:_collectionView];
    
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.dataSource.count+1;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    WEChooseCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:
                         WEChooseCellID forIndexPath:indexPath];
    cell.delegate = self;
    cell.indexPath = indexPath;
    
    if (self.dataSource.count==0) {
        cell.iamgeView.image = [UIImage imageNamed:@"xw_post"];
        cell.cancleBtn.hidden = YES;
        
    }else{
        if (indexPath.row == self.dataSource.count) {
            cell.iamgeView.image = [UIImage imageNamed:@"xw_post"];
            cell.cancleBtn.hidden = YES;
        }else{
//            cell.iamgeView.image = self.dataSource[indexPath.row];
            NSURL *imagURL =[NSURL URLWithString: [NSString stringWithFormat:@"%@/%@/%@",ImageURL,self.userId,self.dataSource[indexPath.item]]];
            [cell.iamgeView sd_setImageWithURL:imagURL placeholderImage:[UIImage imageNamed:@"baby"]];
            cell.cancleBtn.hidden = NO;
        }
    }
    return cell;
    
}


#pragma mark 改变头像高度

- (void)changeHeightOfCollectionView {
    
    if (self.dataSource.count >= 4 && self.dataSource.count <=7) {
        
        self.height.constant =170;
        self.collectionView.frame = CGRectMake(0, 0,KScreenWidth,170);
        [UIView animateWithDuration:0.3 animations:^{
            [self.view layoutIfNeeded];
        }];
        
    }else if (self.dataSource.count >= 8){
        
        
        self.height.constant =260;
        self.collectionView.frame = CGRectMake(0, 0,KScreenWidth,260);
        [UIView animateWithDuration:0.3 animations:^{
            [self.view layoutIfNeeded];
        }];
        
    } else if (self.dataSource.count <= 3){
        
        self.height.constant =80;
        self.collectionView.frame = CGRectMake(0, 0,KScreenWidth,260);
        [UIView animateWithDuration:0.3 animations:^{
            [self.view layoutIfNeeded];
        }];
        
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.dataSource.count >=9) {
        [self showMessage:@"最多9张" toView:self.view];
        return;
    }
 
    JKAlert *aler = [[JKAlert alloc]initWithTitle:@"提示" andMessage:@"选择" style:STYLE_ACTION_SHEET];
    
    [aler addButton:ITEM_OK withTitle:@"从相册选择" handler:^(JKAlertItem *item) {
        ImagePickerController *imageVC1 = [[ImagePickerController alloc]init];
        imageVC1.allowsEditing = YES;

        [imageVC1 cameraSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum onFinishingBlock:^(UIImagePickerController *picker, NSDictionary *info, UIImage *originalImage, UIImage *editedImage) {
            
            // 1.上传头像
            [BANetManager ba_uploadImageWithUrlString:BASEURL(@"/user/uploadimg")
                                           parameters:@{@"userId":self.userId,
                                                        @"oldFileName":@0}
                                           imageArray:@[editedImage]
                                             fileName:@"file"
                                         successBlock:^(id response) {
                                             if ([response[@"success"] boolValue]) {
                                                 
                                                 SVPSUCCESS(@"上传成功");
                                                 
                                                 // 2.改变数组
                                                 [self.dataSource addObject:response[@"data"]];
                                                 [self.collectionView reloadData];
                                                 
                                                 // 3.改变头像高度
                                                 [self changeHeightOfCollectionView];
                                             } else {
                                                 SVPERROR(response[@"msg"]);
                                             }
                                         }
                                          failurBlock:^(NSError *error) {
                                              SVPERROR(@"上传失败");
                                          }
                                       upLoadProgress:^(int64_t bytesProgress, int64_t totalBytesProgress) {
                                           [SVProgressHUD showProgress:bytesProgress/totalBytesProgress status:@"正在上传中"];
                                       }];

        } onCancelingBlock:^{

        }];
        [self presentViewController:imageVC1 animated:YES completion:nil];
        
    }];
    
    [aler addButton:ITEM_OK withTitle:@"拍照" handler:^(JKAlertItem *item) {
        
        ImagePickerController *imageVC2222 = [[ImagePickerController alloc]init];
        imageVC2222.allowsEditing = YES;
        [imageVC2222 cameraSourceType:UIImagePickerControllerSourceTypeCamera onFinishingBlock:^(UIImagePickerController *picker, NSDictionary *info, UIImage *originalImage, UIImage *editedImage) {
//            [self.dataSource addObject:editedImage];
//            [self.collectionView reloadData];
//            
//            [self changeHeightOfCollectionView];
            // 1.上传头像
            [BANetManager ba_uploadImageWithUrlString:BASEURL(@"/user/uploadimg")
                                           parameters:@{@"userId":self.userId,
                                                        @"oldFileName":@0}
                                           imageArray:@[editedImage]
                                             fileName:@"file"
                                         successBlock:^(id response) {
                                             if ([response[@"success"] boolValue]) {
                                                 
                                                 SVPSUCCESS(@"上传成功");
                                                 
                                                 // 2.改变数组
                                                 [self.dataSource addObject:response[@"data"]];
                                                 [self.collectionView reloadData];
                                                 
                                                 // 3.改变头像高度
                                                 [self changeHeightOfCollectionView];
                                             } else {
                                                 SVPERROR(response[@"msg"]);
                                             }
                                         }
                                          failurBlock:^(NSError *error) {
                                              SVPERROR(@"上传失败");
                                          }
                                       upLoadProgress:^(int64_t bytesProgress, int64_t totalBytesProgress) {
                                           [SVProgressHUD showProgress:bytesProgress/totalBytesProgress status:@"正在上传中"];
                                       }];

         
            
        } onCancelingBlock:^{
            
        }];
        [self presentViewController:imageVC2222 animated:YES completion:nil];
        
        
    }];
    
    
    [aler addButton:ITEM_CANCEL withTitle:@"取消" handler:^(JKAlertItem *item) {
        
    }];
    [aler show];
    
    
    
}

#pragma mark -- 删除
- (void)didDeleteIndex:(NSIndexPath *)index{

    [BANetManager ba_requestWithType:BAHttpRequestTypePost
                           urlString:BASEURL(@"/user/deleteimg")
                          parameters:@{@"userId":self.userId,
                                       @"oldFileName":self.dataSource[index.item]}
                        successBlock:^(id response) {
                            
                            if ([response[@"success"] boolValue]) {
                                SVPSUCCESS(@"删除成功");
                                
                                [self.dataSource removeObjectAtIndex:index.row];
                                [self.collectionView reloadData];
                                [self changeHeightOfCollectionView];
                                
                            } else {
                                SVPERROR(response[@"msg"]);
                            }
                        } failureBlock:^(NSError *error) {
                            
                        }
                            progress:nil];
    
    
    
}


// 性别
- (IBAction)sexClick:(UIButton *)sender {
    
   XWPickerView *view = [[XWPickerView alloc]initWithCallBack:^(NSString *seletedString) {
       [self.sexBtn setTitle:seletedString forState:UIControlStateNormal];
   } WithDataSource:@[@"男",@"女"]];
    [view show];
}

// 生日
- (IBAction)birsdayClick:(id)sender {
    
    XWDatePickerView *picer = [[XWDatePickerView alloc]initWithCallBack:^(NSString *date) {
        [self.birdayBtn setTitle:date forState:UIControlStateNormal];
        
    }];
    [picer show];
}

// 身高
- (IBAction)statureClick:(UIButton *)sender {
    
    NSMutableArray *heightAr = [NSMutableArray array];
    for (int i = 220; i > 120; i --) {
        [heightAr addObject:[NSString stringWithFormat:@"%d",i]];
    }
    XWPickerView *view = [[XWPickerView alloc]initWithCallBack:^(NSString *seletedString) {
        [sender setTitle:seletedString forState:UIControlStateNormal];
    } WithDataSource:heightAr];
    [view show];
}

// 薪水
- (IBAction)salaryClick:(UIButton *)sender {
    
    NSString *ar = @"0-4999,5000-9999,10000-19999,20000-29999,30000+";
    NSArray *dataAr = [ar componentsSeparatedByString:@","];
    XWPickerView *view = [[XWPickerView alloc]initWithCallBack:^(NSString *seletedString) {
        [sender setTitle:seletedString forState:UIControlStateNormal];
    } WithDataSource:dataAr];
    [view show];
}

// 行业
- (IBAction)hangYeClick:(id)sender {
    NSArray *data = @[
                      @"计算机（软件、硬件、服务）",
                      @"通信",
                      @"电信",
                      @"互联网",
                      @"电子（半导体、仪器、自动化）",
                      @"金融服务（会计/审计、银行、保险）",
                      @"金融/投资/证券",
                      @"贸易（进出口、批发、零售）",
                      @"快速消费品（食品、饮料、化妆品)",
                      @"服装/纺织/皮革",
                      @"家具/家电/工艺品/玩具",
                      @"办工用品及设备",
                      @"医疗/医药",
                      @"广告/公关/市场推广/会展",
                      @"影视/媒体/出版/印刷/包装",
                      @"房地产相关",
                       @"家具/室内设计/装潢",
                       @"服务（咨询、人力资源）",
                       @"法律相关",
                       @"教育/培训",
                       @"学术/科研",
                         @"学术/科研",
                         @"酒店/餐饮业",
                         @"旅游",
                         @"娱乐/体闲/体育",
                         @"美容/保健",
                         @"交通（运输、物流、航空、航天）汽车及零配件",
                         @"美容/保健",
                         @"农业、政府/非盈利机构",
                      @"其它行业"
                      ];
    
    WESeletedController *vc = [[WESeletedController alloc]initWithDataSource:data title:@"选择行业" type:@"" maxCount:0 back:^(NSString *s) {
      [self.hangYeBtn setTitle:s forState:UIControlStateNormal];
  } originalString:self.hangYeBtn.titleLabel.text];
    [self.navigationController pushViewController:vc animated:YES];
    
}

// 运动
- (IBAction)sportClick:(id)sender {
    NSString *s  = @"单车、乒乓球、羽毛球、游泳、跑步、瑜伽、篮球、足球、壁球、排球、棒球、橄榄球、自行车、摩托车、空手道、体操、航海、柔道、潜水、滑板、滑雪、滑冰、武术、钓鱼、水上运动、健身、汽车、网球、高尔夫、台球、舞蹈、街舞、健身房、射箭、击剑、射击、拳击、跆拳道、爬山、骑马、郊游、暴走、睡觉";
    NSArray *data = [s componentsSeparatedByString:@"、"];
    
    WESeletedController *vc = [[WESeletedController alloc]initWithDataSource:data title:@"喜欢的运动"  type:@"all" maxCount:0  back:^(NSString *s) {
        [self.sportsbtn setTitle:s forState:UIControlStateNormal];
    } originalString:self.sportsbtn.titleLabel.text];
    [self.navigationController pushViewController:vc animated:YES];

    

}

#pragma mark - 我的提问
// 提问
- (IBAction)askClick:(id)sender {
    WEMYAskViewController *vc = [[WEMYAskViewController alloc]init];
    vc.questionStr = self.myQuestionsBtn.titleLabel.text;
    vc.blockAskBlock = ^(NSString *retureStr){
        [self.myQuestionsBtn setTitle:retureStr forState:UIControlStateNormal];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

// 动漫
- (IBAction)dongManBtnClick:(UIButton *)sender {
    
    NSString *s  = @"纳兰容若、王阳明、白落梅、三毛、张爱玲、金庸、古龙、鲁迅、韩寒、郭敬明、王朔、王小波、琼瑶、亦舒、几米、村上春树、米兰。昆德拉、海贼王、火影忍者、灌篮高手、哆啦A梦、名侦探柯南、七龙珠、进击的巨人、新世纪福音战士、棋魂、樱桃小丸子、宠物小精灵、蜡笔小新、Hello Kitty、美少女战士、圣斗士星矢、幽游白书、乱马1/2、城市猎人、金田一少年事件簿、天使禁猎区、喜羊羊与灰太狼、妖精的尾巴、黑子的篮球、美食的俘虏、死神、网球王子";
    NSArray *data = [s componentsSeparatedByString:@"、"];
    
    WESeletedController *vc = [[WESeletedController alloc]initWithDataSource:data title:@"喜欢的书和动漫"  type:@"all" maxCount:0 back:^(NSString *s) {
        [self.dongManBtn setTitle:s forState:UIControlStateNormal];
    } originalString:self.dongManBtn.titleLabel.text];
    [self.navigationController pushViewController:vc animated:YES];
}

// 电影
- (IBAction)movieBtnClick:(UIButton *)sender {
    
    NSString *s  = @"泰坦尼克号、当幸福来敲门、纵横四海、机械师、北京遇上西雅图、忠犬八公的故事、罗马假日、肖申克的救赎、霸王别姬、这个杀手不太冷、教父、阿甘正传、盗梦空间、黑客帝国、蝙蝠侠、低俗小说、搏击俱乐部、海上钢琴师、触不可及、千与千寻、乱世佳人、辛德勒的名单、天使爱美丽、两杆大烟枪、飞越疯人院、闻香识女人、死亡诗社、美丽心灵、魔戒三部曲、狮子王、哈利波特、机器人总动员、英雄本色、赌神、无间道、大话西游、喜剧之王、东邪西毒、倩女幽魂、中国合伙人、阳光灿烂的日子、那些年，我们一起追的女孩、老男孩、功夫熊猫、我的野蛮女友、初恋这件小事、重庆森林、春光乍泄、情书、偷拐抢骗、杀死比尔、被解救的姜戈、沉默的羔羊、心灵捕手、日落大道、美国往事、上帝之城、大鱼、雨人、角斗士、穆赫兰道、X战警、终结者、变形金刚、星球大战、源代码、美丽人生、放牛班的春天、剪刀手爱德华、天堂电影院、燃情岁月、记忆碎片、撞车、第九区、傲慢与偏见、两小无猜、猩球崛起、小时代";
    NSArray *data = [s componentsSeparatedByString:@"、"];
    
    WESeletedController *vc = [[WESeletedController alloc]initWithDataSource:data title:@"喜欢的电影"  type:@"all" maxCount:0 back:^(NSString *s) {
        [self.movirBtn setTitle:s forState:UIControlStateNormal];
    } originalString:self.movirBtn.titleLabel.text];
    [self.navigationController pushViewController:vc animated:YES];
    
}

// 食物
- (IBAction)footbtnClick:(UIButton *)sender {
    
    NSString *s  = @"北京烤鸭、火锅、麻辣香锅、泰国菜、法国菜、意大利菜、日式料理、牛排、港式茶餐厅、烧烤、烤鱼、冒菜、川菜、素食、越南菜、娘惹菜、生煎包、卤肉饭、石锅拌饭、韩式烤肉、墨西哥Tacos、披萨、汉堡、薯条、美式炸鸡、土耳其烤肉、甜点蛋糕、奶酪芝士、巧克力、冰激凌";
    NSArray *data = [s componentsSeparatedByString:@"、"];
    
    WESeletedController *vc = [[WESeletedController alloc]initWithDataSource:data title:@"喜欢的食物"  type:@"all" maxCount:0 back:^(NSString *s) {
        [self.footBtn setTitle:s forState:UIControlStateNormal];
    } originalString:self.footBtn.titleLabel.text];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - 经常出没
// 去过的地方
- (IBAction)muscibtnClick:(id)sender {
    
    NSString *s  = @"美国、德国、奥地利、匈牙利、马来西亚、泰国、迪拜、法国、希腊、意大利、瑞士、捷克、成都、桂林、三亚、丽江、大理、香格里拉、西藏、鼓浪屿、张家界、九寨沟、台湾、日本、韩国、巴厘岛、塞班岛、新加坡、印度、越南、朝鲜、尼泊尔、土耳其、加拿大、澳大利亚、英国、西班牙、葡萄牙、芬兰、荷兰、比利时、瑞典、丹麦、古巴、阿根廷、巴西、新西兰、俄罗斯、埃及、柬埔寨、老挝、伊朗、菲律宾、缅甸、墨西哥、帕劳、大溪地、夏威夷、关岛、马尔代夫、毛里求斯、斯里兰卡、智利、冰岛、挪威、斐济、非洲";
    NSArray *data = [s componentsSeparatedByString:@"、"];
    
    WESeletedController *vc = [[WESeletedController alloc]initWithDataSource:data title:@"去过的地方"  type:@"all" maxCount:0 back:^(NSString *s) {
        [self.musicBtn setTitle:s forState:UIControlStateNormal];
    } originalString:self.musicBtn.titleLabel.text];
    [self.navigationController pushViewController:vc animated:YES];
    
    
}

// 业余爱好
- (IBAction)habbitClick:(id)sender {
    
    NSString *s  = @"诗词歌赋、茶艺、插花、国学、文学、哲学、禅宗、音乐、交际、收藏、运动、跑酷、天文、地理、政治、航海、汽车、飞机、军事、投资、摄影、美术、模型、小说、动漫、写作、书法、表演、烘培、陶艺、阅读、手工制作、游戏、乐器";
    NSArray *data = [s componentsSeparatedByString:@"、"];

    WESeletedController *vc = [[WESeletedController alloc]initWithDataSource:data title:@"兴趣爱好"  type:@"all" maxCount:0 back:^(NSString *s) {
        [self.hibbitBtn setTitle:s forState:UIControlStateNormal];
    } originalString:self.hibbitBtn.titleLabel.text];
    [self.navigationController pushViewController:vc animated:YES];

    
}
// 自我评价
- (IBAction)selfPingjia:(id)sender {
    
    
}

#pragma mark --- 来自
// 来自
- (IBAction)conmForm:(id)sender {
    
    STPickerArea *picker = [[STPickerArea alloc] initWithDelegate:self];
    [picker show];
}
// 领域
- (IBAction)lingyueBtnclick:(id)sender {
    
    NSArray *data = @[
                      @"创始人",
                      @"投资人",
                      @"职业经理人",
                      @"咨询顾问",
                      @"服务业",
                      @"演艺/艺术/音乐人",
                      @"运营/市场/销售",
                      @"产品",
                      @"客服",
                      @"商务/公关",
                      @"行政/管理/人事",
                      @"财务/会计/出纳",
                      @"工程师/技术",
                      @"律师",
                      @"教师",
                      @"翻译",
                      @"警察/公务员",
                      @"科研人员",
                      @"医护人员",
                      @"导演/摄影/摄像师",
                      @"主持人/司仪",
                      @"化妆/造型",
                      @"编辑/设计/文字工作者",
                      @"记者",
                      @"店长/店员/服务员",
                      @"自由职业者",
                      @"企业家/私营业主",
                      @"采购",
                      @"航空/航天/航海",
                      @"餐饮/旅游",
                      @"运动员/教练",
                      @"其他"
                      
                      ];
    
    WESeletedController *vc = [[WESeletedController alloc]initWithDataSource:data title:@"选择工作"  type:@"" maxCount:0 back:^(NSString *s) {
        [self.lingYubtn setTitle:s forState:UIControlStateNormal];
    } originalString:self.lingYubtn.titleLabel.text];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (IBAction)xueliBtnClick:(id)sender {
    XWPickerView *view = [[XWPickerView alloc]initWithCallBack:^(NSString *seletedString) {
        [self.xueliBtn setTitle:seletedString forState:UIControlStateNormal];
        
    } WithDataSource:@[@"初中",@"高中",@"大专",@"本科",@"硕士",@"博士",@"博士后",@"教授"]];
    [view show];

}


- (IBAction)yuLeiBtnClick:(id)sender {
    
    
    NSString *s  = @"酒吧、水吧、清吧、茶室、台球室、电影院、洗浴、足浴、保健按摩、健身房、咖啡厅、图书馆、美术馆、话剧社、家具城、商场、游泳馆、瑜珈馆、美食城、KTV、公园、棋牌、书屋、养生会馆、温泉";
    NSArray *data = [s componentsSeparatedByString:@"、"];
    
    WESeletedController *vc = [[WESeletedController alloc]initWithDataSource:data title:@"娱乐休闲"  type:@"all" maxCount:0 back:^(NSString *s) {
        [self.yuLeiBtn setTitle:s forState:UIControlStateNormal];
    } originalString:self.yuLeiBtn.titleLabel.text];
    [self.navigationController pushViewController:vc animated:YES];

}


- (IBAction)fumuOneClick:(id)sender {
    XWPickerView *view = [[XWPickerView alloc]initWithCallBack:^(NSString *seletedString) {
        [self.fumuOne setTitle:seletedString forState:UIControlStateNormal];
        
    } WithDataSource:@[@"愿意",@"不愿意",@"视情况而定"]];
    [view show];
    

}


- (IBAction)fumuTwoClick:(id)sender {
    XWPickerView *view = [[XWPickerView alloc]initWithCallBack:^(NSString *seletedString) {
        [self.fumuTwo setTitle:seletedString forState:UIControlStateNormal];
        
    } WithDataSource:@[@"父母健在",@"单亲家庭",@"父亲健在",@"母亲健在",@"父母均离世"]];
    [view show];
    

}

#pragma mark ---- 自我评价
- (IBAction)ziwoBtnClicj:(id)sender {
    
    
    
    NSString *s  = @"聪慧善良、善解人意、浪漫风趣、诚信温和、务实能干、成熟稳重、开朗活泼、热心正义";
    NSArray *data = [s componentsSeparatedByString:@"、"];
    
    WESeletedController *vc = [[WESeletedController alloc]initWithDataSource:data title:@"自我评价"  type:@"all" maxCount:3 back:^(NSString *s) {
        [self.ziwBtn setTitle:s forState:UIControlStateNormal];
    } originalString:self.ziwBtn.titleLabel.text];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - delegate
- (void)pickerArea:(STPickerArea *)pickerArea province:(NSString *)province city:(NSString *)city area:(NSString *)area {
    
    [self.comeBtn setTitle:city forState:UIControlStateNormal];
}

- (QJCLLocationTool *)locationTool {
    
    if (!_locationTool) {
        _locationTool = [QJCLLocationTool locationTool];
    }
    return _locationTool;
}

@end
