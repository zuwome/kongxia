//
//  ZZNewHomeShanZuCell.m
//  zuwome
//
//  Created by MaoMinghui on 2018/8/16.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZNewHomeShanZuCell.h"

@interface ZZNewHomeShanZuCell ()

@property (nonatomic, strong) UIButton *shanzuBtn;
@property (nonatomic, strong) UIImageView *shanzuIcon;
@property (nonatomic, strong) UILabel *shanzuTitle;
@property (nonatomic, strong) UILabel *shanzuSubTitle;

@property (nonatomic, strong) UIButton *videoBtn;
@property (nonatomic, strong) UIImageView *videoIcon;
@property (nonatomic, strong) UILabel *videoTitle;
@property (nonatomic, strong) UILabel *videoSubTitle;

@end

@implementation ZZNewHomeShanZuCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createView];
    }
    return self;
}

- (void)createView {
    self.backgroundColor = kBGColor;
    [self.contentView addSubview:self.shanzuBtn];
    [self.shanzuBtn addSubview:self.shanzuTitle];
    [self.shanzuBtn addSubview:self.shanzuIcon];
    [self.shanzuBtn addSubview:self.shanzuSubTitle];
    
    [self.contentView addSubview:self.videoBtn];
    [self.videoBtn addSubview:self.videoTitle];
    [self.videoBtn addSubview:self.videoIcon];
    [self.videoBtn addSubview:self.videoSubTitle];
    
    [self.videoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(@0);
        make.leading.equalTo(@7);
        make.width.equalTo(@((SCREEN_WIDTH - 21) / 2));
    }];
    
    [self.shanzuBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(@0);
        make.leading.equalTo(self.videoBtn.mas_trailing).offset(7);
        make.trailing.equalTo(@-7);
    }];
    
    [self.shanzuTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.shanzuBtn).offset(-15);
        make.centerX.equalTo(self.shanzuBtn).offset(12);
        make.height.equalTo(@25);
    }];
    
    [self.shanzuIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.shanzuTitle);
        make.size.mas_equalTo(CGSizeMake(25, 25));
        make.trailing.equalTo(self.shanzuTitle.mas_leading).offset(-3);
    }];
    
    [self.shanzuSubTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.shanzuBtn);
        make.centerY.equalTo(self.shanzuBtn).offset(12);
        make.height.equalTo(@20);
    }];
    
    [self.videoTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.videoBtn).offset(-15);
        make.centerX.equalTo(self.videoBtn).offset(12);
        make.height.equalTo(@25);
    }];
    
    [self.videoIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.videoTitle);
        make.size.mas_equalTo(CGSizeMake(25, 25));
        make.trailing.equalTo(self.videoTitle.mas_leading).offset(-3);
    }];
    
    [self.videoSubTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.videoBtn);
        make.centerY.equalTo(self.videoBtn).offset(12);
        make.height.equalTo(@20);
    }];
}

- (void)setRentOptions:(ZZHomeChatModel *)rentOptions {
    self.shanzuTitle.text = rentOptions.name;
    self.shanzuSubTitle.text = rentOptions.content;
//    [self.shanzuIcon sd_setImageWithURL:[NSURL URLWithString:rentOptions.url]];
}

- (void)setChatOptions:(ZZHomeChatModel *)chatOptions {
    self.videoTitle.text = chatOptions.name;
    if ([ZZUserHelper shareInstance].isLogin) {
        if ([ZZUserHelper shareInstance].loginer.rent.status == 2) {
            self.videoSubTitle.text = chatOptions.content;
        } else {
            self.videoSubTitle.text = chatOptions.content_user;
        }
    } else {
        self.videoSubTitle.text = chatOptions.content_user;
    }
//    [self.videoIcon sd_setImageWithURL:[NSURL URLWithString:chatOptions.url]];
}

- (void)shanzuClick {   //点击闪租任务
    !self.shanZuCallback ? : self.shanZuCallback();
}
- (void)videoClick {    //点击视频咨询
    !self.videoCounselCallback ? : self.videoCounselCallback();
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (UIButton *)shanzuBtn {
    if (nil == _shanzuBtn) {
        _shanzuBtn = [[UIButton alloc] init];
        _shanzuBtn.backgroundColor = [UIColor whiteColor];
        _shanzuBtn.layer.cornerRadius = 3;
        _shanzuBtn.layer.masksToBounds = YES;
        [_shanzuBtn addTarget:self action:@selector(shanzuClick) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _shanzuBtn;
}
- (UIImageView *)shanzuIcon {
    if (nil == _shanzuIcon) {
        _shanzuIcon = [[UIImageView alloc] init];
        _shanzuIcon.image = [UIImage imageNamed:@"rectangle54"];
    }
    return _shanzuIcon;
}
- (UILabel *)shanzuTitle {
    if (nil == _shanzuTitle) {
        _shanzuTitle = [[UILabel alloc] init];
        [_shanzuTitle setText:@"全部通告"];
        [_shanzuTitle setTextColor:kBlackColor];
        [_shanzuTitle setFont:[UIFont systemFontOfSize:18 weight:(UIFontWeightBold)]];
    }
    return _shanzuTitle;
}
- (UILabel *)shanzuSubTitle {
    if (nil == _shanzuSubTitle) {
        _shanzuSubTitle = [[UILabel alloc] init];
        [_shanzuSubTitle setText:@"海量通告 报名赚钱"];
        [_shanzuSubTitle setTextColor:kWarmGray];
        [_shanzuSubTitle setFont:[UIFont systemFontOfSize:14 weight:(UIFontWeightMedium)]];
    }
    return _shanzuSubTitle;
}


- (UIButton *)videoBtn {
    if (nil == _videoBtn) {
        _videoBtn = [[UIButton alloc] init];
        _videoBtn.backgroundColor = [UIColor whiteColor];
        _videoBtn.layer.cornerRadius = 3;
        _videoBtn.layer.masksToBounds = YES;
        [_videoBtn addTarget:self action:@selector(videoClick) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _videoBtn;
}
- (UIImageView *)videoIcon {
    if (nil == _videoIcon) {
        _videoIcon = [[UIImageView alloc] init];
        _videoIcon.image = [UIImage imageNamed:@"icSpzxSy"];
    }
    return _videoIcon;
}
- (UILabel *)videoTitle {
    if (nil == _videoTitle) {
        _videoTitle = [[UILabel alloc] init];
        [_videoTitle setText:@"视频咨询"];
        [_videoTitle setTextColor:kBlackColor];
        [_videoTitle setFont:[UIFont systemFontOfSize:18 weight:(UIFontWeightBold)]];
    }
    return _videoTitle;
}
- (UILabel *)videoSubTitle {
    if (nil == _videoSubTitle) {
        _videoSubTitle = [[UILabel alloc] init];
        [_videoSubTitle setText:@"线上互动 轻松收益"];
        [_videoSubTitle setTextColor:kWarmGray];
        [_videoSubTitle setFont:[UIFont systemFontOfSize:14 weight:(UIFontWeightMedium)]];
    }
    return _videoSubTitle;
}

@end
