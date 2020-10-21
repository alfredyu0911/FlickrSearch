//
//  DataManager.m
//  FlickrSearch
//
//  Created by Alfred Yu on 2020/10/21.
//

#import "DataManager.h"
#import "FSPhoto.h"

@implementation DataManager

+ (sqlite3 *) dbInstance
{
    NSString *docsDir;
    NSArray *dirPath;
    sqlite3 *db = nil;
    
    // Get the documents directory
    dirPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = [dirPath objectAtIndex:0];
    
    // Build the path to the database file
    NSString *databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"photos"]];
    
    NSFileManager *filemgr = [NSFileManager defaultManager];
    
    if ( [filemgr fileExistsAtPath: databasePath ] == YES )
    {
        const char *dbpath = [databasePath UTF8String];
        if ( sqlite3_open(dbpath, &db) == SQLITE_OK )
            return db;
    }
    
    return db;
}

+ (BOOL) createDatabaseIfNotExist
{
    NSString *docsDir;
    NSArray *dirPath;
    sqlite3 *db;
    
    // Get the documents directory
    dirPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = [dirPath objectAtIndex:0];
    
    // Build the path to the database file
    NSString *databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"photos"]];
    
    NSFileManager *filemgr = [NSFileManager defaultManager];
    
    if ( [filemgr fileExistsAtPath: databasePath ] == NO )
    {
        const char *dbpath = [databasePath UTF8String];
        
        if ( sqlite3_open(dbpath, &db) == SQLITE_OK )
        {
            const char *sql = "CREATE TABLE IF NOT EXISTS photos (id INTEGER PRIMARY KEY AUTOINCREMENT, photo_id TEXT, photo_owner TEXT, source TEXT)";
            
            char *errMsg;
            if ( sqlite3_exec(db, sql, NULL, NULL, &errMsg) != SQLITE_OK )
            {
                NSLog(@"Failed to create table");
                return NO;
            }
            
            sqlite3_close(db);
            return YES;
        }
        else
        {
            NSLog(@"Failed to open/create database");
            return NO;
        }
    }
    else
    {
        NSLog(@"table already exist.");
        return YES;
    }
}

+ (BOOL) addRecordByphotoId: (NSString *)photoId owner:(NSString *)owner source: (NSString *)source
{
    sqlite3 *db = [DataManager dbInstance];
    
    NSString *str = [NSString stringWithFormat:@"insert into photos(photo_id, photo_owner, source) values('%@','%@', '%@')", photoId, owner, source];
    const char *cmd = str.UTF8String;
 
    char *errorMsg;
    if ( sqlite3_exec(db, cmd, NULL, NULL, &errorMsg) == SQLITE_OK )
    {
        sqlite3_close(db);
        return YES;
    }
    else
    {
        NSLog(@"Insert error: %s",errorMsg);
        sqlite3_close(db);
        return NO;
    }
}

+ (BOOL) queryRecordByphotoId: (NSString *)photoId owner:(NSString *)owner source: (NSString *)source
{
    sqlite3 *db = [DataManager dbInstance];
    
    NSString *str = [NSString stringWithFormat:@"select * from photos where photo_id='%@' and photo_owner='%@' and source='%@'", photoId, owner, source];
    const char *cmd = str.UTF8String;
    
    BOOL found = NO;
    sqlite3_stmt *statement = nil;
    if ( sqlite3_prepare_v2(db, cmd, -1, &statement, NULL ) == SQLITE_OK )
    {
        if ( sqlite3_column_int(statement, 0) > 0 )
            found = YES;
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(db);
    return found;
}

+ (BOOL) queryRecordByphotoId: (NSString *)photoId owner:(NSString *)owner
{
    sqlite3 *db = [DataManager dbInstance];
    
    NSString *str = [NSString stringWithFormat:@"select COUNT(id) from photos where photo_id='%@' and photo_owner='%@'", photoId, owner];
    const char *cmd = str.UTF8String;
    
    BOOL found = NO;
    sqlite3_stmt *statement = nil;
    if ( sqlite3_prepare_v2(db, cmd, -1, &statement, NULL ) == SQLITE_OK )
    {
        while ( sqlite3_step(statement) == SQLITE_ROW )
        {
            NSString *count = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
            
            found = [count intValue] > 0;
            break;
        }
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(db);
    return found;
}

+ (NSMutableArray *) queryRecord
{
    sqlite3 *db = [DataManager dbInstance];
    
    NSMutableArray *list = [[NSMutableArray alloc] init];
    [list removeAllObjects];
    
    const char *cmd = "select * from photos";
    
    sqlite3_stmt *statement = nil;
    if ( sqlite3_prepare_v2(db, cmd, -1, &statement, NULL ) == SQLITE_OK )
    {
        while ( sqlite3_step(statement) == SQLITE_ROW )
        {
            NSString *photoid = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
            NSString *photoowner = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
            NSString *source = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
            
            FSPhoto *info = [[FSPhoto alloc] initWithId:photoid andOwner:photoowner];
            info.photo_source = source;
            [list addObject:info];
            
            NSLog(@"%@, %@, %@", photoid, photoowner, source);
        }
        
        sqlite3_finalize(statement);
    }
    
    sqlite3_close(db);
    return list;
}

+ (BOOL) deleteRecordByphotoId: (NSString *)photoId owner:(NSString *)owner
{
    sqlite3 *db = [DataManager dbInstance];
    
    NSString *str = [NSString stringWithFormat:@"delete from photos where photo_id='%@' and photo_owner='%@'", photoId, owner];
    const char *cmd = str.UTF8String;
    
    char *errorMsg;
    if ( sqlite3_exec(db, cmd, NULL, NULL, &errorMsg) == SQLITE_OK )
    {
        sqlite3_close(db);
        return YES;
    }
    else
    {
        NSLog(@"DELETE error: %s",errorMsg);
        sqlite3_close(db);
        return NO;
    }
}

+ (BOOL) updateRecordSourceByphotoId: (NSString *)photoId owner:(NSString *)owner source: (NSString *)source
{
    sqlite3 *db = [DataManager dbInstance];
    
    NSString *str = [NSString stringWithFormat:@"update photos set source='%@' where photo_id='%@' and photo_owner='%@'", source, photoId, owner];
    const char *cmd = str.UTF8String;
    
    char *errorMsg;
    if ( sqlite3_exec(db, cmd, NULL, NULL, &errorMsg) == SQLITE_OK )
    {
        NSLog(@"UPDATE OK");
        sqlite3_close(db);
        return YES;
    }
    else
    {
        NSLog(@"UPDATE error: %s",errorMsg);sqlite3_close(db);
        return NO;
    }
}

@end
