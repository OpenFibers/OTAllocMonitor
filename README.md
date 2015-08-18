Hooks alloc and dealloc in all objects, to see how the underly system works. Expecially for locating bugs caused by apple.  

Just call **beginAllocAndDeallocMonitor** to begin:  

```objective-c
[NSObject beginAllocAndDeallocMonitor];
```

Then watch the console:  

```
2015-08-18 17:43:17.532 OTAllocMonitorDemo[69818:4563833] OTAllocMonitor: UIResumeActiveAction alloc
2015-08-18 17:43:17.532 OTAllocMonitorDemo[69818:4563708] OTAllocMonitor: UITraitCollection<0x7f89eac3d780> dealloc
2015-08-18 17:43:17.532 OTAllocMonitorDemo[69818:4563833] OTAllocMonitor: BSSettings alloc
2015-08-18 17:43:17.532 OTAllocMonitorDemo[69818:4563833] OTAllocMonitor: NSSet alloc
2015-08-18 17:43:17.532 OTAllocMonitorDemo[69818:4563708] OTAllocMonitor: _UIViewControllerTransitionCoordinator<0x7f89eac280d0> dealloc

...

2015-08-18 17:43:17.533 OTAllocMonitorDemo[69818:4563833] OTAllocMonitor: BSHashBuilder alloc
2015-08-18 17:43:17.533 OTAllocMonitorDemo[69818:4563708] OTAllocMonitor: _UIViewControllerOneToOneTransitionContext<0x7f89eac3c050> dealloc
2015-08-18 17:43:17.533 OTAllocMonitorDemo[69818:4563833] OTAllocMonitor: BSHashBuilder alloc
2015-08-18 17:43:17.533 OTAllocMonitorDemo[69818:4563708] OTAllocMonitor: _UIWindowRotationAnimationController<0x7f89eac3b5a0> dealloc
2015-08-18 17:43:17.533 OTAllocMonitorDemo[69818:4563833] OTAllocMonitor: BSHashBuilder<0x7f89eaf701a0> dealloc
```

And call **endAllocAndDeallocMonitor** for end:  

```objective-c
[NSObject endAllocAndDeallocMonitor];
```