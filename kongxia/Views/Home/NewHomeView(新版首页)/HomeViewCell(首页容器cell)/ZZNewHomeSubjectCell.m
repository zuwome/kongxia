//
//  ZZNewHomeSubjectCell.m
//  zuwome
//
//  Created by MaoMinghui on 2018/8/16.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZNewHomeSubjectCell.h"
#import "ZZNewHomeSubjectCellItem.h"

#define itemHeight 100
#define itemLineSpace 5

@interface ZZNewHomeSubjectCell ()

@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) ZZNewHomeSubjectCellItem *item1;
@property (nonatomic, strong) ZZNewHomeSubjectCellItem *item2;
@property (nonatomic, strong) ZZNewHomeSubjectCellItem *item3;
@property (nonatomic, strong) ZZNewHomeSubjectCellItem *item4;
@property (nonatomic, strong) ZZNewHomeSubjectCellItem *item5;

@end

@implementation ZZNewHomeSubjectCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    _title = [[UILabel alloc] init];
    _title.text = @"精选专题";
    _title.textColor = kBlackColor;
    _title.font = [UIFont systemFontOfSize:23 weight:(UIFontWeightBold)];
    [self.contentView addSubview:_title];
    [_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.leading.equalTo(@15);
        make.trailing.equalTo(@-15);
        make.height.equalTo(@50);
    }];
    
    _bgView = [[UIView alloc] init];
    _bgView.backgroundColor = [UIColor whiteColor];
    _bgView.clipsToBounds = YES;
    [self.contentView addSubview:_bgView];
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@50);
        make.leading.equalTo(@15);
        make.trailing.bottom.equalTo(@-15);
    }];
    
    CGFloat smallItemW = (SCREEN_WIDTH - 30 - 2 * itemLineSpace) / 3;
    CGFloat bigItemW = SCREEN_WIDTH - 30 - smallItemW - itemLineSpace;
    
    WeakSelf
    _item1 = [[ZZNewHomeSubjectCellItem alloc] init];
    _item1.specialTopicCallback = ^(ZZHomeSpecialTopicModel *model) {
        !weakSelf.specialTopicCallback ? : weakSelf.specialTopicCallback(model);
    };
    _item1.backgroundColor = kBGColor;
    _item1.cornerRadio = 5;
    _item1.showVideoIcon = YES;
    [_bgView addSubview:_item1];
    [_item1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.equalTo(@0);
        make.size.mas_equalTo(CGSizeMake(bigItemW, smallItemW));
    }];
    
    _item2 = [[ZZNewHomeSubjectCellItem alloc] init];
    _item2.specialTopicCallback = ^(ZZHomeSpecialTopicModel *model) {
        !weakSelf.specialTopicCallback ? : weakSelf.specialTopicCallback(model);
    };
    _item2.backgroundColor = kBGColor;
    _item2.cornerRadio = 5;
    [_bgView addSubview:_item2];
    [_item2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.leading.equalTo(_item1.mas_trailing).offset(itemLineSpace);
        make.size.mas_equalTo(CGSizeMake(smallItemW, smallItemW));
    }];
    
    _item3 = [[ZZNewHomeSubjectCellItem alloc] init];
    _item3.specialTopicCallback = ^(ZZHomeSpecialTopicModel *model) {
        !weakSelf.specialTopicCallback ? : weakSelf.specialTopicCallback(model);
    };
    _item3.backgroundColor = kBGColor;
    _item3.cornerRadio = 5;
    [_bgView addSubview:_item3];
    [_item3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(smallItemW + itemLineSpace));
        make.leading.equalTo(@0);
        make.size.mas_equalTo(CGSizeMake(smallItemW, smallItemW));
    }];
    
    _item4 = [[ZZNewHomeSubjectCellItem alloc] init];
    _item4.specialTopicCallback = ^(ZZHomeSpecialTopicModel *model) {
        !weakSelf.specialTopicCallback ? : weakSelf.specialTopicCallback(model);
    };
    _item4.backgroundColor = kBGColor;
    _item4.cornerRadio = 5;
    [_bgView addSubview:_item4];
    [_item4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_item3);
        make.leading.equalTo(_item3.mas_trailing).offset(itemLineSpace);
        make.size.mas_equalTo(CGSizeMake(smallItemW, smallItemW));
    }];
    
    _item5 = [[ZZNewHomeSubjectCellItem alloc] init];
    _item5.specialTopicCallback = ^(ZZHomeSpecialTopicModel *model) {
        !weakSelf.specialTopicCallback ? : weakSelf.specialTopicCallback(model);
    };
    _item5.backgroundColor = kBGColor;
    _item5.cornerRadio = 5;
    [_bgView addSubview:_item5];
    [_item5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_item3);
        make.leading.equalTo(_item4.mas_trailing).offset(itemLineSpace);
        make.size.mas_equalTo(CGSizeMake(smallItemW, smallItemW));
    }];
}

- (void)setSpecialTopicArray:(NSArray *)specialTopicArray {
    [super setSpecialTopicArray:specialTopicArray];
    if (specialTopicArray.count <= 0) {
        return;
    }
    if (specialTopicArray.count < 5) {  //只显示两个
        if (specialTopicArray[0]) {
            [_item1 setModel:specialTopicArray[0]];
        }
        if (specialTopicArray[1]) {
            [_item2 setModel:specialTopicArray[1]];
        }
    }
    if (specialTopicArray.count >= 5) { //显示5个
        if (specialTopicArray[0]) {
            [_item1 setModel:specialTopicArray[0]];
        }
        if (specialTopicArray[1]) {
            [_item2 setModel:specialTopicArray[1]];
        }
        if (specialTopicArray[2]) {
            [_item3 setModel:specialTopicArray[2]];
        }
        if (specialTopicArray[3]) {
            [_item4 setModel:specialTopicArray[3]];
        }
        if (specialTopicArray[4]) {
            [_item5 setModel:specialTopicArray[4]];
        }
    }
}

- (void)playVideo {
    if ([_item1 isVideo]) {
        [_item1 videoPlay];
    }
}

- (void)stopVideo {
    [_item1 videoStop];
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
