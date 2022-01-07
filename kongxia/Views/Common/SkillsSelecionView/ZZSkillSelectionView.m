//
//  ZZSkillSelectionView.m
//  zuwome
//
//  Created by qiming xiao on 2019/4/8.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZSkillSelectionView.h"
#import "ZZPostTaskBasicInfoController.h"
#import "ZZAllTopicsViewController.h"
#import "ZZChooseSkillViewController.h"

#import "ZZSkillsSelectResponseModel.h"

#define kMsg_SkillChoosedNotification @"kMsg_SkillChoosedNotification"
#define kMsg_ShowAllSkillsNotification @"kMsg_ShowAllSkillsNotification"
@interface ZZSkillSelectionView ()

@property (nonatomic, weak) UIViewController *parentViewController;

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) SkillSelectionView *selecionView;

@property (nonatomic, strong) ZZSkillsSelectResponseModel *responesModel;

@property (nonatomic, assign) TaskType taskType;

@end

@implementation ZZSkillSelectionView

+ (instancetype)showsIn:(UIViewController *)viewController taskType:(TaskType)taskType {
    ZZSkillSelectionView *selectionsView = [[ZZSkillSelectionView alloc] initWithTaskType:taskType];
    selectionsView.parentViewController = viewController;
    selectionsView.frame = [UIApplication sharedApplication].keyWindow.bounds;
    
    [[UIApplication sharedApplication].keyWindow addSubview:selectionsView];
    return selectionsView;
}

- (instancetype)initWithTaskType:(TaskType)taskType {
    self = [super init];
    if (self) {
        _taskType = taskType;
        [self fetchContents];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(choosedSkill:) name:kMsg_SkillChoosedNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showAllSkills) name:kMsg_ShowAllSkillsNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)configureTexts {
    if (_taskType == TaskFree) {
        if ([_responesModel.text[@"title"] isKindOfClass:[NSString class]] && !isNullString(_responesModel.text[@"title"])) {
            _selecionView.headerView.titleLabel.text = _responesModel.text[@"title"];
        }
        
        if ([_responesModel.text[@"tips"] isKindOfClass:[NSString class]] && !isNullString(_responesModel.text[@"tips"])) {
            _selecionView.footerView.titleLabel.text = _responesModel.ionic_text;
            _selecionView.footerView.desLabel.text = _responesModel.text[@"tips"];
        }
        
        _selecionView.footerView.desLabel.textColor = HEXCOLOR(0x666666);
        _selecionView.footerView.desLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14.0];
    }
    else {
        if (UserHelper.loginer.gender == 2) {
            _selecionView.headerView.titleLabel.text = _responesModel.text[@"title"];
            _selecionView.footerView.titleLabel.text = _responesModel.ionic_text;
            _selecionView.footerView.desLabel.text = _responesModel.text[@"tips"];
        }
        else {
            _selecionView.headerView.titleLabel.text = _responesModel.text[@"title"];
            _selecionView.footerView.titleLabel.text = _responesModel.ionic_text;
            _selecionView.footerView.desLabel.text = _responesModel.text[@"tips"];
        }
        
        _selecionView.footerView.desLabel.textColor = HEXCOLOR(0x3F3A3A);
        _selecionView.footerView.desLabel.font = CustomFont(14);
    }
}

#pragma mark - Notification Method
- (void)choosedSkill:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    ZZSkill *skill = userInfo[@"skill"];
    [self hide];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self goToPost:skill];
    });
}

#pragma mark Navigator
- (void)goToPost:(ZZSkill *)skill {
    ZZPostTaskBasicInfoController *vc = [[ZZPostTaskBasicInfoController alloc] initWithSkill:skill taskType:_taskType];
    vc.hidesBottomBarWhenPushed = YES;
    [_parentViewController.navigationController pushViewController:vc animated:YES];
}

- (void)showAllSkills {
    [self hide];
    
    if (_taskType == TaskFree) {
        ZZChooseSkillViewController *allSkills = [[ZZChooseSkillViewController alloc] init];
        allSkills.taskType = _taskType;
        if ([_responesModel.text[@"title"] isKindOfClass:[NSString class]] && !isNullString(_responesModel.text[@"title"])) {
            allSkills.title = _responesModel.text[@"title"];
        }
        allSkills.isFromSkillSelectView = YES;
        allSkills.hidesBottomBarWhenPushed = YES;
        [_parentViewController.navigationController pushViewController:allSkills animated:YES];
    }
    else {
        ZZAllTopicsViewController *allTopics = [[ZZAllTopicsViewController alloc] init];
        allTopics.taskType = _taskType;
        if ([_responesModel.text[@"title"] isKindOfClass:[NSString class]] && !isNullString(_responesModel.text[@"title"])) {
            allTopics.title = _responesModel.text[@"title"];
        }
        allTopics.isFromSkillSelectView = YES;
        allTopics.hidesBottomBarWhenPushed = YES;
        [_parentViewController.navigationController pushViewController:allTopics animated:YES];
    }
}

#pragma mark request
- (void)fetchContents {
    NSDictionary *param = @{
                            @"gender" : @(UserHelper.loginer.gender),
                            @"entryType": _taskType == TaskFree ? @2 : @1,
                            @"type": @1,
                            };
    [ZZRequest method:@"GET" path:@"/api/pd/getSkillWriting" params:param next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
        }
        else {
            _responesModel = [[ZZSkillsSelectResponseModel alloc] initWithDictionary:data error:nil];
            [self layout];
            [self configureTexts];
            [self show];
        }
    }];
}

- (void)show {
    [UIView animateWithDuration:0.3 animations:^{
        _bgView.alpha = 0.5;
        CGRect frame = _selecionView.frame;
        frame.origin.y -= 523;
        _selecionView.frame = frame;
    }];
}

- (void)hide {
    [UIView animateWithDuration:0.3 animations:^{
        _bgView.alpha = 0.0;
        CGRect frame = _selecionView.frame;
        frame.origin.y = SCREEN_HEIGHT;
        _selecionView.frame = frame;
    } completion:^(BOOL finished) {
        [_bgView removeFromSuperview];
        [_selecionView removeFromSuperview];
        [self removeFromSuperview];
    }];
}

#pragma mark - Layout
- (void)layout {
    [self addSubview:self.bgView];
    [self addSubview:self.selecionView];
    
    _bgView.frame = [UIApplication sharedApplication].keyWindow.bounds;

    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_selecionView.bounds byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight) cornerRadii:CGSizeMake(10,10)];//圆角大小
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = _selecionView.bounds;
    maskLayer.path = maskPath.CGPath;
    _selecionView.layer.mask = maskLayer;
    
}

#pragma mark getters and setters
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = UIColor.blackColor;
        _bgView.alpha = 0.0;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
        [_bgView addGestureRecognizer:tap];
    }
    return _bgView;
}

- (SkillSelectionView *)selecionView {
    if (!_selecionView) {
        _selecionView = [[SkillSelectionView alloc] initWithSkillsArray:_responesModel.skills frame:CGRectMake(0.0, SCREEN_HEIGHT, SCREEN_WIDTH, 523)];
        [_selecionView.headerView.cancelBtn addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selecionView;
}
@end

#pragma mark - SkillSelectionView
@interface SkillSelectionView ()

@property (nonatomic, copy) NSArray<ZZSkill *> *skillsArray;

@property (nonatomic, strong) SkillItemView *totalBtn;

@end

@implementation SkillSelectionView

- (instancetype)initWithSkillsArray:(NSArray<ZZSkill *> *)skillsArray frame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _skillsArray = skillsArray;
        [self layout];
    }
    return self;
}

- (void)choosed:(UIButton *)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_SkillChoosedNotification
                                                        object:nil
                                                      userInfo:@{@"skill": _skillsArray[sender.tag]}];
}

- (void)choose:(UITapGestureRecognizer *)recognizer {
    SkillItemView *view = (SkillItemView *)recognizer.view;
    [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_SkillChoosedNotification
                                                        object:nil
                                                      userInfo:@{@"skill": view.skill}];
}

- (void)showAllSkills {
    [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_ShowAllSkillsNotification
                                                        object:nil
                                                      userInfo:nil];
}

#pragma mark Layout
- (void)layout {
    self.backgroundColor = UIColor.whiteColor;
    [self addSubview:self.headerView];
    [self addSubview:self.footerView];
    [self addSubview:self.skillsView];
    
    _totalBtn = [[SkillItemView alloc] initWithIsAll:YES];
    _totalBtn.center = CGPointMake(_skillsView.width * 0.5, _skillsView.height * 0.5);
    _totalBtn.bounds = CGRectMake(0.0, 0.0, 73, 95);
    _totalBtn.iconImageView.image = [UIImage imageNamed:@"icQbYaoyue"];
    _totalBtn.titleLabel.text = @"全部";
    
    UITapGestureRecognizer *tapAll = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showAllSkills)];
    [_totalBtn addGestureRecognizer:tapAll];
    [_skillsView addSubview:_totalBtn];
    
    CGFloat radius = 120;
    CGFloat totalAngle = _skillsArray.count > 6 ? 360 : 220;
    CGFloat anglePer = totalAngle / (_skillsArray.count - 1);
    
    for (int i = 0; i < _skillsArray.count; i++) {
        ZZSkill *skill = _skillsArray[i];
        CGFloat angle = anglePer * i;
        if (totalAngle == 220) {
            if (i == 0) {
                angle = 360 - 20;
            }
            else if (i == _skillsArray.count - 1) {
                angle = 180 + 20;
            }
            else {
                angle -= 20;
            }
        }
        
        double x1 = 0  + radius * cos(angle * 3.14 / 180);
        double y1 = 0  + radius * sin(angle * 3.14 / 180);
//        NSLog(@"angle is %f and x is %f, y is %f", angle, x1, y1);
        SkillItemView *itemBtn = [[SkillItemView alloc] initWithIsAll:NO];
        itemBtn.center = CGPointMake(_totalBtn.center.x - x1, _totalBtn.center.y - y1);
        itemBtn.bounds = CGRectMake(0.0, 0.0, 57, 74);
        itemBtn.tag = i;
        itemBtn.skill = skill;
        UITapGestureRecognizer *tapAll = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(choose:)];
        [itemBtn addGestureRecognizer:tapAll];
        [_skillsView addSubview:itemBtn];
    }
    
//    [self addSubview:self.scrollView];
//
//    CGFloat totalHeight = 0.0;
//    for (NSInteger i = 0; i < _skillsArray.count; i++) {
//        CGFloat offsetY = 2.0;
//        CGFloat offsetX = 25.0;
//        CGFloat offsetBottom = 10.0;
//        CGFloat width = SCREEN_WIDTH - offsetX * 2;
//        CGFloat height = 50.0;
//        SkillItemView *skillView = [[SkillItemView alloc] initWithFrame:CGRectMake(offsetX ,
//                                                                           offsetY + (height + offsetBottom) * i,
//                                                                           width,
//                                                                           height)];
//        skillView.skill = _skillsArray[i];
//
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(choose:)];
//        [skillView addGestureRecognizer:tap];
//
//        [_scrollView addSubview:skillView];
//        if (i == _skillsArray.count - 1) {
//            totalHeight += (skillView.frame.origin.y + height);
//        }
//    }
//    totalHeight += 30.0;
//    _scrollView.frame = CGRectMake(0.0, 56.0, SCREEN_WIDTH, totalHeight);
//
//    totalHeight += 56.0;
//    _totalHeight = totalHeight;
}

#pragma mark getters and setters
- (SkillSelectionHeadView *)headerView {
    if (!_headerView) {
        _headerView = [[SkillSelectionHeadView alloc] initWithFrame:CGRectMake(0.0, 0.0, [UIApplication sharedApplication].keyWindow.bounds.size.width, 77.0)];
    }
    return _headerView;
}

- (SkillSelectionFooterView *)footerView {
    if (!_footerView) {
        _footerView = [[SkillSelectionFooterView alloc] initWithFrame:CGRectMake(0.0, self.height - 102, self.width, 102)];
    }
    return _footerView;
}

- (UIView *)skillsView {
    if (!_skillsView) {
        _skillsView = [[UIView alloc] initWithFrame:CGRectMake(SCALE_SET(20.0), _headerView.bottom + SCALE_SET(20.0), self.width - SCALE_SET(20.0) * 2, _footerView.top - _headerView.bottom - SCALE_SET(20.0) * 2)];
    }
    return _skillsView;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
    }
    return _scrollView;
}

@end

#pragma mark - SkillSelectionHeadView
@interface SkillSelectionHeadView ()

@end

@implementation SkillSelectionHeadView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self layout];
    }
    return self;
}

#pragma mark Layout
- (void)layout {
    [self addSubview:self.cancelBtn];
    [self addSubview:self.titleLabel];
    
    CGFloat titleWidth = self.width - 40;
    _titleLabel.frame = CGRectMake(15, self.height - 42, titleWidth, 42);

    _cancelBtn.frame = CGRectMake(self.width - 15 - 40, _titleLabel.height * 0.5 - self.frame.size.height * 0.5 + _titleLabel.top, 40, self.frame.size.height);
}

#pragma mark getters and setters
- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [[UIButton alloc] init];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:RGBCOLOR(63, 58, 58) forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = CustomFont(14);
    }
    return _cancelBtn;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"邀请达人做什么？";
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont boldSystemFontOfSize:27.0];
    }
    return _titleLabel;
}

@end

@interface SkillSelectionFooterView ()

@end

@implementation SkillSelectionFooterView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self layout];
    }
    return self;
}

- (void)layout {
    [self addSubview:self.titleLabel];
    [self addSubview:self.titleImageView];
    [self addSubview:self.desLabel];
    
    CGFloat titleWidth = [NSString findWidthForText:_titleLabel.text havingWidth:self.width andFont:_titleLabel.font];
    _titleLabel.frame = CGRectMake(self.width * 0.5 - titleWidth * 0.5, 0.0, titleWidth, _titleLabel.font.lineHeight);
    
    _desLabel.frame = CGRectMake(15.0, _titleLabel.bottom + 10.0, self.width - 15.0 * 2, 40);
}

#pragma mark - getters and setters
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"";
        _titleLabel.textColor = RGBCOLOR(153, 153, 153);
        _titleLabel.font = CustomFont(14);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.hidden = YES;
    }
    return _titleLabel;
}

- (UIImageView *)titleImageView {
    if (!_titleImageView) {
        _titleImageView = [[UIImageView alloc] init];

    }
    return _titleImageView;
}

- (UILabel *)desLabel {
    if (!_desLabel) {
        _desLabel = [[UILabel alloc] init];
        _desLabel.text = @"Tips: 选择技能， 达人看到您发布的通告后会主动报名，您就越能够快速找到合适的达人进行本次通告 ，可随时取消";
        _desLabel.textColor = HEXCOLOR(0x3F3A3A);
        _desLabel.font = CustomFont(14);
        _desLabel.textAlignment = NSTextAlignmentCenter;
        _desLabel.numberOfLines = 3;
    }
    return _desLabel;
}

@end

#pragma mark - SkillItemView
@interface SkillItemView ()

@property (nonatomic, assign) BOOL isAll;

@end

@implementation SkillItemView

- (instancetype)initWithIsAll:(BOOL)isAll {
    self = [super init];
    if (self) {
        _isAll = isAll;
        [self layout];
    }
    return self;
}

- (void)configureData {
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:_skill.selected_img]];
    _titleLabel.text = _skill.name;
}

#pragma mark Layout
- (void)layout {
//    self.layer.cornerRadius = 3.0;
    
//    self.layer.shadowColor = RGBCOLOR(198, 198, 198).CGColor;//shadowColor阴影颜色
//    self.layer.shadowOffset = CGSizeMake(0,1);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
//    self.layer.shadowOpacity = 0.5;//阴影透明度，默认0
//    self.layer.shadowRadius = 3;//阴影半径，默认3
    
    [self addSubview:self.iconImageView];
    [self addSubview:self.titleLabel];
    
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        if (_isAll) {
            make.size.mas_equalTo(CGSizeMake(73, 73));
        }
        else {
            make.size.mas_equalTo(CGSizeMake(57, 57));
        }
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_iconImageView);
        make.left.right.equalTo(_iconImageView);
        make.top.equalTo(_iconImageView.mas_bottom);
        make.bottom.equalTo(self);
    }];

}

#pragma mark getters and setters
- (void)setSkill:(ZZSkill *)skill {
    _skill = skill;
    [self configureData];
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _iconImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"选择通告主题";
        _titleLabel.textColor = RGBCOLOR(102, 102, 102);
        if (_isAll) {
            _titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
        }
        else {
            _titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12];
        }
        
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

@end
