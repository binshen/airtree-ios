//
//  BackgroundRunner.m
//  airtree
//
//  Created by Bin Shen on 6/30/16.
//  Copyright © 2016 Bin Shen. All rights reserved.
//

#import "BackgroundRunner.h"
#import "UIKit/UIKit.h"

@implementation BackgroundRunner

+ (BackgroundRunner *)shared
{
    static BackgroundRunner *sharedRunner;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedRunner = [[BackgroundRunner alloc] init];
    });
    return sharedRunner;
}

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)dealloc
{

}

#pragma mark - public method
- (void)hold
{
    _holding = YES;
    while (_holding) {
        [NSThread sleepForTimeInterval:1];
        /** clean the runloop for other source */
        CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0, TRUE);
    }
}

- (void)stop
{
    _holding = NO;
}

- (void)run
{
    UIApplication *application = [UIApplication sharedApplication];
    __block UIBackgroundTaskIdentifier background_task;
    //Create a task object
    background_task = [application beginBackgroundTaskWithExpirationHandler: ^ {
        [self hold];
        [application endBackgroundTask: background_task];
        background_task = UIBackgroundTaskInvalid;
    }];
   
}
@end
