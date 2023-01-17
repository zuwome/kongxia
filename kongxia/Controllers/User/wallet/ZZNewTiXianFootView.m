//
//  ZZNewTiXianFootView.m
//  zuwome
//
//  Created by 潘杨 on 2018/6/12.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZNewTiXianFootView.h"
#import "TYAttributedLabel.h"

@interface ZZNewTiXianFootView()<TYAttributedLabelDelegate>
@property (nonatomic,strong) UIButton *tiXianButton;
@property (nonatomic,strong) TYAttributedLabel *instructionsLab;
@end
@implementation ZZNewTiXianFootView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.tiXianButton];
        [self addSubview:self.instructionsLab];
    }
    return self;
}


- (void)setUserName:(NSString *)userName {
    if (_userName != userName) {
        _userName = userName;
        
        NSString *money = [NSString stringWithFormat:@"(最低%ld元/笔, 最多%ld元/笔, 每日提现总额最高2000元）",(long)[ZZUserHelper shareInstance].configModel.min_bankcard_transfer, (long)[ZZUserHelper shareInstance].configModel.max_bankcard_transfer];
        
        NSString *string = [NSString stringWithFormat:@"只能提现到认证姓名为%@的微信账户%@详细",userName,money];
        NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:string attributes:nil];
        
        [attribute addAttribute:NSForegroundColorAttributeName value:RGBCOLOR(161, 161, 161) range:NSMakeRange(0, string.length)];
        [attribute addAttribute:NSForegroundColorAttributeName value:HEXCOLOR(0x3F3A3A) range:[string rangeOfString:money]];
        
        self.instructionsLab.attributedText = attribute;
        [self.instructionsLab appendLinkWithText:@"提现规则" linkFont:ADaptedFontMediumSize(12) linkData:@"提现规则"];
        
    }
}
- (TYAttributedLabel *)instructionsLab {
    if (!_instructionsLab) {
        _instructionsLab = [[TYAttributedLabel alloc]init];
        _instructionsLab.numberOfLines=0;
        _instructionsLab.lineBreakMode = kCTLineBreakByCharWrapping;
        _instructionsLab.textColor = RGBCOLOR(161, 161, 161);
        _instructionsLab.textAlignment = kCTTextAlignmentCenter;
        _instructionsLab.font = CustomFont(12);
        _instructionsLab.delegate = self;
        _instructionsLab.linesSpacing = 5;
        _instructionsLab.linkColor = RGBCOLOR(74, 144, 226);
        _instructionsLab.backgroundColor = [UIColor clearColor];
    }
    return _instructionsLab;
}
- (UIButton *)tiXianButton {
    if (!_tiXianButton) {
        _tiXianButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_tiXianButton addTarget:self action:@selector(tixianClick:) forControlEvents:UIControlEventTouchUpInside];
        [_tiXianButton setTitle:@"确认提现" forState:UIControlStateNormal];
        _tiXianButton.titleLabel.font = CustomFont(15);
        [_tiXianButton setTitleColor:RGBCOLOR(0, 0, 0) forState:UIControlStateNormal];
        _tiXianButton.layer.cornerRadius = 3.5;
        _tiXianButton.layer.shadowOpacity = 0.5;//不透明度
        _tiXianButton.layer.shadowOffset = CGSizeMake(0, 1);//偏移距离
        _tiXianButton.layer.shadowColor = RGBCOLOR(216, 216, 216).CGColor;//阴影颜色
        _tiXianButton.enabled = NO;
        [_tiXianButton setTitleColor:[UIColor blackColor] forState:UIControlStateDisabled];
        _tiXianButton.backgroundColor = RGBCOLOR(216, 216, 216);


    }
    return _tiXianButton;
}

- (void)tixianClick:(UIButton *)sender {
    if (self.goToTixian) {
        self.goToTixian(sender);
    }
}

#pragma mark - TYAttributedLabelDelegate
- (void)attributedLabel:(TYAttributedLabel *)attributedLabel textStorageClicked:(id<TYTextStorageProtocol>)TextRun atPoint:(CGPoint)point {
    
    if ([TextRun isKindOfClass:[TYLinkTextStorage class]]) {
        NSString *linkStr = ((TYLinkTextStorage*)TextRun).linkData;
        if ([linkStr isEqualToString:@"提现规则"]) {
            if (self.goToTixianRule) {
                self.goToTixianRule();
            }
        }
    }
}

/**
 当前提现按钮是否可以点击

 @param isEnable 是否可以点击
 */
- (void)changeTiXianButtonStateIsEnable:(BOOL) isEnable {
    self.tiXianButton.enabled = isEnable;
    if (isEnable) {
        self.tiXianButton.backgroundColor = RGBCOLOR(244, 203, 7);
    }else{
        self.tiXianButton.backgroundColor = RGBCOLOR(216, 216, 216);
    }
}
/**
 当前提现按钮是否是微信
 */
- (void)changeTiXianButtonIsWeiXianTiXianType:(BOOL)isWeiXianTiXianType {
    if (isWeiXianTiXianType) {
        [self.tiXianButton setTitle:@"确认提现" forState:UIControlStateNormal];
    }else{
        [self.tiXianButton setTitle:@"下一步" forState:UIControlStateNormal];
    }
}

-(void)layoutSubviews {
    [super layoutSubviews];
    [self.tiXianButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(7.5);
        make.right.offset(-7.5);
        make.top.offset(12);
        make.height.equalTo(@50);
    }];
    
    [self.instructionsLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(16.5);
        make.width.equalTo(@(SCREEN_WIDTH-16.5*2));
        make.top.equalTo(self.tiXianButton.mas_bottom).offset(7);
        make.height.equalTo(@80);
    }];
    
}
@end
