//
//  NSObject+RDRAppearance.m
//  RDRAppearance
//  
//
//  Created by Damiaan Twelker on 28/05/2023.
//  Copyright © 2023 Damiaan Twelker. All rights reserved.
//

#import "NSObject+RDRAppearance.h"

#import <objc/runtime.h>

@implementation NSObject (RDRAppearance)
@dynamic rdr_appearanceBySelector;

- (NSMapTable *)rdr_appearanceBySelector
{
    NSMapTable *result = objc_getAssociatedObject(self, @selector(rdr_appearanceBySelector));
    if (!result) {
        result = [NSMapTable strongToWeakObjectsMapTable];
        self.rdr_appearanceBySelector = result;
    }
    
    return result;
}

- (void)setrdr_appearanceBySelector:(NSMapTable *)rdr_appearanceBySelector
{
    objc_setAssociatedObject(self, @selector(rdr_appearanceBySelector), rdr_appearanceBySelector, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
