//
//  AppDelegate.m
//  SGLocalNotification
//
//  Created by ParkSanggeon on 21/01/15.
//  Copyright (c) 2015 SGP. All rights reserved.
//

#import "SGAppDelegate.h"
#import "SGNotificationHelper.h"
@interface SGAppDelegate ()

@end

@implementation SGAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // at launch, let' remove all local notifications.
    [SGNotificationHelper removeAllNotifications];
    
    BOOL authorized = YES;
    
    if ([application respondsToSelector:@selector(currentUserNotificationSettings)]) {
        UIUserNotificationSettings* settings = [[UIApplication sharedApplication] performSelector:@selector(currentUserNotificationSettings) withObject:nil];
        authorized = (settings.types & UIUserNotificationTypeAlert);
    }
    
    if (!authorized && [application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationType types = UIUserNotificationTypeAlert;
        UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
    }
    
    UILocalNotification *localNotif = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if(localNotif){
        [SGNotificationHelper removeNotification:localNotif];
    }
    
    // handle some corner cases with remote notification
    NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if(userInfo){
        // handle some corner cases with remote notification
    }
    
    return YES;
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    
    // this remote notification must be "Silent Notification"
    UILocalNotification *localNoti = [SGNotificationHelper localNotificationForKey:@"specify your key here" userInfo:userInfo];
    [SGNotificationHelper showNotification:localNoti];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    // check if we get noti in foreground
    UIApplicationState state = [[UIApplication sharedApplication] applicationState];
    
    if (state == UIApplicationStateBackground || state == UIApplicationStateInactive)
    {
        // remove selected Notification from cache.
        [SGNotificationHelper removeNotification:notification];
        // handle in background
        
    } else {
        //handle in foreground
        //commented for test.
        //[SGNotificationHelper removeNotification:notification];
    }
}

@end
