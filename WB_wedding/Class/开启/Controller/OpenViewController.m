//
//  OpenViewController.m
//  WB_wedding
//
//  Created by 谢威 on 17/1/9.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import "OpenViewController.h"
#import "CardLayout.h"
#import "CardSelectedLayout.h"
#import "JLDragCardView.h"
#import "WESomeOneAnswerQuestionVC.h"
#import "CardCellCollectionViewCell.h"
#import "WESomeOneAnswerQuestionVC.h"
#import "WELookDetailViewController.h"
#import "OpenLikeAnswerVC.h"

#import "WEMarchTool.h"

#define RGBAColor(r,g,b,a)  [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define RGBColor(r,g,b)     RGBAColor(r,g,b,1.0)
#define RGBColorC(c)        RGBColor((((int)c) >> 16),((((int)c) >> 8) & 0xff),(((int)c) & 0xff))




#define ACTION_MARGIN_RIGHT lengthFit(150)
#define ACTION_MARGIN_LEFT lengthFit(150)
#define ACTION_VELOCITY 400
#define SCALE_STRENGTH 4
#define SCALE_MAX .93
#define ROTATION_MAX 1
#define ROTATION_STRENGTH lengthFit(414)

#define BUTTON_WIDTH lengthFit(40)
@interface OpenViewController ()<CardLayoutDelegate,iCarouselDataSource, iCarouselDelegate>{
CGFloat xFromCenter;
CGFloat yFromCenter;
}

//@property(nonatomic, strong)UICollectionView* cardCollectionView;
//@property(nonatomic, strong)UICollectionViewLayout* cardLayout;
//@property(nonatomic, strong)UICollectionViewLayout* cardLayoutStyle1;
//@property(nonatomic, strong)UICollectionViewLayout* cardLayoutStyle2;
//@property(nonatomic, strong)UITapGestureRecognizer* tapGesCollectionView;

@property (nonatomic,strong)UIButton  *likeBtn;
@property (nonatomic,strong)UIButton  *moreBtn;
@property (nonatomic,assign)BOOL        isAnimation;

@property (nonatomic,strong)NSMutableArray  *dataSource;


@property (nonatomic, strong) iCarousel *carousel;

@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, strong) NSMutableArray *cellArray;
@property (nonatomic,assign)CGRect      oringFrame;
@property (nonatomic,assign)CGFloat     origX;

@property (nonatomic,assign)BOOL        isNO;
/**
 *  所有的图片
 */
@property (nonatomic,strong)NSMutableArray      *allPicArray;
/**
 *  记录现在的张数
 */
@property (nonatomic,assign)NSInteger       number;

/**
 *  记录现在的页数
 */
@property (nonatomic,assign)NSInteger       page;

@end

@implementation OpenViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"完美人生";
    self.view.backgroundColor = [UIColor whiteColor];
    self.dataSource = [NSMutableArray array];
    self.items = [NSMutableArray array];
    self.cellArray = [NSMutableArray array];
    self.allPicArray = [NSMutableArray array];
     self.page = 1;
//    [self.items addObject:@"baby"];
//    [self.items addObject:@"bg"];
//    [self.items addObject:@"test"];
//    [self.items addObject:@"3"];
//    [self.items addObject:@"3"];
    
    XWUserModel *model = [XWUserModel getUserInfoFromlocal];
    
  
    
    
    NSArray *array = [WEHomeCacheTool readAllInfo];
      NSLog(@"===========总共 %ld 张",array.count);
    
    if (array.count == 0 ) {
        [WEMarchTool marchPersonWithID:[XWUserModel getUserInfoFromlocal].xw_id  page:@"1" size:@"15" success:^(NSArray *modelss) {
            @try {
                
                if ([model isVip]){
                    // vip 5张
                    [self.items addObject:modelss[0]];
                    [self.items addObject:modelss[1]];
                    [self.items addObject:modelss[2]];
                    [self.items addObject:modelss[3]];
                    [self.items addObject:modelss[4]];
                    self.number = 4;
                    
                }else{
                    
                    [self.items addObject:modelss[0]];
                    [self.items addObject:modelss[1]];
                    [self.items addObject:modelss[2]];
                    self.number = 2;
                    
                }
                //            [self.carousel reloadData];
                [self.allPicArray addObjectsFromArray:modelss];
                
                [self configCarousel];
                
                self.oringFrame = _carousel.currentItemView.frame;
                self.origX = _carousel.currentItemView.frame.origin.x;
                
            } @catch (NSException *exception) {
                
                
                
            }
            
            

            
            
        } failed:^(NSString *error) {
            
            
        }];
        
    }else{
        
        if ([model isVip]) {
            if (array.count>5) {
                // vip 5张
                [self.items addObject:array[0]];
                [self.items addObject:array[1]];
                [self.items addObject:array[2]];
                [self.items addObject:array[3]];
                [self.items addObject:array[4]];
                
            }else{
                // 不足5张了 就去请求
                
                
            }
             self.number = 4;
            
        }else{
            if (array.count>3) {

            [self.items addObject:array[0]];
            [self.items addObject:array[1]];
            [self.items addObject:array[2]];
        
        }else{
            // 不足3张就去请求
            [self getData];
            
                
            }
             self.number = 2;
            
        }
        
        [self.allPicArray addObjectsFromArray:array];
        [self configCarousel];
        self.oringFrame = _carousel.currentItemView.frame;
        self.origX = _carousel.currentItemView.frame.origin.x;

        
    }

      UIPanGestureRecognizer *pans = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panges:)];
    [self.view addGestureRecognizer:pans];
    
}

#pragma mark -- 请求数据
- (void)getData{
    
    XWUserModel *model = [XWUserModel getUserInfoFromlocal];
    
    // 获取首页的总张数
    NSString *allCount = [KUserDefaults objectForKey:KHomeSize];
    
    NSInteger page;
    NSInteger cachePage = 1;
    if ([KUserDefaults objectForKey:@"KPage"]) {
        cachePage = [[KUserDefaults objectForKey:@"KPage"] integerValue];
    }
    
    if ([allCount integerValue]<=15) {
        // 小于15张 就永远只有一页
        page = 1;
    }
    else if([allCount integerValue]>15 && (15 *cachePage)<=[allCount integerValue]){
        
        page = cachePage + 1;
        
        
    }else if ((15 *cachePage)>[allCount integerValue]){
        
        page = 1;
        
    }
//    [self.allPicArray removeAllObjects];
    [self showActivity];
    [KUserDefaults setObject:[NSString stringWithFormat:@"%ld",page] forKey:@"KPage"];
    [WEMarchTool marchPersonWithID:[XWUserModel getUserInfoFromlocal].xw_id  page:[NSString stringWithFormat:@"%ld",page] size:@"15" success:^(NSArray *modelss) {
      
        if ([model.userRight isEqualToString:@"1"]){
            
            // vip 5张
//            [self.items addObject:modelss[0]];
//            [self.items addObject:modelss[1]];
//            [self.items addObject:modelss[2]];
//            [self.items addObject:modelss[3]];
//            [self.items addObject:modelss[4]];
            self.number = 4;
            
        }else{
            
//            [self.items addObject:modelss[0]];
//            [self.items addObject:modelss[1]];
//            [self.items addObject:modelss[2]];
            self.number = 2;
            
        }
        
          [self cancleActivity];
        [self.carousel reloadData];
        [self.allPicArray addObjectsFromArray:modelss];
        
        
    } failed:^(NSString *error) {
        [self cancleActivity];
        [self showMessage:error toView:self.view];
        
    }];
    
    
}

- (void)panges:(UIPanGestureRecognizer *)panssss{
    
    CGPoint current = [panssss translationInView:panssss.view];
    
    if (current.x<0) {
        NSLog(@"左边");
    }else{
        NSLog(@"右边");
    }
    if (current.x<0) {
        // 左滑动
        
        if (panssss.state == UIGestureRecognizerStateChanged) {
            
            NSLog(@"手势移动");
           _carousel.currentItemView.center = CGPointMake(current.x+CGRectGetMidX(self.oringFrame),CGRectGetMidY( self.oringFrame));
            
            _carousel.currentItemView.transform = CGAffineTransformMakeScale(1., 1.);
        }
        
        else if ( panssss.state == UIGestureRecognizerStateEnded||panssss.state == UIGestureRecognizerStateCancelled||
                 panssss.state == UIGestureRecognizerStateFailed){
            
            
            if (current.x<-60*self.scaleX) {
//              
//                if (_carousel.numberOfItems >= 4)
//                {
                
                    CardCellCollectionViewCell *cell = (CardCellCollectionViewCell*)_carousel.currentItemView;
                    [UIView animateWithDuration:0.3 animations:^{
                        
                        cell.transform = CGAffineTransformMakeTranslation(-300,0);
                    } completion:^(BOOL finished) {
                        
                        NSInteger  index = _carousel.currentItemIndex;
                        
                        
                        NSDictionary *dic = self.items[index];
                        
                        // 从数据库中删除
                        [WEHomeCacheTool deleteInfoWithID:dic[@"id"]];
                        
                        
                        [_carousel removeItemAtIndex:index animated:YES];
                        [_items    removeObjectAtIndex:index];
                        
                        
                        // 在添加
                        NSInteger index2 = _carousel.currentItemIndex;
                        
                            // 张数递增
                        NSInteger page =++self.number;
                        NSArray *array = [WEHomeCacheTool readAllInfo];

                        XWUserModel *model = [XWUserModel getUserInfoFromlocal];
                        if ([model.userRight isEqualToString:@"1"]) {
                            
                            
                            if (array.count<=6) {
                                NSLog(@"删完了 要重新请求了.....");
                                [self getData];
                    
                                
                            }
                            
                            [_items insertObject:self.allPicArray[page] atIndex:index2];
                            [_carousel insertItemAtIndex:index2 animated:YES];
                            [self carouselDidEndScrollingAnimation:self.carousel];

                            
                            
                            
                            
                            
                        }else{
                            // 非vip
                            if (array.count<=4) {
                                 NSLog(@"删完了 要重新请求了.....");

                                [self getData];

                            }
                            
                            [_items insertObject:self.allPicArray[page] atIndex:index2];
                            [_carousel insertItemAtIndex:index2 animated:YES];
                             [self carouselDidEndScrollingAnimation:self.carousel];
                            
                        }

                        
                        
                        
//                        
//                        if (page >= self.allPicArray.count -1) {
//                            // 数组中最好一张了
//                            // 重新请求第2页
//                            
//                            NSLog(@"删完了 要重新请求了.....");
//                            
////                            [self getData];
//                            
//                            
//                        }else{
//                            
//                            [_items insertObject:self.allPicArray[page] atIndex:index2];
//                            [_carousel insertItemAtIndex:index2 animated:YES];
//                            [self carouselDidEndScrollingAnimation:self.carousel];
//                            
//                        }
                        
                        
                        
                    }];
                    
                    
//                }

            }else{
                [UIView animateWithDuration:0.3 animations:^{
                    _carousel.currentItemView.frame = self.oringFrame;
                     _carousel.currentItemView.transform = CGAffineTransformMakeScale(1.2, 1.2);
                }];
            }
            
        }
                
        
        
    }else{
        
        
        if (panssss.state == UIGestureRecognizerStateChanged) {
            
            NSLog(@"手势移动");
            _carousel.currentItemView.center = CGPointMake(current.x+CGRectGetMidX( self.oringFrame),CGRectGetMidY( self.oringFrame));
               _carousel.currentItemView.transform = CGAffineTransformMakeScale(1., 1.);
            
            }
        
        else if ( panssss.state == UIGestureRecognizerStateEnded||panssss.state == UIGestureRecognizerStateCancelled||
                 panssss.state == UIGestureRecognizerStateFailed){
            
            if (current.x>60*self.scaleX) {
                
                
//                if (_carousel.numberOfItems >= 4)
//                {
                
                    CardCellCollectionViewCell *cell = (CardCellCollectionViewCell*)_carousel.currentItemView;
                    [UIView animateWithDuration:0.3 animations:^{
                        cell.transform = CGAffineTransformMakeTranslation(300, 0);
                    } completion:^(BOOL finished) {
                        
                        
                      
                        NSInteger  index = _carousel.currentItemIndex;
                        
                        
                        NSDictionary *dic = self.items[index];
                        
                        // 从数据库中删除
                        [WEHomeCacheTool deleteInfoWithID:dic[@"id"]];
                        
                        
                        [_carousel removeItemAtIndex:index animated:YES];
                        [_items    removeObjectAtIndex:index];
                        
                        
                        // 在添加
                        NSInteger index2 = _carousel.currentItemIndex;
                        
                        // 张数递增
                        NSInteger page =++self.number;
                        NSArray *array = [WEHomeCacheTool readAllInfo];
                        
                        XWUserModel *model = [XWUserModel getUserInfoFromlocal];
                        if ([model.userRight isEqualToString:@"1"]) {
                            
                            
                            if (array.count<=6) {
                                NSLog(@"删完了 要重新请求了.....");
                                [self getData];
                                
                                
                            }
                            
                            [_items insertObject:self.allPicArray[page] atIndex:index2];
                            [_carousel insertItemAtIndex:index2 animated:YES];
                            [self carouselDidEndScrollingAnimation:self.carousel];
                            
                            
                            
                            
                            
                            
                        }else{
                            // 非vip
                            if (array.count<=4) {
                                NSLog(@"删完了 要重新请求了.....");
                                 [self getData];
                                
                            }
                            
                            [_items insertObject:self.allPicArray[page] atIndex:index2];
                            [_carousel insertItemAtIndex:index2 animated:YES];
                            [self carouselDidEndScrollingAnimation:self.carousel];
                            
                        }

                        
                        
                    }];
                    
                    
//                }
                
            }else{
                [UIView animateWithDuration:0.3 animations:^{
                    
                     _carousel.currentItemView.frame = self.oringFrame;
                     _carousel.currentItemView.transform = CGAffineTransformMakeScale(1.2, 1.2);
                }completion:^(BOOL finished) {
                    
                    
                }];
              
            }

            
        }
               
    }

    
}


-(void)configCarousel{
    
    //create carousel
    _carousel = [[iCarousel alloc] initWithFrame:CGRectMake(0,64,KScreenWidth,KScreenHeight-64-44)];
    _carousel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    _carousel.type = iCarouselTypeCoverFlow;
    _carousel.delegate = self;
    _carousel.dataSource = self;
    _carousel.vertical = YES;
    _carousel.bounces = NO;
//    _carousel.scrollOffset = 3;
    [self.view addSubview:_carousel];
    [self.view addSubview:self.likeBtn];
    [self.view addSubview:self.moreBtn];

    
    
}
#pragma mark -
#pragma mark iCarousel methods
- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return  self.items.count;
}


- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    
    CardCellCollectionViewCell *cell = [CardCellCollectionViewCell xw_loadFromNib];
    cell.frame = CGRectMake(0, 0, 240*self.scaleX, 240*self.scaleX);
    cell.tag = index;
    NSDictionary *dic = self.items[index];
    NSString *imageSrtring = dic[@"imgFileNames"];
    
    NSArray *array = [imageSrtring componentsSeparatedByString:@","];
    NSURL *imagURL =[NSURL URLWithString: [NSString stringWithFormat:@"%@/%@/%@",ImageURL,dic[@"id"],array[0]]];
    NSLog(@"====！===%@",array);
    [cell.imagView sd_setImageWithURL:imagURL placeholderImage:[UIImage imageNamed:@"3"]];
    cell.ids = dic[@"id"];
    
    cell.name = dic[@"nickname"];
    cell.xinzuoLable.text = dic[@"xingZuo"];
    cell.ardess.text = dic[@"city"];
    if ([dic[@"sex"] integerValue] == 0) {
        cell.ageLable.text = [NSString stringWithFormat:@"女 %@",dic[@"age"]];
    }else{
           cell.ageLable.text = [NSString stringWithFormat:@"男 %@",dic[@"age"]];
    }
    cell.pipeLable.text = [NSString stringWithFormat:@"匹配度%@%@",dic[@"matchDegree"],@"%"];
    [self.cellArray  addObject:cell];
    [self.dataSource addObject:cell];
    return cell;
}


- (CATransform3D)carousel:(iCarousel *)carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform
{
    
    
    transform = CATransform3DRotate(transform, M_PI / 8.0, 0.0, 1.0, 0.0);
    return CATransform3DTranslate(transform, 0.0, 0.0, offset * self.carousel.itemWidth);
}
- (void)carouselDidEndScrollingAnimation:(iCarousel *)carousel{
//    
//    [UIView animateWithDuration:0.2 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//        
//    } completion:^(BOOL finished) {
//        
//    }];
//    
    
    [UIView animateWithDuration:0.25 animations:^{
        carousel.currentItemView.transform = CGAffineTransformMakeScale(1.2, 1.2);

    }];
}


- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    
       
    if (self.isNO == NO) {
        for (CardCellCollectionViewCell *cell in self.dataSource) {
            if (cell == carousel.currentItemView) {
                
            }else{
                cell.transform = CGAffineTransformMakeScale(1., 1.);
            }
        }
        
        
    }
    
    switch (option)
    {
        case iCarouselOptionWrap:
        {
            //normally you would hard-code this to YES or NO
            return YES;
        }
        case iCarouselOptionSpacing:
        {
            // 控制器滚动的范围
            return value * 0.70;
        }
        case iCarouselOptionFadeMax:
        {
            if (carousel.type == iCarouselTypeCustom)
            {
                
                return 0.8f;
            }
            return value;
        }
        default:
        {
            return value;
        }
    }
}


- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index{
    
    NSDictionary *dic = self.items[index];
    
    WELookDetailViewController *vc = [[WELookDetailViewController alloc]initWithType:vcTypeHome];
    self.tabBarController.hidesBottomBarWhenPushed = YES;
    vc.dic = dic;
    vc.ID = dic[@"id"];
    [self.navigationController pushViewController:vc animated:YES];
    
}


#pragma mark -- 右滑
- (void)swichController:(UISwipeGestureRecognizer *)pan{
    if (pan.direction == UISwipeGestureRecognizerDirectionRight) {
        if (_carousel.numberOfItems >= 5)
        {
            
            CardCellCollectionViewCell *cell = (CardCellCollectionViewCell*)_carousel.currentItemView;
            [UIView animateWithDuration:0.3 animations:^{
                
                cell.transform = CGAffineTransformMakeTranslation(300, 0);
            } completion:^(BOOL finished) {
                
                
                // 先删除
                NSInteger index = _carousel.currentItemIndex;
                [_carousel removeItemAtIndex:index animated:YES];
                [_items removeObjectAtIndex:index];
                
                // 在添加
                NSInteger index2 = _carousel.currentItemIndex;
                [_items insertObject:@"4" atIndex:index2];
                [_carousel insertItemAtIndex:index2 animated:YES];
                
                
            }];
            
            
        }
        
    }else {
        
        
        if (_carousel.numberOfItems >= 5)
        {
            
            CardCellCollectionViewCell *cell = (CardCellCollectionViewCell*)_carousel.currentItemView;
            [UIView animateWithDuration:0.3 animations:^{
                
                cell.transform = CGAffineTransformMakeTranslation(-300, 0);
            } completion:^(BOOL finished) {
                
                NSInteger index = _carousel.currentItemIndex;
                [_carousel removeItemAtIndex:index animated:YES];
                [_items    removeObjectAtIndex:index];
               
                
                // 在添加
                NSInteger index2 = _carousel.currentItemIndex;
                [_items insertObject:@"4" atIndex:index2];
                [_carousel insertItemAtIndex:index2 animated:YES];

                
            }];
            
            
        }
        

        
        
    }
    
}


#pragma mark -- 喜欢
- (void)likeBtnClick:(UIButton *)sender{

    OpenLikeAnswerVC *vc = [OpenLikeAnswerVC new];
    
    vc.modelsAr = [self.items copy];
    
    
    self.tabBarController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc
                                         animated:YES];
    
}

#pragma mark -- 换一批
-(void)moreBtnClick:(UIButton *)sender{
    self.isNO = YES;
    [UIView beginAnimations:nil context:nil];
    _carousel.type = iCarouselTypeLinear;
    [UIView commitAnimations];
    
    [self.cellArray enumerateObjectsUsingBlock:^(CardCellCollectionViewCell * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"%ld",idx);
        [UIView animateWithDuration:0.4 delay:idx *0.05 options:UIViewAnimationOptionCurveEaseInOut animations:^{
           
            obj.transform  = CGAffineTransformMakeTranslation(0,900);
            
        } completion:^(BOOL finished) {
            
           
            
        }];
        
        [self performSelector:@selector(succedd) withObject:nil afterDelay:0.8];
        
     
    
    }];
    
}
#pragma mark -- 换一批完成后
- (void)succedd{
      _carousel.type = iCarouselTypeCoverFlow;
    [self.items removeAllObjects];
//    [self.cellArray removeAllObjects];
//
//    [self.items addObject:@"baby"];
//    [self.items addObject:@"baby"];
//    [self.items addObject:@"baby"];
//    [self.items addObject:@"baby"];
//     [self.items addObject:@"baby"];
    
    NSLog(@"%@",_carousel.visibleItemViews);
 
    NSArray  *arrays = [_carousel visibleItemViews];
    for (CardCellCollectionViewCell *cell in arrays) {
        // 从数据库中删除
        [WEHomeCacheTool deleteInfoWithID:cell.ids];
        
    }

    NSArray *array = [WEHomeCacheTool readAllInfo];
    XWUserModel *model = [XWUserModel getUserInfoFromlocal];
    
    // 张数递增
//    NSInteger page =++self.number;
//    NSLog(@"====={{{{{{   %ld",page);
      NSLog(@"====={{{{{{   %ld",self.allPicArray.count);
    if ([model.userRight isEqualToString:@"1"]) {
        
        
        if (array.count<=6) {
            NSLog(@"删完了 要重新请求了.....");
            [self getData];
            
            
        }else{
            
              [_items insertObject:array[0] atIndex:0];
              [_items insertObject:array[1] atIndex:1];
              [_items insertObject:array[2] atIndex:2];
              [_items insertObject:array[3] atIndex:3];
              [_items insertObject:array[4] atIndex:4];
//            page = page+5;
            
        }
        
        
    }else{
        // 非vip
        if (array.count<=4) {
            NSLog(@"删完了 要重新请求了.....");
            
            [self getData];
            
        }else{
            
            [_items insertObject:array[0] atIndex:0];
            [_items insertObject:array[1] atIndex:1];
            [_items insertObject:array[2] atIndex:2];
  
   
//            page = page+3;
            
        }
    }
    

    
//    [self.carousel reloadData];
    self.isNO = NO;


    
    
    

}


//-(UICollectionView*)cardCollectionView
//{
//    if (!_cardCollectionView) {
//        _cardCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, KScreenHeight-64-44-40) collectionViewLayout:self.cardLayout];
//        [_cardCollectionView registerNib:[UINib nibWithNibName:@"CardCellCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:CardCellCollectionViewCellID];
//        _cardCollectionView.delegate = self;
//        _cardCollectionView.dataSource = self;
//        [_cardCollectionView setContentOffset:CGPointMake(0, 300)];
//        _cardCollectionView.backgroundColor = [UIColor whiteColor];
//    }
//    return _cardCollectionView;
//}

- (UIButton *)likeBtn{
    if (!_likeBtn) {
        _likeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_likeBtn setTitle:@"LIKE" forState:UIControlStateNormal];
        [_likeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _likeBtn.backgroundColor = KNaviBarTintColor;
        _likeBtn.layer.cornerRadius = 20;
        _likeBtn.layer.masksToBounds = YES;
        _likeBtn.frame = CGRectMake(KScreenWidth-50,KScreenHeight-100,40, 40);
        [_likeBtn addTarget:self action:@selector(likeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    
    return _likeBtn;
}

- (UIButton *)moreBtn{
    if (!_moreBtn) {
        _moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_moreBtn setTitle:@"NO" forState:UIControlStateNormal];
        [_moreBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _moreBtn.backgroundColor = KNaviBarTintColor;
        _moreBtn.layer.cornerRadius = 20;
        _moreBtn.layer.masksToBounds = YES;
        _moreBtn.frame = CGRectMake(10,KScreenHeight-100,40, 40);
        [_moreBtn addTarget:self action:@selector(moreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    
    return _moreBtn;
}



@end
