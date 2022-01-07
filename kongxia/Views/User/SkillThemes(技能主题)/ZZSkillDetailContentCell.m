//
//  ZZSkillDetailContentCell.m
//  zuwome
//
//  Created by MaoMinghui on 2018/8/13.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZSkillDetailContentCell.h"

@interface ZZSkillDetailContentCell ()

@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UILabel *content;

@end

@implementation ZZSkillDetailContentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
    }
    return self;
}

- (void)createUI {
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [self.contentView addSubview:self.title];
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.equalTo(@15);
        make.trailing.equalTo(@-15);
        make.height.equalTo(@20);
    }];
    switch (self.cellType) {
        case SkillDetaillCellTypeContent:
        case SkillDetaillCellTypeTip: {
            [self.contentView addSubview:self.content];
            [self.content mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(@15);
                make.top.equalTo(self.title.mas_bottom).offset(10);
                make.bottom.trailing.equalTo(@-15);
            }];
        } break;
        case SkillDetaillCellTypeFlow: {
            [self createFlowView];
        } break;
        case SkillDetaillCellTypeEnsure: {
            [self createEnsureView];
        } break;
        default: break;
    }
}
//邀约流程
- (void)createFlowView {
    for (NSInteger i = 0; i < 5; i++) {
        UIView *item = [self createFlowItemAtIndex:i];
        [self.contentView addSubview:item];
        [item mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH / 5, 80));
            make.leading.equalTo(@(SCREEN_WIDTH / 5 * i));
            make.top.equalTo(self.title.mas_bottom).offset(15);
            make.bottom.equalTo(@0);
        }];
    }
}
- (UIView *)createFlowItemAtIndex:(NSInteger)index {
    NSString *title = @"";
    NSString *icon = @"";
    switch (index) {
        case 0:
            title = @"填写邀约信息"; icon = @"icTianxiexinxiZhutixiangqing"; break;
        case 1:
            title = @"支付意向金"; icon = @"icZhifuyixiangjinZhutixiangqing"; break;
        case 2:
            title = @"对方接受后付全款"; icon = @"icFuquankuanZhutixiangqing"; break;
        case 3:
            title = @"见面"; icon = @"icJianmianZhutixiangqing"; break;
        case 4:
            title = @"评价"; icon = @"icPingjiaZhutixiangqing"; break;
    }
    UIView *item = [[UIView alloc] init];
    UIButton *titleBtn = [[UIButton alloc] init];
    [titleBtn setTitle:title forState:(UIControlStateNormal)];
    [titleBtn setTitleColor:kBrownishGreyColor forState:(UIControlStateNormal)];
    [titleBtn.titleLabel setFont:[UIFont systemFontOfSize:12 weight:(UIFontWeightMedium)]];
    [titleBtn.titleLabel setNumberOfLines:0];
    [titleBtn.titleLabel setTextAlignment:(NSTextAlignmentCenter)];
    [item addSubview:titleBtn];
    [titleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@5);
        make.leading.equalTo(@5);
        make.trailing.equalTo(@-5);
        make.height.greaterThanOrEqualTo(@17);
    }];
    UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:icon]];
    img.contentMode = UIViewContentModeScaleAspectFit;
    [item addSubview:img];
    [img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleBtn.mas_bottom).offset(8);
        make.centerX.equalTo(item);
        make.bottom.equalTo(@-15);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    UIView *leftLine = [[UIView alloc] init];
    leftLine.backgroundColor = RGBCOLOR(209, 209, 209);
    [item addSubview:leftLine];
    [leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(img);
        make.leading.equalTo(@0);
        make.trailing.equalTo(img.mas_centerX);
        make.height.equalTo(@2);
    }];
    UIView *rightLine = [[UIView alloc] init];
    rightLine.backgroundColor = RGBCOLOR(209, 209, 209);
    [item addSubview:rightLine];
    [rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(img);
        make.trailing.equalTo(@0);
        make.leading.equalTo(img.mas_centerX);
        make.height.equalTo(@2);
    }];
    [item bringSubviewToFront:img];
    if (index == 0) {
        leftLine.hidden = YES;
    } else if (index == 4) {
        rightLine.hidden = YES;
    }
    return item;
}
//平台保障
- (void)createEnsureView {
    for (NSInteger i = 0; i < 3; i++) {
        UIView *item = [self createEnsureItemAtIndex:i];
        [self.contentView addSubview:item];
        [item mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.title.mas_bottom).offset(15);
            make.width.equalTo(@(SCREEN_WIDTH / 3));
            make.leading.equalTo(@(SCREEN_WIDTH / 3 * i));
            make.bottom.equalTo(@-15);
        }];
    }
}
- (UIView *)createEnsureItemAtIndex:(NSInteger)index {
    NSString *title = @"";
    NSString *subTitle = @"";
    NSString *icon = @"";
    switch (index) {
        case 0:
            title = @"真实资料";
            subTitle = @"实名认证 真实可靠";
            icon = @"icZhenshiziliaoZhutixiangqing";
            break;
        case 1:
            title = @"资金安全";
            subTitle = @"平台监督 保障安全";
            icon = @"icZijinanquanZhutixiangqing";
            break;
        case 2:
            title = @"在线客服";
            subTitle = @"在线客服 全程服务";
            icon = @"icZaixiankefuZhutixiangqing";
            break;
    }
    UIView *item = [[UIView alloc] init];
    UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:icon]];
    img.contentMode = UIViewContentModeScaleAspectFit;
    [item addSubview:img];
    [img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(item);
        make.size.mas_equalTo(CGSizeMake(30, 30));
        make.top.equalTo(@0);
    }];
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.text = title;
    titleLab.textColor = kBlackColor;
    titleLab.font = [UIFont systemFontOfSize:12 weight:(UIFontWeightMedium)];
    titleLab.textAlignment = NSTextAlignmentCenter;
    [item addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(item);
        make.top.equalTo(img.mas_bottom).offset(10);
        make.height.equalTo(@17);
        make.leading.trailing.equalTo(@0);
    }];
    UILabel *subTitleLab = [[UILabel alloc] init];
    subTitleLab.text = subTitle;
    subTitleLab.textColor = kBrownishGreyColor;
    subTitleLab.font = [UIFont systemFontOfSize:12];
    subTitleLab.textAlignment = NSTextAlignmentCenter;
    [item addSubview:subTitleLab];
    [subTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(item);
        make.top.equalTo(titleLab.mas_bottom).offset(5);
        make.height.equalTo(@17);
        make.leading.trailing.equalTo(@0);
        make.bottom.equalTo(@0);
    }];
    return item;
}

- (void)setCellType:(SkillDetaillCellType)cellType {
    [super setCellType:cellType];
    [self createUI];
}

- (void)setTopicModel:(ZZTopic *)topicModel {
    ZZSkill *skill = topicModel.skills[0];
    switch (self.cellType) {
        case SkillDetaillCellTypeContent:
            self.title.text = @"主题介绍";
            self.content.text = skill.detail.content;
            break;
        case SkillDetaillCellTypeFlow:
            self.title.text = @"邀约流程";
            break;
        case SkillDetaillCellTypeEnsure:
            self.title.text = @"平台保障";
            break;
        case SkillDetaillCellTypeTip:
            self.title.text = @"温馨提示";
            self.content.text = @"* 达人接受前可以退意向金，邀约完成前，资金由平台保管。\n* 邀约过程中，多与达人沟通，使用文明用语，如遇纠纷，请联系客服处理。\n* 为了保障您的利益，请不要使用空虾以外的第三方聊天工具与达人联系，或线下交易，平台仅视空虾内的聊天记录为有效证据。\n* 若申请退款，请提供有效证据，平台有权根据双方提供证据判定责任和退款比例。";
            break;
        default: break;
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (UILabel *)title {
    if (nil == _title) {
        _title = [[UILabel alloc] init];
        _title.font = [UIFont systemFontOfSize:15 weight:(UIFontWeightBold)];
        _title.textColor = kBlackColor;
    }
    return _title;
}
- (UILabel *)content {
    if (nil == _content) {
        _content = [[UILabel alloc] init];
        _content.font = [UIFont systemFontOfSize:12];
        _content.textColor = kBrownishGreyColor;
        _content.numberOfLines = 0;
    }
    return _content;
}

@end
