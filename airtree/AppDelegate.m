//
//  AppDelegate.m
//  airtree
//
//  Created by Bin Shen on 5/29/16.
//  Copyright © 2016 Bin Shen. All rights reserved.
//

#import "AppDelegate.h"
#import "MKNetworkKit.h"
#import "BackgroundRunner.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [NSThread sleepForTimeInterval:2.0];
    
    _backgroundRunningTimeInterval = 0;
    [self performSelectorInBackground:@selector(runningInBackground) withObject:nil];
    
    
    if([[NSUserDefaults standardUserDefaults] stringForKey:@"user_id"] != nil){
        NSMutableDictionary *loginUser = [[NSMutableDictionary alloc] init];
        [loginUser setObject:[[NSUserDefaults standardUserDefaults] stringForKey:@"user_id"] forKey:@"_id"];
        [loginUser setObject:[[NSUserDefaults standardUserDefaults] stringForKey:@"username"] forKey:@"username"];
        [loginUser setObject:[[NSUserDefaults standardUserDefaults] stringForKey:@"password"] forKey:@"password"];
        [loginUser setObject:[[NSUserDefaults standardUserDefaults] stringForKey:@"nickname"] forKey:@"nickname"];
        self.loginUser = [loginUser mutableCopy];
        
        UINavigationController *nav = [self.window.rootViewController.storyboard instantiateViewControllerWithIdentifier:@"NavMainViewController"];
        nav.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
        [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
        
        self.window.rootViewController = nav;
        [self.window makeKeyAndVisible];
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    if ([[UIDevice currentDevice] isMultitaskingSupported]) {
        [[BackgroundRunner shared] run];
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    [[BackgroundRunner shared] stop];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (void)runningInBackground
{
    while (TRUE) {
        [NSThread sleepForTimeInterval:10];
        _backgroundRunningTimeInterval++;
        NSLog(@"Heartbeat: %d",(int)_backgroundRunningTimeInterval);
        [self runHeartbeatService];
    }
}

- (void) runHeartbeatService
{
    if (self.loginUser[@"_id"] == nil) {
        return;
    }
    NSString *path = [[NSString alloc] initWithFormat:[NSString stringWithFormat:@"/user/%@/online", self.loginUser[@"_id"]]];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    MKNetworkHost *host = [[MKNetworkHost alloc] initWithHostName:@"121.40.92.176:3000"];
    MKNetworkRequest *request = [host requestWithPath:path params:param httpMethod:@"POST"];
    [request addCompletionHandler: ^(MKNetworkRequest *completedRequest) {
        NSString *response = [completedRequest responseAsString];
        NSLog(@"Response: %@", response);
    }];
    [host startRequest:request];
}

@end
