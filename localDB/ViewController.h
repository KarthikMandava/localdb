//
//  ViewController.h
//  localDB
//
//  Created by Intellisense Technology on 21/07/16.
//  Copyright © 2016 intellisense Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKEditVC.h"

#import "JTSImageViewController.h"
#import "JTSImageInfo.h"

@interface ViewController : UIViewController<UITableViewDelegate, UITableViewDataSource,EditInfoVCDelegate,UISearchBarDelegate,UISearchDisplayDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableVw;
- (IBAction)onClickPlus:(UIButton *)sender;

- (IBAction)onClickEdit:(UIButton *)sender;
- (IBAction)onClickImagePic:(UIButton *)sender;
- (IBAction)onClickSearch:(id)sender;
@property  UISearchBar *search;
@end

