//
//  SGFileCacheHelper.h
//  SGLocalNotification
//
//  Created by ParkSanggeon on 21/01/15.
//  Copyright (c) 2015 SGP. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SGCacheHelperProtocol <NSObject>

@required
+ (NSString *)cacheFolderPath;
+ (NSString *)cachePathWithKey:(NSString *)key;
+ (BOOL)hasCacheForKey:(NSString *)key;
+ (void)cacheObject:(id<NSCoding>)obj forKey:(NSString *)key;
+ (id<NSCoding>)cacheForKey:(NSString *)key;
+ (void)removeAllCaches;
+ (NSArray *)allCaches;

@end

@interface SGFileCacheHelper : NSObject <SGCacheHelperProtocol>

@end
