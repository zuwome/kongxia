//
//  HostModel.h
//  Pods
//
//  Created by wlsy on 16/1/22.
//
//

#import <Foundation/Foundation.h>

@interface HostModel : NSObject

@property (strong, nonatomic) NSString *host;
@property (strong, nonatomic) NSString *ip;
@property (assign) BOOL isExpired;

@end
