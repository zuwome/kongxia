//
//  ZZPlayerCellHeaderView.m
//  zuwome
//
//  Created by 潘杨 on 2018/1/11.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZPlayerCellHeaderView.h"
@interface ZZPlayerCellHeaderView()
@property (nonatomic,strong) UILabel     *locationLab;
@property (nonatomic,strong) UIImageView *locationImageView;

@end
@implementation ZZPlayerCellHeaderView
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithReuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self addSubview:self.readLabel];
        [self addSubview:self.bgView];
        [self addSubview:self.ipLabel];
        [self.bgView addSubview:self.headImgView];
        [self.bgView addSubview:self.contentLabel];

        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = kGrayCommentColor;
        _timeLabel.font = [UIFont systemFontOfSize:12];
        _timeLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:_timeLabel];
        [self.bgView addSubview:self.locationLab];
        [self.bgView addSubview:self.locationImageView];
        
        [self setUpConstraints];
    }
    
    return self;
}
- (void)setReadLabtitle:(NSString *)readTitleLab andTimeLab:(NSString *)timeLab andIpOrigin:(NSString *)origin {
    self.readLabel.text = readTitleLab;
    if ([ZZUtils isEmpty:origin] || [origin containsString:@"null"]) {
        [self.ipLabel setHidden:YES];
    } else {
        [self.ipLabel setHidden:NO];
        self.ipLabel.text = origin;
    }
    
    self.timeLabel.text = timeLab;
}
- (void)setUpConstraints {
    [_readLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(15);
        make.centerY.mas_equalTo(_timeLabel.mas_centerY);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(100);
    }];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).with.offset(AdaptedHeight(3));
        make.height.mas_equalTo(30);
        make.right.mas_equalTo(self.mas_right).offset(-15);
        make.width.mas_equalTo(120);
    }];
    
    
    [_ipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(15);
        make.centerY.mas_equalTo(_timeLabel.mas_centerY);
        make.height.mas_equalTo(30);
        make.right.mas_equalTo(_timeLabel.mas_left).offset(-5);
        make.left.mas_equalTo(_timeLabel.mas_right).offset(5);
    }];
    
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_timeLabel.mas_bottom).with.offset(1);
        make.left.right.offset(0);
        make.bottom.mas_equalTo(self.mas_bottom).with.offset(AdaptedHeight(-6));
    }];
}

- (UILabel *)ipLabel {
    if (!_ipLabel) {
        _ipLabel = [[UILabel alloc] init];
        _ipLabel.textColor = kGrayCommentColor;
        _ipLabel.font = [UIFont systemFontOfSize:12];
        _ipLabel.textAlignment = NSTextAlignmentRight;
    }
    return _ipLabel;
}

- (UILabel *)readLabel {
    if (!_readLabel) {
        _readLabel = [[UILabel alloc] init];
        _readLabel.textColor = kGrayCommentColor;
        _readLabel.font = [UIFont systemFontOfSize:12];
    }
    return _readLabel;
}

- (void)setTopicModel:(id)topicModel {
 
    _topicModel = topicModel;
    
    if ([_topicModel isKindOfClass:[ZZSKModel class]]) {
        [self setSkModel:(ZZSKModel *)_topicModel];
    }
    else if ([_topicModel isKindOfClass:[ZZMMDModel class]]){
        [self setMmdModel:(ZZMMDModel *)_topicModel];
    }
}
- (void)setSkModel:(ZZSKModel *)skModel
{
    if (_skModel==skModel) {
        return;
    }
    self.headImgView.hidden = YES;
    self.contentLabel.text = skModel.content;
    _skModel = skModel;
    [self setGroups:skModel.groups];
    if (!isNullString(skModel.loc_name)) {
        self.locationLab.text = skModel.loc_name;
        self.locationLab.hidden  = NO;
        self.locationImageView.hidden  = NO;
        if (skModel.groups.count<=0&&isNullString(skModel.content)) {
            [self.locationImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(_bgView.mas_left).offset(13);
                make.centerY.mas_equalTo(self.locationLab.mas_centerY);
                make.size.mas_equalTo(CGSizeMake(AdaptedWidth(16), AdaptedWidth(16)));
            }];
            [self.locationLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo (self.locationImageView.mas_right).offset(5);
                make.right.mas_equalTo(_bgView.mas_right).with.offset(-5);
                make.bottom.offset(0);
                make.height.equalTo(@(skModel.loca_name_height));
            }];
            return;
        }

        [_contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_bgView.mas_left).offset(15);
            make.bottom.mas_equalTo(self.locationLab.mas_top).offset(-10);
            make.right.mas_equalTo(_bgView.mas_right).with.offset(-5);
            make.top.mas_equalTo(_bgView.mas_top).with.offset(10);
        }];
        [self.locationImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_bgView.mas_left).offset(13);
            make.centerY.mas_equalTo(self.locationLab.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(AdaptedWidth(16), AdaptedWidth(16)));
        }];
        [self.locationLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo (self.locationImageView.mas_right).offset(5);
            make.right.mas_equalTo(_bgView.mas_right).with.offset(-5);
            make.bottom.offset(-10);
            make.height.equalTo(@(skModel.loca_name_height));
        }];
    }else{
        self.locationLab.hidden  = YES;
        self.locationImageView.hidden  = YES;
        [_contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_bgView.mas_left).offset(15);
            make.bottom.mas_equalTo(_bgView.mas_bottom);
            make.right.mas_equalTo(_bgView.mas_right).with.offset(-5);
            make.top.mas_equalTo(_bgView.mas_top);
        }];
    }
    
}

- (void)setMmdModel:(ZZMMDModel *)mmdModel
{
    if (_mmdModel ==mmdModel) {
        return;
    }
    self.headImgView.hidden = NO;
    _mmdModel = mmdModel;
    if (_mmdModel.answers.count<=0) {
        return;
    }
    self.locationImageView.hidden = YES;
    self.locationLab.hidden = YES;
    ZZMMDAnswersModel *answersModel = (ZZMMDAnswersModel*)_mmdModel.answers[0];
  
    if (!isNullString(answersModel.content)&&!isNullString(answersModel.loc_name)) {
        self.locationImageView.hidden = NO;
        self.locationLab.hidden = NO;
        self.locationLab.text = answersModel.loc_name;
        [self.locationImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_bgView.mas_left).offset(13);
            make.centerY.mas_equalTo(self.locationLab.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(AdaptedWidth(16), AdaptedWidth(16)));
        }];
        [self.locationLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo (self.locationImageView.mas_right).offset(5);
            make.right.mas_equalTo(_bgView.mas_right).with.offset(-5);
            make.bottom.offset(-5);
            make.height.equalTo(@(answersModel.loca_name_height));
        }];
        self.contentLabel.text = answersModel.content;
        [_contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_bgView.mas_left).offset(15);
            make.bottom.mas_equalTo(self.locationLab.mas_top).offset(-5);
            make.right.mas_equalTo(_bgView.mas_right).with.offset(-5);
            make.top.mas_equalTo(_bgView.mas_top).with.offset(10);
        }];
    }else if (!isNullString(answersModel.content)){
        self.contentLabel.text = answersModel.content;
        [_contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_bgView.mas_left).offset(15);
            make.bottom.mas_equalTo(_bgView.mas_bottom).offset(0);
            make.right.mas_equalTo(_bgView.mas_right).with.offset(-5);
            make.top.mas_equalTo(_bgView.mas_top).with.offset(0);
        }];
    }
     else  if (!isNullString(answersModel.loc_name)) {
        self.locationImageView.hidden = NO;
        self.locationLab.hidden = NO;
        self.locationLab.text = answersModel.loc_name;
        [self.locationImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_bgView.mas_left).offset(13);
            make.centerY.mas_equalTo(self.locationLab.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(AdaptedWidth(16), AdaptedWidth(16)));
        }];
        [self.locationLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo (self.locationImageView.mas_right).offset(5);
            make.right.mas_equalTo(_bgView.mas_right).with.offset(-5);
            make.bottom.offset(0);
            make.height.equalTo(@(answersModel.loca_name_height));
        }];
    }

   
}

- (void)setGroups:(NSMutableArray<ZZMemedaTopicModel> *)groups
{
    __block NSString *str = self.contentLabel.text;
    if (isNullString(str)) {
        str = @"";
    }
    [groups enumerateObjectsUsingBlock:^(ZZMemedaTopicModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        str = [NSString stringWithFormat:@"%@ %@",str,model.content];
    }];
    str = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    _contentLabel.text = str;
    [groups enumerateObjectsUsingBlock:^(ZZMemedaTopicModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        NSRange range = [str rangeOfString:model.content];
        [_contentLabel addLinkToTransitInformation:@{[NSNumber numberWithInteger:idx]:model.content} withRange:range];
    }];
}

- (UIView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
}

- (ZZHeadImageView *)headImgView
{
    WeakSelf;
    if (!_headImgView) {
        _headImgView = [[ZZHeadImageView alloc] init];
        _headImgView.touchHead = ^{
            if (weakSelf.touchHead) {
                weakSelf.touchHead();
            }
        };
    }
    return _headImgView;
}

- (UIImageView *)locationImageView {
    if (!_locationImageView) {
        _locationImageView = [[UIImageView alloc]init];
        _locationImageView.image = [UIImage imageNamed:@"icVideoPlayLocation"];
    }
    return _locationImageView;
}

- (UILabel *)locationLab {
    if (!_locationLab) {
        _locationLab = [[UILabel alloc]init];
        _locationLab.textAlignment = NSTextAlignmentLeft;
        _locationLab.font = [UIFont systemFontOfSize:13];
        _locationLab.textColor = RGBACOLOR(0, 0, 0, 0.49);
        _locationLab.numberOfLines = 0;
    }
    return _locationLab;
}



- (TTTAttributedLabel *)contentLabel
{
    if (!_contentLabel) {
        _contentLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
        _contentLabel.textColor = [UIColor blackColor];
        _contentLabel.font = [UIFont systemFontOfSize:15];
        _contentLabel.numberOfLines = 0;
        _contentLabel.highlightedTextColor = kYellowColor;
        _contentLabel.linkAttributes = @{(NSString*)kCTForegroundColorAttributeName : (id)[kYellowColor CGColor]};
        _contentLabel.activeLinkAttributes = @{(NSString *)kCTForegroundColorAttributeName : (id)[kYellowColor CGColor]};
        _contentLabel.userInteractionEnabled = YES;
        
   
    }
    return _contentLabel;
}


@end
