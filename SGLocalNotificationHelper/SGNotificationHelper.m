//
//  SGNotificationHelper.m
//  SGLocalNotification
//
//  Created by ParkSanggeon on 21/01/15.
//  Copyright (c) 2015 SGP. All rights reserved.
//

#import "SGNotificationHelper.h"
#import "NSString+SGNotificationHelper.h"
#import "SGFileCacheHelper.h"

@implementation SGNotificationHelper

+ (UILocalNotification *)localNotificationForKey:(NSString *)key userInfo:(NSDictionary *)userInfo
{
    NSNumber *badge = nil;
    NSString *sound = nil;
    NSString *launchImage = nil;
    NSString *actionString = nil;
    
    NSString *alertString = nil;
    NSDictionary *alertDict = nil;
    id alert = [userInfo objectForKey:@"alert"];
    
    if ([alert isKindOfClass:[NSString class]]) {
        alertString = (NSString *)alert;
    } else if ([alert isKindOfClass:[NSDictionary class]]) {
        alertDict = (NSDictionary *)alert;
    }
    
    // handle alert dictionary
    if (alertDict) {
        
        NSString *bodyString = [alertDict objectForKey:@"body"];
        if (bodyString == nil) { // with some reason, it may have 0 length string.
            NSString *localizedStringKey = [alertDict objectForKey:@"loc-key"];
            NSArray *arguments = [alertDict objectForKey:@"loc-args"];
            if (arguments && [arguments isKindOfClass:[NSString class]]) {
                arguments = @[arguments];
            }
            
            if (arguments.count && localizedStringKey.length) {
                alertString = [NSString stringWithFormat:NSLocalizedString(localizedStringKey, nil) array:arguments];
            } else if (localizedStringKey.length) {
                alertString = NSLocalizedString(localizedStringKey, nil);
            }
        } else {
            alertString = bodyString;
        }
        
        NSString *actionStringKey = [alertDict objectForKey:@"action-loc-key"];
        if (actionString.length) {
            actionString = NSLocalizedString(actionStringKey, nil);
        }
        
        badge = [userInfo objectForKey:@"badge"];
        sound = [userInfo objectForKey:@"sound"];
        launchImage = [userInfo objectForKey:@"launch-image"];
    }
    
    // create LocalNotification
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];

    if (actionString) {
        localNotification.alertAction = actionString;
    } else {
        localNotification.hasAction = NO;
    }
    
    localNotification.alertBody = alertString;
    localNotification.soundName = sound;
    localNotification.alertLaunchImage = launchImage;
    localNotification.applicationIconBadgeNumber = [badge integerValue];
    localNotification.userInfo = userInfo;
    localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:0.1];

    [localNotification setKey:key];
    
    return localNotification;
}

+ (BOOL)showNotification:(UILocalNotification *)notification;
{
    return [self showNotification:notification withKey:notification.key];
}

+ (BOOL)showNotification:(UILocalNotification *)notification withKey:(NSString *)key
{
    if (key.length == 0 || notification == nil) {
        return NO;
    }
    
    [SGFileCacheHelper cacheObject:notification forKey:key];
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    return YES;
}

+ (BOOL)removeNotification:(UILocalNotification *)notification
{
    return [self removeNotificationForKey:notification.key];
}

+ (BOOL)removeNotificationForKey:(NSString *)key
{
    if (key.length == 0) {
        return NO;
    }
    
    NSString *archivePath = [SGFileCacheHelper cachePathWithKey:key];
    
    UILocalNotification *cachedNotification = [self notificationForKey:key];
    if (cachedNotification == nil) {
        return NO;
    }
    
    [[UIApplication sharedApplication] cancelLocalNotification:cachedNotification];
    
    [[NSFileManager defaultManager] removeItemAtPath:archivePath error:nil];
    
    return YES;
}

+ (void)removeAllNotifications
{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [SGFileCacheHelper removeAllCaches];
}

+ (UILocalNotification *)notificationForKey:(NSString *)key
{
    if ([SGFileCacheHelper hasCacheForKey:key] == NO) {
        return nil;
    }
    return (UILocalNotification *)[SGFileCacheHelper cacheForKey:key];
}

+ (NSArray *)allNotifications
{
   return [SGFileCacheHelper allCaches];
}

@end
