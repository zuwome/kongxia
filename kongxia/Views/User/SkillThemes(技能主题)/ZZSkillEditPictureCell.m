//
//  ZZSkillEditPictureCell.m
//  zuwome
//
//  Created by MaoMinghui on 2018/8/3.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZSkillEditPictureCell.h"

@interface ZZSkillEditPictureCell ()

@property (nonatomic, strong) UILabel *title;

@property (nonatomic, strong) ZZSubmitThemePictureViewController *pictureCtrl;

@property (nonatomic, strong) UIButton *rightBtn;

@end

@implementation ZZSkillEditPictureCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createView];
    }
    return self;
}

- (void)addToParentViewController:(UIViewController *)viewController {
    [viewController addChildViewController:self.pictureCtrl];
}

- (void)createView {
    [self.contentView addSubview:self.title];
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.equalTo(@15);
        make.height.equalTo(@20);
    }];
    [self.contentView addSubview:self.rightBtn];
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 20));
        make.centerY.equalTo(self.title);
        make.trailing.equalTo(self.contentView).offset(-15);
        make.leading.equalTo(self.title.mas_trailing).offset(10);
    }];
    [self.contentView addSubview:self.pictureCtrl.view];
    [self.pictureCtrl.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.title.mas_bottom);
        make.leading.trailing.bottom.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, PictureCollectionFooterHeight + PictureCollectionItemHeight + 20));
    }];
    [_rightBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -_rightBtn.imageView.size.width - 2, 0, _rightBtn.imageView.size.width + 2)];
    [_rightBtn setImageEdgeInsets:UIEdgeInsetsMake(0, _rightBtn.titleLabel.bounds.size.width + 2, 0, -_rightBtn.titleLabel.bounds.size.width - 2)];
}

- (void)setTopicModel:(ZZTopic *)topicModel {
    super.topicModel = topicModel;
    ZZSkill *skill = topicModel.skills[0];
    self.pictureCtrl.pictureArray = [NSMutableArray arrayWithArray:skill.photo];
    self.pictureCtrl.topic = topicModel;
    WeakSelf
    [self.pictureCtrl setSavePhotoCallback:^(NSArray<ZZPhoto> *photos) {
        weakSelf.isUpdated = YES;   //更新修改标记
        [ZZSkillThemesHelper shareInstance].photoUpdate = YES;
        skill.photo = photos;
    }];
}

- (BOOL)synconizePhotos {
    //调用pictureCtrl的方法，将pictureCtrl的图片数据同步到cell的model中
    return [self.pictureCtrl savePhotoManual];
}

#pragma mark -- lazy load
- (ZZSubmitThemePictureViewController *)pictureCtrl {
    if (nil == _pictureCtrl) {
        _pictureCtrl = [[ZZSubmitThemePictureViewController alloc] init];
    }
    return _pictureCtrl;
}
- (UILabel *)title {
    if (nil == _title) {
        _title = [[UILabel alloc] init];
        _title.text = @"上传图片";
        _title.font = [UIFont systemFontOfSize:14];
    }
    return _title;
}
- (UIButton *)rightBtn {
    if (nil == _rightBtn) {
        _rightBtn = [[UIButton alloc] init];
        _rightBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        _rightBtn.userInteractionEnabled = NO;
        [_rightBtn setTitle:@"去上传" forState:(UIControlStateNormal)];
        [_rightBtn setTitleColor:RGBCOLOR(190, 190, 190) forState:UIControlStateNormal];
        [_rightBtn setImage:[UIImage imageNamed:@"icon_report_right"] forState:UIControlStateNormal];
    }
    return _rightBtn;
}

@end
