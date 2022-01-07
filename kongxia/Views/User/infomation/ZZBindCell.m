//
//  ZZBindCell.m
//  zuwome
//
//  Created by angBiu on 16/6/17.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZBindCell.h"
#import "ZZUser.h"
#import "ZZRedPointView.h"
#import "ZZUserHelper.h"

@implementation ZZBindCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        _imgView = [[UIImageView alloc] init];
        [self.contentView addSubview:_imgView];
        
        [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(15);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(22, 22));
        }];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = kBlackTextColor;
        _titleLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_titleLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_imgView.mas_right).offset(7.5);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
        }];
        
        _redPointView = [[ZZRedPointView alloc] init];
        _redPointView.hidden = YES;
        [self.contentView addSubview:_redPointView];
        
        [_redPointView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_titleLabel.mas_right).offset(5);
            make.centerY.mas_equalTo(_titleLabel.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(8, 8));
        }];
        
        _bindBtn = [[UIButton alloc] init];
        [_bindBtn setTitle:@"绑定" forState:UIControlStateNormal];
        [_bindBtn setTitleColor:kBlackTextColor forState:UIControlStateNormal];
        _bindBtn.backgroundColor = kLineViewColor;
        [_bindBtn addTarget:self action:@selector(bindBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _bindBtn.titleLabel.font = [UIFont systemFontOfSize:11];
        _bindBtn.userInteractionEnabled = NO;
        [self.contentView addSubview:_bindBtn];
        
        [_bindBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(50, 25));
        }];
        
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = kLineViewColor;
        [self.contentView addSubview:_lineView];
        
        [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(15);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
            make.bottom.mas_equalTo(self.contentView.mas_bottom);
            make.height.mas_equalTo(@1);
        }];
    }
    
    return self;
}

- (void)bindBtnClick
{
    
}

- (void)setDataModel:(ZZUser *)user indexPath:(NSIndexPath *)indexPath
{
    _lineView.hidden = NO;
    _redPointView.hidden = YES;
    switch (indexPath.row) {
        case 0:
        {
            _imgView.image = [UIImage imageNamed:@"icon_bind_phone"];
            _titleLabel.text = [ZZUtils encryptPhone:user.phone];
            [_bindBtn setTitle:@"更换" forState:UIControlStateNormal];
        }
            break;
        case 1:
        {
            _imgView.image = [UIImage imageNamed:@"icon_bind_qq"];
            _titleLabel.text = @"QQ";
            NSString *str = user.qq.openid ? @"解绑":@"绑定";
            [_bindBtn setTitle:str forState:UIControlStateNormal];
            _bindBtn.backgroundColor = user.qq.openid ? kLineViewColor:kYellowColor;
        }
            break;
        case 2:
        {
            _imgView.image = [UIImage imageNamed:@"icon_bind_wx"];
            _titleLabel.text = @"微信";
            NSString *str = user.wechat.unionid ? @"解绑":@"绑定";
            [_bindBtn setTitle:str forState:UIControlStateNormal];
            _bindBtn.backgroundColor = user.wechat.unionid ? kLineViewColor:kYellowColor;
        }
            break;
        case 3:
        {
            _imgView.image = [UIImage imageNamed:@"icon_bind_wb"];
            _titleLabel.text = @"新浪微博";
            _lineView.hidden = YES;
            NSString *str = user.weibo.uid ? @"解绑":@"绑定";
            if (!user.weibo.uid && ![ZZUserHelper shareInstance].userFirstWB) {
                _redPointView.hidden = NO;
            }
            [_bindBtn setTitle:str forState:UIControlStateNormal];
            _bindBtn.backgroundColor = user.weibo.uid ? kLineViewColor:kYellowColor;
        }
            break;
        default:
            break;
    }
}

@end
