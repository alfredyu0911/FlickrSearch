//
//  FlickrSearchResultVC.h
//  t5
//
//  Created by Alfred Yu on 2020/10/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FlickrSearchResultVC : UIViewController

- (instancetype) initWithPhotoList:(NSMutableArray *)list
                           nibName:(nullable NSString *)nibNameOrNil
                            bundle:(nullable NSBundle *)nibBundleOrNil;

@end

NS_ASSUME_NONNULL_END
