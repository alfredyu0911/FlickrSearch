//
//  FlickrSearchMainVC.m
//  t5
//
//  Created by Alfred Yu on 2020/10/19.
//

#import "FlickrSearchDetailVC.h"
#import "FlickrApi.h"
#import "FlickrPhoto.h"
#import "FlickrSearchResultVC.h"

@interface FlickrSearchDetailVC () <NSXMLParserDelegate>

@property (strong, nonatomic) IBOutlet UIButton *btn_confirm;
@property (strong, nonatomic) IBOutlet UITextField *txt_text;
@property (strong, nonatomic) IBOutlet UITextField *txt_page;
@property (strong, nonatomic) NSMutableArray *aryPhotoList;

@end

@implementation FlickrSearchDetailVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.btn_confirm setEnabled:NO];
    [self.btn_confirm addTarget:self action:@selector(btnDidClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.txt_text setText:@""];
    [self.txt_text addTarget:self action:@selector(textFieldDidEndEditing:) forControlEvents:UIControlEventEditingChanged];
    
    [self.txt_page setText:@""];
    [self.txt_page setKeyboardType:UIKeyboardTypeNumberPad];
    [self.txt_page addTarget:self action:@selector(textFieldDidEndEditing:) forControlEvents:UIControlEventEditingChanged];
}

#pragma mark - button event

- (void) btnDidClick: (UIButton *) btn
{
    self.aryPhotoList = [[NSMutableArray alloc] init];
    [self.aryPhotoList removeAllObjects];
    
    [FlickrApi searchPhotoByText:self.txt_text.text andPage:[self.txt_page.text integerValue] delegate:self];
}

#pragma mark - textField event

- (void) textFieldDidEndEditing: (UITextField *) textField
{
    if ( self.txt_text.text.length <= 0 || self.txt_text.text == nil || [self.txt_text isEqual:@""] )
    {
        [self.btn_confirm setEnabled:NO];
        return;
    }
    
    if ( self.txt_page.text.length <= 0 || self.txt_page.text == nil || [self.txt_page isEqual:@""] )
    {
        [self.btn_confirm setEnabled:NO];
        return;
    }
    
    [self.btn_confirm setEnabled:YES];
}

#pragma mark - XML parser

- (void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict
{
    if ( [elementName isEqual:@"photo"] )
    {
        FlickrPhoto *photo = [[FlickrPhoto alloc] initWithId:[attributeDict valueForKey:@"id"] andOwner:[attributeDict valueForKey:@"owner"]];
        [self.aryPhotoList addObject:photo];
    }
}

- (void) parserDidEndDocument: (NSXMLParser *)parser
{
    dispatch_async(dispatch_get_main_queue(), ^
    {
        // push to next view;
        FlickrSearchResultVC *vc = [[FlickrSearchResultVC alloc] initWithPhotoList:self.aryPhotoList nibName:@"FlickrSearchResultVC" bundle:nil];
        [self presentViewController:vc animated:YES completion:nil];
    });
}

@end
