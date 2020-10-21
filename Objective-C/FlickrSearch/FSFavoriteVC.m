//
//  FSFavoriteVC.m
//  FlickrSearch
//
//  Created by Alfred Yu on 2020/10/21.
//

#import "FSFavoriteVC.h"
#import "DataManager.h"

@interface FSFavoriteVC ()

@end

@implementation FSFavoriteVC

- (instancetype) init
{
    NSMutableArray *list = [DataManager queryRecord];
    
    self = [super initWithPhotoList:list nibName:@"FSResultVC" bundle:nil];
    
    self.str_notFound = @"Empty !!";
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

@end
