//
//  ZZPayGuaranteeCell.h
//  zuwome
//
//  Created by qiming xiao on 2019/4/19.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZZPayGuaranteeCell : ZZTableViewCell

@property (nonatomic, copy) NSDictionary *guaranteeTexts;

- (void)isPayTonggao:(BOOL)isPayTonggao guaranteeTexts:(NSDictionary *)guaranteeTexts;

@end

NS_ASSUME_NONNULL_END
