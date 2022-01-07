//
//  ZZUserCenterOrderCell.m
//  zuwome
//
//  Created by angBiu on 16/8/11.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZUserCenterOrderCell.h"
#import "ZZSelfOrderButton.h"

@implementation ZZUserCenterOrderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        _ingBtn = [[ZZSelfOrderButton alloc] init];
        _ingBtn.imgView.image = [UIImage imageNamed:@"icon_order_ing"];
        _ingBtn.typeLabel.text = @"进行中";
        [_ingBtn addTarget:self action:@selector(ingBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _ingBtn.badgeLabel.hidden = YES;
        [self.contentView addSubview:_ingBtn];
        
        [_ingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH/3, 50));
        }];
        
        _commentBtn = [[ZZSelfOrderButton alloc] init];
        _commentBtn.imgView.image = [UIImage imageNamed:@"icon_order_comment"];
        _commentBtn.typeLabel.text = @"待评价";
        [_commentBtn addTarget:self action:@selector(commentBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _commentBtn.badgeView.hidden = YES;
        _commentBtn.badgeLabel.hidden = YES;
        [self.contentView addSubview:_commentBtn];
        
        [_commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.contentView.mas_centerX);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH/3, 50));
        }];
        
        _doneBtn = [[ZZSelfOrderButton alloc] init];
        _doneBtn.imgView.image = [UIImage imageNamed:@"icon_order_done"];
        _doneBtn.typeLabel.text = @"已结束";
        [_doneBtn addTarget:self action:@selector(doneBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _doneBtn.badgeView.hidden = YES;
        _doneBtn.badgeLabel.hidden = YES;
        [self.contentView addSubview:_doneBtn];
        
        [_doneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentView.mas_right);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH/3, 50));
        }];
    }
    
    return self;
}

- (void)setData
{
    NSInteger count = [ZZUserHelper shareInstance].unreadModel.order_ongoing_count;
    if (count) {
        self.ingBtn.badgeView.count = count;
        self.ingBtn.badgeView.hidden = NO;
    } else {
        self.ingBtn.badgeView.hidden = YES;
    }
    if ([ZZUserHelper shareInstance].unreadModel.order_commenting) {
        self.commentBtn.badgeLabel.hidden = NO;
    } else {
        self.commentBtn.badgeLabel.hidden = YES;
    }
    if ([ZZUserHelper shareInstance].unreadModel.order_done) {
        self.doneBtn.badgeLabel.hidden = NO;
    } else {
        self.doneBtn.badgeLabel.hidden = YES;
    }
}

#pragma mark -

- (void)ingBtnClick
{
    if (_selectOrder) {
        _selectOrder(0);
    }
}

- (void)commentBtnClick
{
    if (_selectOrder) {
        _selectOrder(1);
    }
}

- (void)doneBtnClick
{
    if (_selectOrder) {
        _selectOrder(2);
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
