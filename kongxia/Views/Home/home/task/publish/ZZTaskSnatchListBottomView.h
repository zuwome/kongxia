//
//  ZZTaskSnatchListBottomView.h
//  zuwome
//
//  Created by angBiu on 2017/8/8.
//  Copyright © 2017年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZZTaskSnatchListBottomView : UIView

@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UIButton *detailBtn;
@property (nonatomic, strong) UIButton *rentBtn;
@property (nonatomic, strong) UILabel *infoLabel;

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) double price;
@property (nonatomic, assign) double sumPrice;

@property (nonatomic, copy) dispatch_block_t touchRent;
@property (nonatomic, copy) dispatch_block_t touchDetail;

@end
