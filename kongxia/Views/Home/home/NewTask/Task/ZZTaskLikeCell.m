//
//  ZZTaskLikeCell.m
//  zuwome
//
//  Created by qiming xiao on 2019/4/3.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZTaskLikeCell.h"
#import "TTTAttributedLabel.h"
#import "ZZTaskLikeModel.h"
#import "ZZDateHelper.h"

@interface ZZTaskLikeCell ()

@property (nonatomic, strong) ZZHeadImageView *headImgView;

@property (nonatomic, strong) TTTAttributedLabel *contentLabel;

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UIImageView *imgView;//红包或者么么答

@property (nonatomic, strong) UIView *lineView;

@end

@implementation ZZTaskLikeCell

+ (NSString *)cellIdentifier {
    return @"ZZTaskLikeCell";
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self layout];
    }
    return self;
}

- (void)configreData {
    [_headImgView setUser:_likeModel.like_user width:50 vWidth:12];
    _timeLabel.text = [ZZDateHelper localTime:_likeModel.created_at];
    
//    if (model.message.mmd.mid) {
//        _imgView.hidden = NO;
//        if (model.message.mmd.answers.count) {
//            ZZMMDAnswersModel *answerModel = model.message.mmd.answers[0];
//            [_imgView sd_setImageWithURL:[NSURL URLWithString:answerModel.video.cover_url]];
//        }
//    } else if (model.message.sk.skId) {
//        _imgView.hidden = NO;
//        [_imgView sd_setImageWithURL:[NSURL URLWithString:model.message.sk.video.cover_url]];
//    } else if ([model.message.type isEqualToString:@"following"]) {
//        _imgView.hidden = YES;
//    }  else {
//        _imgView.hidden = YES;
//    }
    
    NSString *str = [NSString stringWithFormat:@"%@%@",_likeModel.like_user.nickname,@"点赞了你发布的通告"];
    _contentLabel.text = str;
    
    if (!isNullString(_likeModel.like_user.nickname)) {
        NSRange range = [str rangeOfString:_likeModel.like_user.nickname];
        [_contentLabel addLinkToURL:[NSURL URLWithString:_likeModel.like_user.nickname] withRange:range];
    }
}

#pragma mark - Layout
- (void)layout {
    [self addSubview:self.headImgView];
    [self addSubview:self.contentLabel];
    [self addSubview:self.timeLabel];
    [self addSubview:self.lineView];
    
    [_headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(15);
        make.top.mas_equalTo(self.mas_top).offset(10);
        make.bottom.mas_equalTo(self.mas_top).offset(-10);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_headImgView.mas_right).offset(8);
        make.top.mas_equalTo(_headImgView.mas_top);
        make.right.mas_equalTo(self).offset(-10);
    }];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_contentLabel.mas_left);
        make.top.mas_equalTo(_contentLabel.mas_bottom).offset(15);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-10);
    }];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(15);
        make.right.mas_equalTo(self.mas_right).offset(-15);
        make.top.mas_equalTo(self.mas_top);
        make.height.mas_equalTo(@0.5);
    }];
}

#pragma mark - getters and setters
- (void)setLikeModel:(ZZTaskLikeModel *)likeModel {
    _likeModel = likeModel;
    [self configreData];
}

- (ZZHeadImageView *)headImgView {
    if (!_headImgView) {
        _headImgView = [[ZZHeadImageView alloc] init];
        WeakSelf
        _headImgView.touchHead = ^{
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(cell:showUserInfo:)]) {
                [weakSelf.delegate cell:weakSelf showUserInfo:weakSelf.likeModel];
            }
        };
    }
    return _headImgView;
}

- (TTTAttributedLabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
        _contentLabel.backgroundColor = [UIColor whiteColor];
        _contentLabel.textAlignment = NSTextAlignmentLeft;
        _contentLabel.textColor = kBlackTextColor;
        _contentLabel.font = [UIFont systemFontOfSize:14];
        _contentLabel.numberOfLines = 3;
//        _contentLabel.delegate = self;
        _contentLabel.highlightedTextColor = kYellowColor;
        _contentLabel.linkAttributes = @{(NSString*)kCTForegroundColorAttributeName : (id)[kYellowColor CGColor]};
        _contentLabel.activeLinkAttributes = @{(NSString *)kCTForegroundColorAttributeName : (id)[kYellowColor CGColor]};
        _contentLabel.userInteractionEnabled = YES;
        _contentLabel.text = @"挖哈哈哈哈";
    }
    return _contentLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textAlignment = NSTextAlignmentLeft;
        _timeLabel.textColor = kGrayTextColor;
        _timeLabel.font = [UIFont systemFontOfSize:11];
        _timeLabel.backgroundColor = [UIColor whiteColor];
        _timeLabel.text = @"挖哈哈哈哈";
    }
    return _timeLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = kLineViewColor;
    }
    return _lineView;
}

@end
