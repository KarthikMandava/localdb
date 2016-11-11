//
//  MKGameSelectVC.m
//  localDB
//
//  Created by Intellisense Technology on 27/07/16.
//  Copyright © 2016 intellisense Technology. All rights reserved.
//

#import "MKGameSelectVC.h"
#import "MKDragBtnVC.h"
@interface MKGameSelectVC ()
{
    NSInteger gameType;
}
@end

@implementation MKGameSelectVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _btn3X3.layer.cornerRadius = 5;
    _btn4X4.layer.cornerRadius = 5;
    _btn5X5.layer.cornerRadius = 5;
    
    _btn3X3.backgroundColor=[[UIColor whiteColor] colorWithAlphaComponent:0.8];
    _btn4X4.backgroundColor=[[UIColor whiteColor] colorWithAlphaComponent:0.8];
    _btn5X5.backgroundColor=[[UIColor whiteColor] colorWithAlphaComponent:0.8];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  //STARTGAME
    
    MKDragBtnVC *vc=segue.destinationViewController;
    vc.gameType=gameType;
}


- (IBAction)onClick:(UIButton *)sender {
}

- (IBAction)onClick3X3:(UIButton *)sender
{
    gameType = 3;
    [self performSegueWithIdentifier:@"STARTGAME" sender:self];
}

- (IBAction)onClick4X4:(UIButton *)sender
{
     gameType = 4;
    [self performSegueWithIdentifier:@"STARTGAME" sender:self];
}

- (IBAction)onClick5X5:(UIButton *)sender
{
    gameType = 5;
    [self performSegueWithIdentifier:@"STARTGAME" sender:self];
}
@end
