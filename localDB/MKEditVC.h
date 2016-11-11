//
//  MKEditVC.h
//  localDB
//
//  Created by Intellisense Technology on 21/07/16.
//  Copyright © 2016 intellisense Technology. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EditInfoVCDelegate

-(void)editingInfoWasFinished;

@end


@interface MKEditVC : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) id<EditInfoVCDelegate> delegate;

@property (strong, nonatomic) IBOutlet UIButton *btnSave;
- (IBAction)onClickSave:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UITextField *textFirstName;
@property (strong, nonatomic) IBOutlet UITextField *textLastName;

@property (strong, nonatomic) IBOutlet UITextField *textMobileNumber;

@property (strong, nonatomic) IBOutlet UIImageView *imageVw;

@property (nonatomic) int recordIDToEdit;
- (IBAction)onClickImageVw:(UIButton *)sender;

@end
