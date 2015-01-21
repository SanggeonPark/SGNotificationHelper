//
//  UILocalNotification+SGNotificationHelper.m
//  SGLocalNotification
//
//  Created by ParkSanggeon on 21/01/15.
//  Copyright (c) 2015 SGP. All rights reserved.
//

#import "UILocalNotification+SGNotificationHelper.h"

#define LOCALNOTIFICATION_HELPER_KEY @"SG_LOCALNOTIFICATION_HELPER_KEY"

@implementation UILocalNotification (SGNotificationHelper)

- (void)setKey:(NSString *)key
{
    NSMutableDictionary *newUserInfo = [NSMutableDictionary dictionaryWithDictionary:self.userInfo];
    [newUserInfo setObject:key forKey:LOCALNOTIFICATION_HELPER_KEY];
    self.userInfo = newUserInfo;
}
- (NSString *)key
{
    return [self.userInfo objectForKey:LOCALNOTIFICATION_HELPER_KEY];
}

@end
