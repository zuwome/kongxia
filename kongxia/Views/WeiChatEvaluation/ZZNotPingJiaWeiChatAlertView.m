//
//  ZZNotPingJiaWeiChatAlertView.m
//  zuwome
//
//  Created by 潘杨 on 2018/2/26.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZNotPingJiaWeiChatAlertView.h"
#import "TYAttributedLabel.h"
#import "ZZWeiChatEvaluationCustomButton.h"
#import "ZZReportModel.h"
#import "ZZWeiChatBadReviewCell.h"
#import "ZZWeiChatEvaluationHeaderCell.h"
#import "ZZShowAgainSure.h"
#import "ZZWechatReviewToast.h"
#import "kongxia-Swift.h"

@interface ZZNotPingJiaWeiChatAlertView()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIButton *closeButton;//关闭按钮

@property (nonatomic,strong) ZZWeiChatEvaluationCustomButton *copywXNumberButton;//复制微信号
@property (nonatomic,strong) UIButton *pingJiaWxNumberButton;//评价微信号

@property (nonatomic,strong) UIButton *goodPingJia;//好评
@property (nonatomic,strong) UIButton *badPingJia;//差评
@property (nonatomic,strong) UIButton *immediateEvaluation;//立即评价
@property (nonatomic,assign) NSInteger selectTypePingJia;//选中的评价状态
@property (nonatomic,strong) NSMutableArray *pingJiaArray;//评价的数组
@property (nonatomic,strong) ZZUser *user;

@property (nonatomic,strong) NSMutableArray *badEvaluationReasonArrayDataSource;//差评数据源
@property (nonatomic,strong) NSMutableArray *badEvaluationDataSource;//数据源

@property (nonatomic,strong) UICollectionView *badReviewReasonCollectionView;

@property (nonatomic, weak) UIViewController *ctl;
@property (nonatomic,copy)  void(^evaluationCallBlack)(BOOL goChat);

@property (nonatomic, assign) BOOL isAlreadyReported;
@end

@implementation ZZNotPingJiaWeiChatAlertView

/**
 购买微信号后的弹窗
 @param viewController 要弹出的界面
 @param curentLookModel 微信号评价的model
 @param badEvaluationReasonArray 微信号差评的原因
 @param evaluationCallBlack  评价成功的回调

 */
+ (void)showNotPingJiaWeiChatAlertViewWithViewController:(UIViewController *)viewController model:(ZZWeiChatEvaluationModel*)curentLookModel array:(NSMutableArray *)badEvaluationReasonArray evaluation:(void (^)(BOOL))evaluationCallBlack {
    [[[ZZNotPingJiaWeiChatAlertView alloc]init] showNotPingJiaWeiChatAlertViewWithViewController:viewController model:curentLookModel array:badEvaluationReasonArray evaluation:evaluationCallBlack];
}

/**
 购买微信号后的弹窗
 */
- (void)showNotPingJiaWeiChatAlertViewWithViewController:(UIViewController *)viewController model:(ZZWeiChatEvaluationModel*)curentLookModel array:(NSMutableArray *)badEvaluationReasonArray evaluation:(void(^)(BOOL goChat))evaluationCallBlack {
    self.ctl = viewController;
    self.user = curentLookModel.user;
    if (evaluationCallBlack) {
        self.evaluationCallBlack = evaluationCallBlack;
    }
    self.badEvaluationDataSource = badEvaluationReasonArray;
    [self setUpUI];
    viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    [self showView:viewController];
    
    [ZZWeiChatEvaluationNetwork checkIfisReported:self.user.uid next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            [ZZHUD showTastInfoErrorWithString:error.message];
        }
        else {
            _isAlreadyReported = [data boolValue];
        }
    }];
    
    //如果评价过了
    if (curentLookModel.isPingJia) {
        if (curentLookModel.wechat_comment_score == 1) {
            //已经差评
            self.goodPingJia.selected = NO;
            self.badPingJia.selected = YES;
            for (ZZWeiChatBadEvaluationReasonModel *cellModel in badEvaluationReasonArray) {
                for (NSString *reason in curentLookModel.user.wechat_comment_content) {
                    if ([reason isEqualToString:cellModel.reason]) {
                        cellModel.isSelect = YES;
                    }
                }
            }
            self.badEvaluationReasonArrayDataSource = badEvaluationReasonArray;
            float height = AdaptedHeight(290)+SafeAreaBottomHeight+ceilf(self.badEvaluationReasonArrayDataSource.count/2.0f)*AdaptedHeight(45);
            if (height-SCREEN_HEIGHT>=0) {
                self.badReviewReasonCollectionView.scrollEnabled = YES;
            }
            self.bgView.frame =  CGRectMake(0, SCREEN_HEIGHT - height, SCREEN_WIDTH, height);
            [self.badReviewReasonCollectionView reloadData];
            return;
        }
        self.goodPingJia.selected = YES;
    }
}



#pragma mark - UI布局
- (void)setUpUI {
    [self addSubview:self.bgView];
    _selectTypePingJia = -1;

    [self.bgView addSubview:self.closeButton];
    [self.bgView addSubview:self.copywXNumberButton];
    [self.bgView addSubview:self.pingJiaWxNumberButton];
    [self.bgView addSubview:self.goodPingJia];
    [self.bgView addSubview:self.badPingJia];
    [self.bgView addSubview:self.badReviewReasonCollectionView];
    [self setUpTheConstraints];
}
/**
 设置约束
 */
- (void)setUpTheConstraints {
    
    [self.pingJiaWxNumberButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.left.equalTo(self.copywXNumberButton.mas_right);
        make.right.equalTo(self.closeButton.mas_left);
        make.height.mas_equalTo(SCREEN_HEIGHT*0.08);
    }];
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.offset(0);
        make.size.equalTo(@(CGSizeMake(49, 49)));
    }];
    
    [self.goodPingJia mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(AdaptedWidth(110) , AdaptedHeight(40)));
        make.left.offset(AdaptedWidth(55));
        make.top.offset(AdaptedHeight(101));
    }];

    [self.badPingJia mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(AdaptedWidth(110) , AdaptedHeight(40)));
        make.right.offset(-AdaptedWidth(55));
        make.top.offset(AdaptedHeight(101));
    }];
    
    [self.badReviewReasonCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        make.top.mas_equalTo(self.badPingJia.mas_bottom).with.offset(23);
    }];

}

#pragma mark - 懒加载
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-AdaptedHeight(305)-SafeAreaBottomHeight, SCREEN_WIDTH, AdaptedHeight(305)+SafeAreaBottomHeight)];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.clipsToBounds = YES;
        _bgView.layer.cornerRadius = 8;
        
    }
    return _bgView;
}

- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setImage:[UIImage imageNamed:@"icChatEvaluatePopClosed"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(clickDissMiss) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}
- (UIButton *)pingJiaWxNumberButton {
    if (!_pingJiaWxNumberButton) {
        _pingJiaWxNumberButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_pingJiaWxNumberButton setImage:[UIImage imageNamed:@"icChatEvaluatePopEvaluate"] forState:UIControlStateNormal];
        [_pingJiaWxNumberButton setTitle:@"  评价TA的微信号" forState:UIControlStateNormal];
        _pingJiaWxNumberButton.adjustsImageWhenHighlighted=NO;
        [_pingJiaWxNumberButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _pingJiaWxNumberButton.titleLabel.font = AdaptedFontSize(15);
        _pingJiaWxNumberButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _pingJiaWxNumberButton;
}

- (ZZWeiChatEvaluationCustomButton *)copywXNumberButton {
    if (!_copywXNumberButton) {
        _copywXNumberButton = [ZZWeiChatEvaluationCustomButton buttonWithType:UIButtonTypeCustom];
        _copywXNumberButton.frame = CGRectMake(0, 0, SCREEN_WIDTH*0.47, SCREEN_HEIGHT*0.08);
        [_copywXNumberButton setImage:[UIImage imageNamed:@"icChatEvaluatePopCopy"] forState:UIControlStateNormal];
        [_copywXNumberButton addTarget:self action:@selector(copywxNumberClick) forControlEvents:UIControlEventTouchUpInside];
        [_copywXNumberButton setTitle:@"  复制微信号" forState:UIControlStateNormal];
        [_copywXNumberButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _copywXNumberButton.titleLabel.font = AdaptedFontSize(15);
        _copywXNumberButton.titleLabel.adjustsFontSizeToFitWidth = YES;

    }
    return _copywXNumberButton;
}



- (UIButton *)goodPingJia {
    if (!_goodPingJia) {
        _goodPingJia = [UIButton buttonWithType:UIButtonTypeCustom];
        _goodPingJia.tag = 305;
        if (!self.user.have_commented_wechat_no) {
               [_goodPingJia addTarget:self action:@selector(goodPingJiaClick:) forControlEvents:UIControlEventTouchUpInside];
        }
    
        [_goodPingJia setImage:[UIImage imageNamed:@"btChatEvaluatePraiseUnselected"] forState:UIControlStateNormal];
        [_goodPingJia setImage:[UIImage imageNamed:@"btChatEvaluatePraiseSelected"] forState:UIControlStateSelected];
        _goodPingJia.adjustsImageWhenHighlighted=NO;
    }
    return  _goodPingJia;
}
- (UIButton *)badPingJia {
    if (!_badPingJia) {
        _badPingJia = [UIButton buttonWithType:UIButtonTypeCustom];
        _badPingJia.tag = 301;
         _badPingJia.adjustsImageWhenHighlighted=NO;
        if (!self.user.have_commented_wechat_no) {
        [_badPingJia addTarget:self action:@selector(badPingJiaClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        [_badPingJia setImage:[UIImage imageNamed:@"btChatEvaluateNegativeUnselected"] forState:UIControlStateNormal];
        [_badPingJia setImage:[UIImage imageNamed:@"btChatEvaluateNegativeSelected"] forState:UIControlStateSelected];
    }
    return _badPingJia;
}
- (UICollectionView *)badReviewReasonCollectionView {
    if (!_badReviewReasonCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
        layout.minimumLineSpacing = AdaptedWidth(15);
        layout.itemSize = CGSizeMake(AdaptedWidth(90), AdaptedHeight(30));
        layout.sectionInset = UIEdgeInsetsMake(0, AdaptedWidth(60), AdaptedHeight(50), AdaptedWidth(60));
        layout.minimumInteritemSpacing = AdaptedWidth(23);
        _badReviewReasonCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _badReviewReasonCollectionView.backgroundColor = [UIColor whiteColor];
        [_badReviewReasonCollectionView registerClass:[ZZWeiChatBadReviewCell class] forCellWithReuseIdentifier:@"ZZWeiChatBadReviewCellID"];
        [_badReviewReasonCollectionView registerClass:[ZZWeiChatEvaluationHeaderCell class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"ZZWeiChatEvaluationHeaderCellID"];
        _badReviewReasonCollectionView.scrollEnabled = NO;
        _badReviewReasonCollectionView.delegate = self;
        _badReviewReasonCollectionView.dataSource = self;
    }
    return _badReviewReasonCollectionView;
}
/**
 已经选的差评理由
 */
- (NSMutableArray *)pingJiaArray {
    if (!_pingJiaArray) {
        _pingJiaArray = [NSMutableArray array];
    }
    return _pingJiaArray;
}
#pragma mark - 点击事件
//差评
- (void)badPingJiaClick:(UIButton *)sender {
//    sender.enabled = NO;
//    if (!self.user.can_bad_comment) {
//        [ZZHUD showTastInfoNomalWithString:@"达人响应需要时间,请24小时后给予对方差评" callBack:^{
//            sender.enabled = YES;
//        }];
//
//        return;
//    }
//    sender.enabled = YES;

    [self pingJiaClick:sender];

}

- (void)goodPingJiaClick:(UIButton *)sender {
    
    [self pingJiaClick:sender];
 
}

/**
 更新UI布局
 */
- (void)updateUI {
    
    if (_selectTypePingJia == 305) {
        //好评
    float height = AdaptedHeight(305)+SafeAreaBottomHeight;
    self.bgView.frame =  CGRectMake(0, SCREEN_HEIGHT -height, SCREEN_WIDTH,height);
        self.badEvaluationReasonArrayDataSource = nil;
    }else {
    self.badEvaluationReasonArrayDataSource = self.badEvaluationDataSource;
    float height = AdaptedHeight(290)+SafeAreaBottomHeight+ceilf(self.badEvaluationReasonArrayDataSource.count/2.0f)*AdaptedHeight(45);
        if (height-SCREEN_HEIGHT>=0) {
            self.badReviewReasonCollectionView.scrollEnabled = YES;
        }
        self.bgView.frame =  CGRectMake(0, SCREEN_HEIGHT - height, SCREEN_WIDTH, height);
    }
 
    [self.badReviewReasonCollectionView reloadData];
}

/**
 评价
 */
- (void)pingJiaClick:(UIButton *)sender {
     NSLog(@"PY_微信号评价");
    if (sender.tag== _selectTypePingJia) {
        if (sender.selected) {
            //没有选评价
            self.immediateEvaluation.enabled = NO;
            sender.selected =!sender.selected;
            _selectTypePingJia = -1;
            _immediateEvaluation.backgroundColor = RGBCOLOR(208, 208, 208);
        }
        
    }else{
    self.immediateEvaluation.enabled  = YES;
    _immediateEvaluation.backgroundColor = RGBCOLOR(244, 203, 7);
    if (_selectTypePingJia != -1) {
        UIButton *button = [self.bgView viewWithTag:_selectTypePingJia];
        if (button) {
            button.selected = NO;
        }
    }
    _selectTypePingJia = sender.tag;
    [self updateUI];
    sender.selected =!sender.selected;
    }
}

/**
 拷贝微信号
 */
- (void)copywxNumberClick {
     NSLog(@"PY_拷贝微信号");
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = _user.wechat.no ? _user.wechat.no : @"";
    [ZZHUD showSuccessWithStatus:@"已保存至粘贴板"];
}

/**
 *  举报微信号
 */
- (void)reportWechat {
    [self dissMiss];
    ZZWXOrderReportViewController *controller = [ZZWXOrderReportViewController createToUser:self.user];
    controller.didCamefromOldWechatReview = YES;
    if ([_ctl isKindOfClass:[ZZTabBarViewController class]]) {
        [[UIViewController currentDisplayViewController].navigationController pushViewController:controller animated:YES];
    }
    else {
       [_ctl.navigationController pushViewController:controller animated:YES];
    }
}

- (void)showReportCompleteView {
    [self dissMiss];
    ZZWXOrderReportCompleteViewController *vc = [[ZZWXOrderReportCompleteViewController alloc] init];
    vc.isCameStraightFromReview = YES;
    vc.didCamefromOldWechatReview = YES;
    
    ZZNavigationController *nav = [[ZZNavigationController alloc] initWithRootViewController:vc];
    UIViewController *rootVC = [UIViewController currentDisplayViewController];
    [rootVC presentViewController:nav animated:YES completion:nil];
//    if ([_ctl isKindOfClass:[ZZTabBarViewController class]]) {
//        [[UIViewController currentDisplayViewController].navigationController pushViewController:vc animated:YES];
//    }
//    else {
//       [_ctl.navigationController pushViewController:vc animated:YES];
//    }
}

#pragma mark - 消失
- (void)clickDissMiss {
    [self dissMiss];
}

#pragma mark - UICollectionViewMethod

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.badEvaluationReasonArrayDataSource.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZZWeiChatBadReviewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZZWeiChatBadReviewCellID" forIndexPath:indexPath];
 
    [cell setModel:self.badEvaluationReasonArrayDataSource[indexPath.item]];
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.user.have_commented_wechat_no) {
        //已经评价过的不管
        return;
    }
    
    ZZWeiChatBadReviewCell *cell = (ZZWeiChatBadReviewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    cell.isSelectEvaluation = !cell.isSelectEvaluation;
    ZZWeiChatBadEvaluationReasonModel *model = self.badEvaluationReasonArrayDataSource[indexPath.item];
    if (cell.isSelectEvaluation) {
        if ([self.pingJiaArray containsObject:model.reason]) {
            return;
        }
        [self.pingJiaArray addObject:model.reason];
    }
    else{
        if ([self.pingJiaArray containsObject:model.reason]) {
            [self.pingJiaArray removeObject:model.reason];
            return;
        }
    }
}
//TODO:底部的
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    
    return CGSizeMake(SCREEN_WIDTH, AdaptedHeight(100)+SafeAreaBottomHeight);
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        return [[UIView alloc] init];
    }
    NSString *CellIdentifier = @"ZZWeiChatEvaluationHeaderCellID";
    ZZWeiChatEvaluationHeaderCell *cell = (ZZWeiChatEvaluationHeaderCell *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:CellIdentifier forIndexPath:indexPath];
      if (self.user.have_commented_wechat_no) {
             [cell.immediateEvaluation setTitle:@"已评价" forState:UIControlStateNormal];
      }
    self.immediateEvaluation = cell.immediateEvaluation;
    
    WS(weakSelf);
    cell.reportWXNumber = ^{
        if (weakSelf.isAlreadyReported) {
            [weakSelf showReportCompleteView];
        }
        else {
            [weakSelf reportWechat];
        }
        
//        [ZZWeiChatEvaluationNetwork reportFalseWXWithWeiXinNumber:weakSelf.user.wechat.no userId:weakSelf.user.uid];
    };
    __weak typeof(cell) weakSelfCell = cell;
    cell.immediateEvaluationWXNumber = ^{
        
     
        NSString *content = nil ;
        for (NSString *pingJiaReasons in weakSelf.pingJiaArray) {
            content = [NSString stringWithFormat:@"%@|%@",content,pingJiaReasons];
        }
    
        WS(weakSelf);
        
        if (weakSelf.selectTypePingJia == 301) {
            
            [ZZWechatReviewToast showWithCancelBlock:^{
                NSLog(@"cancel");
            } reviewBlock:^{
                [ZZHUD show];
                NSString *content = nil ;
                for (NSString *pingJiaReasons in weakSelf.pingJiaArray) {
                    content = [NSString stringWithFormat:@"%@|%@",content,pingJiaReasons];
                }
                [ZZWeiChatEvaluationNetwork weiChatEvaluationWithEvaluationUid:weakSelf.user.uid score:_selectTypePingJia content:content next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
                    weakSelfCell.immediateEvaluation.enabled = YES;
                    if (!error) {
                        if (weakSelf.evaluationCallBlack) {
                            weakSelf.evaluationCallBlack(NO);
                        }
                        [ZZHUD showTastInfoWithString:@"评价成功"];
                        [weakSelf dissMiss];
                        
                    }else{
                        [ZZHUD showTaskInfoWithStatus:@"达人响应需要时间,请24小时后给予对方差评"];
                    }
                }];
            } okBlock:^{
                NSLog(@"ok");
                if (weakSelf.evaluationCallBlack) {
                    weakSelf.evaluationCallBlack(YES);
                }
                [weakSelf dissMiss];
            }];
          }
        else {
        
            [ZZHUD show];
            NSString *content = nil ;
            for (NSString *pingJiaReasons in weakSelf.pingJiaArray) {
                content = [NSString stringWithFormat:@"%@|%@",content,pingJiaReasons];
            }
            [ZZWeiChatEvaluationNetwork weiChatEvaluationWithEvaluationUid:weakSelf.user.uid score:_selectTypePingJia content:content next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
                weakSelfCell.immediateEvaluation.enabled = YES;
                if (!error) {
                    if (weakSelf.evaluationCallBlack) {
                        weakSelf.evaluationCallBlack(NO);
                    }
                    [ZZHUD showTastInfoWithString:@"评价成功"];
                    [weakSelf dissMiss];
                    
                }else{
                    [ZZHUD showTastInfoNomalWithString:@"达人响应需要时间,请24小时后给予对方差评" callBack:nil];
                }
            }];
        }

    };
    return cell;
}
@end
