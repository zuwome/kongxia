//
//  ZZMessageCommentCell.m
//  zuwome
//
//  Created by angBiu on 16/9/22.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZMessageCommentCell.h"

#import "ZZMessageCommentModel.h"

@implementation ZZMessageCommentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.layer.shouldRasterize = YES;
        self.layer.rasterizationScale = [UIScreen mainScreen].scale;
        self.contentView.backgroundColor = kBGColor;
        
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.layer.cornerRadius = 2;
        [self.contentView addSubview:_bgView];
        
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(8);
            make.top.mas_equalTo(self.contentView.mas_top).offset(8);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-8);
            make.bottom.mas_equalTo(self.contentView.mas_bottom);
        }];
        
        _headImgView = [[ZZHeadImageView alloc] init];
        [_bgView addSubview:_headImgView];
        
        [_headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_bgView.mas_left).offset(8);
            make.top.mas_equalTo(_bgView.mas_top).offset(15);
            make.size.mas_equalTo(CGSizeMake(38, 38));
        }];
        
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchHeadImageView)];
        recognizer.numberOfTapsRequired = 1;
        [_headImgView addGestureRecognizer:recognizer];
        
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.textColor = kBlackTextColor;
        _nameLabel.font = [UIFont systemFontOfSize:15];
        [_bgView addSubview:_nameLabel];
        
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_headImgView.mas_right).offset(8);
            make.top.mas_equalTo(_headImgView.mas_top);
        }];
        
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textAlignment = NSTextAlignmentLeft;
        _timeLabel.textColor = kGrayContentColor;
        _timeLabel.font = [UIFont systemFontOfSize:12];
        [_bgView addSubview:_timeLabel];
        
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_nameLabel.mas_left);
            make.bottom.mas_equalTo(_headImgView.mas_bottom);
        }];
        
        UIButton *commentBtn = [[UIButton alloc] init];
        [commentBtn setTitle:@"回复" forState:UIControlStateNormal];
        [commentBtn setTitleColor:kGrayTextColor forState:UIControlStateNormal];
        commentBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [commentBtn addTarget:self action:@selector(commentBtnClick) forControlEvents:UIControlEventTouchUpInside];
        commentBtn.layer.borderWidth = 0.5;
        commentBtn.layer.borderColor = HEXCOLOR(0xDBDBE0).CGColor;
        [_bgView addSubview:commentBtn];
        
        [commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_bgView.mas_right).offset(-8);
            make.centerY.mas_equalTo(_headImgView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(46, 26));
        }];
        
        _commentLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
        _commentLabel.backgroundColor = [UIColor clearColor];
        _commentLabel.textAlignment = NSTextAlignmentLeft;
        _commentLabel.textColor = kBlackTextColor;
        _commentLabel.font = [UIFont systemFontOfSize:14];
        _commentLabel.numberOfLines = 3;
        _commentLabel.delegate = self;
        _commentLabel.highlightedTextColor = [UIColor redColor];
        _commentLabel.linkAttributes = @{(NSString*)kCTForegroundColorAttributeName : (id)[kYellowColor CGColor]};
        _commentLabel.activeLinkAttributes = @{(NSString *)kCTForegroundColorAttributeName : (id)[kYellowColor CGColor]};
        _commentLabel.userInteractionEnabled = YES;
        [_bgView addSubview:_commentLabel];
        
        [_commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_bgView.mas_left).offset(8);
            make.right.mas_equalTo(_bgView.mas_right).offset(-8);
            make.top.mas_equalTo(_headImgView.mas_bottom).offset(10);
        }];
        
        UIView *bottomView = [[UIView alloc] init];
        bottomView.backgroundColor = kBGColor;
        [_bgView addSubview:bottomView];
        
        [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_commentLabel.mas_left);
            make.right.mas_equalTo(_commentLabel.mas_right);
            make.top.mas_equalTo(_commentLabel.mas_bottom).offset(8);
            make.bottom.mas_equalTo(_bgView.mas_bottom).offset(-12);
            make.height.mas_equalTo(@65);
        }];
        
        _coverImgView = [[UIImageView alloc] init];
        _coverImgView.contentMode = UIViewContentModeScaleAspectFill;
        _coverImgView.backgroundColor = [UIColor whiteColor];
        _coverImgView.clipsToBounds = YES;
        [bottomView addSubview:_coverImgView];
        
        [_coverImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(bottomView.mas_left);
            make.top.mas_equalTo(bottomView.mas_top);
            make.bottom.mas_equalTo(bottomView.mas_bottom);
            make.width.mas_equalTo(@65);
        }];
        
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textAlignment = NSTextAlignmentLeft;
        _contentLabel.textColor = kGrayContentColor;
        _contentLabel.font = [UIFont systemFontOfSize:14];
        _contentLabel.numberOfLines = 0;
        [bottomView addSubview:_contentLabel];
        
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_coverImgView.mas_right).offset(10);
            make.right.mas_equalTo(bottomView.mas_right).offset(-3);
            make.centerY.mas_equalTo(bottomView.mas_centerY);
        }];
        
        _bgView.layer.shadowColor = HEXCOLOR(0xdedcce).CGColor;
        _bgView.layer.shadowOffset = CGSizeMake(0, 1);
        _bgView.layer.shadowOpacity = 0.9;
        _bgView.layer.shadowRadius = 1;
    }
    
    return self;
}

- (void)setData:(ZZMessageCommentModel *)model
{
    ZZReplyModel *reply;
    if ([model.message.type isEqualToString:@"mmd_reply"]) {
        if (model.message.mmd.answers.count) {
            ZZMMDAnswersModel *answerModel = model.message.mmd.answers[0];
            [_coverImgView sd_setImageWithURL:[NSURL URLWithString:answerModel.video.cover_url]];
        }
        _contentLabel.text = model.message.mmd.content;
        reply = model.message.reply;
    }
    else {
        [_coverImgView sd_setImageWithURL:[NSURL URLWithString:model.message.sk.video.cover_url]];
        _contentLabel.text = model.message.sk.content;
        reply = model.message.sk_reply;
    }
    [_headImgView setUser:model.message.from width:38 vWidth:10];
    _nameLabel.text = model.message.from.nickname;
    _timeLabel.text = reply.created_at_text;
    
    if (reply.reply_which_reply.user.uid) {
        NSString *str = [NSString stringWithFormat:@"回复 %@：%@",reply.reply_which_reply.user.nickname,reply.content];
        NSRange range = [str rangeOfString:reply.reply_which_reply.user.nickname];
        _commentLabel.text = str;
        [_commentLabel addLinkToURL:[NSURL URLWithString:reply.reply_which_reply.user.nickname] withRange:range];
    } else {
        _commentLabel.text = reply.content;
    }
    
    if (model.read == 0) {
        _bgView.backgroundColor = HEXCOLOR(0xfffdef);
    } else {
        _bgView.backgroundColor = [UIColor whiteColor];
    }
}

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url
{
    if (_touchNickname) {
        _touchNickname();
    }
}

- (void)touchHeadImageView
{
    if (_touchHead) {
        _touchHead();
    }
}

- (void)commentBtnClick
{
    if (_touchComment) {
        _touchComment();
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
