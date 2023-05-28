//
//  NSInvocation+RDRAppearance.m
//  RDRAppearance
//  
//
//  Created by Damiaan Twelker on 28/05/2023.
//  Copyright © 2023 Damiaan Twelker. All rights reserved.
//

#import "NSInvocation+RDRAppearance.h"
#import "RDRAppearance.h"

#import <objc/runtime.h>

@implementation NSInvocation (RDRAppearance)

+ (void)load
{
    if (self == [NSInvocation class]) {
        method_exchangeImplementations(
                                       class_getInstanceMethod([self class], @selector(invokeUsingIMP:)),
                                       class_getInstanceMethod([self class], @selector(rdr_originalInvokeUsingIMP:))
                                       );
        method_setImplementation(
                                 class_getInstanceMethod([self class], @selector(invokeUsingIMP:)),
                                 method_getImplementation(class_getInstanceMethod([self class], @selector(rdr_invokeUsingIMP:)))
                                 );
        
        method_exchangeImplementations(
                                       class_getInstanceMethod([self class], @selector(invokeWithTarget:)),
                                       class_getInstanceMethod([self class], @selector(rdr_originalInvokeWithTarget:))
                                       );
        method_setImplementation(
                                 class_getInstanceMethod([self class], @selector(invokeWithTarget:)),
                                 method_getImplementation(class_getInstanceMethod([self class], @selector(rdr_invokeWithTarget:)))
                                 );
    }
}

- (void)rdr_originalInvokeUsingIMP:(IMP)imp { }

- (void)rdr_invokeUsingIMP:(IMP)imp
{
    id target = self.target;
    
    if ([target conformsToProtocol:@protocol(RDRAppearance)]) {
        [target rdr_willReceiveInvocation:self];
    }

    [self rdr_originalInvokeUsingIMP:imp];
}

- (void)rdr_invokeWithTarget:(id)target
{
    if ([target conformsToProtocol:@protocol(RDRAppearance)]) {
        [target rdr_willReceiveInvocation:self];
    }
    
    [self rdr_originalInvokeWithTarget:target];
}

- (void)rdr_originalInvokeWithTarget:(id)target { }

@end
