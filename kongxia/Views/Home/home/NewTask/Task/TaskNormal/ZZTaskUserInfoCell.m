//
//  ZZTaskUserInfoCell.m
//  zuwome
//
//  Created by qiming xiao on 2019/3/20.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZTaskUserInfoCell.h"
#import "ZZHeadImageView.h"
#import "ZZLevelImgView.h"
#import "ZZTaskModel.h"
#import "ZZDateHelper.h"
#import "kongxia-Swift.h"

@interface ZZTaskUserInfoCell ()

@property (nonatomic, strong) ZZHeadImageView *headView;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *createTimeLabel;

@property (nonatomic, strong) UIImageView *genderImageView;

@property (nonatomic, strong) UIImageView *verifyImageView;

@property (nonatomic, strong) ZZLevelImgView *levelImageView;



@end

@implementation ZZTaskUserInfoCell

+ (NSString *)cellIdentifier {
    return @"ZZTaskUserInfoCell";
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self layout];
    }
    return self;
}

- (void)configureData {
    if ([_item isKindOfClass: [TaskUserInfoItem class]]) {
        TaskUserInfoItem *item = (TaskUserInfoItem *)_item;
        [self layoutFrames];
        
        [_headView setUser:item.task.from anonymousAvatar:item.task.task.anonymous_avatar width:60.0 vWidth:12];
        
        _nameLabel.text = item.task.from.nickname;

        // 性别
        if (item.task.from.gender == 2) {
            _genderImageView.image = [UIImage imageNamed:@"girl"];
        }
        else if (item.task.from.gender == 1) {
            _genderImageView.image = [UIImage imageNamed:@"boy"];
        }
        else {
            _genderImageView.image = [UIImage imageNamed:@""];
        }

        [_levelImageView setLevel:item.task.from.level];

        
        if (item.task.task.isMine) {
            [_createTimeLabel setHidden:NO];
            _createTimeLabel.text = [ZZDateHelper localTime:item.task.task.created_at];
            
            _moreBtn.normalTitle = @"取消发布";
        }
        else {
            [_createTimeLabel setHidden:YES];
        }
        
        if (item.task.task.taskStatus == TaskOngoing) {
            _moreBtn.hidden = NO;
        }
        else {
            _moreBtn.hidden = YES;
        }
    }
}

- (void)showMore {
    TaskUserInfoItem *item = (TaskUserInfoItem *)_item;
    if (item.task.task.isMine) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(cell:cancelAction:)]) {
            [self.delegate cell:self cancelAction:item];
        }
    }
    else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(cell:showMoreAction:)]) {
            [self.delegate cell:self showMoreAction:(TaskUserInfoItem *)_item];
        }
    }
}

#pragma mark - Layout
- (void)layout {
    [self.contentView addSubview:self.headView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.genderImageView];
    [self.contentView addSubview:self.verifyImageView];
    [self.contentView addSubview:self.levelImageView];
    [self.contentView addSubview:self.moreBtn];
    [self.contentView addSubview:self.createTimeLabel];
}

- (void)layoutFrames {
    _headView.frame = CGRectMake(15.0, 15.0, 60.0, 60.0);
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
    
    // 更多btn
    CGFloat moreBtnWidth = 30;
    if (_item.task.task.isMine) {
        moreBtnWidth = 70;
    }
    else {
        moreBtnWidth = 30;
    }
    CGFloat moreHeight = [NSString findHeightForText:_moreBtn.normalTitle havingWidth:30 andFont:CustomFont(13.0)];
    _moreBtn.frame = CGRectMake(self.width - 15 - moreBtnWidth,
                                _nameLabel.height * 0.5 - moreHeight * 0.5 + _nameLabel.top,
                                moreBtnWidth,
                                moreHeight);
    
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
}

#pragma mark - Getter&Setter
- (void)setItem:(TaskItem *)item {
    _item = item;
    [self configureData];
}

- (ZZHeadImageView *)headView {
    if (!_headView) {
        _headView = [[ZZHeadImageView alloc] init];
        WeakSelf
        _headView.touchHead = ^{
            if (_item.task.task.is_anonymous != 2) {
                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(cell:showUserInfoWith:)]) {
                    [weakSelf.delegate cell:weakSelf showUserInfoWith:weakSelf.item];
                }
            }
        };
    }
    return _headView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _nameLabel.font = [UIFont fontWithName:@"PingFang-SC-Bold" size:17.0];
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

- (UIButton *)moreBtn {
    if (!_moreBtn) {
        _moreBtn = [[UIButton alloc] init];
        [_moreBtn setTitle:@"更多" forState:UIControlStateNormal];
        [_moreBtn setTitleColor:RGBCOLOR(153, 153, 154) forState:UIControlStateNormal];
        _moreBtn.titleLabel.font = CustomFont(13.0);
        [_moreBtn addTarget:self action:@selector(showMore) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreBtn;
}

@end
