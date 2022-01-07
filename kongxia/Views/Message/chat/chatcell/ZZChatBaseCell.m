//
//  ZZChatBaseCell.m
//  zuwome
//
//  Created by angBiu on 16/10/6.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZChatBaseCell.h"

#import "ZZDateHelper.h"

@implementation ZZChatBaseCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.layer.shouldRasterize = YES;
        self.layer.rasterizationScale = [UIScreen mainScreen].scale;
        
        self.contentView.backgroundColor = HEXCOLOR(0xF0F0F0);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _timeView = [[ZZChatTimeView alloc] init];
        _timeView.hidden = YES;
        [self.contentView addSubview:_timeView];
        
        [_timeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left);
            make.right.mas_equalTo(self.contentView.mas_right);
            make.top.mas_equalTo(self.contentView.mas_top);
            make.height.mas_equalTo(@30);
        }];
        
        _otherHeadImgView = [[ZZHeadImageView alloc] init];
        _otherHeadImgView.layer.cornerRadius = 20;
        _otherHeadImgView.clipsToBounds = YES;
        _otherHeadImgView.contentMode = UIViewContentModeScaleAspectFill;
        _otherHeadImgView.userInteractionEnabled = YES;
        [self.contentView addSubview:_otherHeadImgView];
        
        [_otherHeadImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(10);
            make.top.mas_equalTo(self.contentView.top).offset(10);
            make.size.mas_equalTo(CGSizeMake(40, 40));
        }];
        
        UITapGestureRecognizer *otherRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(otherHeadImgViewClick)];
        otherRecognizer.numberOfTapsRequired = 1;
        [_otherHeadImgView addGestureRecognizer:otherRecognizer];
        
        _bgView = [[UIView alloc] init];
        [self.contentView addSubview:_bgView];
        
        //起泡背景
        _bubbleImgView = [[UIImageView alloc] init];
        _bubbleImgView.contentMode = UIViewContentModeScaleToFill;
        [_bgView addSubview:_bubbleImgView];
        
        [_bubbleImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(_bgView);
        }];
        
        //已读
        _readStatusView = [[ZZChatReadStatusView alloc] init];
        [_bgView addSubview:_readStatusView];
        
        [_readStatusView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_bgView.mas_top);
            make.right.mas_equalTo(_bgView.mas_left).offset(-8);
            make.size.mas_equalTo(CGSizeMake(25, 14));
        }];
        
        _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self.contentView addSubview:_activityView];
        
        [_activityView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_bgView.mas_left).offset(-10);
            make.centerY.mas_equalTo(_bgView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }];
        
        _retryButton = [[UIButton alloc] init];
        [_retryButton setImage:IMAGENAME(@"message_send_fail_status") forState:UIControlStateNormal];
        [_retryButton addTarget:self action:@selector(retryBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_retryButton];
        
        [_retryButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_bgView.mas_left).offset(-10);
            make.centerY.mas_equalTo(_bgView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }];
        
        _unreadRedPointView = [[UIView alloc] init];
        _unreadRedPointView.backgroundColor = kRedPointColor;
        _unreadRedPointView.layer.cornerRadius = 4;
        [self.contentView addSubview:_unreadRedPointView];
        
        [_unreadRedPointView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.bgView.mas_centerY);
            make.left.mas_equalTo(_bgView.mas_right).offset(5);
            make.size.mas_equalTo(CGSizeMake(8, 8));
        }];
        
        UIView *countBgView = [[UIView alloc] init];
        countBgView.backgroundColor = HEXCOLOR(0xFF7B4C);
        countBgView.layer.cornerRadius = 2;
        [self.contentView addSubview:countBgView];
        
        _countLabel = [[UILabel alloc] init];
        _countLabel.textColor = [UIColor whiteColor];
        _countLabel.font = [UIFont systemFontOfSize:9];
        _countLabel.textAlignment = NSTextAlignmentCenter;
        _countLabel.text = @"30s";
        [countBgView addSubview:_countLabel];
        
        [_countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.mas_equalTo(countBgView);
        }];
        
        UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
        recognizer.minimumPressDuration = 1;
        [self.bgView addGestureRecognizer:recognizer];
        
        [self addNotification];
    }
    
    return self;
}

- (void)setData:(ZZChatBaseModel *)model {
    _dataModel = model;
    self.bubbleImgView.alpha = 1.0;
    RCMessage *message = model.message;
    _activityView.hidden = YES;
    _retryButton.hidden = YES;
    _unreadRedPointView.hidden = YES;
    
    CGFloat topOffset = 0;
    //是否显示时间
    if (model.showTime) {
        _timeView.hidden = NO;
        _timeView.timeLabel.text = [[ZZDateHelper shareInstance] getMessageChatMessageTime:message.sentTime];
        topOffset = 45;
    }
    else {
        _timeView.hidden = YES;
        topOffset = 15;
    }
    
    if (message.messageDirection == MessageDirection_SEND) {
        _isLeft = NO;
        _otherHeadImgView.hidden = YES;
        [_bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView.mas_top).offset(topOffset);
            make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-10);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
        }];
        _bubbleImgView.image = [ZZChatBaseCell resizeWithImage:[UIImage imageNamed:@"icon_chat_bubble_right"]];

        [_countLabel.superview mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_bgView.mas_top);
            make.right.mas_equalTo(_bgView.mas_left).offset(-10);
            make.size.mas_equalTo(CGSizeMake(25, 13));
        }];
    }
    else {
        _isLeft = YES;
        _otherHeadImgView.hidden = NO;
        [_bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView.mas_top).offset(topOffset);
            make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-10);
            make.left.mas_equalTo(_otherHeadImgView.mas_right).with.offset(7);
        }];
        [_otherHeadImgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView.top).offset(topOffset);
        }];
        _bubbleImgView.image = [ZZChatBaseCell resizeWithImage:[UIImage imageNamed:@"icon_chat_bubble_left"]];
        
        [_countLabel.superview mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_bgView.mas_top);
            make.left.mas_equalTo(_bgView.mas_right).offset(10);
            make.size.mas_equalTo(CGSizeMake(25, 13));
        }];
    }
    
    self.activityView.hidden = YES;
    [self.activityView stopAnimating];
    self.retryButton.hidden = YES;
    self.readStatusView.hidden = YES;
    _countLabel.superview.hidden = YES;
    if (message.messageDirection == MessageDirection_SEND) {
        switch (message.sentStatus) {
            case SentStatus_SENDING: {
                self.activityView.hidden = NO;
                [self.activityView startAnimating];
                break;
            }
            case SentStatus_FAILED: {
                self.retryButton.hidden = NO;
                break;
            }
            case SentStatus_READ: {
                self.readStatusView.hidden = !_countLabel.superview.hidden;
                break;
            }
            default:
                break;
        }
    }
    [self resetBurnCount];
    
    _topOffset = topOffset;
}

- (void)setUrl:(NSString *)portraitUrl {
    [_otherHeadImgView.headImgView sd_setImageWithURL:[NSURL URLWithString:portraitUrl]];
}

- (void)addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetBurnCount) name:kMsg_BurnAfterReadCount object:nil];
}

- (void)resetBurnCount {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.dataModel.message.messageDirection == MessageDirection_SEND) {
            switch (self.dataModel.message.sentStatus) {
                case SentStatus_READ:
                {
                    _countLabel.superview.hidden = _dataModel.count == 0;
                    self.readStatusView.hidden = !_countLabel.superview.hidden;
                }
                    break;
                default:
                    break;
            }
        }
        else {
            _countLabel.superview.hidden = _dataModel.count == 0;
        }
        _countLabel.text = [NSString stringWithFormat:@"%lds",self.dataModel.count];
    });
}

#pragma mark - UIButtonMethod
- (void)otherHeadImgViewClick {
    if (_touchLeftHeadImgView) {
        _touchLeftHeadImgView();
    }
}

- (void)retryBtnClick {
    if (_touchRetry) {
        _touchRetry();
    }
}

- (void)longPress:(UILongPressGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        if (_cellLongPress) {
            _cellLongPress(_bgView);
        }
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kMsg_BurnAfterReadCount object:nil];
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

+ (UIImage *)resizeWithImage:(UIImage *)image{
    CGFloat top = 28;
    CGFloat left = 31;
    CGFloat bottom = 18;
    CGFloat right = 31;
    return [image resizableImageWithCapInsets:UIEdgeInsetsMake(top, left, bottom, right)resizingMode:UIImageResizingModeStretch];
}

@end
