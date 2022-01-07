//
//  ZZTaskSnatchListBottomView.m
//  zuwome
//
//  Created by angBiu on 2017/8/8.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZTaskSnatchListBottomView.h"

@implementation ZZTaskSnatchListBottomView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        _rentBtn = [[UIButton alloc] init];
        [_rentBtn setTitle:@"马上预约" forState:UIControlStateNormal];
        [_rentBtn setTitleColor:kBlackColor forState:UIControlStateNormal];
        _rentBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _rentBtn.backgroundColor = HEXCOLOR(0xdcdcdc);
        _rentBtn.userInteractionEnabled = NO;
        [_rentBtn addTarget:self action:@selector(rentBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_rentBtn];
        
        [_rentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.right.mas_equalTo(self);
            make.width.mas_equalTo(@120);
        }];
        
        _infoLabel = [[UILabel alloc] init];
        _infoLabel.textColor = HEXCOLOR(0xfc2f52);
        _infoLabel.font = [UIFont systemFontOfSize:15];
        _infoLabel.text = @"请选人";
        _infoLabel.numberOfLines = 0;
        [self addSubview:_infoLabel];
        
        [_infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).offset(15);
            make.centerY.mas_equalTo(self.mas_centerY);
        }];
        
//        _detailLabel = [[UILabel alloc] init];
//        _detailLabel.textAlignment = NSTextAlignmentCenter;
//        _detailLabel.textColor = [UIColor whiteColor];
//        _detailLabel.font = [UIFont systemFontOfSize:12];
//        _detailLabel.text = @"?";
//        _detailLabel.layer.cornerRadius = 8;
//        _detailLabel.backgroundColor = HEXCOLOR(0xd8d8d8);
//        _detailLabel.clipsToBounds = YES;
//        _detailLabel.userInteractionEnabled = NO;
//        [self addSubview:_detailLabel];
//        
//        [_detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(_infoLabel.mas_right).offset(5);
//            make.centerY.mas_equalTo(_infoLabel.mas_centerY);
//            make.size.mas_equalTo(CGSizeMake(16, 16));
//        }];
//        
//        _detailBtn = [[UIButton alloc] init];
//        [_detailBtn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:_detailBtn];
//        
//        [_detailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.top.bottom.mas_equalTo(self);
//            make.right.mas_equalTo(_detailLabel.mas_right);
//        }];
    }
    
    return self;
}

- (void)setDataArray:(NSMutableArray *)dataArray
{
    _rentBtn.userInteractionEnabled = YES;
    _rentBtn.backgroundColor = kYellowColor;
    [_rentBtn setTitle:@"马上预约" forState:UIControlStateNormal];
    _infoLabel.textColor = HEXCOLOR(0x9b9b9b);
    _detailLabel.hidden = NO;
    _detailBtn.userInteractionEnabled = YES;
    NSInteger count = dataArray.count;
    CGFloat maxWidth = (SCREEN_WIDTH - 15 - 5 - 16 - 5 - 120);
    CGFloat textWidth = 0;
    if (count == 0) {
        _sumPrice = 0;
        _rentBtn.userInteractionEnabled = NO;
        _rentBtn.backgroundColor = HEXCOLOR(0xdcdcdc);
        _infoLabel.text = @"请选人";
        _infoLabel.textColor = HEXCOLOR(0xfc2f52);
        _detailLabel.hidden = YES;
        _detailBtn.userInteractionEnabled = NO;
        textWidth = [ZZUtils widthForCellWithText:_infoLabel.text fontSize:15];
    } else if (count == 1) {
        _sumPrice = _price;
        NSString *string = @"已选1人";
        NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:string];
        [attributeString addAttribute:NSForegroundColorAttributeName value:HEXCOLOR(0xfc2f52) range:[string rangeOfString:@"1"]];
        _infoLabel.attributedText = attributeString;
        textWidth = [ZZUtils widthForCellWithText:_infoLabel.text fontSize:15];
    } else {
        [_rentBtn setTitle:@"确认支付" forState:UIControlStateNormal];
        _sumPrice = _price*(count - 1);
        NSString *moneyString = [NSString stringWithFormat:@"需再支付%@元",[ZZUtils dealAccuracyDouble:_sumPrice]];
        NSString *string;
        if (SCREEN_WIDTH > 320) {
            string = [NSString stringWithFormat:@"已选%ld人 %@",count,moneyString];
        } else {
            string = [NSString stringWithFormat:@"已选%ld人\n%@",count,moneyString];
        }
        NSMutableAttributedString *attirbuteString = [[NSMutableAttributedString alloc] initWithString:string];
        NSRange range1 = [string rangeOfString:moneyString];
        NSRange range2 = [string rangeOfString:[NSString stringWithFormat:@"%ld",count]];
        [attirbuteString addAttribute:NSForegroundColorAttributeName value:HEXCOLOR(0xfc2f52) range:range1];
        [attirbuteString addAttribute:NSForegroundColorAttributeName value:HEXCOLOR(0xfc2f52) range:range2];
        _infoLabel.attributedText = attirbuteString;
        textWidth = [ZZUtils widthForCellWithText:_infoLabel.text fontSize:15];
    }
    
    [_infoLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(maxWidth>textWidth?textWidth:maxWidth);
    }];
}

#pragma mark - UIButtonMethod

- (void)rentBtnClick
{
    if (_touchRent) {
        _touchRent();
    }
}

- (void)btnClick
{
    if (_touchDetail) {
        _touchDetail();
    }
}

@end
