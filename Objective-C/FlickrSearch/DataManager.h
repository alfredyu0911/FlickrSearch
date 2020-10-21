//
//  DataManager.h
//  FlickrSearch
//
//  Created by Alfred Yu on 2020/10/21.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

NS_ASSUME_NONNULL_BEGIN

@interface DataManager : NSObject

+ (BOOL) createDatabaseIfNotExist;
+ (BOOL) addRecordByphotoId: (NSString *)photoId owner:(NSString *)owner source: (NSString *)source;
+ (BOOL) queryRecordByphotoId: (NSString *)photoId owner:(NSString *)owner source: (NSString *)source;
+ (BOOL) queryRecordByphotoId: (NSString *)photoId owner:(NSString *)owner;
+ (BOOL) deleteRecordByphotoId: (NSString *)photoId owner:(NSString *)owner;
+ (BOOL) updateRecordSourceByphotoId: (NSString *)photoId owner:(NSString *)owner source: (NSString *)source;
+ (NSMutableArray *) queryRecord;

@end

NS_ASSUME_NONNULL_END
