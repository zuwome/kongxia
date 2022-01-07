//
//  ZZPostTaskThemeTagsCell.m
//  kongxia
//
//  Created by qiming xiao on 2019/10/25.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZPostTaskThemeTagsCell.h"
#import "ZZPostTaskViewModel.h"
#import "ZZSkill.h"

@interface ZZPostTaskThemeTagsCell ()

@property (nonatomic, strong) UIView *line;

@property (nonatomic, copy) NSArray<UILabel *> *tagsArray;

@end

@implementation ZZPostTaskThemeTagsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self layout];
    }
    return self;
}

- (void)configureData {
    self.accessoryType = _cellModel.accessoryType;
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    
    if (![_cellModel.data isKindOfClass:[ZZSkill class]]) {
        return;
    }
    
    ZZSkill *skill = (ZZSkill *)_cellModel.data;
    
    [_tagsArray enumerateObjectsUsingBlock:^(UILabel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (skill.tags.count == 0) {
            obj.frame = CGRectZero;
            obj.hidden = YES;
        }
        else {
            if (idx < skill.tags.count) {
                ZZSkillTag *tag = skill.tags[idx];
                obj.hidden = NO;
                obj.frame = [_cellModel.tagsFrameArray[idx] CGRectValue];
                obj.text = tag.name;
            }
            else {
                obj.frame = CGRectZero;
                obj.hidden = YES;
            }
        }
    }];
}

#pragma mark - UI
- (void)layout {
    self.backgroundColor = RGBCOLOR(247, 247, 247);
    
    [self addSubview:self.line];
    
    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.right.equalTo(self).offset(-15.0);
        make.left.equalTo(self).offset(15.0);
        make.height.equalTo(@0.5);
    }];
    
    NSMutableArray *arrM = @[].mutableCopy;
    for (NSInteger i = 0; i < 5; i++) {
        UILabel *label = [[UILabel alloc] init];
        label.textColor = RGBCOLOR(63, 58, 58);
        label.layer.cornerRadius = 2;
        label.font = [UIFont fontWithName:@"PingFangSC-Medium" size:12];
        label.layer.borderWidth = 1;
        label.layer.borderColor = RGBCOLOR(153, 153, 153).CGColor;
        label.hidden = YES;
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        [arrM addObject:label];
//        label.padding = UIEdgeInsetsMake(5, 8, 5, 8);
    }
    _tagsArray = arrM.copy;
}

#pragma mark - Getter&Setter
- (void)setCellModel:(ZZPostTaskCellModel *)cellModel {
    _cellModel = cellModel;
    [self configureData];
}

- (UIView *)line {
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = RGBCOLOR(237, 237, 237);
    }
    return _line;
}

@end
