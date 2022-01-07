//
//  HttpDNS.m
//  Pods
//
//  Created by wlsy on 16/1/22.
//
//

#import "HttpDNS.h"
#import "HostModel.h"



#define DNSPOD_SERVER_IP @"119.29.29.29"

@interface HttpDNS()
{
    NSMutableDictionary* _hostManager;
}
@end


@implementation HttpDNS

+ (HttpDNS *)shareInstance {
    static dispatch_once_t p = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&p, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

-(id)init {
    if (self = [super init]) {
        _hostManager = [[NSMutableDictionary alloc] init];
        
        Reachability* reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
        
        // Tell the reachability that we DON'T want to be reachable on 3G/EDGE/CDMA
        reach.reachableOnWWAN = NO;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(reachabilityChanged:)
                                                     name:kReachabilityChangedNotification
                                                   object:nil];
        
        [reach startNotifier];
    }
    return self;
}


-(void)getIpByHost:(NSString *)host next:(httpDNSNext)next {
    
    // 从缓存获取
    HostModel *cache = [_hostManager objectForKey:host];
    if (cache && [cache isKindOfClass:[HostModel class]] && !cache.isExpired) {
        NSLog(@"get ip by %@ from cache", host);
        return next(NULL, cache.ip);
    }
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/d?dn=%@", DNSPOD_SERVER_IP, host]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:URL
                                                                cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                            timeoutInterval:5];

    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      if (error) {
                                          return next(error, NULL);
                                      }
                                      NSString *ret = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                      if (ret.length == 0) {
                                          NSMutableDictionary* details = [NSMutableDictionary dictionary];
                                          [details setValue:@"Ip is empty" forKey:NSLocalizedDescriptionKey];
                                          NSError *error = [NSError errorWithDomain:host code:404 userInfo:details];
                                          return next(error, NULL);
                                      }
                                      NSArray *aRet = [ret componentsSeparatedByString:@";"];
                                      HostModel *hostModel = [[HostModel alloc] init];
                                      hostModel.ip = [aRet firstObject];
                                      hostModel.host = host;
                                      hostModel.isExpired = NO;
                                      [_hostManager setObject:hostModel forKey:host];
                                      next(NULL, hostModel.ip);
                                  }];
    [task resume];
    
}

// 当切换网络时候强制所有Host过期
- (void)unavailableHosts {
    [_hostManager enumerateKeysAndObjectsUsingBlock:^(NSString *key, HostModel *obj, BOOL * _Nonnull stop) {
        obj.isExpired = YES;
    }];
}

- (void)reachabilityChanged:(NSNotification *)sender {
    NSLog(@"网络状态改变");
    Reachability *bility = [sender object];
    NetworkStatus netStatus = [bility currentReachabilityStatus];
    if (self.netWorkStatus) {
        self.netWorkStatus(netStatus);
    }
    [self unavailableHosts];
}

@end
