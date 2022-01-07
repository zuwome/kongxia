//
//  NSString+Regex.h
//  Additions
//
//  Created by Sumeru Chatterjee on 5/18/11.


#import <Foundation/Foundation.h>


@interface  NSString (Regex)
- (BOOL)isPureNumber;

-(NSString*) firstURLinString;
-(NSString*) firstStringWithPattern:(NSString*)pattern;
-(BOOL) matchesPattern:(NSString*)pattern;

- (BOOL)wechatAlipayAccountCheck;
@end
