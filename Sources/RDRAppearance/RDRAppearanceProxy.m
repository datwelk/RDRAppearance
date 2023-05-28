//
//  RDRAppearanceProxy.m
//  RDRAppearance
//  
//
//  Created by Damiaan Twelker on 28/05/2023.
//  Copyright © 2023 Damiaan Twelker. All rights reserved.
//

#import "RDRAppearanceProxy.h"

#import "RDRAppearance.h"

@implementation RDRAppearanceProxy

+ (NSMapTable *)appearanceInstances
{
    static NSMapTable *table = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        table = [NSMapTable strongToWeakObjectsMapTable];
    });
    return table;
}

+ (instancetype)withProxy:(NSObject *)proxy
{
    RDRAppearanceProxy *wrapper = [[self class] alloc];
    [wrapper configureWithProxy:proxy];
    return wrapper;
}

+ (instancetype)appearanceForInvocation:(NSInvocation *)invocation
{
    NSString *appearanceIdentifier = RDRIdentifierForInvocation(invocation);
    return [[RDRAppearanceProxy appearanceInstances] objectForKey:appearanceIdentifier];
}

+ (void)clear
{
    [[[self class] appearanceInstances] removeAllObjects];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel
{
    return [self.proxy methodSignatureForSelector:sel];
}

- (void)configureWithProxy:(NSObject *)proxy
{
    self.proxy = proxy;
    self.recordedInvocations = [NSHashTable weakObjectsHashTable];
    
    __weak typeof(self) weakSelf = self;
    [[NSNotificationCenter defaultCenter] addObserverForName:RDRDidRefreshAppearanceNotificationName object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        [weakSelf cleanup];
    }];
}

- (void)forwardInvocation:(NSInvocation *)invocation
{
    // Called when we setup a new theme.
    NSString *identifier = RDRIdentifierForInvocation(invocation);
    [[[self class] appearanceInstances] setObject:self forKey:identifier];
    [self.recordedInvocations addObject:invocation];

    invocation.target = _proxy;
    [invocation invoke];
}

- (BOOL)respondsToSelector:(SEL)aSelector
{
    return [self.proxy respondsToSelector:aSelector];
}

- (void)cleanup
{
    [self.recordedInvocations removeAllObjects];
}

@end
