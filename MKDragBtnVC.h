//
//  MKDragBtnVC.h
//  localDB
//
//  Created by Intellisense Technology on 25/07/16.
//  Copyright © 2016 intellisense Technology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MKDragBtnVC : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource>

@property (strong, nonatomic) IBOutlet UIButton *btnForDrag;
- (IBAction)btnDrag:(id)sender;
- (IBAction)btnDragExit:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *resultLabel;
@property (strong,nonatomic) IBOutlet UILabel *resultOfSystem;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionVw;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *heightOfCollectionVw;
- (IBAction)onClickEqual:(UIButton *)sender;

@property (strong, nonatomic) IBOutlet UIButton *btnEqual;
- (IBAction)ronClickRefresh:(UIBarButtonItem *)sender;
@property NSInteger gameType;
@end
