//
//  FlickrPhotoCell.m
//  t5
//
//  Created by Alfred Yu on 2020/10/19.
//

#import "FlickrPhotoCell.h"
#import "FlickrPhoto.h"

@interface FlickrPhotoCell () <FlickrPhoto_Delegate>

@property (strong, nonatomic) FlickrPhoto *photoInfo;

@end

@implementation FlickrPhotoCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setLoadingComplete:NO];
    [self imageViewInit];
}

- (void) imageViewInit
{
    [self.imageView setClipsToBounds:YES];
    [self.imageView.layer setCornerRadius:9];
    [self.imageView setContentMode:UIViewContentModeScaleAspectFill];
}

- (void) setLoadingComplete: (BOOL)status
{
    [self.imageView setHidden:(status ? NO : YES)];
    [self.activityView setHidden:(status ? YES : NO)];
    (status ? [self.activityView stopAnimating] : [self.activityView startAnimating]);
}

- (void) loadImageWithInfo: (FlickrPhoto *)info
{
    self.photoInfo = info;
    
    if ( info.image == nil )
    {
        [self setLoadingComplete:NO];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
        {
            [self.photoInfo loadImage];
            self.photoInfo.delegate = self;
        });
    }
    else
    {
        [self setPhoto];
    }
}

- (void) setPhoto
{
    [self.imageView setImage:self.photoInfo.image];
    [self setLoadingComplete:YES];
}

#pragma mark - FlickrPhoto_Delegate

- (void) photoLoadComplete
{
    dispatch_async(dispatch_get_main_queue(), ^
    {
        [self setPhoto];
    });
}

@end
