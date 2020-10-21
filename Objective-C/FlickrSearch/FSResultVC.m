//
//  FSResultVC.m
//  t5
//
//  Created by Alfred Yu on 2020/10/19.
//

#import "FSResultVC.h"
#import "FSResultCell.h"
#import "FSPhoto.h"

#define UIColorFromHex(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

const CGFloat kGap = 20.0;
const NSInteger kColumns = 2;

@interface FSResultVC () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *label_notFound;
@property (strong, nonatomic) NSMutableArray *photoList;

@end

@implementation FSResultVC

- (instancetype) initWithPhotoList:(NSMutableArray *)list
                           nibName:(NSString *)nibNameOrNil
                            bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if ( self == nil )
    {
        return nil;
    }
    
    self.photoList = list;
    self.str_notFound = @"Nothing Found !!";
    
    return self;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    if ( self.photoList.count > 0 )
        [self collectionViewInit];

    [self.label_notFound setText:self.str_notFound];
    [self.label_notFound setHidden:(self.photoList.count > 0 ? YES : NO)];
}

- (void) collectionViewInit
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;

    self.collectionView.backgroundColor = UIColorFromHex(0xEFF0F8);
    self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    self.collectionView.collectionViewLayout = layout;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"FSResultCell" bundle:nil] forCellWithReuseIdentifier:@"id_FSResultCell"];
}

#pragma mark - CollectionView datasource

- (NSInteger) collectionView: (UICollectionView *)collectionView numberOfItemsInSection: (NSInteger)section
{
    return self.photoList.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *) collectionView: (UICollectionView *)collectionView
                   cellForItemAtIndexPath: (NSIndexPath *)indexPath
{
    FSResultCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"id_FSResultCell" forIndexPath:indexPath];
    
    if ( indexPath.row < self.photoList.count )
    {
        NSObject *obj = [self.photoList objectAtIndex:indexPath.row];
        if ( [obj isKindOfClass:[FSPhoto class]] )
        {
            FSPhoto *photoInfo = (FSPhoto *)obj;
            cell.label_id.text = photoInfo.photo_id;
            cell.label_owner.text = photoInfo.photo_owner;
            [cell loadImageWithInfo:photoInfo];
        }
    }
    
    return cell;
}

#pragma mark - CollectionView Flow Layout Delegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat size = (self.view.frame.size.width - 2*kGap - (kColumns-1)*kGap) / 2.0;
    return CGSizeMake(size, size);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(kGap, kGap, kGap, kGap);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section;
{
    return kGap;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return kGap;
}

@end
