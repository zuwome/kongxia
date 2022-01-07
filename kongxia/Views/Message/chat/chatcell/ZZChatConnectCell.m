//
//  ZZChatConnectCell.m
//  zuwome
//
//  Created by angBiu on 2017/7/21.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZChatConnectCell.h"

#import "ZZChatConnectModel.h"

@implementation ZZChatConnectCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _bgView = [[UIView alloc] init];
        _bgView.clipsToBounds = YES;
        [self.contentView addSubview:_bgView];
        _bgView.layer.cornerRadius = 3;
        
        if (IOS8_OR_LATER) {
            UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
            UIVisualEffectView *effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
            effectview.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
            effectview.alpha = 0.3;
            [_bgView addSubview:effectview];
        } else {
            UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
            toolbar.barStyle = UIBarStyleBlackOpaque;
            toolbar.alpha = 0.3;
            [_bgView addSubview:toolbar];
        }
        
        _topBtn = [[UIButton alloc] init];
        _topBtn.backgroundColor = [UIColor whiteColor];
        [_topBtn setTitleColor:HEXCOLOR(0x3f3a3a) forState:UIControlStateNormal];
        _topBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _topBtn.layer.cornerRadius = 3;
        [_topBtn addTarget:self action:@selector(topBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_bgView addSubview:_topBtn];
        
        [_topBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_bgView.mas_left).offset(12);
            make.right.mas_equalTo(_bgView.mas_right).offset(-12);
            make.top.mas_equalTo(_bgView.mas_top).offset(10);
            make.height.mas_equalTo(@40);
        }];
        
        _bottomBtn = [[UIButton alloc] init];
        _bottomBtn.backgroundColor = [UIColor whiteColor];
        [_bottomBtn setTitleColor:HEXCOLOR(0x3f3a3a) forState:UIControlStateNormal];
        _bottomBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _bottomBtn.layer.cornerRadius = 3;
        [_bottomBtn addTarget:self action:@selector(bottomBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_bgView addSubview:_bottomBtn];
        
        [_bottomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(_topBtn);
            make.top.mas_equalTo(_bgView.mas_top).offset(10+40+10);
            make.height.mas_equalTo(@40);
        }];
    }
    
    return self;
}

- (void)setData:(ZZChatBaseModel *)model
{
    _model = model;
    ZZChatConnectModel *content = (ZZChatConnectModel *)model.message.content;
    CGFloat textWidth = [ZZUtils widthForCellWithText:content.content fontSize:15];
    CGFloat minWidth = [ZZUtils widthForCellWithText:@"查看TA的微信号" fontSize:15];
    if (textWidth < minWidth) {
        textWidth = minWidth;
    }
    CGFloat maxWidth = SCREEN_WIDTH - 40 - 10 - 20 - 50;
    CGFloat viewWidth = MIN(textWidth, maxWidth) + 35;
    if (model.message.messageDirection == MessageDirection_SEND) {
        [_bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentView.mas_right).offset(-10);
            make.top.mas_equalTo(self.contentView.mas_top).offset(5);
            make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-5);
            make.width.mas_equalTo(viewWidth);
        }];
        [_topBtn setTitle:@"再次视频" forState:UIControlStateNormal];
        [_bottomBtn setTitle:@"查看TA的微信号" forState:UIControlStateNormal];
        
        _topBtn.hidden = NO;
        _bottomBtn.hidden = NO;
        [_bottomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_bgView.mas_top).offset(10+40+10);
        }];
        switch (content.type) {
            case 0:
            {
                _bottomBtn.hidden = YES;
            }
                break;
            case 1:
            {
                
            }
                break;
            case 2:
            {
                _topBtn.hidden = YES;
                [_bottomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(_bgView.mas_top).offset(10);
                }];
            }
                break;
            default:
                break;
        }
    } else {
        [_bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(50);
            make.top.mas_equalTo(self.contentView.mas_top).offset(5);
            make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-5);
            make.width.mas_equalTo(viewWidth);
        }];
        [_topBtn setTitle:@"查看我的钱包" forState:UIControlStateNormal];
//        _topBtn.hidden = YES;
//        _bgView.hidden = YES;
        _bottomBtn.hidden = YES;
    }
}

- (void)topBtnClick
{
    if (_model.message.messageDirection == MessageDirection_SEND) {
        if (_touchVideo) {
            _touchVideo();
        }
    } else {
        if (_touchWallet) {
            _touchWallet();
        }
    }
}

- (void)bottomBtnClick
{
    if (_touchWX) {
        _touchWX();
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
