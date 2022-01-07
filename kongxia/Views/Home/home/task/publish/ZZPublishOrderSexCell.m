//
//  ZZPublishOrderSexCell.m
//  zuwome
//
//  Created by angBiu on 2017/7/11.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZPublishOrderSexCell.h"

@interface ZZPublishOrderSexCell ()

@property (nonatomic, strong) UIButton *tempBtn;
@property (nonatomic, strong) UILabel *leftLabel;

@end

@implementation ZZPublishOrderSexCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.imgView.image = [UIImage imageNamed:@"icon_task_sex_n"];
        self.imgView.hidden = YES;
        
        self.leftLabel.hidden = NO;
        
        UIButton *nolimitBtn = [self createButton:@"不限" tag:103];
        
        [nolimitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
            make.size.mas_equalTo(CGSizeMake(44, 44));
        }];
        
        UIButton *boyBtn = [self createButton:@"男" tag:101];
        
        [boyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.right.mas_equalTo(nolimitBtn.mas_left).offset(-20);
            make.size.mas_equalTo(CGSizeMake(44, 44));
        }];
        
        UIButton *girlBtn = [self createButton:@"女" tag:102];
        girlBtn.backgroundColor = kYellowColor;
        _tempBtn = girlBtn;
        
        [girlBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.right.mas_equalTo(boyBtn.mas_left).offset(-20);
            make.size.mas_equalTo(CGSizeMake(44, 44));
        }];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = kLineViewColor;
        [self.contentView addSubview:lineView];
        
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.contentView.mas_bottom);
            make.left.mas_equalTo(self.contentView.mas_left).offset(15);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
            make.height.mas_equalTo(@0.5);
        }];
    }
    
    return self;
}

- (void)setGender:(NSInteger)gender
{
    _gender = gender;
    UIButton *btn = (UIButton *)[self.contentView viewWithTag:100+gender];
    [self btnClick:btn];
}

- (void)btnClick:(UIButton *)sender
{
    if (sender != _tempBtn) {
        _tempBtn.backgroundColor = kBGColor;
        sender.backgroundColor = kYellowColor;
        _tempBtn = sender;
        
        if (_selectedIndex) {
            _selectedIndex(sender.tag - 100);
        }
    }
}

- (UIButton *)createButton:(NSString *)title tag:(NSInteger)tag
{
    UIButton *btn = [[UIButton alloc] init];
    btn.layer.cornerRadius = 22;
    btn.tag = tag;
    btn.backgroundColor = kBGColor;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:kBlackTextColor forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:btn];
    return btn;
}

#pragma mark -

- (UILabel *)leftLabel {
    if (!_leftLabel) {
        _leftLabel = [UILabel new];
        _leftLabel.text = @"达人性别";
        _leftLabel.textColor = [UIColor blackColor];
        _leftLabel.font = [UIFont systemFontOfSize:15];
        
        [self.contentView addSubview:_leftLabel];
        [_leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(15);
            make.centerY.mas_equalTo(self.contentView);
        }];
    }
    return _leftLabel;
}

- (UIImageView *)imgView
{
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
        _imgView.contentMode = UIViewContentModeCenter;
        [self.contentView addSubview:_imgView];
        
        [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(15);
            make.top.bottom.mas_equalTo(self.contentView);
            make.width.mas_equalTo(@22);
        }];
    }
    return _imgView;
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
