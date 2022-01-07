//
//  ZZBeautyManager.m
//  zuwome
//
//  Created by qiming xiao on 2019/4/8.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZBeautyManager.h"

@implementation ZZBeautyManager
singleton_implementation(ZZBeautyManager)

- (AgoraBeautyOptions *)safeFilterSettings:(FilterType)filterType value:(CGFloat)value {
    NSMutableDictionary *param = [[ZZKeyValueStore getValueWithKey:[ZZStoreKey sharedInstance].filterOptions] mutableCopy];
    if (!param) {
        param = @{}.mutableCopy;
        param[@"lighteningContrastLevel"] = @(AgoraLighteningContrastNormal);
    }

    if (filterType == FilterTypeWhitening) {
        param[@"lighteningLevel"] = @(value);
    }
    else if (filterType == FilterTypeMopi) {
        param[@"smoothnessLevel"] = @(value);
    }
    else if (filterType == FilterTypeRosy) {
        param[@"rednessLevel"] = @(value);
    }

    AgoraBeautyOptions *filterOption = [[AgoraBeautyOptions alloc] init];
    filterOption.lighteningContrastLevel = AgoraLighteningContrastNormal;
    filterOption.lighteningLevel = param[@"lighteningLevel"] ? [param[@"lighteningLevel"] floatValue] : 0.5;
    filterOption.smoothnessLevel = param[@"smoothnessLevel"] ? [param[@"smoothnessLevel"] floatValue] : 0.5;
    filterOption.rednessLevel = param[@"rednessLevel"] ? [param[@"rednessLevel"] floatValue] : 0.5;

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [ZZKeyValueStore saveValue:param key:[ZZStoreKey sharedInstance].filterOptions];
    });
    return filterOption;
}

- (AgoraBeautyOptions *)loadFilterSetting {
    NSMutableDictionary *param = [ZZKeyValueStore getValueWithKey:[ZZStoreKey sharedInstance].filterOptions];
    AgoraBeautyOptions *filterOption = [[AgoraBeautyOptions alloc] init];
    filterOption.lighteningContrastLevel = AgoraLighteningContrastNormal;
    filterOption.lighteningLevel = param[@"lighteningLevel"] ? [param[@"lighteningLevel"] floatValue] : 0.5;
    filterOption.smoothnessLevel = param[@"smoothnessLevel"] ? [param[@"smoothnessLevel"] floatValue] : 0.5;
    filterOption.rednessLevel = param[@"rednessLevel"] ? [param[@"rednessLevel"] floatValue] : 0.5;
    return filterOption;
}

@end
