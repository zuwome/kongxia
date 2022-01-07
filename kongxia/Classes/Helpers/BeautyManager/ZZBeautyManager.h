//
//  ZZBeautyManager.h
//  zuwome
//
//  Created by qiming xiao on 2019/4/8.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AgoraRtcKit/AgoraRtcEngineKit.h>

typedef NS_ENUM(NSInteger, FilterType) {
    FilterTypeWhitening = 0,
    FilterTypeMopi,
    FilterTypeRosy,
    FilterTypeLighteningContrast
};

@interface ZZBeautyManager : NSObject

+ (instancetype)shared;

- (AgoraBeautyOptions *)safeFilterSettings:(FilterType)filterType value:(CGFloat)value;

- (AgoraBeautyOptions *)loadFilterSetting;

@end


