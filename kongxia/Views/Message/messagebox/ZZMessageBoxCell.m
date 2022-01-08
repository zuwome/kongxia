//
//  ZZMessageBoxCell.m
//  zuwome
//
//  Created by angBiu on 2017/6/6.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZMessageBoxCell.h"
#import "ZZChatPacketModel.h"
#import "ZZChatOrderInfoModel.h"
#import "ZZChatOrderNotifyModel.h"
#import "ZZMessageListCellLocationView.h"
#import "ZZDateHelper.h"
#import "ZZChatUtil.h"

@implementation ZZMessageBoxCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = kLineViewColor;
        [self.contentView addSubview:lineView];
        
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(15);
            make.top.mas_equalTo(self.contentView.mas_top);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
            make.height.mas_equalTo(@0.5);
        }];
        
        _imgView = [[UIImageView alloc] init];
        _imgView.layer.cornerRadius = 20;
        _imgView.clipsToBounds = YES;
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
        _imgView.backgroundColor = kBGColor;
        [self.contentView addSubview:_imgView];
        
        [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(15);
            make.top.mas_equalTo(self.contentView.mas_top).offset(10);
            make.size.mas_equalTo(CGSizeMake(40, 40));
        }];
        
        _unreadCountLabel = [[UILabel alloc] init];
        _unreadCountLabel.textAlignment = NSTextAlignmentCenter;
        _unreadCountLabel.textColor = [UIColor whiteColor];
        _unreadCountLabel.font = [UIFont systemFontOfSize:10];
        _unreadCountLabel.backgroundColor = kRedPointColor;
        _unreadCountLabel.text = @"1";
        _unreadCountLabel.layer.cornerRadius = 8;
        _unreadCountLabel.clipsToBounds = YES;
        _unreadCountLabel.hidden = YES;
        [self.contentView addSubview:_unreadCountLabel];
        
        [_unreadCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_imgView.mas_right);
            make.top.mas_equalTo(_imgView.mas_top).offset(-5);
            make.size.mas_equalTo(CGSizeMake(16, 16));
        }];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = kBlackTextColor;
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_titleLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_imgView.mas_top);
            make.left.mas_equalTo(_imgView.mas_right).offset(15);
        }];
        
        _levelImgView = [[ZZLevelImgView alloc] init];
        [self.contentView addSubview:_levelImgView];
        
        [_levelImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_titleLabel.mas_right).offset(5);
            make.centerY.mas_equalTo(_titleLabel.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(30, 14));
        }];
        
        _locationView = [[ZZMessageListCellLocationView alloc] init];
        [self addSubview:_locationView];
        
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textAlignment = NSTextAlignmentLeft;
        _contentLabel.textColor = kGrayContentColor;
        _contentLabel.font = [UIFont systemFontOfSize:13];
        _contentLabel.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_contentLabel];
        
        [_locationView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_titleLabel.mas_left);
            make.bottom.mas_equalTo(_imgView.mas_bottom);
            make.height.equalTo(@18);
            make.width.equalTo(@0);
        }];
        
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_locationView.mas_right).offset(8);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-60);
            make.bottom.mas_equalTo(_imgView.mas_bottom);
        }];
        
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textAlignment = NSTextAlignmentRight;
        _timeLabel.textColor = kGrayContentColor;
        _timeLabel.font = [UIFont systemFontOfSize:11];
        _timeLabel.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_timeLabel];
        
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
            make.top.mas_equalTo(_titleLabel.mas_top);
        }];
        
        _blackBtn = [MGSwipeButton buttonWithTitle:@"拉黑" backgroundColor:kYellowColor];
        _blackBtn.buttonWidth = 70;
        MGSwipeButton *deleteBtn = [MGSwipeButton buttonWithTitle:@"删除" backgroundColor:kRedColor];
        deleteBtn.buttonWidth = 70;
        self.rightButtons = @[_blackBtn,deleteBtn];
        self.rightSwipeSettings.transition = MGSwipeTransitionStatic;
        self.delegate = self;
    }
    
    return self;
}

- (void)setData:(ZZMessageBoxModel *)model
{
    [_levelImgView setLevel:model.say_hi_total.from.level];
    
    [_imgView sd_setImageWithURL:[NSURL URLWithString:[model.say_hi_total.from displayAvatar]] placeholderImage:nil];
    _titleLabel.text = model.say_hi_total.from.nickname;
    if ([model.say_hi_total.from.uid isEqualToString:kMmemejunUid]) {
        _titleLabel.textColor = kYellowColor;
    } else {
        _titleLabel.textColor = kBlackTextColor;
    }
    _timeLabel.text = model.say_hi_total.latest_at_text;
    if (model.say_hi_total.count) {
        _unreadCountLabel.hidden = NO;
        if (model.say_hi_total.count > 99) {
            _unreadCountLabel.text = @"99";
        } else {
            _unreadCountLabel.text = [NSString stringWithFormat:@"%ld",model.say_hi_total.count];
        }
    } else {
        _unreadCountLabel.hidden = YES;
    }
    
    CGFloat nameWidth = [ZZUtils widthForCellWithText:_titleLabel.text fontSize:15];
    CGFloat timeWidth = [ZZUtils widthForCellWithText:_timeLabel.text fontSize:11];
    CGFloat maxWidth = SCREEN_WIDTH - 15 - 40 - 15 - 15 - timeWidth - 10;
    if (nameWidth > maxWidth) {
        [_titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(maxWidth);
        }];
    } else {
        [_titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(nameWidth);
        }];
    }
    _contentLabel.text = model.say_hi_total.content;
    if ([model.say_hi_total.videoMessageType isEqualToString:@"视屏挂断的消息"]) {
        _contentLabel.text = @"[视屏通话]";
    }
    
    [_locationView configureUser:model];
    
    [_locationView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(_locationView.totalWidth));
    }];
}

- (BOOL)swipeTableCell:(MGSwipeTableCell *)cell tappedButtonAtIndex:(NSInteger)index direction:(MGSwipeDirection)direction fromExpansion:(BOOL)fromExpansion
{
    if (index == 0) {
        if (_touchAddBlock) {
            _touchAddBlock();
        }
    } else if (index == 1) {
        if (_touchDelete) {
            _touchDelete();
        }
    }
    return YES;
}

- (void)layoutSubviews
{
    for (UIView *subView in self.subviews) {
        if ([subView isKindOfClass:NSClassFromString(@"UITableViewCellDeleteConfirmationView")]) {
            subView.backgroundColor = kRedColor;
            for (UIButton *btn in subView.subviews) {
                if ([btn isKindOfClass:[UIButton class]]) {
                    [btn setTitle:@"" forState:UIControlStateNormal];
                    UIImageView *imgView = [[UIImageView alloc] initWithFrame:btn.bounds];
                    imgView.contentMode = UIViewContentModeCenter;
                    imgView.image = [UIImage imageNamed:@"icon_chat_delete"];
                    imgView.userInteractionEnabled = NO;
                    [btn addSubview:imgView];
                }
            }
        }
    }
}

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    if (selected) {
        _unreadCountLabel.backgroundColor = kRedColor;
    }
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    
    if (highlighted) {
        _unreadCountLabel.backgroundColor = kRedColor;
    }
}

@end
