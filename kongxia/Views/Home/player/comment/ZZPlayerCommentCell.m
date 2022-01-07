//
//  ZZPlayerCommentCell.m
//  zuwome
//
//  Created by angBiu on 2016/12/28.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZPlayerCommentCell.h"

@implementation ZZPlayerCommentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        
        _bgView = [[UIView alloc] init];
        [self.contentView addSubview:_bgView];
        
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.contentView);
        }];
        
        _headImgView = [[ZZHeadImageView alloc] init];
        [_bgView addSubview:_headImgView];
        
        [_headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_bgView.mas_left).offset(15);
            make.top.mas_equalTo(_bgView.mas_top).offset(15);
            make.size.mas_equalTo(CGSizeMake(36, 36));
        }];
        
        WeakSelf;
        _headImgView.touchHead = ^{
            [weakSelf headViewClick];
        };
        
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.textColor = kBlackTextColor;
        _nameLabel.font = [UIFont systemFontOfSize:13];
        [_bgView addSubview:_nameLabel];
        
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_headImgView.mas_right).offset(15);
            make.top.mas_equalTo(_headImgView.mas_top);
        }];
        
        _levelImgView = [[ZZLevelImgView alloc] init];
        [_bgView addSubview:_levelImgView];
        
        [_levelImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_nameLabel.mas_right).offset(5);
            make.centerY.mas_equalTo(_nameLabel.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(30, 14));
        }];
        
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textAlignment = NSTextAlignmentRight;
        _timeLabel.textColor = kGrayCommentColor;
        _timeLabel.font = [UIFont systemFontOfSize:12];
        [_bgView addSubview:_timeLabel];
        
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_bgView.mas_right).offset(-15);
            make.centerY.mas_equalTo(_nameLabel.mas_centerY);
        }];
        
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textAlignment = NSTextAlignmentLeft;
        _contentLabel.textColor = kGrayCommentColor;
        _contentLabel.font = [UIFont systemFontOfSize:14];
        _contentLabel.numberOfLines = 0;
        [_bgView addSubview:_contentLabel];
        
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_headImgView.mas_centerY).offset(10);
            make.left.mas_equalTo(_nameLabel.mas_left);
            make.right.mas_equalTo(_timeLabel.mas_right);
            make.bottom.mas_equalTo(_bgView.mas_bottom).offset(-15);
        }];
        
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = kLineViewColor;
        [self.contentView addSubview:_lineView];
        
        [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(15);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
            make.bottom.mas_equalTo(self.contentView.mas_bottom);
            make.height.mas_equalTo(@0.5);
        }];
        
        UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(viewLongPresee:)];
        [_bgView addGestureRecognizer:recognizer];
    }
    
    return self;
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)setData:(ZZCommentModel *)model
{
    [_headImgView setUser:model.reply.user width:36 vWidth:8];
    _nameLabel.text = model.reply.user.nickname;
    _timeLabel.text = model.reply.created_at_text;
    if (model.reply.reply_which_reply.user) {
        NSString *str = [NSString stringWithFormat:@"回复 %@：",model.reply.reply_which_reply.user.nickname];
        NSString *sumStr = [NSString stringWithFormat:@"%@%@",str,model.reply.content];
        sumStr = [sumStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSRange range = NSMakeRange(0, str.length);
        NSMutableAttributedString *attributionStr = [[NSMutableAttributedString alloc] initWithString:sumStr];
        [attributionStr addAttribute:NSForegroundColorAttributeName value:kYellowColor range:range];
        _contentLabel.attributedText = attributionStr;
    } else {
        _contentLabel.text = [model.reply.content stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    
    CGFloat timeWidth = [ZZUtils widthForCellWithText:_timeLabel.text fontSize:12];
    CGFloat maxWidth = SCREEN_WIDTH - 15 - 36 - 15 - 5 - 30 - 5 - 15 - timeWidth;
    CGFloat nameWidth = [ZZUtils widthForCellWithText:_nameLabel.text fontSize:13];
    if (nameWidth > maxWidth) {
        [_nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(maxWidth);
        }];
    } else {
        [_nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(nameWidth);
        }];
    }
    
    [_levelImgView setLevel:model.reply.user.level];
}

- (void)headViewClick
{
    if (_touchHead) {
        _touchHead();
    }
}

- (void)viewLongPresee:(UILongPressGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        [self becomeFirstResponder];
        if (_cellLongPress) {
            _cellLongPress(_bgView);
        }
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
