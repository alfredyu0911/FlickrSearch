//
//  FlickrSearchHelper.m
//  t5
//
//  Created by Alfred Yu on 2020/10/19.
//

#import "FlickrApiManager_PhotoSearch.h"
#import "FlickrPhoto.h"

const NSString *apiKey = @"9325596e04160c1d5c5c04fd1d96ba13";

@interface FlickrApiManager_PhotoSearch()

@property (strong, nonatomic) NSURLSession *session;
@property (strong, nonatomic) NSMutableArray *aryPhotoList;

@end


@implementation FlickrApiManager_PhotoSearch

- (instancetype) init
{
    self = [super init];
    if ( !self )
    {
        return nil;
    }
    
    self.session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    self.aryPhotoList = [[NSMutableArray alloc] init];
    
    return self;
}

- (void) searchByText:(NSString *)text andPage:(NSInteger)page
{
    [self.aryPhotoList removeAllObjects];
    
    NSString *url = @"https://www.flickr.com/services/rest/?method=flickr.photos.search&";
    
    NSMutableString *parameter = [[NSMutableString alloc] init];
    [parameter appendFormat:@"api_key=%@&", apiKey];
    [parameter appendFormat:@"text=%@&", text];
    [parameter appendFormat:@"per_page=%ld&", page];
    
    url = [url stringByAppendingString:parameter];

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"GET"];

    NSURLSessionTask *task = [self.session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
    {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
        if ( httpResponse.statusCode == 200 )
        {
            NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
            NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:data];
            [xmlParser setDelegate:self];
            [xmlParser parse];
        }
    }];

    [task resume];
}

- (void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict
{
    if ( [elementName isEqual:@"photo"] )
    {
        FlickrPhoto *photo = [[FlickrPhoto alloc] initWithId:[attributeDict valueForKey:@"id"] andOwner:[attributeDict valueForKey:@"owner"]];
        [self.aryPhotoList addObject:photo];
    }
}

@end
