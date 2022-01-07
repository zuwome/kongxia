//
//  ZZRightShareView.m
//  zuwome
//
//  Created by angBiu on 16/5/17.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZRightShareView.h"

#import "ZZReportViewController.h"
#import "ZZUserHelper.h"

#import <UMSocialCore/UMSocialCore.h>

typedef NS_ENUM(NSInteger, ShareItemType) {
    ShareItemTypeWechatMoment,
    ShareItemTypeWechat,
    ShareItemTypeQQ,
    ShareItemTypeSina,
    ShareItemTypeReport,
    ShareItemTypeDelete,
    ShareItemTypeNotInterested,
    ShareItemTypeBlackList,
    ShareItemTypeGotBanned,
};

@implementation ZZRightCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont systemFontOfSize:11];
        [self.contentView addSubview:_titleLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-15);
            make.left.right.mas_equalTo(self.contentView);
            make.height.mas_equalTo(@20);
        }];
        
        _imgView = [[UIImageView alloc] init];
        _imgView.contentMode = UIViewContentModeBottom;
        [self.contentView addSubview:_imgView];
        
        [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(_titleLabel.mas_top).offset(-14);
            make.left.right.mas_equalTo(self.contentView);
            make.height.mas_equalTo(@35);
        }];
    }
    
    return self;
}

@end

@implementation ZZRightShareView
{
    UIView              *_bgView;
    UIButton            *_bgBtn;
    UIViewController    *_shareViewController;
    NSArray<NSNumber *>  *itemTypeArray;
}

- (instancetype)initWithFrame:(CGRect)frame withController:(UIViewController *)ctl shouldShowNotIntersted:(BOOL)shouldShowNotIntersted blackList:(BOOL)blackList isBanned:(BOOL)isBanned {
    self = [super initWithFrame:frame];
    
    if (self) {
        _shouldShowNotIntersted = shouldShowNotIntersted;
        _shouldAddToBlackList = blackList;
        _shareViewController = ctl;
        _isBanned = isBanned;
        _itemCount = 5;
        
        _bgBtn = [[UIButton alloc] initWithFrame:frame];
        _bgBtn.backgroundColor = [UIColor blackColor];
        [_bgBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_bgBtn];
        
        CGFloat width = SCREEN_WIDTH/4.0 - 0.1;
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-SafeAreaBottomHeight, SCREEN_WIDTH, 186+50+SafeAreaBottomHeight)];
        _bgView.backgroundColor = [UIColor clearColor];
        [self addSubview:_bgView];
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(width, 88);
        flowLayout.sectionInset = UIEdgeInsetsMake(5, 0, 5, 0);
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 186) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[ZZRightCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        [_bgView addSubview:_collectionView];
        
        UIButton *cancelBtn = [[UIButton alloc] init];
        [cancelBtn setTitle:@"取 消" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
        cancelBtn.backgroundColor = [UIColor whiteColor];
        [_bgView addSubview:cancelBtn];
        _bgView.backgroundColor = [UIColor whiteColor];
        [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(_bgView);
            make.height.mas_equalTo(50+SafeAreaBottomHeight);
        }];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = kLineViewColor;
        [_bgView addSubview:lineView];
        
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(_bgView);
            make.bottom.mas_equalTo(cancelBtn.mas_top);
            make.height.mas_equalTo(@0.5);
        }];
        [self createTypesArray];
        [self viewUp];
        
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame withController:(UIViewController *)ctl
{
    self = [super initWithFrame:frame];
    
    if (self) {
        _shareViewController = ctl;
        _itemCount = 5;
        
        _bgBtn = [[UIButton alloc] initWithFrame:frame];
        _bgBtn.backgroundColor = [UIColor blackColor];
        [_bgBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_bgBtn];
        
        CGFloat width = SCREEN_WIDTH/4.0 - 0.1;
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-SafeAreaBottomHeight, SCREEN_WIDTH, 186+50+SafeAreaBottomHeight)];
        _bgView.backgroundColor = [UIColor clearColor];
        [self addSubview:_bgView];
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(width, 88);
        flowLayout.sectionInset = UIEdgeInsetsMake(5, 0, 5, 0);
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 186) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[ZZRightCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        [_bgView addSubview:_collectionView];
        
        UIButton *cancelBtn = [[UIButton alloc] init];
        [cancelBtn setTitle:@"取 消" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
        cancelBtn.backgroundColor = [UIColor whiteColor];
        [_bgView addSubview:cancelBtn];
        _bgView.backgroundColor = [UIColor whiteColor];
        [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(_bgView);
            make.height.mas_equalTo(50+SafeAreaBottomHeight);
        }];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = kLineViewColor;
        [_bgView addSubview:lineView];
        
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(_bgView);
            make.bottom.mas_equalTo(cancelBtn.mas_top);
            make.height.mas_equalTo(@0.5);
        }];
        [self createTypesArray];
        [self viewUp];
    }
    
    return self;
}

- (void)createTypesArray {
    NSMutableArray *items = @[].mutableCopy;
    [items addObject:@(ShareItemTypeWechatMoment)];
    [items addObject:@(ShareItemTypeWechat)];
    [items addObject:@(ShareItemTypeQQ)];
    [items addObject:@(ShareItemTypeSina)];
    
    if (_showDelete) {
        [items addObject:@(ShareItemTypeDelete)];
    }
    else {
        [items addObject:@(ShareItemTypeReport)];
    }
    
    if (_shouldShowNotIntersted) {
        [items addObject:@(ShareItemTypeNotInterested)];
    }
    
    if (_shouldAddToBlackList) {
        [items addObject:@(ShareItemTypeBlackList)];
    }
    itemTypeArray = items.copy;
    
    [_collectionView reloadData];
}

- (void)setItemCount:(NSInteger)itemCount
{
    if (itemCount != _itemCount) {
        _itemCount = itemCount;
        [self createTypesArray];
//        [_collectionView reloadData];
        NSInteger maxCount = 5;
        if (_showDelete) {
            maxCount = 4;
        }
        
        if (itemCount < maxCount) {
            _collectionView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 98);
            _bgView.height = 96+50;
        } else {
            _collectionView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 186);
            _bgView.height = 186+50+SafeAreaBottomHeight;
        }
        _bgView.top = SCREEN_HEIGHT - _bgView.height ;
    }
    else {
        [self createTypesArray];
    }
}

#pragma mark - UICollectionViewMethod

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return itemTypeArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZZRightCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    ShareItemType type = (ShareItemType)[itemTypeArray[indexPath.row] integerValue];
    switch (type) {
        case ShareItemTypeWechatMoment: {
            cell.imgView.image = [UIImage imageNamed:@"btn_share_wxTimeline"];
            cell.titleLabel.text = @"朋友圈";
            break;
        }
        case ShareItemTypeWechat: {
            cell.imgView.image = [UIImage imageNamed:@"btn_share_wxSession"];
            cell.titleLabel.text = @"微信";
            break;
        }
        case ShareItemTypeQQ: {
            cell.imgView.image = [UIImage imageNamed:@"btn_share_QQ"];
            cell.titleLabel.text = @"QQ";
            break;
        }
        case ShareItemTypeSina: {
            cell.imgView.image = [UIImage imageNamed:@"btn_share_sina"];
            cell.titleLabel.text = @"微博";
            break;
        }
        case ShareItemTypeDelete: {
            cell.imgView.image = [UIImage imageNamed:@"btn_delete"];
            cell.titleLabel.text = @"删除";
            break;
        }
        case ShareItemTypeReport: {
            cell.imgView.image = [UIImage imageNamed:@"btn_report"];
            cell.titleLabel.text = @"举报";
            break;
        }
        case ShareItemTypeNotInterested: {
            cell.imgView.image = [UIImage imageNamed:@"icBuganxingqu"];
            cell.titleLabel.text = @"不感兴趣";
            break;
        }
        case ShareItemTypeBlackList: {
            cell.imgView.image = _isBanned ? [UIImage imageNamed:@"ic_quxiaolahei"] : [UIImage imageNamed:@"icLahei"];
            cell.titleLabel.text = _isBanned ? @"取消拉黑" : @"拉黑";
            break;
        }
        default:
            break;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    UMShareWebpageObject *webObject = [UMShareWebpageObject shareObjectWithTitle:_shareTitle descr:_shareContent thumImage:[NSString stringWithFormat:@"%@?imageView2/1/q/45",_userImgUrl]];
    webObject.webpageUrl = _shareUrl;
    messageObject.shareObject = webObject;
    
    if (_shareImg) {
        NSData *imgData = [ZZUtils imageWithImage:_shareImg scaledToSize:_shareImg.size];
        
        NSLog(@"%ld",imgData.length/1024);
        _shareImg = [UIImage imageWithData:imgData];
        webObject.thumbImage = _shareImg;
    }
    
    _clickDelete = NO;
    __weak typeof(self)weakSelf = self;
    
    ShareItemType type = (ShareItemType)[itemTypeArray[indexPath.row] integerValue];
    switch (type) {
        case ShareItemTypeWechatMoment: {
            _type = RightShareTypeWXTimeline;
            
            [[UMSocialManager defaultManager] shareToPlatform:UMSocialPlatformType_WechatTimeLine messageObject:messageObject currentViewController:_shareViewController completion:^(id result, NSError *error) {
                if (!error) {
                    [MobClick event:Event_share_to_friendcircle];
                    if (weakSelf.successCallBack) {
                        weakSelf.successCallBack(result);
                    }
                }
            }];
            break;
        }
        case ShareItemTypeWechat: {
            _type = RightShareTypeWXSession;
            
            [[UMSocialManager defaultManager] shareToPlatform:UMSocialPlatformType_WechatSession messageObject:messageObject currentViewController:_shareViewController completion:^(id result, NSError *error) {
                if (!error) {
                    [MobClick event:Event_share_to_wechat];
                    if (weakSelf.successCallBack) {
                        weakSelf.successCallBack(result);
                    }
                }
            }];
            break;
        }
        case ShareItemTypeQQ: {
            _type = RightShareTypeQQ;
            
            [[UMSocialManager defaultManager] shareToPlatform:UMSocialPlatformType_QQ messageObject:messageObject currentViewController:_shareViewController completion:^(id result, NSError *error) {
                if (!error) {
                    [MobClick event:Event_share_to_qq];
                    if (weakSelf.successCallBack) {
                        weakSelf.successCallBack(result);
                    }
                }
            }];
            break;
        }
        case ShareItemTypeSina: {
            _type = RightShareTypeSina;
            
            webObject.descr = [NSString stringWithFormat:@"%@  >>> %@",_shareContent,_shareUrl];
            messageObject.shareObject = webObject;
            
            [[UMSocialManager defaultManager] shareToPlatform:UMSocialPlatformType_Sina messageObject:messageObject currentViewController:_shareViewController completion:^(id result, NSError *error) {
                if (!error) {
                    [MobClick event:Event_share_to_weibo];
                    if (weakSelf.successCallBack) {
                        weakSelf.successCallBack(result);
                    }
                }
            }];
            break;
        }
        case ShareItemTypeDelete: {
            if (![ZZUserHelper shareInstance].isLogin) {
                [self gotoLoginView];
                return;
            }
            _clickDelete = YES;
            if (_touchDelete) {
                NSLog(@"PY_删除视屏");
                _touchDelete();
            }
            
            break;
        }
        case ShareItemTypeReport: {
            _type = RightShareTypeReport;
            ZZReportViewController *controller = [[ZZReportViewController alloc] init];
            controller.isUser = _isUser;
            controller.uid = _uid;
            controller.mid = _mid;
            controller.skId = _skId;
            ZZNavigationController *navCtl = [[ZZNavigationController alloc] initWithRootViewController:controller];
            [_shareViewController.navigationController presentViewController:navCtl animated:YES completion:NULL];
            break;
        }
        case ShareItemTypeNotInterested: {
            if (![ZZUserHelper shareInstance].isLogin) {
                [self gotoLoginView];
                return;
            }
            
            if (_shouldShowNotIntersted) {
                if (_touchNotIntersted) {
                    _touchNotIntersted();
                }
            }
            break;
        }
        case ShareItemTypeBlackList: {
            if (![ZZUserHelper shareInstance].isLogin) {
                [self gotoLoginView];
                return;
            }
            
            if (_shouldAddToBlackList) {
                if (_touchBlackList) {
                    _touchBlackList();
                }
            }
            break;
        }
        default:
            break;
    }
    [self cancelBtnClick];
}

- (void)gotoLoginView
{
    [self cancelBtnClick];
      NSLog(@"PY_登录界面%s",__func__);
    [[LoginHelper sharedInstance] showLoginViewIn:_shareViewController];
}

#pragma mark - UIButtonMethod

- (void)viewUp
{
    _bgBtn.alpha = 0.5;
    [UIView animateWithDuration:0.3 animations:^{
        _bgView.top = SCREEN_HEIGHT - _bgView.height ;
    }];
}

- (void)show
{
    self.hidden = NO;
    [self viewUp];
}

- (void)cancelBtnClick
{
    _bgBtn.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        _bgView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, _bgView.height);
    } completion:^(BOOL finished) {
        self.hidden = YES;
        if (!_clickDelete) {
            if (_touchCancel) {
                _touchCancel();
            }
        }
        _clickDelete = NO;
    }];
}

@end
