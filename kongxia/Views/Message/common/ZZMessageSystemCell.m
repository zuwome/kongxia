//
//  ZZMessageSystemCell.m
//  zuwome
//
//  Created by angBiu on 16/7/26.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZMessageSystemCell.h"
#import "ZZDateHelper.h"

#import <RongIMLib/RongIMLib.h>

@implementation ZZMessageSystemCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = kLineViewColor;
        [self.contentView addSubview:_lineView];
        
        [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView.mas_top);
            make.left.mas_equalTo(self.contentView.mas_left).offset(15);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
            make.height.mas_equalTo(@0.5);
        }];
        
        _imgView = [[UIImageView alloc] init];
        _imgView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_imgView];
        
        [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(21.5);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(27, 27));
        }];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = kBlackTextColor;
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_titleLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.left.mas_equalTo(_imgView.mas_right).offset(25);
        }];
        
        
        _unreadCountLabel = [[UILabel alloc] init];
        _unreadCountLabel.textAlignment = NSTextAlignmentCenter;
        _unreadCountLabel.textColor = [UIColor whiteColor];
        _unreadCountLabel.font = [UIFont systemFontOfSize:10];
        _unreadCountLabel.backgroundColor = kRedPointColor;
        _unreadCountLabel.text = @"1";
        _unreadCountLabel.layer.cornerRadius = 8;
        _unreadCountLabel.clipsToBounds = YES;
        _unreadCountLabel.hidden = YES;
        [self.contentView addSubview:_unreadCountLabel];
        [self.contentView bringSubviewToFront:_unreadCountLabel];
        [_unreadCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
            make.size.mas_equalTo(CGSizeMake(16, 16));
        }];
    }
    
    return self;
}


/**
 UI展示
 @param dict cell的title 和cell的image
 @param unReadArray 未读数量
 kFcount 客服的未读数量
 */
- (void)setMessageStyleWithIndexPath:(NSIndexPath *)indexPath uiDict:(NSDictionary *)dict unReadCountArray:(NSArray *) unReadArray kefuUnReadCount:(NSInteger)kFcount {
    
    if (indexPath.section>0) {
        return;
    }
    self.titleLabel.text = dict[@"title"][indexPath.row];
    self.imgView.image = [UIImage imageNamed:dict[@"image"][indexPath.row]];
    NSNumber *unreadCount ;
    switch (indexPath.row) {
        case 0:
        {
            unreadCount = [ZZUserHelper shareInstance].unreadModel.hd;
        }
            break;
        case 1:
        {
            unreadCount = [ZZUserHelper shareInstance].unreadModel.system_msg;

        }
            break;
        case 2:
        {
            unreadCount = [ZZUserHelper shareInstance].unreadModel.reply;
        }
            break;
            case 3:
        {
            unreadCount = @(kFcount);
        }
            break;
        default:
            break;
    }
  
    self.unreadCountLabel.hidden = YES;
    if (unreadCount ==nil ||[unreadCount integerValue]<=0) {
        return;
    }
    [self updateCurrentCellUnReadCountWithCell:self unReadCountStr:unreadCount];

}

/**
 专门为客服开辟的

 @param kfUnRead 客服的未读数据
 */
- (void)unReadCountKeFu:(NSInteger )kfUnRead {
    if (kfUnRead) {
        self.unreadCountLabel.hidden = NO;
        if (kfUnRead > 99) {
            self.unreadCountLabel.text = @"99";
        } else {
            self.unreadCountLabel.text = [NSString stringWithFormat:@"%ld",(long)kfUnRead];
        }
    } else {
        self.unreadCountLabel.hidden = YES;
    }
    
    
}


/**
 根据cell来更新cell上红点数据
 */
- (void)updateCurrentCellUnReadCountWithCell:(ZZMessageSystemCell *)cell unReadCountStr:(NSNumber *)unreadCountStr {
    cell.unreadCountLabel.hidden = NO;

    if ([unreadCountStr integerValue] > 99) {
        cell.unreadCountLabel.text = @"99+";
        [cell updateConstraintsWhenUnreadCountChanngWithChange:YES];
    } else {
        cell.unreadCountLabel.text = [NSString stringWithFormat:@"%@",unreadCountStr];
        [cell updateConstraintsWhenUnreadCountChanngWithChange:NO];
    }
}

/**
  当未读数量变化的时候更改约束

 @param isChange yes 更改为99+的模式
         No 默认模式
 */
- (void)updateConstraintsWhenUnreadCountChanngWithChange:(BOOL) isChange {
    if (isChange) {
        [_unreadCountLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@25);
        }];
    }else{
        [_unreadCountLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@16);
        }];
    }
   
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        _unreadCountLabel.textColor = [UIColor whiteColor];
        _unreadCountLabel.backgroundColor = kRedPointColor;
    }
}
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    if (highlighted) {
        _unreadCountLabel.textColor = [UIColor whiteColor];
        _unreadCountLabel.backgroundColor = kRedPointColor;
    }
}

@end
