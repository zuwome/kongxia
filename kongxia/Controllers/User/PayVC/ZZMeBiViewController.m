//
//  ZZMeBiViewController.m
//  zuwome
//
//  Created by 潘杨 on 2017/12/29.
//  Copyright © 2017年 TimoreYu. All rights reserved.
//

#import "ZZMeBiViewController.h"
#import "ZZUser.h"
#import "ZZBillingRecordsViewController.h"
#import "ZZMeBiCollectionViewCell.h"
#import "ZZMeBiHeaderCollectionReusableView.h"
#import "ZZPayHelper.h"
#import "TYAttributedLabel.h"
#import "ZZLinkWebViewController.h"
#import "ZZPayManager.h"
#import "LSPaoMaView.h"

@interface ZZMeBiViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,ZZPayHelperDelegate,TYAttributedLabelDelegate>
@property (nonatomic, strong) UICollectionView *collection;

@property (nonatomic, strong) ZZMeBiCollectionViewCell *currentCell;

@property (nonatomic, strong) UIButton *payAgreementBtn;//充值协议

@property (nonatomic, strong) TYAttributedLabel *payAgreementLab;//支付协议

@property (nonatomic, strong) NSMutableArray *meBiArray;

@property (nonatomic, strong) UIButton *payButton, *rightBarItem;

@property (nonatomic, strong) UICollectionReusableView *currentHeader;

@property (nonatomic, strong) UIView *topView;

@property (nonatomic, strong) UILabel *paymentTitleLabel;

@property (nonatomic, strong) UIButton *aliPayBtn;

@property (nonatomic, strong) UIButton *weChatBtn;

@property (nonatomic, strong) UILabel *paymentLabel;

@property (nonatomic, assign) NSInteger currentSelectRechargeType; // 充值并购买的渠道:1:微信 2:支付宝

@end

@implementation ZZMeBiViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}
 
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"么币";
    self.view.backgroundColor = [UIColor whiteColor];
    _currentSelectRechargeType = 1;
    if (!self.user) {
        _user = [ZZUserHelper shareInstance].loginer;
    }
    [self creatRightBarButtonUI];
    [self createCollectionUI];
    [self loadMeBiData];
    [self fetchMebiList];
    [self loadNewMebi];
    [self viewClicked];
    
    [_weChatBtn setSelected: _currentSelectRechargeType == 1];
    [_aliPayBtn setSelected: _currentSelectRechargeType == 2];
    if (_currentSelectRechargeType == 1) {
        _paymentLabel.text = @"使用微信支付";
        _paymentLabel.textColor = ColorHex(72c448);
    }
    else if (_currentSelectRechargeType == 2) {
        _paymentLabel.text = @"使用支付宝支付";
        _paymentLabel.textColor = ColorHex(51b6ec);
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinishPay:) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self]   ;
}

- (void)didFinishPay:(NSNotification *)notification {
    self.view.userInteractionEnabled = YES;
    self.navigationLeftBtn.enabled = YES;
    self.rightBarItem.enabled = YES;
    
    NSDictionary *paymentData = [ZZUserDefaultsHelper objectForDestKey:kPaymentData];
    NSString *paymentId = paymentData[@"id"];
    if (paymentId) {
        [ZZThirdPayHelper pingxxRetrieve:paymentId next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
            if (error) {
                //do nothing
            }
            else if (data) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    _user = [ZZUserHelper shareInstance].loginer;
                    [self.collection reloadData];
                    self.payButton.enabled = YES;
                    if ([data[@"paid"] intValue] == 1) {
                        [ZZHUD showWithStatus:@"充值成功"];
                        if (self.paySuccess) {
                            self.paySuccess(self.user);
                        }
                    }
                    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0/*延迟执行时间*/ * NSEC_PER_SEC));
                    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                        [ZZHUD dismiss];
                    });
                });
            }
        }];
    }
}

- (void)loadNewMebi {
    [ZZUserHelper requestMeBiAndMoneynext:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        self.user = [ZZUserHelper shareInstance].loginer;
        [self.collection reloadData];
    }];
}

- (UIView *)topView {
    if (!_topView) {
        _topView = [UIView new];
        _topView.frame = CGRectMake(0, 0, SCREEN_WIDTH, [self isShowTopView] ? 40 : 0);
        _topView.backgroundColor = HEXCOLOR(0xF9F3D0);
        
        UIImageView *noticeImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icNotice"]];
        noticeImageView.frame = CGRectMake(15, 13.5, 17, 13);

        LSPaoMaView *paomaView = [[LSPaoMaView alloc] initWithFrame:CGRectMake(45, 0, SCREEN_WIDTH - 44, 40) title:@"充值问题请咨询官方微信公众号：空虾（kongxiaapp)" font: 14];
        [_topView addSubview:noticeImageView];
        [_topView addSubview:paomaView];
    }
    return _topView;
}

// 是否需要显示 TopView
- (BOOL)isShowTopView {
    return YES;
}

- (void)fetchMebiList {
    [ZZMeBiModel fetchRechargeMebiList:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            [ZZHUD showTastInfoErrorWithString:error.message];
        } else {
            NSMutableArray *array = [NSMutableArray array];
            for (NSDictionary *mebiDict in data) {
                ZZMeBiModel *model = [[ZZMeBiModel alloc] initWithDictionary:mebiDict error:nil];
                [array addObject:model];
            }
            self.meBiArray = array;
            [self.collection reloadData];
        }
    }];
}

- (void)loadMeBiData {    
    [ZZPayManager downloadInAppPurchase:^(NSArray *payArray) {
        self.meBiArray = [payArray mutableCopy];
        [self.collection reloadData];
    }];
  
}

#pragma mark - UI布局
- (void)createCollectionUI {
    [self.view addSubview:self.topView];
    [self.view addSubview:self.collection];
    [self.view addSubview:self.payButton];
    [self.view addSubview:self.payAgreementLab];
    [self.view addSubview:self.payAgreementBtn];
    [self setUpTheConstraints];
}

- (UICollectionView *)collection {
    if (!_collection) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = AdaptedWidth(24);
        layout.itemSize = CGSizeMake(AdaptedWidth(99), AdaptedHeight(64));
        layout.sectionInset = UIEdgeInsetsMake(0, AdaptedWidth(15), AdaptedWidth(15), AdaptedWidth(15));
        layout.minimumInteritemSpacing = 15;
        [ZZPayManager downloadInAppPurchase:^(NSArray *payArray) {
            self.meBiArray = [payArray mutableCopy];
        }];
        _collection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH,AdaptedWidth(152+99*2)) collectionViewLayout:layout];
        _collection.backgroundColor = [UIColor whiteColor];
        [_collection registerClass:[ZZMeBiCollectionViewCell class] forCellWithReuseIdentifier:@"ZZMeBiCollectionViewCellID"];
        [_collection registerClass:[ZZMeBiHeaderCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ZZMeBiHeaderCollectionReusableViewID"];
        _collection.delegate = self;
        _collection.dataSource = self;
    }
    return _collection;
}

- (void)creatRightBarButtonUI {
    UIButton  *rightBarItem = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBarItem addTarget:self action:@selector(rightBarBtnClick) forControlEvents:UIControlEventTouchUpInside];
    rightBarItem.frame = CGRectMake(0, 0, AdaptedWidth(80), 44);
    [rightBarItem setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rightBarItem setTitle:@"账单记录" forState:UIControlStateNormal];
    self.rightBarItem =rightBarItem;
    rightBarItem.titleLabel.font = [UIFont systemFontOfSize:15];
    UIBarButtonItem *rightBarButon = [[UIBarButtonItem alloc]initWithCustomView:rightBarItem];
    self.navigationItem.rightBarButtonItems = @[rightBarButon];
}

-(UIButton *)payButton {
    if (!_payButton) {
        _payButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _payButton.backgroundColor = RGBCOLOR(240, 203, 7);
        [_payButton setTitle:@"充值" forState: UIControlStateNormal];
        [_payButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_payButton addTarget:self action:@selector(payClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _payButton;
}

-(UIButton *)payAgreementBtn {
    if (!_payAgreementBtn) {
        _payAgreementBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_payAgreementBtn setImage:[UIImage imageNamed:@"btn_report_n"] forState:UIControlStateNormal];
         [_payAgreementBtn setImage:[UIImage imageNamed:@"btn_report_p"] forState:UIControlStateSelected];
        _payAgreementBtn.selected = YES;
          [_payAgreementBtn addTarget:self action:@selector(payAgreementClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _payAgreementBtn;
}


- (TYAttributedLabel *)payAgreementLab {
    if (!_payAgreementLab) {
       _payAgreementLab =[[TYAttributedLabel alloc]initWithFrame:CGRectZero];
        _payAgreementLab.textAlignment = kCTTextAlignmentLeft;
        _payAgreementLab.textColor= RGBCOLOR(128, 128, 128);
        
        _payAgreementLab.font= [UIFont systemFontOfSize:12];
        _payAgreementLab.text = @"我已阅读并同意";
        _payAgreementLab.delegate = self;
        [ _payAgreementLab appendLinkWithText:@"《充值协议》" linkFont:[UIFont systemFontOfSize:12 ] linkColor: RGBCOLOR(255, 186, 0) underLineStyle:kCTUnderlineStyleNone linkData:@"充值协议"];
        NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        if ((version && [version isEqualToString:@"3.7.5"])) {
        }
        else {
            [_payAgreementLab appendLinkWithText:@"|  苹果内购教程" linkFont:[UIFont systemFontOfSize:12 ] linkColor: RGBCOLOR(128, 128, 128) underLineStyle:kCTUnderlineStyleNone linkData:@"苹果内购教程"];
        }
    }
    return _payAgreementLab;
}

-(NSMutableArray *)meBiArray {
    if (!_meBiArray) {
        _meBiArray = [NSMutableArray array];
    }
    return _meBiArray;
}

- (UILabel *)paymentTitleLabel {
    if (!_paymentTitleLabel) {
        _paymentTitleLabel = [[UILabel alloc] init];
        _paymentTitleLabel.font = [UIFont systemFontOfSize:14.0];
        _paymentTitleLabel.textColor = RGBCOLOR(63, 58, 58);;
        _paymentTitleLabel.text = @"支付方式";
    }
    return _paymentTitleLabel;
}

- (UIButton *)aliPayBtn {
    if (!_aliPayBtn) {
        _aliPayBtn = [[UIButton alloc] init];
        _aliPayBtn.normalImage = [UIImage imageNamed:@"ic_zhifubao"];
        _aliPayBtn.selectedImage = [UIImage imageNamed:@"ic_zhifubaozhifu"];
        _aliPayBtn.tag = 2;
        [_aliPayBtn addTarget:self action:@selector(didSelectPayment:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _aliPayBtn;
}

- (UIButton *)weChatBtn {
    if (!_weChatBtn) {
        _weChatBtn = [[UIButton alloc] init];
        _weChatBtn.normalImage = [UIImage imageNamed:@"ic_weixin"];
        _weChatBtn.selectedImage = [UIImage imageNamed:@"ic_weixinzhifu"];
        _weChatBtn.tag = 1;
        [_weChatBtn addTarget:self action:@selector(didSelectPayment:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _weChatBtn;
}

- (UILabel *)paymentLabel {
    if (!_paymentLabel) {
        _paymentLabel = [[UILabel alloc] init];
        _paymentLabel.font = [UIFont systemFontOfSize:12.0];
        _paymentLabel.textColor = kGrayTextColor;
        _paymentLabel.textAlignment = NSTextAlignmentCenter;
        _paymentLabel.text = @"还未选取支付方式";
    }
    return _paymentLabel;
}

/**
 设置约束
 */
- (void)setUpTheConstraints {
    
    [self.payAgreementBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@20);
        make.bottom.equalTo(self.view).with.offset(-120.0);
        
        NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        if ((version && [version isEqualToString:@"3.7.5"])) {
            make.left.offset(AdaptedWidth(100));
        }
        else {
            make.left.offset(AdaptedWidth(42));
        }
    }];
    
    [self.payAgreementLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.payAgreementBtn.mas_right).with.offset(3.5);
        make.height.equalTo(@20);
        make.centerY.equalTo(self.payAgreementBtn.mas_centerY);
        make.right.offset(-15);
    }];
    
    [self.payButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.payAgreementBtn.mas_top).with.offset(-13.0);
        make.height.mas_equalTo(50);
        make.left.offset(15);
        make.right.offset(-15);
    }];
    
    [_collection mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.bottom.equalTo(_payButton.mas_top).offset(-10.0);
    }];
    
}

- (void)didSelectPayment:(UIButton *)sender {
    _currentSelectRechargeType = sender.tag;
    [_weChatBtn setSelected: _currentSelectRechargeType == 1];
    [_aliPayBtn setSelected: _currentSelectRechargeType == 2];
    if (_currentSelectRechargeType == 1) {
        _paymentLabel.text = @"使用微信支付";
        _paymentLabel.textColor = ColorHex(72c448);
    }
    else if (_currentSelectRechargeType == 2) {
        _paymentLabel.text = @"使用支付宝支付";
        _paymentLabel.textColor = ColorHex(51b6ec);
    }
}

#pragma mark - 账单记录
- (void)rightBarBtnClick {
    ZZBillingRecordsViewController *recordVC = [[ZZBillingRecordsViewController alloc]init];
    recordVC.recordStyle = BillingRecordsStyle_MeBi;
    [self.navigationController pushViewController:recordVC animated:YES];
}

#pragma mark - 充值协议
- (void)payAgreementClick:(UIButton *)sender {
    sender.selected = !sender.selected;
}

#pragma mark - TYAttributedLabelDelegate
- (void)attributedLabel:(TYAttributedLabel *)attributedLabel textStorageClicked:(id<TYTextStorageProtocol>)TextRun atPoint:(CGPoint)point {
    if ([TextRun isKindOfClass:[TYLinkTextStorage class]]) {
        NSString *linkStr = ((TYLinkTextStorage*)TextRun).linkData;
        if ([linkStr isEqualToString:@"充值协议"]) {

            ZZLinkWebViewController *webViewController = [[ZZLinkWebViewController alloc]init];
            NSString *url = H5Url.rechargeAgreement_zuwome;
            NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
            if ((version && [version isEqualToString:@"3.7.5"])) {
                url = H5Url.rechargeAgreement;
            }
            webViewController.urlString = url;
            webViewController.navigationItem.title = @"充值协议";
            [self.navigationController pushViewController:webViewController animated:YES];
        }
        else {
            [self payHelpButtonClick];
        }
    }
}

/**
 *  进入页面就要去发送点击进来的请求
 */
- (void)viewClicked {
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    if (!(version && [version isEqualToString:@"3.7.5"])) {
        [ZZRequest method:@"GET" path:@"/api/user/mcoin/recharge/click" params:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        }];
    }
}

#pragma mark - 充值
- (void)payClick:(UIButton *)sender {
    [MobClick event:Event_click_MeBi_TopUp];
    sender.enabled = NO;
    WeakSelf;
    if (!self.payAgreementBtn.selected) {
        [UIAlertView showWithTitle:@"温馨提示" message:@"请先同意充值协议" cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
            weakSelf.payButton.enabled = YES;
            if (buttonIndex ==1) {
                weakSelf.payAgreementBtn.selected = YES;
            }
        }];
        return;
    }
    
    if (self.currentCell) {
        ZZPayHelper *request =   [ZZPayHelper shared];
        request.delegate = self;
        self.view.userInteractionEnabled = NO;
        self.navigationLeftBtn.enabled = NO;
        self.rightBarItem.enabled = NO;
        //开启ios右滑返回
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)])
        {
            self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        }
        
        [ZZHUD showWithStatus:@"正在购买中"];
        [ZZPayHelper requestProductWithId:self.currentCell.meBiModel.productId];
        
//        // 使用支付宝微信充值
//        [self rechargeByPayments];
    }
    NSLog(@"PY_内购购买开始%@",[NSDate date]);
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0/*延迟执行时间*/ * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        weakSelf.payButton.enabled = YES;
    });
}

- (void)rechargeByPayments {
    if (self.currentCell && (_currentSelectRechargeType == 1 || _currentSelectRechargeType == 2)) {
        [_currentCell.meBiModel rechargeBy:_currentSelectRechargeType model:_currentCell.meBiModel next:^(BOOL isSuccess) {
            self.view.userInteractionEnabled = YES;
            self.navigationLeftBtn.enabled = YES;
            self.rightBarItem.enabled = YES;
            
            if (isSuccess) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [ZZHUD showWithStatus:@"充值成功"];
                    _user = [ZZUserHelper shareInstance].loginer;
                    [self.collection reloadData];
                    self.payButton.enabled = YES;
                    if (self.paySuccess) {
                        self.paySuccess(self.user);
                    }
                    
                    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0/*延迟执行时间*/ * NSEC_PER_SEC));
                    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                        [ZZHUD dismiss];
                    });
                });
            }
        }];
    }
}

#pragma mark - 支付结果回调
/**
 支付成功在这里面将数据上传给服务器
 注*服务器上传结束后需要服务器返回 @"transactionID" 这个字段下的用户的交易订单号
 然后调用本地的移除本地存储接口
 @param infoDic 支付成功的数据
 */
- (void)paySuccessWithtransactionInfo:(NSDictionary *)infoDic {
    NSLog(@"PY_内购购买结束 %@",[NSDate date]);
    dispatch_async(dispatch_get_main_queue(), ^{
        self.view.userInteractionEnabled = YES;
        self.navigationLeftBtn.enabled = YES;
        self.rightBarItem.enabled = YES;
        //开启ios右滑返回
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        }
        if (!infoDic[@"error"]) {
            [ZZHUD showWithStatus:@"充值成功"];
            _user = [ZZUserHelper shareInstance].loginer;
            [self.collection reloadData];
            self.payButton.enabled = YES;
            if (self.paySuccess) {
                self.paySuccess(self.user);
            }
        }
        else{
            NSString *errorMessage = infoDic[@"error"][@"message"];
            [ZZHUD showWithStatus:errorMessage];
        }
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0/*延迟执行时间*/ * NSEC_PER_SEC));
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
            [ZZHUD dismiss];
        });
    });
}

/**
 支付失败
 
 @param errorCode 失败状态码
 @param error 失败信息
 */
- (void)filedWithErrorCode:(NSInteger)errorCode andError:(NSString *)error transactionIdentifier:(NSString *)transactionIdentifier {
    if (isNullString(transactionIdentifier)) {
        transactionIdentifier = @"";
    }
    if (isNullString(error)) {
        error = @"";
    }
    NSDictionary *dic = @{
        @"errorCodeType" : @(errorCode),
        @"errorCodeString" : error,
        @"transactionIdentifier" : transactionIdentifier
    };
    
    [ZZPayManager uploadToServerData:dic];
    //开启ios右滑返回
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
    [ZZHUD dismiss];
    self.view.userInteractionEnabled = YES;
    self.navigationLeftBtn.enabled = YES;
    self.rightBarItem.enabled = YES;
    self.payButton.enabled = YES;
    [UIAlertView showWithTitle:@"温馨提示" message:error cancelButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
    }];
}

#pragma mark - UICollectionViewMethod
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.meBiArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZZMeBiCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZZMeBiCollectionViewCellID" forIndexPath:indexPath];
    if (indexPath.item > self.meBiArray.count) {
        return [[UICollectionViewCell alloc] init];
    }
    [cell setMeBiModel:self.meBiArray[indexPath.item]];
    
    cell.tag = indexPath.item;
    if (indexPath.item ==0) {
        cell.selected = YES;
        cell.tag = indexPath.item;
        self.currentCell = cell;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ZZMeBiCollectionViewCell *cell = (ZZMeBiCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    if (cell.tag == self.currentCell.tag ) {
        return;
    }
    else{
        self.currentCell.selected = NO;
        cell.selected = YES;
        self.currentCell = cell;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(SCREEN_WIDTH, 152);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = @"ZZMeBiHeaderCollectionReusableViewID";
    ZZMeBiHeaderCollectionReusableView *cell = (ZZMeBiHeaderCollectionReusableView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    if (indexPath.item == 0) {
        [cell setUserModel:self.user];
        self.currentHeader = cell;
    }
    return cell;
}

- (void)payHelpButtonClick {
    ZZLinkWebViewController *controller = [[ZZLinkWebViewController alloc] init];
    controller.urlString = H5Url.rechargeAppleGuide;
    controller.title = @"充值流程";
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)navigationLeftBtnClick {
    if (self.callBlack) {
        self.callBlack();
    }
    [super navigationLeftBtnClick];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
