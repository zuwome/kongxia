//
//  ZZMessageSystemDetailCell.m
//  zuwome
//
//  Created by angBiu on 16/7/28.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZMessageSystemDetailCell.h"

#import "ZZSystemMessageModel.h"

@implementation ZZMessageSystemDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = kBGColor;
        
        UIView *timeBgView = [[UIView alloc] init];
        timeBgView.backgroundColor = HEXCOLOR(0xD8D8D8);
        timeBgView.layer.cornerRadius = 2;
        [self.contentView addSubview:timeBgView];
        
        [timeBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView.mas_top).offset(12);
            make.centerX.mas_equalTo(self.contentView.mas_centerX);
            make.height.equalTo(@20);
        }];
        
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.font = [UIFont systemFontOfSize:12];
        _timeLabel.backgroundColor = HEXCOLOR(0xD8D8D8);
        [timeBgView addSubview:_timeLabel];
        
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(timeBgView.mas_top).offset(2);
            make.bottom.mas_equalTo(timeBgView.mas_bottom).offset(-2);
            make.left.mas_equalTo(timeBgView.mas_left).offset(5);
            make.right.mas_equalTo(timeBgView.mas_right).offset(-5);
        }];
        
        _headImgView = [[UIImageView alloc] init];
        _headImgView.clipsToBounds = NO;
        _headImgView.layer.cornerRadius = 18;
        _headImgView.contentMode = UIViewContentModeScaleToFill;
        _headImgView.image = [UIImage imageNamed:@"icon_chat_system"];
        _headImgView.backgroundColor = kBGColor;
        [self.contentView addSubview:_headImgView];
        
        [_headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(10);
            make.top.mas_equalTo(timeBgView.mas_bottom).offset(15);
            make.size.mas_equalTo(CGSizeMake(36, 36));
        }];
        
        _bgImgView = [[UIImageView alloc] init];
        _bgImgView.contentMode = UIViewContentModeScaleToFill;
        UIImage *img = [UIImage imageNamed:@"icon_message_system_bubble"];
        _bgImgView.image = [img stretchableImageWithLeftCapWidth:img.size.width/2 topCapHeight:img.size.height/2];
        _bgImgView.userInteractionEnabled = YES;
        [self.contentView addSubview:_bgImgView];
        
        [_bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_headImgView.mas_right).offset(4);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-40);
            make.top.mas_equalTo(_headImgView.mas_top);
            make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-10);
        }];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = kBlackTextColor;
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.numberOfLines = 0;
        _titleLabel.backgroundColor = [UIColor whiteColor];
        [_bgImgView addSubview:_titleLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_bgImgView.mas_top).offset(10);
            make.left.mas_equalTo(_bgImgView.mas_left).offset(15);
            make.right.mas_equalTo(_bgImgView.mas_right).offset(-10);
        }];
        
        _contentLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
        _contentLabel.backgroundColor = [UIColor clearColor];
        _contentLabel.textAlignment = NSTextAlignmentLeft;
        _contentLabel.textColor = kBlackTextColor;
        _contentLabel.font = [UIFont systemFontOfSize:14];
        _contentLabel.numberOfLines = 0;
        _contentLabel.delegate = self;
        _contentLabel.highlightedTextColor = [UIColor redColor];
        _contentLabel.linkAttributes = @{(NSString*)kCTForegroundColorAttributeName : (id)[[UIColor blueColor] CGColor]};
        _contentLabel.activeLinkAttributes = @{(NSString *)kCTForegroundColorAttributeName : (id)[kYellowColor CGColor]};
        _contentLabel.userInteractionEnabled = YES;
        _contentLabel.backgroundColor = [UIColor whiteColor];
        [_bgImgView addSubview:_contentLabel];
        
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_titleLabel.mas_left);
            make.top.mas_equalTo(_titleLabel.mas_bottom);
            make.right.mas_equalTo(_titleLabel.mas_right);
            make.bottom.mas_equalTo(_bgImgView.mas_bottom).offset(-10);
        }];
    }
    
    return self;
}

- (void)setData:(ZZSystemMessageModel *)model {
    if (isNullString(model.message.created_at_text)) {
        [_timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self);
            make.height.equalTo(@0);
        }];
    }
    else {
        _timeLabel.text = model.message.created_at_text;
    }
    
    _titleLabel.text = model.message.title;
    if (!isNullString(model.message.link)) {
        NSString *str = [NSString stringWithFormat:@"%@%@",model.message.content,model.message.link];
        NSRange range = [str rangeOfString:model.message.link];
        _contentLabel.text = str;
        [_contentLabel addLinkToURL:[NSURL URLWithString:model.message.link] withRange:range];
    }
    else {
        _contentLabel.text = model.message.content;
    }
//    NSString *str = [NSString stringWithFormat:@"%@%@",model.message.content,model.message.link];
//    NSRange range = [str rangeOfString:model.message.link];
//    _contentLabel.text = str;
//    [_contentLabel addLinkToURL:[NSURL URLWithString:model.message.link] withRange:range];
}

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url
{
    if (_touchLinkUrl) {
        _touchLinkUrl();
    }
}

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
