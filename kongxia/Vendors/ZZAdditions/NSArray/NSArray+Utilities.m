//
//  NSArray+Utilities.m
//  Additions
//
//  Created by Erica Sadun, http://ericasadun.com
//  iPhone Developer's Cookbook, 3.0 Edition
//  BSD License, Use at your own risk

#import "NSArray+Utilities.h"
#import <time.h>
#import <stdarg.h>

/*
 Thanks to August Joki, Emanuele Vulcano, BlueLlama, Optimo, jtbandes

 To add Math Extensions like sum, product?
 */

#pragma mark StringExtensions
@implementation NSArray (StringExtensions)
///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSArray *) arrayBySortingStrings
{
	NSMutableArray *sort = [NSMutableArray arrayWithArray:self];
	for (id eachitem in self)
		if (![eachitem isKindOfClass:[NSString class]])	[sort removeObject:eachitem];
	return [sort sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
@end

#pragma mark UtilityExtensions
@implementation NSArray (UtilityExtensions)

@end

#pragma mark Mutable UtilityExtensions
@implementation NSMutableArray (UtilityExtensions)
///////////////////////////////////////////////////////////////////////////////////////////////////
@end


#pragma mark StackAndQueueExtensions
@implementation NSMutableArray (StackAndQueueExtensions)
@end