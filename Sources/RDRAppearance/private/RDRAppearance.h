//
//  RDRAppearance.h
//  RDRAppearance
//  
//
//  Created by Damiaan Twelker on 28/05/2023.
//  Copyright © 2023 Damiaan Twelker. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NSString * RDRIdentifierForInvocation(NSInvocation *invocation);
OBJC_EXTERN NSString * const RDRDidRefreshAppearanceNotificationName;

@protocol RDRAppearance <UIAppearance>

+ (instancetype)rdr_appearance NS_SWIFT_NAME(rdr_appearance());
+ (instancetype)rdr_appearanceWhenContainedInInstancesOfClasses:(NSArray<Class <UIAppearanceContainer>> *)containerTypes NS_SWIFT_NAME(rdr_appearance(whenContainedInInstancesOf:));

- (void)rdr_willReceiveInvocation:(NSInvocation *)invocation;

@end

@protocol RDRAppearance;
@class RDRAppearanceProxy;
@interface UIView (RDRAppearance) <RDRAppearance>

- (RDRAppearanceProxy *)rdr_appearanceForSelector:(NSString *)selector;

@end
