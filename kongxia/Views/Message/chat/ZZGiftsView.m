//
//  ZZGiftsView.m
//  kongxia
//
//  Created by qiming xiao on 2019/11/22.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZGiftsView.h"
#import "ZZGiftItemsCell.h"
#import "ZZGiftModel.h"

@interface ZZGiftsView () <UICollectionViewDelegate, UICollectionViewDataSource, ZZGiftItemsCellDelegate>

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIImageView *mebiIconImageView;

@property (nonatomic, strong) UILabel *mebiLabel;

@property (nonatomic, strong) UIImageView *moreImageView;

@property (nonatomic, strong) UIView *seperateLine;

@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, strong) UIButton *rechargeBtn;

@property (nonatomic, copy) NSArray<ZZGiftModel *> *giftsArr;

@end

@implementation ZZGiftsView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self layout];
    }
    return self;
}

#pragma mark - public Method
- (void)show {
    [UIView animateWithDuration:0.3 animations:^{
        _bgView.alpha = 0.4;
        _contentView.top = self.height - _contentView.height;
    } completion:^(BOOL finished) {
        _bgView.userInteractionEnabled = YES;
    }];
}

- (void)hide {
    [UIView animateWithDuration:0.3 animations:^{
        _bgView.alpha = 0.0;
        _contentView.top = self.height;
    } completion:^(BOOL finished) {
        [_bgView removeFromSuperview];
        [_contentView removeFromSuperview];
        [self removeFromSuperview];
    }];
}

#pragma mark - private method
- (void)updateMebi {
    // 更新当前么币的数量
    NSUInteger leftMcoin = [[ZZUserHelper shareInstance].loginer.mcoin integerValue] - [ZZUserHelper shareInstance].consumptionMebi;
    _mebiLabel.text = [NSString stringWithFormat:@"%ld", leftMcoin];
}

- (void)configureData {
    WeakSelf
    [_giftHelper fetchGiftsListWithCompleteBlock:^(NSArray<ZZGiftModel *> *giftsArr) {
        weakSelf.giftsArr = giftsArr;
        [_collectionView reloadData];
        
        if (_giftsArr.count % 8 == 0) {
            _pageControl.numberOfPages = _giftsArr.count / 8;
        }
        else {
            _pageControl.numberOfPages = _giftsArr.count / 8 + 1;
        }
    }];
}

- (void)sendGift:(ZZGiftModel *)model {
    if (![_giftHelper didHaveEnoughMoneyToSendGift:model]) {
        // 余额不足,显示充值
        [self showRechargeView:model];
        return;
    }
    
    [_giftHelper sendGift:model finishedBlock:^(BOOL isSuccess) {
        [self hide];
        if (isSuccess) {
            [self updateMebi];
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(giftView:chooseGift:)]) {
                [self.delegate giftView:self chooseGift:model];
            }
        }
    }];
}

#pragma mark - response method
- (void)hideView {
    [self hide];
}

- (void)goToRecharge {
    [self showRechargeView:nil];
}

#pragma mark - ZZGiftItemsCellDelegate
- (void)cell:(ZZGiftItemsCell *)view chooseGift:(ZZGiftModel *)giftModel {
    // 是否要显示提示框
    if ([_giftHelper shouldShowSendGiftTips]) {
        NSString *message = [NSString stringWithFormat:@"本次礼物需支付%ld么币，确认支付吗？",giftModel.mcoin];
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *doneAction = [UIAlertAction actionWithTitle:@"确认 不再提醒" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [_giftHelper neverShowSendGiftTips];
            [self sendGift:giftModel];
        }];
        [alertController addAction:doneAction];
        
        UIAlertAction *doneAction1 = [UIAlertAction actionWithTitle:@"确认 每次提醒" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self sendGift:giftModel];
        }];
        [alertController addAction:doneAction1];
        
        UIAlertAction *doneAction2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:doneAction2];
        
        UIViewController *rootVC = [[[UIApplication sharedApplication] keyWindow] rootViewController];
        if ([rootVC presentedViewController] != nil) {
            rootVC = [UIAlertController findAppreciatedRootVC];
        }
        [rootVC presentViewController:alertController animated:YES completion:nil];
        
        return;
    }
    
    [self sendGift:giftModel];
}

#pragma mark -- UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (_giftsArr.count % 8 == 0) {
        return _giftsArr.count / 8;
    }
    else {
        return _giftsArr.count / 8 + 1;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZZGiftItemsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZZGiftItemCell" forIndexPath:indexPath];
    cell.delegate = self;
    
    NSArray<ZZGiftModel *> *subArr = nil;
    NSInteger startIndex = 8 * indexPath.item;
    if (startIndex + 8 < _giftsArr.count) {
        subArr = [_giftsArr subarrayWithRange:NSMakeRange(startIndex, 8)];
    }
    else {
        subArr = [_giftsArr subarrayWithRange:NSMakeRange(startIndex, _giftsArr.count - startIndex)];
    }
    [cell configureGifts:subArr selectedGift:nil];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(collectionView.width, 240);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

#pragma mark - UIScrollView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    _pageControl.currentPage = scrollView.contentOffset.x / SCREEN_WIDTH;
}

#pragma mark - Layout
- (void)layout {
    [self addSubview:self.bgView];
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.mebiIconImageView];
    [self.contentView addSubview:self.mebiLabel];
    [self.contentView addSubview:self.moreImageView];
    [self.contentView addSubview:self.seperateLine];
    [self.contentView addSubview:self.rechargeBtn];
    [self.contentView addSubview:self.collectionView];
    [self.contentView addSubview:self.pageControl];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(12);
        make.left.equalTo(self.contentView).offset(15);
    }];
    
    [_moreImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_titleLabel);
        make.right.equalTo(_contentView).offset(-20);
        make.size.mas_equalTo(CGSizeMake(5, 10));
    }];
    
    [_mebiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_titleLabel);
        make.right.equalTo(_moreImageView.mas_left).offset(-8);
    }];
    
    [_mebiIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_titleLabel);
        make.right.equalTo(_mebiLabel.mas_left).offset(-7);
        make.size.mas_equalTo(CGSizeMake(19, 19));
    }];
    
    [_seperateLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_contentView);
        make.top.equalTo(_titleLabel.mas_bottom).offset(11.5);
        make.height.equalTo(@0.5);
    }];
    
    [_rechargeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.equalTo(_contentView);
        make.bottom.equalTo(_seperateLine);
        make.left.equalTo(_mebiIconImageView.mas_left).offset(-10.0);
    }];
    
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_contentView);
        make.top.equalTo(_seperateLine.mas_bottom);
        make.height.equalTo(@240);
    }];
    
    [_pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_contentView);
        make.bottom.equalTo(_contentView).offset(- (SafeAreaBottomHeight + 16));
        make.height.equalTo(@7);
    }];
}

- (void)showRechargeView:(ZZGiftModel *)giftModel {
    ZZWeiChatEvaluationModel *model = [[ZZWeiChatEvaluationModel alloc]init];
    model.type = PaymentTypeGift;
    model.source = SourceChat;
    model.mcoinForItem = giftModel ? giftModel.mcoin : -99999;
    
    WeakSelf
    [[ZZPaymentManager shared] buyItemWithPayItem:model in:_parentVC buyComplete:^(BOOL isSuccess, NSString * _Nonnull payType) {
    } rechargeComplete:^(BOOL isSuccess) {
        [ZZUser loadUser:[ZZUserHelper shareInstance].loginerId param:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
            if (error) {
                [ZZHUD showErrorWithStatus:error.message];
            }
            else {
                ZZUser *user = [ZZUser yy_modelWithJSON:data];;
                [[ZZUserHelper shareInstance] saveLoginer:user postNotif:NO];
                
                [ZZUserHelper shareInstance].consumptionMebi = 0;
                [weakSelf updateMebi];
                
                // 假如是直接点击礼物的,在充值之后要直接点击发送
                if (giftModel) {
                    [weakSelf sendGift:giftModel];
                }
            }
        }];
    }];
}

#pragma mark - getters and setters
- (void)setGiftHelper:(ZZGiftHelper *)giftHelper {
    _giftHelper = giftHelper;
    [self configureData];
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:self.bounds];
        _bgView.backgroundColor = UIColor.blackColor;
        _bgView.alpha = 0.0;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideView)];
        [_bgView addGestureRecognizer:tap];
        _bgView.userInteractionEnabled = NO;
    }
    return _bgView;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0.0, self.bottom, self.width, 341 + SafeAreaBottomHeight)];
        _contentView.backgroundColor = UIColor.whiteColor;
    }
    return _contentView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"送点小礼物，增加亲密度";
        _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
        _titleLabel.textColor = RGBCOLOR(63, 58, 58);
    }
    return _titleLabel;
}

- (UIImageView *)mebiIconImageView {
    if (!_mebiIconImageView) {
        _mebiIconImageView = [[UIImageView alloc] init];
        _mebiIconImageView.image = [UIImage imageNamed:@"icMebi"];
    }
    return _mebiIconImageView;
}

- (UILabel *)mebiLabel {
    if (!_mebiLabel) {
        _mebiLabel = [[UILabel alloc] init];
        _mebiLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
        _mebiLabel.textColor = RGBCOLOR(119, 119, 119);
        _mebiLabel.textAlignment = NSTextAlignmentRight;
        
        NSUInteger leftMcoin = [[ZZUserHelper shareInstance].loginer.mcoin integerValue] - [ZZUserHelper shareInstance].consumptionMebi;
        _mebiLabel.text = [NSString stringWithFormat:@"%ld", leftMcoin];
    }
    return _mebiLabel;
}

- (UIImageView *)moreImageView {
    if (!_moreImageView) {
        _moreImageView = [[UIImageView alloc] init];
        _moreImageView.image = [UIImage imageNamed:@"icGengduo_user"];
    }
    return _moreImageView;
}

- (UIView *)seperateLine {
    if (!_seperateLine) {
        _seperateLine = [[UIView alloc] init];
        _seperateLine.backgroundColor = RGBCOLOR(229, 229, 229);
    }
    return _seperateLine;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = UIColor.whiteColor;
        _collectionView.pagingEnabled = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[ZZGiftItemsCell class] forCellWithReuseIdentifier:@"ZZGiftItemCell"];
    }
    return _collectionView;
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.currentPage = 0;
        _pageControl.numberOfPages = 2;
        _pageControl.pageIndicatorTintColor = [kBlackColor colorWithAlphaComponent:0.3];
        _pageControl.currentPageIndicatorTintColor = kGoldenRod;
        _pageControl.userInteractionEnabled = NO;
    }
    return _pageControl;
}

- (UIButton *)rechargeBtn {
    if (!_rechargeBtn) {
        _rechargeBtn = [[UIButton alloc] init];
        _rechargeBtn.backgroundColor = UIColor.clearColor;
        [_rechargeBtn addTarget:self action:@selector(goToRecharge) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rechargeBtn;
}

@end
