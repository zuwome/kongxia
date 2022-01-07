//
//  ZZChatBoxMoreCell.m
//  zuwome
//
//  Created by angBiu on 16/10/17.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZChatBoxMoreCell.h"

@implementation ZZChatBoxMoreCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = HEXCOLOR(0xF8F8F8);
        
        _imgView = [[UIImageView alloc] init];
        [self.contentView addSubview:_imgView];
        
        [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left);
            make.right.mas_equalTo(self.contentView.mas_right);
            make.top.mas_equalTo(self.contentView.mas_top);
            make.height.mas_equalTo(@60);
        }];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = kBlackTextColor;
        _titleLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_titleLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.contentView.mas_centerX);
            make.top.mas_equalTo(_imgView.mas_bottom);
            make.bottom.mas_equalTo(self.contentView.mas_bottom);
        }];
    }
    
    return self;
}

- (void)setData:(NSNumber *)number
{
    switch ([number integerValue]) {
        case CHATBOX_MORE_ALBUM_TAG:
        {
            _titleLabel.text = @"照片";
            _imgView.image = IMAGENAME(@"actionbar_picture_icon");
        }
            break;
        case CHATBOX_MORE_CAMERA_TAG:
        {
            _titleLabel.text = @"拍摄";
            _imgView.image = IMAGENAME(@"actionbar_camera_icon");
        }
            break;
        case CHATBOX_MORE_LOCATION_TAG:
        {
            _titleLabel.text = @"位置";
            _imgView.image = IMAGENAME(@"actionbar_location_icon");
        }
            break;
        case CHATBOX_MORE_VOICE_TAG:
        {
            _titleLabel.text = @"语音通话";
            _imgView.image = IMAGENAME(@"voip/actionbar_audio_call_icon");
        }
            break;
        case CHATBOX_MORE_VIDEO_TAG:
        {
            _titleLabel.text = @"视频通话";
            _imgView.image = IMAGENAME(@"voip/actionbar_video_call_icon");
        }
            break;
        case CHATBOX_MORE_MEMEDA:
        {
            _titleLabel.text = @"发红包";
            _imgView.image = [UIImage imageNamed:@"icon_chat_memeda"];
        }
            break;
        case CHATBOX_MORE_BURN:
        {
            _titleLabel.text = @"阅后即焚";
            _imgView.image = [UIImage imageNamed:@"icon_chat_memeda"];
        }
            break;
        default:
            break;
    }
}

@end
