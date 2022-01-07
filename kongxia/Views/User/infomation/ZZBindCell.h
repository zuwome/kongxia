//
//  ZZBindCell.h
//  zuwome
//
//  Created by angBiu on 16/6/17.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZZUser;
@class ZZRedPointView;

@interface ZZBindCell : UITableViewCell

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *bindBtn;
@property (nonatomic, strong) UIView *lineView;//线
@property (nonatomic, strong) ZZRedPointView *redPointView;
@property (nonatomic, copy) dispatch_block_t touchBind;

- (void)setDataModel:(ZZUser *)user indexPath:(NSIndexPath *)indexPath;

@end
