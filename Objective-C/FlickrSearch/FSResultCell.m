//
//  FSResultCell.m
//  t5
//
//  Created by Alfred Yu on 2020/10/19.
//

#import "FSResultCell.h"
#import "FSPhoto.h"
#import "DataManager.h"

typedef enum enFavoriteStatus
{
    Selected = 0,
    UnSelected
} FavoriteStatus;

@interface FSResultCell () <FlickrPhoto_Delegate>

@property (strong, nonatomic) FSPhoto *photoInfo;
@property (weak, nonatomic) IBOutlet UIImageView *favorite;

@end

@implementation FSResultCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setLoadingComplete:NO];
    [self imageViewInit];
    [self favoriteIconInit];
}

- (void) imageViewInit
{
    [self.imageView setClipsToBounds:YES];
    [self.imageView.layer setCornerRadius:9];
    [self.imageView setContentMode:UIViewContentModeScaleAspectFill];
}

- (void) favoriteIconInit
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(favIconOnClick)];
    [self.favorite setUserInteractionEnabled:YES];
    [self.favorite addGestureRecognizer:tap];
}

- (void) setLoadingComplete: (BOOL)status
{
    [self.imageView setHidden:(status ? NO : YES)];
    [self.favorite setHidden:(status ? NO : YES)];
    [self.activityView setHidden:(status ? YES : NO)];
    (status ? [self.activityView stopAnimating] : [self.activityView startAnimating]);
    
    if ( [DataManager queryRecordByphotoId:self.photoInfo.photo_id owner:self.photoInfo.photo_owner] )
        [self setCellIsSelectedAsFavorite:YES];
    else
        [self setCellIsSelectedAsFavorite:NO];
}

- (void) loadImageWithInfo: (FSPhoto *)info
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

- (void) setCellIsSelectedAsFavorite: (BOOL)isSelected
{
    if ( isSelected )
    {
        [self.favorite setImage:[UIImage systemImageNamed:@"heart.fill"]];
        [self.favorite setTag:Selected];
    }
    else
    {
        [self.favorite setImage:[UIImage systemImageNamed:@"heart"]];
        [self.favorite setTag:UnSelected];
    }
}

- (void) switchCellSelected
{
    if ( self.favorite.tag == Selected )
    {
        [DataManager deleteRecordByphotoId:self.label_id.text owner:self.label_owner.text];
        [self setCellIsSelectedAsFavorite:NO];
    }
    else
    {
        [DataManager addRecordByphotoId:self.label_id.text owner:self.label_owner.text source:self.photoInfo.photo_source];
        [self setCellIsSelectedAsFavorite:YES];
    }
}

#pragma mark - FlickrPhoto_Delegate

- (void) photoLoadComplete
{
    dispatch_async(dispatch_get_main_queue(), ^
    {
        [self setPhoto];
    });
}

#pragma mark - gesture event

- (void) favIconOnClick
{
    [self switchCellSelected];
}

@end
