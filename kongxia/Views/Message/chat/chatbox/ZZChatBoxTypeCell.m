//
//  ZZChatBoxTypeCell.m
//  zuwome
//
//  Created by angBiu on 2017/7/7.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZChatBoxTypeCell.h"

@implementation ZZChatBoxTypeCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        _imgView = [[UIImageView alloc] init];
        _imgView.contentMode = UIViewContentModeCenter;
        _imgView.userInteractionEnabled = YES;
        [self.contentView addSubview:_imgView];
        [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.contentView);
        }];
    }
    
    return self;
}

- (void)setData:(ChatBoxType)type selectedType:(ChatBoxType)selectedType isBurnReaded:(BOOL)isBurnReaded
{

}

@end
