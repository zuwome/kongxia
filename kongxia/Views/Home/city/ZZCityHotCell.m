//
//  ZZCityHotCell.m
//  zuwome
//
//  Created by angBiu on 16/7/27.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZCityHotCell.h"
#import "SKTagView.h"
#import "ZZCity.h"

@implementation ZZCityHotCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        
        _tagView = [[SKTagView alloc] init];
        _tagView.backgroundColor = [UIColor clearColor];
        _tagView.padding = UIEdgeInsetsMake(0, 0, 0, 0);
        _tagView.lineSpacing = 13;
        _tagView.interitemSpacing = 10;
        _tagView.preferredMaxLayoutWidth = SCREEN_WIDTH - 30;
        [self.contentView addSubview:_tagView];
        
        [_tagView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(15);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
            make.top.mas_equalTo(self.contentView.mas_top).offset(10);
            make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-10);
        }];
    }
    
    return self;
}

- (void)setData:(NSArray *)array
{
    __weak typeof(self)weakSelf = self;
    _tagView.didTapTagAtIndex = ^(NSUInteger index){
        if (weakSelf.selectIndex) {
            weakSelf.selectIndex(index);
        }
    };
    [self.tagView removeAllTags];
    
    [array enumerateObjectsUsingBlock:^(ZZCity *city, NSUInteger idx, BOOL *stop)
     {
         SKTag *tag = [SKTag tagWithText:city.name];
         tag.textColor = UIColor.whiteColor;
         tag.bgColor = [UIColor whiteColor];
         tag.cornerRadius = 2;
         tag.fontSize = 14;
         tag.textColor = kBlackTextColor;
         tag.enable = YES;
         tag.padding = UIEdgeInsetsMake(5, 8, 5, 8);
         
         [self.tagView addTag:tag];
     }];
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
