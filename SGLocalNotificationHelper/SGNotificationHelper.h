//
//  SGNotificationHelper.h
//  SGLocalNotification
//
//  Created by ParkSanggeon on 21/01/15.
//  Copyright (c) 2015 SGP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "UILocalNotification+SGNotificationHelper.h"

@interface SGNotificationHelper : NSObject

+ (UILocalNotification *)localNotificationForKey:(NSString *)key withRemoteNotification:(NSDictionary *)userInfo;

// returns NO if notification is nil or if notification doesn't have key (user setKey: in "UILocalNotification+SGNotificationHelper.h")
+ (BOOL)showNotification:(UILocalNotification *)noti;

// returns NO if notification is nil or if key is zero length string (also nil).
+ (BOOL)showNotification:(UILocalNotification *)noti withKey:(NSString *)key;

// returns NO if notification is nil or if notification doesn't have key
+ (BOOL)removeNotification:(UILocalNotification *)noti;

// returns NO if key is zero length string or nil).
+ (BOOL)removeNotificationForKey:(NSString *)key;

+ (void)removeAllNotifications;

+ (UILocalNotification *)notificationForKey:(NSString *)key;

+ (NSArray *)allNotifications;

@end
