//
//  MKEditVC.m
//  localDB
//
//  Created by Intellisense Technology on 21/07/16.
//  Copyright © 2016 intellisense Technology. All rights reserved.
//

#import "MKEditVC.h"
#import "MKDBManager.h"
#import "DejalActivityView.h"

@interface MKEditVC ()
@property (nonatomic, strong) MKDBManager *dbManager;
@end

@implementation MKEditVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Set the navigation bar tint color.
    self.navigationController.navigationBar.tintColor = self.navigationItem.rightBarButtonItem.tintColor;
    
    // Initialize the dbManager object.
    self.dbManager = [[MKDBManager alloc] initWithDataBaseFileName:@"one.sqlite"];
    
    // Check if should load specific record for editing.
    if (self.recordIDToEdit != -1) {
        // Load the record with the specific ID from the database.
        [self loadInfoToEdit];
    }
    
    self.imageVw.layer.cornerRadius=self.imageVw.frame.size.height/2;
    
    self.imageVw.layer.borderColor= [UIColor blackColor].CGColor;
    self.imageVw.layer.borderWidth=1.0;
    
    self.imageVw.layer.masksToBounds=YES;

}



- (IBAction)onClickSave:(UIButton *)sender {
    
    
    if (self.textFirstName.text.length > 0 && self.textLastName.text.length > 0 && self.textMobileNumber.text.length > 0)
    {
       [DejalBezelActivityView activityViewForView:[[[UIApplication sharedApplication] delegate] window]];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
        NSData *imageData = UIImagePNGRepresentation(self.imageVw.image);
        
        NSString *imageString = [NSString stringWithFormat:@"%@",[imageData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed]];
        //imageString = @"karthik";
        NSString *query;
        if (self.recordIDToEdit == -1)
        {
            query = [NSString stringWithFormat:@"insert into peopleInfo(ID, firstname, lastname, mobile, image) values(null, '%@', '%@', '%@', '%@')", self.textFirstName.text, self.textLastName.text, self.textMobileNumber.text, imageString];
        }
        else
        {
            query = [NSString stringWithFormat:@"update peopleInfo set firstname='%@', lastname='%@', mobile='%@', image='%@' where ID=%d", self.textFirstName.text, self.textLastName.text, self.textMobileNumber.text,imageString, self.recordIDToEdit];
        }
        
        // Execute the query.
        [self.dbManager executeQuery:query];
        // If the query was successfully executed then pop the view controller.
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (self.dbManager.affectedRows != 0)
                {
                    NSLog(@"Query was executed successfully. Affected rows = %d", self.dbManager.affectedRows);
                    // Inform the delegate that the editing was finished.
                    [self.delegate editingInfoWasFinished];
                    // Pop the view controller.
                    [DejalBezelActivityView removeView];
                    [self.navigationController popViewControllerAnimated:YES];
                }
                else
                {
                    [DejalBezelActivityView removeView];
                    NSLog(@"Could not execute the query.");
                }
            });
        });
    }
    else
    {
    }
}

#pragma mark - Private method implementation

-(void)loadInfoToEdit{
    // Create the query.
    NSString *query = [NSString stringWithFormat:@"select * from peopleInfo where ID=%d", self.recordIDToEdit];
    
    // Load the relevant data.
    NSArray *results = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    
    // Set the loaded data to the textfields.
    self.textFirstName.text = [[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"firstname"]];
    self.textLastName.text = [[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"lastname"]];
    self.textMobileNumber.text = [[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"mobile"]];
    
    
//    self.imageVw.image=[[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"image"]];
    
    
    NSData *data = [[NSData alloc]initWithBase64EncodedString:[[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"image"]] options:NSDataBase64DecodingIgnoreUnknownCharacters];
    
    self.imageVw.image=[UIImage imageWithData:data];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
- (IBAction)onClickImageVw:(UIButton *)sender
{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.delegate = self;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //You can retrieve the actual UIImage
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    
    
    self.imageVw.image=image;
    //Or you can get the image url from AssetsLibrary
//    NSURL *path = [info valueForKey:UIImagePickerControllerReferenceURL];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}
@end
