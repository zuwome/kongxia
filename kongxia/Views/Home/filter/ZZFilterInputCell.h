//
//  ZZFilterInputCell.h
//  zuwome
//
//  Created by angBiu on 16/5/25.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZZUser;
/**
 *  人名搜索结果cell
 */
@interface ZZFilterInputCell : UITableViewCell

@property (nonatomic, strong) UIImageView *headImgView;//头像
@property (nonatomic, strong) UILabel *nameLabel;//昵称
@property (nonatomic, strong) UILabel *briefLabel;//简介
@property (nonatomic, strong) UIImageView *sexImgView;//性别
@property (nonatomic, strong) ZZLevelImgView *levelImgView;

- (void)setDataModel:(ZZUser *)model highlight:(NSString *)highlight;

@end
