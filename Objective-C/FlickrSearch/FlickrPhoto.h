//
//  FlickrPhoto.h
//  t5
//
//  Created by Alfred Yu on 2020/10/19.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol FlickrPhoto_Delegate

- (void) photoLoadComplete;

@end

@interface FlickrPhoto : NSObject

@property (strong, nonatomic) NSString *photo_id;
@property (strong, nonatomic) NSString *photo_owner;
@property (strong, nonatomic) NSString *photo_source;
@property (strong, nonatomic) UIImage *image;

@property (strong, nonatomic) id<FlickrPhoto_Delegate> delegate;

- (instancetype) initWithId: (NSString *)photoId andOwner: (NSString *) owner;
- (void) loadImage;

@end

NS_ASSUME_NONNULL_END
