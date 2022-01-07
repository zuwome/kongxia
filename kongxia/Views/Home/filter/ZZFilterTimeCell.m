//
//  ZZFiltertTimeCell.m
//  zuwome
//
//  Created by angBiu on 16/8/29.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZFilterTimeCell.h"

@implementation ZZFilterTimeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.contentView.clipsToBounds = YES;
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = kLineViewColor;
        [self.contentView addSubview:lineView];
        
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(15);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
            make.top.mas_equalTo(self.contentView.mas_top);
            make.height.mas_equalTo(@0.5);
        }];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.textColor = kGrayContentColor;
        titleLabel.font = [UIFont systemFontOfSize:15];
        titleLabel.text = @"档期";
        [self.contentView addSubview:titleLabel];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(15);
            make.top.mas_equalTo(self.contentView.mas_top).offset(15);
        }];
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(50, 50);
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        flowLayout.minimumLineSpacing = 10;
        flowLayout.minimumInteritemSpacing = 10;
        
        _selectView = [[ZZSelectView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _selectView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_selectView];
        
        [_selectView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left);
            make.right.mas_equalTo(self.contentView.mas_right);
            make.top.mas_equalTo(titleLabel.mas_bottom).offset(15);
            make.height.mas_equalTo(@50);
        }];
        
        _selectView.options = @[@"全天", @"节假日", @"偶尔", @"白天", @"晚上"];
        _selectView.allowsMultipleSelection = YES;
    }
    
    return self;
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
