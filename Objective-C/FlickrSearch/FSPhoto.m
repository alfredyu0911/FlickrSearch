//
//  FlickrPhoto.m
//  t5
//
//  Created by Alfred Yu on 2020/10/19.
//

#import "FSPhoto.h"
#import "FlickrApi.h"

@interface FSPhoto () <NSXMLParserDelegate>

@property (strong, nonatomic) NSString *xmlContent;

@end

@implementation FSPhoto

- (instancetype) initWithId: (NSString *)photoId andOwner: (NSString *) owner
{
    self = [super init];
    if ( !self )
    {
        return nil;
    }
    
    _photo_id = photoId;
    _photo_owner = owner;
    
    return self;
}

- (void) loadImage
{
    [FlickrApi getImageSourceById:self.photo_id delegate:self];
}

#pragma mark - XML parser

- (void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict
{
    if ( [elementName isEqual:@"size"] )
    {
        NSObject *obj = [attributeDict objectForKey:@"source"];
        if ( obj != nil )
        {
            // for multiple content, only store the last one, which is the largest one
            _photo_source = [attributeDict valueForKey:@"source"];
        }
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(nullable NSString *)namespaceURI qualifiedName:(nullable NSString *)qName
{
    if ( [elementName isEqual:@"sizes"] )
    {
        NSURL *url = [NSURL URLWithString:self.photo_source];
        NSData *data = [NSData dataWithContentsOfURL:url];
        self.image = [UIImage imageWithData:data];
        [self.delegate photoLoadComplete];
    }
}

@end
