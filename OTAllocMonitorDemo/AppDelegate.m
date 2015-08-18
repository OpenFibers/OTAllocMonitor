//
//  AppDelegate.m
//  OTAllocMonitorDemo
//
//  Created by 史江浩 on 8/18/15.
//  Copyright (c) 2015 openthread. All rights reserved.
//

#import "AppDelegate.h"
#import "NSObject+OTAllocMonitor.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [NSObject beginAllocAndDeallocMonitor];
    return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [NSObject endAllocAndDeallocMonitor];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [NSObject beginAllocAndDeallocMonitor];
}

@end
