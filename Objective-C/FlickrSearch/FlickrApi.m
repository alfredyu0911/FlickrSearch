//
//  FlickrSearchHelper.m
//  t5
//
//  Created by Alfred Yu on 2020/10/19.
//

#import "FlickrApi.h"
#import "FlickrPhoto.h"

@implementation FlickrApi

+ (NSString *) apiKey
{
    return @"aad71bc325f1361c0bf1688e0066064f";
}

+ (NSString *) apiURL_searchPhotoByText: (NSString *)text
                             andPerPage: (NSInteger)perpage
{
    NSString *url = @"https://www.flickr.com/services/rest/?method=flickr.photos.search&";
    
    NSMutableString *parameter = [[NSMutableString alloc] init];
    [parameter appendFormat:@"api_key=%@&", FlickrApi.apiKey];
    [parameter appendFormat:@"text=%@&", text];
    [parameter appendFormat:@"per_page=%ld&", perpage];
    
    url = [url stringByAppendingString:parameter];
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    return url;
}

+ (NSString *) apiURL_getPhotoSizesById: (NSString *)photoId
{
    NSString *url = @"https://www.flickr.com/services/rest/?method=flickr.photos.getSizes&";
    
    NSMutableString *parameter = [[NSMutableString alloc] init];
    [parameter appendFormat:@"api_key=%@&", FlickrApi.apiKey];
    [parameter appendFormat:@"photo_id=%@&", photoId];
    
    return [url stringByAppendingString:parameter];
}

+ (NSURLSession *) session
{
    return [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
}

+ (void) searchPhotoByText: (NSString *)text
                   andPage: (NSInteger)page
                  delegate: (id<NSXMLParserDelegate>)parserdelegate;
{
    NSString *url = [FlickrApi apiURL_searchPhotoByText:text andPerPage:page];
    
    NSMutableString *parameter = [[NSMutableString alloc] init];
    [parameter appendFormat:@"api_key=%@&", FlickrApi.apiKey];
    [parameter appendFormat:@"text=%@&", text];
    [parameter appendFormat:@"per_page=%ld&", page];
    
    url = [url stringByAppendingString:parameter];
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"GET"];

    NSURLSessionTask *task = [FlickrApi.session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
    {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
        if ( httpResponse.statusCode == 200 )
        {
            NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
            NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:data];
            [xmlParser setDelegate:parserdelegate];
            [xmlParser parse];
        }
    }];

    [task resume];
}

+ (void) getImageSourceById: (NSString *)photoId
                   delegate: (id<NSXMLParserDelegate>)parserdelegate;
{
    NSString *url = [FlickrApi apiURL_getPhotoSizesById:photoId];

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"GET"];

    NSURLSessionTask *task = [FlickrApi.session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
    {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
        if ( httpResponse.statusCode == 200 )
        {
            NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
            NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:data];
            [xmlParser setDelegate:parserdelegate];
            [xmlParser parse];
        }
    }];

    [task resume];
}

@end
