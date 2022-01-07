//
//  ZZSlider.m
//  zuwome
//
//  Created by qiming xiao on 2019/4/10.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZSlider.h"

@implementation ZZSlider

- (instancetype)init {
    self = [super init];
    if (self) {
        self.minimumTrackTintColor = ColorWhite;
        self.maximumTrackTintColor = RGBACOLOR(255, 255, 255, 0.26);
    }
    return self;
}


@end
