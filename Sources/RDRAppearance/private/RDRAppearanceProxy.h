//
//  RDRAppearanceProxy.h
//  RDRAppearance
//  
//
//  Created by Damiaan Twelker on 28/05/2023.
//  Copyright © 2023 Damiaan Twelker. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RDRAppearanceProxy : NSProxy

@property (nonatomic, weak) NSObject *proxy;
@property (nonatomic, strong) NSHashTable *recordedInvocations;
@property (nonatomic, strong) NSMapTable *targets;

+ (instancetype)withProxy:(NSObject *)proxy;
+ (instancetype)appearanceForInvocation:(NSInvocation *)invocation;
+ (void)clear;

@end
