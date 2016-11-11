//
//  ViewController.m
//  localDB
//
//  Created by Intellisense Technology on 21/07/16.
//  Copyright © 2016 intellisense Technology. All rights reserved.
//

#import "ViewController.h"
#import "MKCustomCell.h"
#import "MKDBManager.h"
#import "DejalActivityView.h"

@interface ViewController ()

@property (nonatomic, strong) MKDBManager *dbManager;

@property (nonatomic, strong) NSArray *arrPeopleInfo;

@property (nonatomic) int recordIDToEdit;
@property NSMutableArray * filterResultArray;
@property NSMutableArray *arrayForNames;
@property NSMutableDictionary *dictForSearch;
@property BOOL isEditMode;
@property BOOL searchBarIsActive;

-(void)loadData;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.tableVw.delegate=self;
    self.tableVw.dataSource=self;
    
    // Initialize the dbManager property.
    self.dbManager = [[MKDBManager alloc] initWithDataBaseFileName:@"one.sqlite"];
    
    // Load the data.
    [self loadData];

    self.tableVw.tableFooterView=[[UIView alloc] init];
}

-(void)viewWillAppear:(BOOL)animated
{
    //[DejalBezelActivityView removeView];
}

#pragma mark - UITableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.searchBarIsActive) {
        return _filterResultArray.count;
    }
   return self.arrPeopleInfo.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MKCustomCell *cell=[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (cell == nil)
    {
        cell=[[MKCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    }
    
    if (self.searchBarIsActive)
    {
        cell.name.text=[NSString stringWithFormat:@"%@ %@",[[_filterResultArray objectAtIndex:indexPath.row] valueForKey:@"fName"],[[_filterResultArray objectAtIndex:indexPath.row] valueForKey:@"lName"]];
        
        cell.name.textColor=[UIColor blueColor];
        
        NSString *firstName=[[_filterResultArray objectAtIndex:indexPath.row] valueForKey:@"fName"];
        
        NSMutableAttributedString *text =
        [[NSMutableAttributedString alloc]
         initWithAttributedString:  cell.name.attributedText];
        
        [text addAttribute:NSForegroundColorAttributeName
                     value:[UIColor redColor]
                     range:NSMakeRange(0, firstName.length)];
        
        [cell.name setAttributedText: text];
        
        cell.mobile.text=[[_filterResultArray objectAtIndex:indexPath.row] valueForKey:@"mobile"];

        NSData *data = [[NSData alloc]initWithBase64EncodedString:[[_filterResultArray objectAtIndex:indexPath.row] valueForKey:@"image"] options:NSDataBase64DecodingIgnoreUnknownCharacters];
        
        cell.imageVw.image=[UIImage imageWithData:data];
    }
    else
    {
    
    NSInteger indexOfFirstname = [self.dbManager.arrColumnNames indexOfObject:@"firstname"];
    NSInteger indexOfLastname = [self.dbManager.arrColumnNames indexOfObject:@"lastname"];
    NSInteger indexOfAge = [self.dbManager.arrColumnNames indexOfObject:@"mobile"];
    
    NSInteger indexOFImage=[self.dbManager.arrColumnNames indexOfObject:@"image"];
    
     NSData *data = [[NSData alloc]initWithBase64EncodedString:[[self.arrPeopleInfo objectAtIndex:indexPath.row] objectAtIndex:indexOFImage] options:NSDataBase64DecodingIgnoreUnknownCharacters];
    
    cell.imageVw.image=[UIImage imageWithData:data];
    
    // Set the loaded data to the appropriate cell labels.
    cell.name.text = [NSString stringWithFormat:@"%@ %@", [[self.arrPeopleInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfFirstname], [[self.arrPeopleInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfLastname]];
    
    NSString *firstName=[[self.arrPeopleInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfFirstname];
    
    cell.name.textColor=[UIColor blueColor];
    
   
            NSMutableAttributedString *text =
            [[NSMutableAttributedString alloc]
             initWithAttributedString:  cell.name.attributedText];
    
            [text addAttribute:NSForegroundColorAttributeName
                         value:[UIColor redColor]
                         range:NSMakeRange(0, firstName.length)];

    [cell.name setAttributedText: text];
    
    cell.mobile.text = [NSString stringWithFormat:@"%@", [[self.arrPeopleInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfAge]];
    
       }

    cell.imageVw.layer.cornerRadius=cell.imageVw.frame.size.height/2;
    cell.imageVw.layer.borderColor= [UIColor blackColor].CGColor;
    cell.imageVw.layer.borderWidth=1.0;
    cell.imageVw.layer.masksToBounds=YES;
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.imageBtn.tag=indexPath.row;

    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.recordIDToEdit = [[[self.arrPeopleInfo objectAtIndex:indexPath.row] objectAtIndex:0] intValue];
    [self performSegueWithIdentifier:@"EditVC" sender:self];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isEditMode)
    {
        return YES;
    }
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
         self.recordIDToEdit = [[[self.arrPeopleInfo objectAtIndex:indexPath.row] objectAtIndex:0] intValue];
        NSString *query;
            query = [NSString stringWithFormat:@"delete from peopleInfo where ID=%d",self.recordIDToEdit];
        
        // Execute the query.
        [self.dbManager executeQuery:query];
        
        // If the query was successfully executed then pop the view controller.
        if (self.dbManager.affectedRows != 0)
        {
            NSLog(@"Query was executed successfully. Affected rows = %d", self.dbManager.affectedRows);
            
        }
        else
        {
            NSLog(@"Could not execute the query.");
        }
        
       //[self.tableVw deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self loadData];
    }
}

#pragma mark - EditInfoViewControllerDelegate method implementation

-(void)editingInfoWasFinished{
    // Reload the data.
    [self loadData];
}
#pragma mark - Private method implementation

-(void)loadData{
    // Form the query.
    NSString *query = @"select * from peopleInfo";
    
    // Get the results.
    if (self.arrPeopleInfo != nil)
    {
        self.arrPeopleInfo = nil;
    }
    self.arrPeopleInfo = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    
    NSLog(@"%@",self.arrPeopleInfo);

    [self.tableVw reloadData];
}
#pragma mark - 

/*
 
*/

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onClickPlus:(UIButton *)sender
{
    self.recordIDToEdit = -1;
    [self performSegueWithIdentifier:@"EditVC" sender:self];
}

- (IBAction)onClickEdit:(UIButton *)sender
{
    if (_isEditMode)
    {
        [sender setTitle:@"Edit" forState:UIControlStateNormal];
        _isEditMode = NO;
         [self.tableVw setEditing: NO animated: YES];
    }
    else
    {
        [sender setTitle:@"Done" forState:UIControlStateNormal];
        _isEditMode = YES;
         [self.tableVw setEditing: YES animated: YES];
    }
}

- (IBAction)onClickImagePic:(UIButton *)sender
{
    JTSImageInfo *imageInfo = [[JTSImageInfo alloc] init];

    NSInteger indexOFImage=[self.dbManager.arrColumnNames indexOfObject:@"image"];
    
    NSData *data = [[NSData alloc]initWithBase64EncodedString:[[self.arrPeopleInfo objectAtIndex:sender.tag] objectAtIndex:indexOFImage] options:NSDataBase64DecodingIgnoreUnknownCharacters];
    
    imageInfo.image=[UIImage imageWithData:data];
    
   // imageInfo.image = YOUR_SOURCE_IMAGE;
    imageInfo.referenceRect = sender.frame;
    imageInfo.referenceView = sender.superview;
    // Setup view controller
    JTSImageViewController *imageViewer = [[JTSImageViewController alloc]
                                           initWithImageInfo:imageInfo
                                           mode:JTSImageViewControllerMode_Image
                                           backgroundStyle:JTSImageViewControllerBackgroundOption_Scaled];
    
    // Present the view controller.
    [imageViewer showFromViewController:self transition:JTSImageViewControllerTransition_FromOriginalPosition];
}

- (IBAction)onClickSearch:(id)sender
{
    self.search = [[UISearchBar alloc]initWithFrame:CGRectMake(0,20, [UIScreen mainScreen].bounds.size.width, 44)];
    self.search.searchBarStyle       = UISearchBarStyleMinimal;
    self.search.tintColor            = [UIColor blackColor];
    self.search.barTintColor         = [UIColor blackColor];
    self.search.delegate             = self;
    self.search.placeholder          = @"Search Here";
    self.search.backgroundColor=[UIColor colorWithRed:(124/255.0) green:(186/255.0) blue:(27/255.0) alpha:1.0];
    
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setTextColor:[UIColor blackColor]];

    [[UIApplication sharedApplication].keyWindow addSubview:self.search];
    [self.search becomeFirstResponder];
    
    _arrayForNames=[[NSMutableArray alloc] init];
   
    NSInteger indexOfFirstname = [self.dbManager.arrColumnNames indexOfObject:@"firstname"];
    NSInteger indexOfLastname = [self.dbManager.arrColumnNames indexOfObject:@"lastname"];
    NSInteger indexOfAge = [self.dbManager.arrColumnNames indexOfObject:@"mobile"];
    NSInteger indexOFImage=[self.dbManager.arrColumnNames indexOfObject:@"image"];

    for (int i=0;i<self.arrPeopleInfo.count;i++)
    {
        NSString *str=[[self.arrPeopleInfo objectAtIndex:i] objectAtIndex:indexOfFirstname];
        NSString *lName=[[self.arrPeopleInfo objectAtIndex:i] objectAtIndex:indexOfLastname];
        NSString *mobile=[[self.arrPeopleInfo objectAtIndex:i] objectAtIndex:indexOfAge];
        NSString *image=[[self.arrPeopleInfo objectAtIndex:i] objectAtIndex:indexOFImage];
         _dictForSearch=[[NSMutableDictionary alloc] init];
        
        [_dictForSearch setValue:str forKey:@"fName"];
        [_dictForSearch setValue:lName forKey:@"lName"];
        [_dictForSearch setValue:mobile forKey:@"mobile"];
        [_dictForSearch setValue:image forKey:@"image"];
        
        [_arrayForNames addObject:_dictForSearch];
    }
   // NSLog(@"%@",_arrayForNames);
}

-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [UIColor whiteColor],
                                                                                                  NSForegroundColorAttributeName,
                                                                                                  [UIColor whiteColor],
                                                                                                  UITextAttributeTextShadowColor,
                                                                                                  [NSValue valueWithUIOffset:UIOffsetMake(0, -1)],
                                                                                                  UITextAttributeTextShadowOffset,nil] forState:UIControlStateNormal];
    searchBar.showsScopeBar = YES;
    [searchBar sizeToFit];
    [searchBar setShowsCancelButton:YES animated:YES];
      _searchBarIsActive = YES;
    return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    _searchBarIsActive = NO;
    searchBar.showsScopeBar = YES;
    [searchBar sizeToFit];
    [searchBar setShowsCancelButton:YES animated:YES];
    return YES;
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
       [self.search resignFirstResponder];
    [self.search removeFromSuperview];
    _searchBarIsActive = NO;
    
    [_tableVw reloadData];
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate *resultPredicate    = [NSPredicate predicateWithFormat:@"self contains[c] %@", searchText];
    
    NSMutableArray *array=[[NSMutableArray alloc] init];
    
    for (char i=0;i<_arrayForNames.count;i++)
    {
        [array addObject:[NSString stringWithFormat:@"%@ %@",[[_arrayForNames objectAtIndex:i] valueForKey:@"fName"],[[_arrayForNames objectAtIndex:i] valueForKey:@"lName"]]];
    }
  
    array=[[array filteredArrayUsingPredicate:resultPredicate] mutableCopy];
    
    _filterResultArray=[[NSMutableArray alloc] init];
    
    for (char i=0;i<array.count;i++)
    {
        for (char j=0;j<_arrayForNames.count;j++)
        {
             NSString *str=[NSString stringWithFormat:@"%@ %@",[[_arrayForNames objectAtIndex:j] valueForKey:@"fName"],[[_arrayForNames objectAtIndex:j] valueForKey:@"lName"]];
            
            if ([[array objectAtIndex:i] containsString:str])
            {
                [_filterResultArray addObject:[_arrayForNames objectAtIndex:j]];
            }
        }
    }
    
    if ([_filterResultArray count] > 0)
    {
        _searchBarIsActive = YES;
        [self.tableVw reloadData];
    }
    else
    {
        
    }
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText.length>0)
    {
       
        [self filterContentForSearchText:searchText
                                   scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                          objectAtIndex:[self.searchDisplayController.searchBar
                                                         selectedScopeButtonIndex]]];
    }
    else
    {
        _searchBarIsActive = NO;
        [_tableVw reloadData];
       
    }
}
#pragma mark -
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"EditVC"])
    {
        MKEditVC *vc=segue.destinationViewController;
        vc.delegate=self;
        vc.recordIDToEdit=self.recordIDToEdit;
    }
}

@end