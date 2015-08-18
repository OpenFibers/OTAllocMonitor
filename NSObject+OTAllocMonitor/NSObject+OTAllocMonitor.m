//
//  NSObject+OTAllocMonitor.m
//  NeteaseMusic
//
//  Created by OpenFibers on 8/18/15.
//  Copyright (c) 2015 OpenFibers. All rights reserved.
//

#import "NSObject+OTAllocMonitor.h"
#import <objc/runtime.h>
#import <objc/objc.h>

#define shouldIgnoreForClass comOpenFibersShouldIgnoreForClass
#define ignoredClasses comOpenFibersIgnoredClasses
#define swizzClassMethodWithOriginalSelector comOpenFibersSwizzClassMethodWithOriginalSelector
#define swizzInstanceMethodWithOriginalSelector comOpenFibersSwizzInstanceMethodWithOriginalSelector

static BOOL IsOTAllocMonitorWorking = NO;

@implementation NSObject (OTAllocMonitor)

+ (BOOL)isMonitorWorking
{
    return IsOTAllocMonitorWorking;
}

+ (void)beginAllocAndDeallocMonitor
{
    //Must init ignored classes before begin monitor, to avoid infinite loop
    [self ignoredClasses];
    
    if (IsOTAllocMonitorWorking == NO)
    {
        IsOTAllocMonitorWorking = YES;
        [self swizzClassMethodWithOriginalSelector:@selector(alloc)
                                 replacingSelector:@selector(allocSwizz)];
        [self swizzInstanceMethodWithOriginalSelector:NSSelectorFromString(@"dealloc")
                                    replacingSelector:@selector(deallocSwizz)];
    }
}

+ (void)endAllocAndDeallocMonitor
{
    if (IsOTAllocMonitorWorking == YES)
    {
        IsOTAllocMonitorWorking = NO;
        [self swizzClassMethodWithOriginalSelector:@selector(allocSwizz)
                                 replacingSelector:@selector(alloc)];
        [self swizzInstanceMethodWithOriginalSelector:@selector(deallocSwizz)
                                    replacingSelector:NSSelectorFromString(@"dealloc")];
    }
}

+ (void)toggleAllocAndDeallocMonitor
{
    if (IsOTAllocMonitorWorking)
    {
        [self endAllocAndDeallocMonitor];
    }
    else
    {
        [self beginAllocAndDeallocMonitor];
    }
}

+ (instancetype)allocSwizz
{
    //Mega logs from NSArray/NSDictionary/NSNotification/NSAutoReleasePool may trash the useful logs.
    if (![NSObject shouldIgnoreForClass:self])
    {
        NSLog(@"OTAllocMonitor: %@ alloc", self);
    }
    
    //When end monitor(exchange methods to original state), some alloc or dealloc call may excuting
    //To avoid infinite loop at this time, check IsOTAllocMonitorWorking mark.
    //If monitor stops, call original alloc
    if (IsOTAllocMonitorWorking)
    {
        return [self allocSwizz];
    }
    else
    {
        return [self alloc];
    }
}

- (void)deallocSwizz
{
    //Mega logs from NSArray/NSDictionary/NSNotification/NSAutoReleasePool may trash the useful logs.
    if (![NSObject shouldIgnoreForClass:[self class]])
    {
        NSLog(@"OTAllocMonitor: %@<%p> dealloc", [self class], self);
    }
    
    //When end monitor(exchange methods to original state), some alloc or dealloc call may excuting
    //To avoid infinite loop at this time, check IsOTAllocMonitorWorking mark.
    //If monitor stops, call original dealloc
    if (IsOTAllocMonitorWorking)
    {
        [self deallocSwizz];
    }
    else
    {
        SEL deallocSelector = NSSelectorFromString(@"dealloc");
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self performSelector:deallocSelector];
#pragma clang diagnostic pop
    }
}

+ (BOOL)shouldIgnoreForClass:(Class)c
{
    BOOL shouldIngore = NO;
    for (Class ignoredClass in [self ignoredClasses])
    {
        if ([c isSubclassOfClass:ignoredClass])
        {
            shouldIngore = YES;
        }
    }
    return shouldIngore;
}

+ (NSArray *)ignoredClasses
{
    //Mega logs from these 4 classes may trash the useful logs.
    static NSArray *ignoredClasses = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ignoredClasses = @[[NSArray class],
                           [NSDictionary class],
                           [NSNotification class],
                           NSClassFromString(@"NSAutoreleasePool"),
                           ];
    });
    return ignoredClasses;
}

+ (void)swizzClassMethodWithOriginalSelector:(SEL)originalSelector replacingSelector:(SEL)replacingSelector
{
    Method originalMethod = class_getClassMethod(self, originalSelector);
    Method replacingMethod = class_getClassMethod(self, replacingSelector);
    method_exchangeImplementations(originalMethod, replacingMethod);
}

+ (void)swizzInstanceMethodWithOriginalSelector:(SEL)originalSelector replacingSelector:(SEL)replacingSelector
{
    Method originalMethod = class_getInstanceMethod(self, originalSelector);
    Method replacingMethod = class_getInstanceMethod(self, replacingSelector);
    method_exchangeImplementations(originalMethod, replacingMethod);
}

@end