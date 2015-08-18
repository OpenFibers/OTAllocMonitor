//
//  NSObject+OTAllocMonitor.h
//  NeteaseMusic
//
//  Created by OpenFibers on 8/18/15.
//  Copyright (c) 2015 OpenFibers. All rights reserved.
//

#import <Foundation/Foundation.h>

#define OTAllocMonitor ComOpenFibersOTAllocMonitor

/**
 *  Hooks alloc and dealloc in all objects, to see how the underly system works.
 */
@interface NSObject (OTAllocMonitor)

/**
 *  Get if the monitor is working.
 *
 *  @return YES if the monitor is working. Otherwise NO.
 */
+ (BOOL)isMonitorWorking;

/**
 *  Begin monitor
 */
+ (void)beginAllocAndDeallocMonitor;

/**
 *  End monitor
 */
+ (void)endAllocAndDeallocMonitor;

/**
 *  Toggle monitor
 */
+ (void)toggleAllocAndDeallocMonitor;

@end
