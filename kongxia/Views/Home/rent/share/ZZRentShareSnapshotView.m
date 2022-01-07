//
//  ZZRentShareSnapshotView.m
//  zuwome
//
//  Created by angBiu on 2016/11/21.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZRentShareSnapshotView.h"
#import "ZZRentShareSnapshotLabelView.h"
#import "GPUImage.h"

@interface ZZRentShareSnapshotView () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIImageView *bgImgView;
@property (nonatomic, strong) UIImageView *headImgView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *skillLabel;
@property (nonatomic, strong) UILabel *memehaoLabel;
//@property (nonatomic, strong) UILabel *interestLabel;
@property (nonatomic, strong) UILabel *personLabel;
//@property (nonatomic, strong) UILabel *constellationLabel;
//@property (nonatomic, strong) UILabel *heightLabel;
@property (nonatomic, strong) UILabel *locationLabel;
@property (nonatomic, strong) UILabel *introduceLabel;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ZZRentShareSnapshotView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:self.tableView];
        self.tableView.tableHeaderView = self.bgImgView;
    }
    
    return self;
}

- (void)getShareSnapshotImage:(void (^)(UIImage *))success failure:(void (^)(void))failure
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIImage *image = [ZZUtils getScrollViewimage:self.tableView];
        if (image) {
            dispatch_async(dispatch_get_main_queue(), ^{
                success(image);
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                failure();
            });
        }
    });
}

- (void)setUser:(ZZUser *)user
{
    _user = user;
    
    [self.headImgView sd_setImageWithURL:[NSURL URLWithString:user.avatar]];
    self.nameLabel.text = _user.nickname;
    if (user.rent.topics.count != 0) {
        ZZTopic *topic = user.rent.topics[0];
        ZZSkill *skill = topic.skills[0];
        self.skillLabel.text = [NSString stringWithFormat:@"%@：%@元/小时",skill.name,topic.price];
    } else {
        self.skillLabel.text = @"";
    }
    if (isNullString(self.skillLabel.text)) {
        [_skillLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_nameLabel.mas_bottom);
        }];
    }
    self.memehaoLabel.text = [NSString stringWithFormat:@"么么号：%@",_user.ZWMId];
    
//    if (user.interests_new.count != 0) {
//        NSMutableArray *array = [NSMutableArray array];
//        for (ZZUserLabel *label in user.interests_new) {
//            [array addObject:label.content];
//        }
//        self.interestLabel.text = [NSString stringWithFormat:@"兴趣爱好：%@",[array componentsJoinedByString:@"、"]];
//    } else {
//        self.interestLabel.text = @"";
//    }
//    if (isNullString(self.interestLabel.text)) {
//        [self.interestLabel mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(_memehaoLabel.mas_bottom);
//        }];
//    }
    if (user.tags_new.count != 0) {
        NSMutableArray *array = [NSMutableArray array];
        for (ZZUserLabel *label in user.tags_new) {
            [array addObject:label.content];
        }
        self.personLabel.text = [NSString stringWithFormat:@"个人标签：%@",[array componentsJoinedByString:@"、"]];
    } else {
        self.personLabel.text = @"";
    }
    if (isNullString(self.personLabel.text)) {
        [self.personLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_memehaoLabel.mas_bottom);
        }];
    }
//    if (isNullString(user.constellation)) {
//        self.constellationLabel.text = @"";
//        [self.constellationLabel mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(_personLabel.mas_bottom);
//        }];
//    } else {
//        self.constellationLabel.text = [NSString stringWithFormat:@"星座：%@",user.constellation];
//    }
//    if (isNullString(user.heightIn)) {
//        self.heightLabel.text = @"";
//        [self.heightLabel mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(_constellationLabel.mas_bottom);
//        }];
//    } else {
//        self.heightLabel.text = [NSString stringWithFormat:@"身高：%@",user.heightIn];
//    }
    if (isNullString(user.address.city)) {
        self.locationLabel.text = @"";
        [self.locationLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_personLabel.mas_bottom);
        }];
    } else {
        self.locationLabel.text = [NSString stringWithFormat:@"常住地：%@",user.address.city];
    }
    if (isNullString(user.bio)) {
        self.introduceLabel.text = @"";
        [self.introduceLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_locationLabel.mas_bottom);
        }];
    } else {
        self.introduceLabel.text = [NSString stringWithFormat:@"自我介绍：%@",user.bio];
    }
    self.bottomView.backgroundColor = [UIColor whiteColor];
    
    CGFloat height = [self.bgImgView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    self.bgImgView.frame = CGRectMake(0, 0, SCREEN_WIDTH, height);
    self.tableView.tableHeaderView = self.bgImgView;
}

#pragma mark - UITableViewMethod

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

#pragma mark - lazyload

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
    }
    return _tableView;
}

- (UIImageView *)bgImgView
{
    if (!_bgImgView) {
        _bgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
        _bgImgView.image = [UIImage imageNamed:@"icon_share_bg"];
    }
    return _bgImgView;
}

- (UIImageView *)headImgView
{
    if (!_headImgView) {
        _headImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, SCREEN_WIDTH)];
        _headImgView.clipsToBounds = YES;
        _headImgView.contentMode = UIViewContentModeScaleAspectFill;
        [_bgImgView addSubview:_headImgView];
        
        [_headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_bgImgView.mas_left).offset(8);
            make.right.mas_equalTo(_bgImgView.mas_right).offset(-8);
            make.top.mas_equalTo(_bgImgView.mas_top).offset(5);
            make.height.mas_equalTo(SCREEN_WIDTH - 16);
        }];
    }
    
    return _headImgView;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = kBlackTextColor;
        _nameLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:22];
        [_bgImgView addSubview:_nameLabel];
        
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_headImgView.mas_bottom).offset(10);
            make.left.mas_equalTo(_bgImgView.mas_left).offset(25);
            make.right.mas_equalTo(_bgImgView.mas_right).offset(-25);
        }];
    }
    
    return _nameLabel;
}

- (UILabel *)skillLabel
{
    if (!_skillLabel) {
        _skillLabel = [[UILabel alloc] init];
        _skillLabel.textColor = kRedTextColor;
        _skillLabel.font = [UIFont systemFontOfSize:19];
        [_bgImgView addSubview:_skillLabel];
        
        [_skillLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_nameLabel.mas_left);
            make.top.mas_equalTo(_nameLabel.mas_bottom).offset(15);
        }];
    }
    
    return _skillLabel;
}

- (UILabel *)memehaoLabel
{
    if (!_memehaoLabel) {
        _memehaoLabel = [[UILabel alloc] init];
        _memehaoLabel.textColor = HEXCOLOR(0x696969);
        _memehaoLabel.font = [UIFont systemFontOfSize:14];
        [_bgImgView addSubview:_memehaoLabel];
        
        [_memehaoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_skillLabel.mas_left);
            make.top.mas_equalTo(_skillLabel.mas_bottom).offset(12);
        }];
    }
    
    return _memehaoLabel;
}

//- (UILabel *)interestLabel
//{
//    if (!_interestLabel) {
//        _interestLabel = [[UILabel alloc] init];
//        _interestLabel.textColor = HEXCOLOR(0x696969);
//        _interestLabel.font = [UIFont systemFontOfSize:14];
//        _interestLabel.numberOfLines = 0;
//        [_bgImgView addSubview:_interestLabel];
//        
//        [_interestLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(_skillLabel.mas_left);
//            make.top.mas_equalTo(_memehaoLabel.mas_bottom).offset(12);
//            make.width.mas_equalTo(SCREEN_WIDTH - 50);
//        }];
//    }
//    return _interestLabel;
//}

- (UILabel *)personLabel
{
    if (!_personLabel) {
        _personLabel = [[UILabel alloc] init];
        _personLabel.textColor = HEXCOLOR(0x696969);
        _personLabel.font = [UIFont systemFontOfSize:14];
        _personLabel.numberOfLines = 0;
        [_bgImgView addSubview:_personLabel];
        
        [_personLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_memehaoLabel.mas_left);
            make.top.mas_equalTo(_memehaoLabel.mas_bottom).offset(12);
            make.width.mas_equalTo(SCREEN_WIDTH - 50);
        }];
    }
    return _personLabel;
}
//
//- (UILabel *)constellationLabel
//{
//    if (!_constellationLabel) {
//        _constellationLabel = [[UILabel alloc] init];
//        _constellationLabel.textColor = HEXCOLOR(0x696969);
//        _constellationLabel.font = [UIFont systemFontOfSize:14];
//        [_bgImgView addSubview:_constellationLabel];
//        
//        [_constellationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(_personLabel.mas_left);
//            make.top.mas_equalTo(_personLabel.mas_bottom).offset(12);
//        }];
//    }
//    return _constellationLabel;
//}
//
//- (UILabel *)heightLabel
//{
//    if (!_heightLabel) {
//        _heightLabel = [[UILabel alloc] init];
//        _heightLabel.textColor = HEXCOLOR(0x696969);
//        _heightLabel.font = [UIFont systemFontOfSize:14];
//        [_bgImgView addSubview:_heightLabel];
//        
//        [_heightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(_constellationLabel.mas_left);
//            make.top.mas_equalTo(_constellationLabel.mas_bottom).offset(12);
//        }];
//    }
//    return _heightLabel;
//}

- (UILabel *)locationLabel
{
    if (!_locationLabel) {
        _locationLabel = [[UILabel alloc] init];
        _locationLabel.textColor = HEXCOLOR(0x696969);
        _locationLabel.font = [UIFont systemFontOfSize:14];
        [_bgImgView addSubview:_locationLabel];
        
        [_locationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_personLabel.mas_left);
            make.top.mas_equalTo(_personLabel.mas_bottom).offset(12);
        }];
    }
    return _locationLabel;
}

- (UILabel *)introduceLabel
{
    if (!_introduceLabel) {
        _introduceLabel = [[UILabel alloc] init];
        _introduceLabel.textColor = HEXCOLOR(0x696969);
        _introduceLabel.font = [UIFont systemFontOfSize:14];
        _introduceLabel.numberOfLines = 0;
        [_bgImgView addSubview:_introduceLabel];
        
        [_introduceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_locationLabel.mas_left);
            make.top.mas_equalTo(_locationLabel.mas_bottom).offset(12);
            make.width.mas_equalTo(SCREEN_WIDTH - 50);
        }];
    }
    return _introduceLabel;
}

- (UIView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = [UIColor whiteColor];
        [_bgImgView addSubview:_bottomView];
        
        [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(_bgImgView);
            make.top.mas_equalTo(_introduceLabel.mas_bottom).offset(30);
            make.height.mas_equalTo(@125);
        }];
        
        UIImageView *logoImgView = [[UIImageView alloc] init];
        logoImgView.image = [UIImage imageNamed:@"sharedIcon"];
        [_bottomView addSubview:logoImgView];
        
        [logoImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_bottomView.mas_left).offset(20);
            make.top.mas_equalTo(_bottomView.mas_top).offset(15);
            make.size.mas_equalTo(CGSizeMake(70, 70));
        }];
        
//        UILabel *sloganLabel = [[UILabel alloc] init];
//        sloganLabel.textColor = HEXCOLOR(0x5D5D5D);
//        sloganLabel.font = [UIFont systemFontOfSize:14];
//        sloganLabel.text = @"国民经纪人";
//        [_bottomView addSubview:sloganLabel];
//
//        [sloganLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(logoImgView.mas_right).offset(5);
//            make.bottom.mas_equalTo(logoImgView.mas_bottom).offset(-3);
//        }];
//
        UIImageView *titleImgView = [[UIImageView alloc] init];
        titleImgView.image = [UIImage imageNamed:@"sharedText"];
        [_bottomView addSubview:titleImgView];

        [titleImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(logoImgView.mas_right).offset(6.5);
            make.bottom.mas_equalTo(logoImgView).offset(-3.5);
            make.size.mas_equalTo(CGSizeMake(81.5, 37.5));
        }];
        
        UIImageView *codeImgView = [[UIImageView alloc] init];
        codeImgView.image = [UIImage imageNamed:@"icon_share_code"];
        [_bottomView addSubview:codeImgView];
        
        [codeImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_bottomView.mas_top).offset(3);
            make.right.mas_equalTo(_bottomView.mas_right).offset(-15);
            make.size.mas_equalTo(CGSizeMake(88, 88));
        }];
        
        UILabel *infoLabel = [[UILabel alloc] init];
        infoLabel.textAlignment = NSTextAlignmentRight;
        infoLabel.textColor = HEXCOLOR(0x696969);
        infoLabel.numberOfLines = 0;
        infoLabel.font = [UIFont systemFontOfSize:12];
        infoLabel.text = @"长按键识别二维码\n下载APP";
        [_bottomView addSubview:infoLabel];
        
        [infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(codeImgView.mas_bottom);
            make.right.mas_equalTo(codeImgView.mas_right);
        }];
    }
    return _bottomView;
}

@end
