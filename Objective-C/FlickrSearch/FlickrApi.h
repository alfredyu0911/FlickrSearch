//
//  FlickrApi.h
//  t5
//
//  Created by Alfred Yu on 2020/10/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FlickrApi : NSObject

+ (NSURLSession *) session;

+ (NSString *) apiKey;

+ (void) searchPhotoByText: (NSString *)text
                   andPage: (NSInteger)page
                  delegate: (id<NSXMLParserDelegate>)parserdelegate;

+ (void) getImageSourceById: (NSString *)photoId
                   delegate: (id<NSXMLParserDelegate>)parserdelegate;

+ (NSString *) apiURL_searchPhotoByText: (NSString *)text
                             andPerPage: (NSInteger)perpage;

+ (NSString *) apiURL_getPhotoSizesById: (NSString *)photoId;

@end

NS_ASSUME_NONNULL_END
