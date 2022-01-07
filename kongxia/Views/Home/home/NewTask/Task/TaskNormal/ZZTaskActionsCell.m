//
//  ZZTaskActionsCell.m
//  zuwome
//
//  Created by qiming xiao on 2019/3/20.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZTaskActionsCell.h"
#import "ZZTaskModel.h"

@interface ZZTaskActionsCell ()

@property (nonatomic, strong) buttonView *leftActionBtn;

@property (nonatomic, strong) buttonView *centerActionBtn;

@property (nonatomic, strong) buttonView *rightActionBtn;

@property (nonatomic, strong) UIView *lineView;

@end

@implementation ZZTaskActionsCell

+ (NSString *)cellIdentifier {
    return @"ZZTaskActionsCell";
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self layout];
    }
    return self;
}

- (void)configureData {
    if ([_item isKindOfClass: [TaskActionsItem class]]) {
        TaskActionsItem *item = (TaskActionsItem *)_item;
        [self layoutFrames];
        // Warning: right is center, center is right
        if (_item.taskType == TaskFree) {
            _leftActionBtn.title = @"马上预约";
            _rightActionBtn.title = @"查看微信";
            _centerActionBtn.title = @"私信查看微信";
        }
        else {
            if (item.task.task.isMine) {
                _rightActionBtn.titleColor = RGBCOLOR(102, 102, 102);
                switch (item.task.task.taskStatus) {
                    case TaskOngoing: {
                        _rightActionBtn.title = @"结束报名";
                        _rightActionBtn.icon = @"icBmjsTonggao";
                        break;
                    }
                    case TaskCancel: {
                        _rightActionBtn.title = @"已取消";
                        _rightActionBtn.icon = @"icYqxTonggao";
                        break;
                    }
                    case TaskClose: {
                        _rightActionBtn.title = @"已结束报名";
                        _rightActionBtn.icon = @"icYjsTonggao";
                        break;
                    }
                    case TaskFinish: {
                        _rightActionBtn.title = @"已结束";
                        _rightActionBtn.icon = @"icYjsTonggao";
                        break;
                    }
                    case TaskExpired: {
                        _rightActionBtn.title = @"已过期";
                        _rightActionBtn.icon = @"icGqTonggao";
                        break;
                    }
                    case TaskReported: {
                        _rightActionBtn.title = @"被举报";
                        _rightActionBtn.icon = @"icYjsTonggao";
                        break;
                    }
                    default: {
                        break;
                    }
                }
                
                if (item.task.task.count > 0) {
                    _centerActionBtn.title = [NSString stringWithFormat:@"%@(%ld)",@"查看报名", (long)item.task.task.count];
                }
                else {
                    _centerActionBtn.title = @"查看报名";
                }
                
                _centerActionBtn.icon = @"icCkbmTonggao";
            }
            else {
                if (item.task.task.isTaskFinished) {
                    _rightActionBtn.icon = @"icGqTonggao";
                    _rightActionBtn.title = @"已过期";
                }
                else {
                    //push_count: 1为报名，-1没报名 ;
                    if (item.task.task.push_count == 1) {
                        _rightActionBtn.title = @"我已报名";
                        _rightActionBtn.titleColor = ColorHex(FFB300);
                        _rightActionBtn.icon = @"icWybmTonggao-1";
                    }
                    else {
                        _rightActionBtn.title = @"我要报名";
                        _rightActionBtn.titleColor = RGBCOLOR(102, 102, 102);
                        _rightActionBtn.icon = @"icWybmTonggao";
                    }
                }
                
                _centerActionBtn.title = @"私信";
                _centerActionBtn.icon = @"icSxTonggao";
            }
            
            NSString *btnTitle = _rightActionBtn.title;
            // 已报名数字女性用户不可见，男性用户及自己可见
            if ((item.task.task.count > 0 && !item.task.task.isMine && UserHelper.loginer.gender == 1) && !item.task.task.isTaskFinished) {
                _rightActionBtn.title = [NSString stringWithFormat:@"%@(%ld)",btnTitle, (long)item.task.task.count];
            }
            
            //selected_count: 1为点赞，-1没点
            if (item.task.task.selected_count == 1) {
                _leftActionBtn.titleColor = ColorHex(FB2282);
                _leftActionBtn.icon = @"icDianzanhouTonggao";
            }
            else {
                _leftActionBtn.titleColor = RGBCOLOR(102, 102, 102);
                _leftActionBtn.icon = @"icDzTonggao";
            }
            
            if (item.task.task.like > 0) {
                _leftActionBtn.title = [NSString stringWithFormat:@"%ld", item.task.task.like];
            }
            else {
                _leftActionBtn.title = [NSString stringWithFormat:@"赞"];
            }
        }
    }
}

- (void)leftAcionBtn {
    if ([_item isKindOfClass: [TaskActionsItem class]]) {
        TaskActionsItem *item = (TaskActionsItem *)_item;
        if (item.taskType == TaskNormal) {
            // 普通的 点赞
            if (self.delegate && [self.delegate respondsToSelector:@selector(cell:likeActionWithItem:)]) {
                [self.delegate cell:self likeActionWithItem:item];
            }
        }
        else if (item.taskType == TaskFree) {
            // 有空的 租他
            if (self.delegate && [self.delegate respondsToSelector:@selector(cell:rent:)]) {
                [self.delegate cell:self rent:item];
            }
        }
    }
}

- (void)centerAcion {
    if ([_item isKindOfClass: [TaskActionsItem class]]) {
        TaskActionsItem *item = (TaskActionsItem *)_item;
        // 普通、有空都是聊天
        if (self.delegate && [self.delegate respondsToSelector:@selector(cell:chatWithItem:)]) {
            [self.delegate cell:self chatWithItem:item];
        }
    }
}

- (void)rightAction {
    if ([_item isKindOfClass: [TaskActionsItem class]]) {
        TaskActionsItem *item = (TaskActionsItem *)_item;
        if (item.taskType == TaskNormal) {
            // 普通的 报名
            if (self.delegate && [self.delegate respondsToSelector:@selector(cell:signUpActionWith:)]) {
                [self.delegate cell:self signUpActionWith:item];
            }
        }
        else if (item.taskType == TaskFree) {
            // 有空的 查看微信
            if (self.delegate && [self.delegate respondsToSelector:@selector(cell:checkWechat:)]) {
                [self.delegate cell:self checkWechat:item];
            }
        }
    }
}

#pragma mark - Layout
- (void)layout {
    [self.contentView addSubview:self.leftActionBtn];
    [self.contentView addSubview:self.centerActionBtn];
    [self.contentView addSubview:self.rightActionBtn];
    [self.contentView addSubview:self.lineView];
}

- (void)layoutFrames {
    CGFloat buttonSize = SCREEN_WIDTH / 3;
    _leftActionBtn.frame = CGRectMake(0.0, 0.0, buttonSize, self.height);
    _rightActionBtn.frame = CGRectMake(_leftActionBtn.right, 0.0, buttonSize, self.height);
    _centerActionBtn.frame = CGRectMake(_rightActionBtn.right, 0.0, buttonSize, self.height);
    _lineView.frame = CGRectMake(15.0, self.height, self.width - 30.0, 0.5);
}

#pragma mark - Getter&Setter
- (void)setItem:(TaskItem *)item {
    _item = item;
    [self configureData];
}

- (buttonView *)leftActionBtn {
    if (!_leftActionBtn) {
        _leftActionBtn = [buttonView new];
        _leftActionBtn.icon = @"icDzYy";
        _leftActionBtn.title = @"赞";
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(leftAcionBtn)];
        [_leftActionBtn addGestureRecognizer:tap];
    }
    return _leftActionBtn;
}

- (buttonView *)centerActionBtn {
    if (!_centerActionBtn) {
        _centerActionBtn = [buttonView new];
        _centerActionBtn.icon = @"icSxYy";
        _centerActionBtn.title = @"私信";
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(centerAcion)];
        [_centerActionBtn addGestureRecognizer:tap];
    }
    return _centerActionBtn;
}

- (buttonView *)rightActionBtn {
    if (!_rightActionBtn) {
        _rightActionBtn = [buttonView new];
        _rightActionBtn.icon = @"group4Copy2";
        _rightActionBtn.title = @"我要报名";
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rightAction)];
        [_rightActionBtn addGestureRecognizer:tap];
    }
    return _rightActionBtn;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = RGBCOLOR(237, 237, 237);
    }
    return _lineView;
}

@end

@interface buttonView ()


@end

@implementation buttonView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self layout];
    }
    return self;
}

- (void)layout {
    [self addSubview:self.iconImageView];
    [self addSubview:self.titleLabel];
    
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self.mas_centerY);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self).offset(-9);
        make.left.right.equalTo(self);
    }];
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        
    }
    return _iconImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = CustomFont(12.0);
        _titleLabel.text = @"";
        _titleLabel.textColor = HEXCOLOR(666666);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (void)setIcon:(NSString *)icon {
    _icon = icon;
    _iconImageView.image = [UIImage imageNamed:icon];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    _titleLabel.text = title;
}

- (void)setTitleColor:(UIColor *)titleColor {
    _titleColor = titleColor;
    _titleLabel.textColor = titleColor;
}

@end

