//
//  ZZActivityUserInfoCell.m
//  zuwome
//
//  Created by qiming xiao on 2019/4/24.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZActivityUserInfoCell.h"
#import "ZZHeadImageView.h"
#import "ZZLevelImgView.h"
#import "ZZTaskModel.h"
#import "ZZDateHelper.h"
#import "kongxia-Swift.h"

@interface ZZActivityUserInfoCell ()

@property (nonatomic, strong) ZZHeadImageView *headView;

@property (nonatomic, strong) UIImageView *freeImageView;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *createTimeLabel;

@property (nonatomic, strong) UIImageView *genderImageView;

@property (nonatomic, strong) UIImageView *verifyImageView;

@property (nonatomic, strong) ZZLevelImgView *levelImageView;

@property (nonatomic, strong) UIImageView *sinaVerifyImageView;

@property (nonatomic, strong) UILabel *introduceLabel;

@end

@implementation ZZActivityUserInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self layout];
    }
    return self;
}

- (void)showMore {
    if (self.delegate && [self.delegate respondsToSelector:@selector(cell:showMoreAction:)]) {
        [self.delegate cell:self showMoreAction:(TaskUserInfoItem *)_item];
    }
}

- (void)showUserInfo {
    if (_item.task.task.is_anonymous != 2) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(cell:activityShowUserInfoWith:)]) {
            [self.delegate cell:self activityShowUserInfoWith:self.item];
        }
    }
}

- (void)configureData {
    if (_item.taskType == TaskFree && _item.task.task.isMine && !(_item.task.task.taskStatus == TaskOngoing || _item.task.task.taskStatus == TaskReviewing)) {
        _headView.alpha = 0.6;
        _nameLabel.alpha = 0.6;
        _genderImageView.alpha = 0.6;
        _levelImageView.alpha = 0.6;
        _createTimeLabel.alpha = 0.6;
        _sinaVerifyImageView.alpha = 0.6;
        _introduceLabel.alpha = 0.6;
        _verifyImageView.alpha = 0.6;
    }
    else {
        _headView.alpha = 1.0;
        _nameLabel.alpha = 1.0;
        _genderImageView.alpha = 1.0;
        _levelImageView.alpha = 1.0;
        _createTimeLabel.alpha = 1.0;
        _sinaVerifyImageView.alpha = 1.0;
        _introduceLabel.alpha = 1.0;
        _verifyImageView.alpha = 1.0;
    }
    
    if (_item.taskType == TaskFree && _item.listType == ListAll) {
        _freeImageView.hidden = NO;
    }
    else {
        _freeImageView.hidden = YES;
    }
    
    [self layoutFrames];
    
    [_headView setUser:_item.task.from anonymousAvatar:_item.task.task.anonymous_avatar width:60.0 vWidth:12];
    _nameLabel.text = _item.task.from.nickname;
    
    // 性别
    if (_item.task.from.gender == 2) {
        _genderImageView.image = [UIImage imageNamed:@"girl"];
    }
    else if (_item.task.from.gender == 1) {
        _genderImageView.image = [UIImage imageNamed:@"boy"];
    }
    else {
        _genderImageView.image = [UIImage imageNamed:@""];
    }
    
    [_levelImageView setLevel:_item.task.from.level];
    
    if (_item.task.task.isMine) {
        [_createTimeLabel setHidden:NO];
        _createTimeLabel.text = [ZZDateHelper localTime:_item.task.task.created_at];
    }
    else {
        [_createTimeLabel setHidden:YES];
    }
    
        _sinaVerifyImageView.hidden = YES;
        [_introduceLabel setHidden:YES];
}

#pragma mark - Layout
- (void)layout {
    self.backgroundColor = ColorClear;
    
    [self.contentView addSubview:self.headView];
    [self.contentView addSubview:self.freeImageView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.genderImageView];
    [self.contentView addSubview:self.verifyImageView];
    [self.contentView addSubview:self.levelImageView];
    
    [self.contentView addSubview:self.createTimeLabel];
    [self.contentView addSubview:self.sinaVerifyImageView];
    [self.contentView addSubview:self.introduceLabel];
}

- (void)layoutFrames {
    _headView.frame = CGRectMake(15.0, 15.0, 60.0, 60.0);
    _freeImageView.frame = CGRectMake(SCREEN_WIDTH - 6 - 88.5, 21.0, 86, 47.0);
    CGFloat width = [NSString findWidthForText:_item.task.from.nickname havingWidth:150 andFont:_nameLabel.font];
    _nameLabel.frame = CGRectMake(_headView.right + 8, 23.0, width, _nameLabel.font.lineHeight);
    
    // 性别
    if (_item.task.from.gender == 2 || _item.task.from.gender == 1) {
        _genderImageView.frame = CGRectMake(_nameLabel.right + 8.0,
                                            _nameLabel.height * 0.5 - 6 + _nameLabel.top,
                                            12,
                                            12);
    }
    else {
        _genderImageView.frame = CGRectMake(_nameLabel.right,
                                            _nameLabel.height * 0.5 - 6 + _nameLabel.top,
                                            0.0,
                                            0.0);
    }
    
    // 认证
    if ([_item.task.from isIdentifierCertified]) {
        [_verifyImageView setHidden: NO];
        _verifyImageView.frame = CGRectMake(_genderImageView.right + 10,
                                            _nameLabel.height * 0.5 - 7 + _nameLabel.top,
                                            19,
                                            14);
    }
    else {
        [_verifyImageView setHidden: YES];
        _verifyImageView.frame = CGRectMake(_genderImageView.right,
                                            _nameLabel.height * 0.5 - 7 + _nameLabel.top,
                                            0.0,
                                            0.0);
    }
    
    if (_item.task.task.is_anonymous != 2) {
        // 等级
        _levelImageView.hidden = NO;
        _levelImageView.frame = CGRectMake(_verifyImageView.right + 10.0,
                                           _nameLabel.height * 0.5 - 7 + _nameLabel.top,
                                           28.0,
                                           14.0);
    }
    else {
        _levelImageView.hidden = YES;
    }
    
    // 创建时间
    if (_item.task.task.isMine) {
        [_createTimeLabel setHidden:NO];
        _createTimeLabel.frame = CGRectMake(_nameLabel.left,
                                            _headView.bottom - 2.5 - _createTimeLabel.font.lineHeight,
                                            self.width - _headView.right - 23.0,
                                            _createTimeLabel.font.lineHeight);
    }
    else {
        [_createTimeLabel setHidden:YES];
    }
    
    _sinaVerifyImageView.frame = CGRectMake(_nameLabel.left, _nameLabel.bottom + 7.5, 13, 13);
    _introduceLabel.frame = CGRectMake(_sinaVerifyImageView.right + 3.5,
                                       _sinaVerifyImageView.height * 0.5 - _introduceLabel.font.lineHeight * 0.5 + _sinaVerifyImageView.top,
                                       self.width - _sinaVerifyImageView.right - 20,
                                       _introduceLabel.font.lineHeight);
}

#pragma mark - Getter&Setter
- (void)setItem:(TaskActivityUserInfoItem *)item {
    _item = item;
    [self configureData];
}

- (UIImageView *)freeImageView {
    if (!_freeImageView) {
        _freeImageView = [[UIImageView alloc] init];
        _freeImageView.image = [UIImage imageNamed:@"picFree"];
    }
    return _freeImageView;
}

- (ZZHeadImageView *)headView {
    if (!_headView) {
        _headView = [[ZZHeadImageView alloc] init];
        WeakSelf
        _headView.touchHead = ^{
            if (_item.task.task.is_anonymous != 2) {
                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(cell:activityShowUserInfoWith:)]) {
                    [weakSelf.delegate cell:weakSelf activityShowUserInfoWith:weakSelf.item];
                }
            }
        };
    }
    return _headView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _nameLabel.font = [UIFont boldSystemFontOfSize:17.0];
        _nameLabel.textColor = RGBCOLOR(63, 58, 58);
        _nameLabel.text = @"挖哈哈哈哈";
    }
    return _nameLabel;
}

- (UILabel *)createTimeLabel {
    if (!_createTimeLabel) {
        _createTimeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _createTimeLabel.font = CustomFont(13.0);
        _createTimeLabel.textColor = RGBCOLOR(153, 153, 153);
        _createTimeLabel.text = @"发布于";
    }
    return _createTimeLabel;
}

- (UIImageView *)genderImageView {
    if (!_genderImageView) {
        _genderImageView = [[UIImageView alloc] init];
    }
    return _genderImageView;
}

- (UIImageView *)verifyImageView {
    if (!_verifyImageView) {
        _verifyImageView = [[UIImageView alloc] init];
        _verifyImageView.image = [UIImage imageNamed:@"icon_identifier"];
    }
    return _verifyImageView;
}

- (ZZLevelImgView *)levelImageView {
    if (!_levelImageView) {
        _levelImageView = [[ZZLevelImgView alloc] init];
    }
    return _levelImageView;
}

- (UIImageView *)sinaVerifyImageView {
    if (!_sinaVerifyImageView) {
        _sinaVerifyImageView = [[UIImageView alloc] init];
        _sinaVerifyImageView.image = [UIImage imageNamed:@"v"];
    }
    return _sinaVerifyImageView;
}

- (UILabel *)introduceLabel {
    if (!_introduceLabel) {
        _introduceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _introduceLabel.font = CustomFont(14.0);
        _introduceLabel.textColor = RGBCOLOR(63, 58, 58);
    }
    return _introduceLabel;
}

@end
