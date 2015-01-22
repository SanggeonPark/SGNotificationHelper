//
//  SGFileCacheHelper.m
//  SGLocalNotification
//
//  Created by ParkSanggeon on 21/01/15.
//  Copyright (c) 2015 SGP. All rights reserved.
//

#import "SGFileCacheHelper.h"
#import "NSString+SGNotificationHelper.h"

#define CACHE_FOLDER_NAME @"SG_NOTIFICATION_HELPER_CACHE"

@implementation SGFileCacheHelper

#pragma mark - private API

+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL
{
    assert([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]);
    
    NSError *error = nil;
    BOOL success = [URL setResourceValue:[NSNumber numberWithBool:YES]
                                  forKey:NSURLIsExcludedFromBackupKey
                                   error:&error];
    if(!success){
        NSLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
    }
    return success;
}

+ (BOOL)addSkipBackupAttributeToItemAtFilePath:(NSString*)path
{
    NSURL* url = [NSURL fileURLWithPath:path];
    return [self addSkipBackupAttributeToItemAtURL:url];
    
}

#pragma mark - public API
+ (NSString *)cacheFolderPath
{
    static NSString *documentsPath;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSArray *documentsPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        documentsPath = [documentsPaths objectAtIndex:0];
        
        documentsPath = [documentsPath stringByAppendingPathComponent:CACHE_FOLDER_NAME];
        if (![[NSFileManager defaultManager] fileExistsAtPath:documentsPath]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:documentsPath withIntermediateDirectories:NO attributes:nil error:nil];
        }
        [self addSkipBackupAttributeToItemAtFilePath:documentsPath];
    });
    
    return documentsPath;
}

+ (NSString *)cachePathWithKey:(NSString *)key
{
    NSString *cacheHash = [key hashString];
    NSString *archivePath = [NSString stringWithFormat:@"%@/%@", [self cacheFolderPath], cacheHash];
    return archivePath;
}

+ (BOOL)hasCacheForKey:(NSString *)key
{
    NSString *archivePath = [self cachePathWithKey:key];
    if ([[NSFileManager defaultManager] fileExistsAtPath:archivePath]) {
        return YES;
    }
    return NO;
}

+ (void)cacheObject:(id<NSCoding>)obj forKey:(NSString *)key
{
    NSString *archivePath = [self cachePathWithKey:key];
    [NSKeyedArchiver archiveRootObject:obj toFile:archivePath];
}

+ (id<NSCoding>)cacheForKey:(NSString *)key
{
    NSString *archivePath = [self cachePathWithKey:key];
    
    return !archivePath ? nil : [NSKeyedUnarchiver unarchiveObjectWithFile:archivePath];
}

+ (NSArray *)allCachePaths
{
    NSFileManager* fileManager = [[NSFileManager alloc] init];
    NSMutableArray *paths = [NSMutableArray array];
    NSString *folderPath = [self cacheFolderPath];
    NSDirectoryEnumerator* enumerator = [fileManager enumeratorAtPath:folderPath];
    NSString* file;
    
    while (file = [enumerator nextObject]) {
        [paths addObject:[folderPath stringByAppendingPathComponent:file]];
    }
    return paths;
}

+ (void) removeAllCaches
{
    NSFileManager* fileManager = [[NSFileManager alloc] init];
    NSArray *cachePaths = [self allCachePaths];
    NSError* err = nil;
    BOOL res;
    
    for (NSString *path in cachePaths) {
        res = [fileManager removeItemAtPath:path error:&err];
        if (!res && err) {
            NSLog(@"Can't remove Notification: %@", err);
        }
    }
}

+ (NSArray *)allCaches
{
    NSMutableArray *caches = [NSMutableArray array];
    NSArray *cachePaths = [self allCachePaths];
    NSError* err = nil;
    
    for (NSString *path in cachePaths) {
        id cacheObject = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        if (!cacheObject) {
            NSLog(@"Can't read cache object: %@", err);
        } else {
            [caches addObject:cacheObject];
        }
    }
    return caches;
}
@end
