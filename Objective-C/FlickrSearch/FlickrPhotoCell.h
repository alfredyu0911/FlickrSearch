//
//  FlickrPhotoCell.h
//  t5
//
//  Created by Alfred Yu on 2020/10/19.
//

#import <UIKit/UIKit.h>
#import "FlickrPhoto.h"

NS_ASSUME_NONNULL_BEGIN

@interface FlickrPhotoCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *label_id;
@property (weak, nonatomic) IBOutlet UILabel *label_owner;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityView;

- (void) loadImageWithInfo: (FlickrPhoto *)info;

@end

NS_ASSUME_NONNULL_END
