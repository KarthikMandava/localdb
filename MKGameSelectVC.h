//
//  MKGameSelectVC.h
//  localDB
//
//  Created by Intellisense Technology on 27/07/16.
//  Copyright © 2016 intellisense Technology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MKGameSelectVC : UIViewController

@property (strong, nonatomic) IBOutlet UIButton *btn3X3;

@property (strong, nonatomic) IBOutlet UIButton *btn4X4;

@property (strong, nonatomic) IBOutlet UIButton *btn5X5;

- (IBAction)onClick:(UIButton *)sender;

- (IBAction)onClick3X3:(UIButton *)sender;
- (IBAction)onClick4X4:(UIButton *)sender;
- (IBAction)onClick5X5:(UIButton *)sender;

@end
