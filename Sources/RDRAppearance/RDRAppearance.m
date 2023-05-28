//
//  RDRAppearance.m
//  RDRAppearance
//
//
//  Created by Damiaan Twelker on 28/05/2023.
//  Copyright © 2023 Damiaan Twelker. All rights reserved.
//

#import "RDRAppearance.h"
#import "NSObject+RDRAppearance.h"
#import "RDRAppearanceProxy.h"

#import <objc/runtime.h>

NSString * const RDRDidRefreshAppearanceNotificationName = @"RDRAppearance.didrefresh";

NSString * RDRIdentifierForInvocation(NSInvocation *invocation) {
    NSMutableString *identifier = [NSMutableString stringWithFormat:@"%@", NSStringFromSelector(invocation.selector)];
    
    for (NSUInteger i = 2; i < invocation.methodSignature.numberOfArguments; i++) {
        const char *argumentType = [invocation.methodSignature getArgumentTypeAtIndex:i];

        if (strcmp(argumentType, @encode(id)) == 0) {
            __unsafe_unretained id argument;
            [invocation getArgument:&argument atIndex:i];
            [identifier appendFormat:@"%p", argument];
       }
        else if (strcmp(argumentType, @encode(unsigned long)) == 0) {
            unsigned long argument = 0;
            [invocation getArgument:&argument atIndex:i];
            [identifier appendFormat:@"%lu", argument];
        }
    }
    
    return [identifier copy];
}

@implementation UIView (RDRAppearance)

+ (instancetype)rdr_appearance
{
    id originalProxy = [self appearance];
    id existingWrapper = objc_getAssociatedObject(originalProxy, @selector(rdr_appearance));
    
    if (existingWrapper != nil) {
        return existingWrapper;
    }
    
    id newProxy = (id)[RDRAppearanceProxy withProxy:originalProxy];
    objc_setAssociatedObject(originalProxy, @selector(rdr_appearance), newProxy, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return newProxy;
}

+ (instancetype)rdr_appearanceWhenContainedInInstancesOfClasses:(NSArray<Class<UIAppearanceContainer>> *)containerTypes
{
    id originalProxy = [self appearanceWhenContainedInInstancesOfClasses:containerTypes];
    id existingWrapper = objc_getAssociatedObject(originalProxy, @selector(rdr_appearance));
    
    if (existingWrapper != nil) {
        return existingWrapper;
    }
    
    id newProxy = (id)[RDRAppearanceProxy withProxy:originalProxy];
    objc_setAssociatedObject(originalProxy, @selector(rdr_appearance), newProxy, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return newProxy;
}

- (void)rdr_willReceiveInvocation:(NSInvocation *)invocation
{
    id appearance = [RDRAppearanceProxy appearanceForInvocation:invocation];
    if (appearance) {
        [self.rdr_appearanceBySelector setObject:appearance forKey:NSStringFromSelector(invocation.selector)];
    }
}

- (NSArray <NSString *> *)rdr_appearanceSelectors
{
    return self.rdr_appearanceBySelector.keyEnumerator.allObjects;
}

- (RDRAppearanceProxy *)rdr_appearanceForSelector:(NSString *)selector
{
    return [self.rdr_appearanceBySelector objectForKey:selector];
}

@end
