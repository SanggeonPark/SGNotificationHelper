//
//  UILocalNotification+SGNotificationHelper.h
//  SGLocalNotification
//
//  Created by ParkSanggeon on 21/01/15.
//  Copyright (c) 2015 SGP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILocalNotification (SGNotificationHelper)
- (void)setKey:(NSString *)key;
- (NSString *)key;
@end
