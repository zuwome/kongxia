//
//  ZZVideoAppraiseVC.m
//  zuwome
//
//  Created by YuTianLong on 2017/12/25.
//  Copyright © 2017年 TimoreYu. All rights reserved.
//

#import "ZZVideoAppraiseVC.h"
#import "ZZStarsView.h"
#import "WBSearchHeaderView.h"
#import "DKInputTextView.h"
#import "ZZVideoAppraiseCollectionViewCell.h"

@interface ZZVideoAppraiseVC () <ZZStarsViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) ZZStarsView *starView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UILabel *infoLabel;
@property (nonatomic, strong) UIButton *appraiseButton;//匿名评价
@property (nonatomic, assign) BOOL isFirstClick;//第一次点击星星

@property (nonatomic, strong) NSDictionary *allComments;//所有的评论按钮选项

@property (nonatomic, strong) DKInputTextView *textView;
@property (nonatomic, strong) NSMutableArray<NSString *> *evaluateOptions;//选中的评价选项

@end

@implementation ZZVideoAppraiseVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor clearColor];
    
    // 监听键盘调起
    BIND_MSG_WITH_OBSERVER(self, UIKeyboardWillShowNotification, @selector(beginLeaveMessage:), nil);

    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Getter

- (NSDictionary *)allComments {
    if (!_allComments) {
        /*格式
         "1":["迟到","提早离开","心不在焉","一直玩手机","大量额外消费","本人与资料不符"],
         "2":["迟到","提早离开","心不在焉","玩手机","额外消费","本人与资料不符"],
         ...
         */
        _allComments = [ZZUserHelper shareInstance].configModel.link_mic_comments;
        
//        _allComments = @{
//            @"1":@[@"没共同话题",@"提早离开2",@"心不在焉3",@"一直玩手机",@"大量外消费",@"资料不符"],
//            @"2":@[@"迟到",@"提早离开",@"心不在焉",@"玩手机",@"额外消费",@"本人与资料不符"],
//            @"3":@[@"迟到",@"提早离开",@"心不在焉",@"没共同话题",@"玩手机",@"额外消费",@"本人与资料一致"],
//            @"4":@[@"迟到",@"提早离开",@"心不在焉",@"共同话题少",@"玩手机",@"额外消费",@"本人与资料一致"],
//            @"5":@[@"准时",@"气质好",@"态度非常好",@"很健谈",@"形象佳"]
//            };
    }
    return _allComments;
}

- (DKInputTextView *)textView {
    if (!_textView) {
        _textView = [[DKInputTextView alloc] init];
        _textView.placeholder = @"给对方留下一个好的评价";
        _textView.textMaxLenght = 40;
        _textView.backgroundColor = RGBCOLOR(245, 245, 246);
        _textView.layer.masksToBounds = YES;
        _textView.layer.cornerRadius = 4.0f;
        _textView.layer.borderColor = RGBCOLOR(216, 216, 216).CGColor;
        _textView.layer.borderWidth = 0.5f;
    }
    return _textView;
}

- (NSMutableArray<NSString *> *)evaluateOptions {
    if (!_evaluateOptions) {
        _evaluateOptions = [NSMutableArray new];
    }
    return _evaluateOptions;
}

#pragma mark - Private

- (void)setupUI {
    
    self.isFirstClick = YES;
    
    // 用于收回键盘手势
    UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(takeKeyboardClick:)];
    UIView *viewTransparent = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT / 2.0f)];;
    viewTransparent.backgroundColor = [UIColor clearColor];
    [viewTransparent addGestureRecognizer:tapGesture1];
    [self.view addSubview:viewTransparent];

    UITapGestureRecognizer *tapGesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(takeKeyboardClick:)];

    // 白色容器背景
    self.bgView = [UIView new];
    self.bgView.backgroundColor = [UIColor whiteColor];
    self.bgView.userInteractionEnabled = YES;
    self.bgView.frame = CGRectMake(0, SCREEN_HEIGHT - 248 - SafeAreaBottomHeight, SCREEN_WIDTH, 248 + SafeAreaBottomHeight);
    [self.bgView addGestureRecognizer:tapGesture2];
    [self.view addSubview:self.bgView];

    UIView *headerView = [self createHeaderView];
    
    [self.bgView addSubview:headerView];
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(@0);
        make.height.equalTo(@54);
    }];
    
    // 五星 UI
    CGFloat width = 25;
    CGFloat offset = 15;
    CGFloat viewWidth = width + 4 * (width+offset);
    _starView = [[ZZStarsView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - viewWidth) / 2.0f, headerView.height + 16, viewWidth, 30)];
    _starView.starWidth = width;
    _starView.starOffset = offset;
    _starView.delegate = self;
    _starView.numberOfStars = 5;

    [self.bgView addSubview:_starView];
    
    // Tips UI
    self.infoLabel = [UILabel new];
    self.infoLabel.text = @"您的评价会让TA做的更好";
    self.infoLabel.textColor = RGBCOLOR(244, 203, 7);
    self.infoLabel.textAlignment = NSTextAlignmentCenter;
    self.infoLabel.font = [UIFont systemFontOfSize:13];
    self.infoLabel.frame = CGRectMake(10, _starView.mj_y + _starView.height + 6, SCREEN_WIDTH - 20, 20);

    [self.bgView addSubview:self.infoLabel];
    
    // 设置多选button
//    [self setupInputView];
    [self setupCollectionView];
    
    // 设置输入框
    [self setupInputTextView];
    
    self.appraiseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.appraiseButton setTitle:@"匿名评价" forState:UIControlStateNormal];
    [self.appraiseButton setTitleColor:kBlackColor forState:UIControlStateNormal];
    self.appraiseButton.backgroundColor = RGBCOLOR(216, 216, 216);
    self.appraiseButton.enabled = NO;
    self.appraiseButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.appraiseButton addTarget:self action:@selector(appraiseClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:self.appraiseButton];
    [self.appraiseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(@0);
        make.height.equalTo(@(50 + SafeAreaBottomHeight));
    }];
}

- (UIView *)createHeaderView {
    UIView *view = [UIView new];
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 54);
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = @"1V1视频评价";
    titleLabel.font = [UIFont systemFontOfSize:17];
    titleLabel.textColor = kBlackColor;
    titleLabel.textAlignment = NSTextAlignmentCenter;

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"icEvaluateClose"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(cancelClick:) forControlEvents:UIControlEventTouchUpInside];
    [button sizeToFit];
    
    UIView *lineView = [UIView new];
    lineView.backgroundColor = RGBCOLOR(245, 245, 245);

    [view addSubview:titleLabel];
    [view addSubview:button];
    [view addSubview:lineView];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view.mas_centerY);
        make.centerX.equalTo(view.mas_centerX);
        make.height.equalTo(@20);
    }];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titleLabel.mas_centerY);
        make.trailing.equalTo(@(-10));
        make.width.height.equalTo(@40);
    }];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(@0);
        make.height.equalTo(@1);
    }];
    return view;
}

- (void)setupCollectionView {

    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    if (ISiPhone5) {
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(20, self.infoLabel.mj_y + self.infoLabel.height + 15, SCREEN_WIDTH - 40, 84) collectionViewLayout:layout];
    } else {
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(30, self.infoLabel.mj_y + self.infoLabel.height + 15, SCREEN_WIDTH - 60, 84) collectionViewLayout:layout];
    }
    [_collectionView registerClass:[ZZVideoAppraiseCollectionViewCell class] forCellWithReuseIdentifier:[ZZVideoAppraiseCollectionViewCell reuseIdentifier]];
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.alpha = 0.0;
    
    [self.bgView addSubview:self.collectionView];
}

// 设置输入框
- (void)setupInputTextView {
    
    CGFloat x = ISiPhone5 ? 25 : 40;
    CGFloat y = self.collectionView.mj_y + self.collectionView.height + 14;
    CGFloat width = SCREEN_WIDTH - 2 * x;
    self.textView.frame = CGRectMake(x , y, width, 50);
    self.textView.alpha = 0.0f;
    [self.bgView addSubview:self.textView];
}

- (void)updateInputViewContent {
    
    [self.view endEditing:YES];
    // 初始化数组
    self.evaluateOptions = [NSMutableArray new];
    
    [self.collectionView reloadData];
}

- (void)addEvaluateOptionsIfNeededWithValue:(NSString *)value {
    
    if ([self.evaluateOptions indexOfObject:value] == NSNotFound) {
        [self.evaluateOptions addObject:value];
        [self.collectionView reloadData];
        return ;
    }
    [self.evaluateOptions removeObject:value];
    [self.collectionView reloadData];
}


- (IBAction)cancelClick:(UIButton *)sender {
    self.view.userInteractionEnabled = NO;
    BLOCK_SAFE_CALLS(self.cancelBlock);
}

- (IBAction)appraiseClick:(UIButton *)sender {
 
//    NSLog(@"%@", self.evaluateOptions);
//    [ZZHUD showWithStatus:@"评价成功"];
//    WEAK_SELF();
//    [NSObject asyncWaitingWithTime:2.0f completeBlock:^{
//        BLOCK_SAFE_CALLS(weakSelf.cancelBlock);
//    }];
    
    self.view.userInteractionEnabled = NO;
    [MobClick event:Event_click_Video_Appraise];
    WEAK_SELF();
    [ZZHUD showWithStatus:@""];
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setObject:[NSString stringWithFormat:@"%d", (int)self.starView.currentScore] forKey:@"score"];
    [dict setObject:self.evaluateOptions forKey:@"content"];
    [dict setObject:isNullString(self.textView.text) ? @"" : self.textView.text forKey:@"feeling"];
    if (!isNullString(_oid)) {
        [dict setObject:_oid forKey:@"oid"];
    }
    
    [ZZRequest method:@"POST" path:[NSString stringWithFormat:@"/api/room/%@/comment", _roomId] params:dict next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
        } else {
            [ZZHUD showSuccessWithStatus:@"评价成功"];
        }
        [NSObject asyncWaitingWithTime:1.0f completeBlock:^{
            weakSelf.view.userInteractionEnabled = YES;
            BLOCK_SAFE_CALLS(weakSelf.commentsSuccessBlock);
        }];
    }];
}

- (void)takeKeyboardClick:(UITapGestureRecognizer*)gesu {
    [self.view endEditing:YES];
}

- (void)notificationLeaveMessage:(CGFloat)keyboardHeight {
    CGFloat height = 354 + SafeAreaBottomHeight;
    
    WEAK_SELF();
    [UIView animateWithDuration:0.4 animations:^{
        weakSelf.bgView.mj_y = keyboardHeight == 0.0 ?
        (SCREEN_HEIGHT - height) :
        (SCREEN_HEIGHT - height - keyboardHeight + 45);
    } completion:^(BOOL finished) {
    }];
}

#pragma mark - Keyboard Notification methods

- (void)beginLeaveMessage:(NSNotification *)aNotification {
    //监听收起键盘
    BIND_MSG_WITH_OBSERVER(self, UIKeyboardWillHideNotification, @selector(endLeaveMessage:), nil);
    NSDictionary *userInfo = [aNotification userInfo];
    CGRect keyboardRect = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat height = keyboardRect.size.height;
    [self notificationLeaveMessage:height];
}

- (void)endLeaveMessage:(NSNotification *)aNotification {
    REMOVE_MSG(UIKeyboardWillHideNotification);
    [self notificationLeaveMessage:0.0];
}

#pragma mark - ZZStarsViewDelegate methods

- (void)starsView:(ZZStarsView *)starsView currentScore:(CGFloat)currentScore
{
    int score = (int)currentScore;
    switch (score) {
        case 1:
        {
            _infoLabel.text = @"态度很差，体验不好，与真人不符";
        }
            break;
        case 2:
        {
            _infoLabel.text = @"态度较差，影响体验";
        }
            break;
        case 3:
        {
            _infoLabel.text = @"态度一般，体验一般";
        }
            break;
        case 4:
        {
            _infoLabel.text = @"态度很棒，体验很赞";
        }
            break;
        case 5:
        {
            _infoLabel.text = @"态度超级棒，体验超级好";
        }
            break;
        default:
            break;
    }
    
    // 更新评价选项按钮
    [self updateInputViewContent];

    // 第一次点击星星，动画及偏移量
    if (self.isFirstClick) {
        self.isFirstClick = NO;
        
        self.appraiseButton.backgroundColor = RGBCOLOR(244, 203, 7);
        self.appraiseButton.enabled = YES;
        
        WEAK_SELF();
        // 计算一个合适的高度
        CGFloat height = 354 + SafeAreaBottomHeight;
        [UIView animateWithDuration:0.4 animations:^{
            weakSelf.bgView.frame = CGRectMake(0, SCREEN_HEIGHT - height, SCREEN_WIDTH, height);

        } completion:^(BOOL finished) {
            weakSelf.collectionView.alpha = 1.0f;
            weakSelf.textView.alpha = 1.0f;
        }];
    }
}

- (NSArray<NSString *> *)currentDataSource {
    NSString *key = [NSString stringWithFormat:@"%d", (int)self.starView.currentScore];
    NSArray<NSString *> *values = [self.allComments objectForKey:key];
    return values;
}

#pragma mark - UICollectionViewDataSource methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self currentDataSource].count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    WEAK_SELF();
    ZZVideoAppraiseCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[ZZVideoAppraiseCollectionViewCell reuseIdentifier] forIndexPath:indexPath];
    [cell setupWithString:[self currentDataSource][indexPath.row]];
    cell.isSelect = [self.evaluateOptions indexOfObject:[self currentDataSource][indexPath.row]] != NSNotFound;
    [cell setSelectItemBlock:^{
        [weakSelf addEvaluateOptionsIfNeededWithValue:[weakSelf currentDataSource][indexPath.row]];
    }];
    return cell;;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(collectionView.width / 3.0f, 42);
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

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self addEvaluateOptionsIfNeededWithValue:[self currentDataSource][indexPath.row]];
}

@end
