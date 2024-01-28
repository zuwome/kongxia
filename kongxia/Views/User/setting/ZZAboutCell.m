//
//  ZZAboutCell.m
//  zuwome
//
//  Created by angBiu on 16/9/6.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZAboutCell.h"
@interface ZZAboutCell ()
@property (nonatomic, assign) BOOL isClick;
@end
@implementation ZZAboutCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = kBlackTextColor;
        _titleLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_titleLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(15);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
        }];
        
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textAlignment = NSTextAlignmentRight;
        _contentLabel.textColor = kGrayContentColor;
        _contentLabel.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:_contentLabel];
        
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
        }];
        
        _imgView = [[UIImageView alloc] init];
        _imgView.image = [UIImage imageNamed:@"kongxialogo"]; //icon_logo
        _imgView.layer.cornerRadius = 10;
        [self.contentView addSubview:_imgView];
        
        [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_contentLabel.mas_left).offset(-10);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }];
        
        _numberLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
        _numberLabel.backgroundColor = [UIColor clearColor];
        _numberLabel.textAlignment = NSTextAlignmentLeft;
        _numberLabel.textColor = kBlackTextColor;
        _numberLabel.font = [UIFont systemFontOfSize:16];
        _numberLabel.numberOfLines = 0;
        _numberLabel.delegate = self;
        _numberLabel.highlightedTextColor = [UIColor redColor];
        _numberLabel.linkAttributes = @{(NSString*)kCTForegroundColorAttributeName:(id)HEXCOLOR(0x4990e2).CGColor};
        _numberLabel.activeLinkAttributes = @{(NSString *)kCTForegroundColorAttributeName:(id)HEXCOLOR(0x4990e2).CGColor};
        _numberLabel.userInteractionEnabled = YES;
        [self.contentView addSubview:_numberLabel];
        
        [_numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
        }];
        
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = kLineViewColor;
        [self.contentView addSubview:_lineView];
        
        [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(15);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
            make.top.mas_equalTo(self.contentView.mas_top);
            make.height.mas_equalTo(@0.5);
        }];
    }
    
    return self;
}

- (void)setIndexPath:(NSIndexPath *)indexPath
{
    _isClick = YES;
    _lineView.hidden = NO;
    _contentLabel.hidden = NO;
    _numberLabel.hidden = YES;
    _imgView.hidden = YES;
    switch (indexPath.row) {
        case 0:
        {
            _contentLabel.hidden = YES;
            _numberLabel.hidden = NO;
            _lineView.hidden = YES;
            _titleLabel.text = @"客服热线";
            NSString *str = @"4008-520-272";
            _numberLabel.text = str;
            [_numberLabel addLinkToPhoneNumber:str withRange:NSMakeRange(0, str.length)];
        }
            break;
        case 1:
        {
            _titleLabel.text = @"微信公众号";
            _contentLabel.text = @"movtrip";
        }
            break;
        case 2:
        {
            _titleLabel.text = @"新浪微博";
            _contentLabel.text = @"空虾";
            _imgView.hidden = NO;
        }
            break;
        default:
            break;
    }
}

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithPhoneNumber:(NSString *)phoneNumber
{
    if (!_isClick) {
        return;
    }
    _isClick = NO;
    NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",phoneNumber];

    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:str]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str] options:@{} completionHandler:NULL];
    }
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0/*延迟执行时间*/ * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        _isClick = YES;
    });
    
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
