//
//  UIView+RDRAppearanceRefresh.m
//  RDRAppearance
//  
//
//  Created by Damiaan Twelker on 28/05/2023.
//  Copyright © 2023 Damiaan Twelker. All rights reserved.
//

#import "UIView+RDRAppearanceRefresh.h"
#import "NSObject+RDRAppearance.h"
#import "NSInvocation+RDRAppearance.h"
#import "RDRAppearanceProxy.h"
#import "RDRAppearance.h"

#import <UIKit/UIKit.h>

@implementation UIView (RDRAppearanceRefresh)

- (void)rdr_applyAppearance
{
    for (NSString *selectorName in self.rdr_appearanceBySelector.keyEnumerator.allObjects) {
        RDRAppearanceProxy *appearance = [self.rdr_appearanceBySelector objectForKey:selectorName];
        
        for (NSInvocation *recordedInvocation in [appearance.recordedInvocations copy]) {
            if ([NSStringFromSelector(recordedInvocation.selector) isEqualToString:selectorName]) {
                [recordedInvocation rdr_originalInvokeWithTarget:self];
            }
        }
    }
    
    for (UIView *v in self.subviews) {
        [v rdr_applyAppearance];
    }
}

+ (void)rdr_refreshAppearance
{
   for (UIWindow *window in [UIApplication sharedApplication].windows) {
       UIViewController *v = window.rootViewController.presentedViewController;
       while (v != nil) {
           [v.view rdr_applyAppearance];
           v = v.presentedViewController;
       }
       
       [window.rootViewController.view rdr_applyAppearance];
   }
   
   [[NSNotificationCenter defaultCenter] postNotificationName:RDRDidRefreshAppearanceNotificationName object:nil];
}

@end
