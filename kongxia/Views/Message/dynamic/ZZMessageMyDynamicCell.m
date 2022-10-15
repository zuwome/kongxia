//
//  ZZMessageMyDynamicCell.m
//  zuwome
//
//  Created by angBiu on 16/8/22.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZMessageMyDynamicCell.h"

#import "ZZMessageDynamicModel.h"

@implementation ZZMessageMyDynamicCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        _headImgView = [[ZZHeadImageView alloc] init];
        _headImgView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_headImgView];
        
        [_headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(15);
            make.top.mas_equalTo(self.contentView.mas_top).offset(10);
            make.size.mas_equalTo(CGSizeMake(50, 50));
        }];
        
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headViewClick)];
        recognizer.numberOfTapsRequired = 1;
        [_headImgView addGestureRecognizer:recognizer];
        
        _imgView = [[UIImageView alloc] init];
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
        _imgView.clipsToBounds = YES;
        _imgView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_imgView];
        
        [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(50, 50));
        }];
        
        _contentLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
        _contentLabel.backgroundColor = [UIColor whiteColor];
        _contentLabel.textAlignment = NSTextAlignmentLeft;
        _contentLabel.textColor = kBlackTextColor;
        _contentLabel.font = [UIFont systemFontOfSize:14];
        _contentLabel.numberOfLines = 3;
        _contentLabel.delegate = self;
        _contentLabel.highlightedTextColor = kYellowColor;
        _contentLabel.linkAttributes = @{(NSString*)kCTForegroundColorAttributeName : (id)[kYellowColor CGColor]};
        _contentLabel.activeLinkAttributes = @{(NSString *)kCTForegroundColorAttributeName : (id)[kYellowColor CGColor]};
        _contentLabel.userInteractionEnabled = YES;
        [self.contentView addSubview:_contentLabel];
        
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_headImgView.mas_right).offset(8);
            make.top.mas_equalTo(_headImgView.mas_top);
            make.right.mas_equalTo(_imgView.mas_left).offset(-10);
        }];
        
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textAlignment = NSTextAlignmentLeft;
        _timeLabel.textColor = kGrayTextColor;
        _timeLabel.font = [UIFont systemFontOfSize:11];
        _timeLabel.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_timeLabel];
        
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_contentLabel.mas_left);
            make.top.mas_equalTo(_contentLabel.mas_bottom).offset(15);
            make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-10);
        }];
        
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = kLineViewColor;
        [self.contentView addSubview:_lineView];
        
        [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(15);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
            make.top.mas_equalTo(self.contentView.mas_top);
            make.height.mas_equalTo(@0.5);
        }];
    }
    
    return self;
}

- (void)setData:(ZZMessageDynamicModel *)model
{
    [_headImgView setUser:model.message.from width:50 vWidth:12];
    _timeLabel.text = model.message.created_at_text;
    
    if (model.message.mmd.mid) {
        _imgView.hidden = NO;
        if (model.message.mmd.answers.count) {
            ZZMMDAnswersModel *answerModel = model.message.mmd.answers[0];
            [_imgView sd_setImageWithURL:[NSURL URLWithString:answerModel.video.cover_url]];
        }
    } else if (model.message.sk.id) {
        _imgView.hidden = NO;
        [_imgView sd_setImageWithURL:[NSURL URLWithString:model.message.sk.video.cover_url]];
    } else if ([model.message.type isEqualToString:@"following"]) {
        _imgView.hidden = YES;
    }  else {
        _imgView.hidden = YES;
    }
    
    NSString *str = [NSString stringWithFormat:@"%@%@",model.message.from.nickname,model.message.content];
    _contentLabel.text = str;
    
    if (!isNullString(model.message.from.nickname)) {
        NSRange range = [str rangeOfString:model.message.from.nickname];
        [_contentLabel addLinkToURL:[NSURL URLWithString:model.message.from.nickname] withRange:range];
    }
}

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url
{
    if (_touchLinkUrl) {
        _touchLinkUrl();
    }
}

- (void)headViewClick
{
    if (_touchHead) {
        _touchHead();
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
