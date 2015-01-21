//
//  NSString+SGNotificationHelper.h
//  SGLocalNotification
//
//  Created by ParkSanggeon on 22/01/15.
//  Copyright (c) 2015 SGP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (SGNotificationHelper)

+ (instancetype)stringWithFormat:(NSString *)format array:(NSArray*)arguments;
- (NSString *)hashString;

@end
