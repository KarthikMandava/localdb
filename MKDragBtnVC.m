//
//  MKDragBtnVC.m
//  localDB
//
//  Created by Intellisense Technology on 25/07/16.
//  Copyright © 2016 intellisense Technology. All rights reserved.
//

#import "MKDragBtnVC.h"
#import "CustomCell.h"
#import <QuartzCore/QuartzCore.h>

@interface MKDragBtnVC ()
@property   UIPanGestureRecognizer *pangr;
@property BOOL isLarge;
@property NSMutableArray *arrayForSymbols;
@property NSMutableArray *arrayForSelected;
@property NSMutableArray *arrayForNeedToSelect;
@property BOOL isDevice;

@end

@implementation MKDragBtnVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _btnForDrag.backgroundColor=[UIColor blueColor];
    _pangr= [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [_btnForDrag addGestureRecognizer:_pangr];
    
    [self refresh];
}

-(void)refresh
{
    self.collectionVw.delegate=self;
    self.collectionVw.dataSource=self;
    
    self.collectionVw.backgroundColor=[UIColor clearColor];
    
    _arrayForSymbols=[[NSMutableArray alloc] init];
    
    [_arrayForSymbols addObject:@"+"];
    [_arrayForSymbols addObject:@"-"];
    [_arrayForSymbols addObject:@"*"];
    [_arrayForSymbols addObject:@"/"];
    
    if (_gameType == 3)
    {
        _arrayForNeedToSelect=[[NSMutableArray alloc] initWithObjects:@"1",@"3",@"5",@"7",@"9",@"11",@"13",@"15",@"17",@"19",@"21",@"23",nil];
        self.heightOfCollectionVw.constant = 300;
    }
    else if (_gameType == 4)
    {
        _arrayForNeedToSelect=[[NSMutableArray alloc] initWithObjects:@"1",@"3",@"5",@"7",@"9",@"11",@"13",@"15",@"17",@"19",@"21",@"23",@"25",@"27",@"29",@"31",@"33",@"35",@"37",@"39",@"41",@"43",@"45",@"47",nil];
        self.heightOfCollectionVw.constant = 400;
    }
    else if (_gameType == 5)
    {
        _arrayForNeedToSelect=[[NSMutableArray alloc] initWithObjects:@"1",@"3",@"5",@"7",@"9",@"11",@"13",@"15",@"17",@"19",@"21",@"23",@"25",@"27",@"29",@"31",@"33",@"35",@"37",@"39",@"41",@"43",@"45",@"47",@"49",@"51",@"53",@"55",@"57",@"59",@"61",@"63",@"65",@"67",@"69",@"71",@"73",@"75",@"77",@"79",nil];
        self.heightOfCollectionVw.constant = 480;
    }

    _arrayForSelected=[[NSMutableArray alloc] init];
    
    self.btnEqual.alpha = 0.7;
    self.btnEqual.userInteractionEnabled = NO;
    self.isDevice=NO;
    self.collectionVw.userInteractionEnabled = YES ;
    
    self.collectionVw.alpha = 1;
    
    [self.collectionVw reloadData];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (_gameType == 3)
    {
        return 25;
    }
    else if (_gameType == 4)
    {
        return 49;
    }
    else if (_gameType == 5)
    {
        return 81;
    }

    return 1;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_arrayForSelected containsObject:[NSString stringWithFormat:@"%li",(long)indexPath.row]])
    {
        
    }
    else
    {
        if (indexPath.row % 2 == 0 )
        {
            
        }
        else
        {
            self.btnEqual.alpha = 1;
            self.btnEqual.userInteractionEnabled = YES;
            
            CustomCell *cell=(CustomCell*)[collectionView cellForItemAtIndexPath:indexPath];
            
            cell.lbl.text=[_arrayForSymbols objectAtIndex:arc4random() % [_arrayForSymbols count]];
            
            [_arrayForSelected addObject:[NSString stringWithFormat:@"%li",(long)indexPath.row]];
            
            self.collectionVw.userInteractionEnabled = NO ;
            
            self.collectionVw.alpha = 0.7;
            
            if (_isDevice)
            {
                _isDevice = NO;
                
                cell.BgvW.backgroundColor=[UIColor orangeColor];
                [self onClickEqual:self.btnEqual];
            }
            else
            {
                cell.BgvW.backgroundColor=[UIColor blackColor];
                cell.lbl.textColor=[UIColor whiteColor];
                _isDevice = YES;
            }
            
            [UIView transitionWithView:cell.BgvW
                              duration:0.5
                               options:UIViewAnimationOptionTransitionFlipFromRight
                            animations:^{
                                [cell.BgvW setFrame:cell.BgvW.bounds];
                                cell.BgvW.transform = CGAffineTransformMakeRotation(0.0);
                            }
                            completion:^(BOOL finished) {}];
            
            [_arrayForNeedToSelect removeObjectAtIndex:[_arrayForNeedToSelect indexOfObject:[NSString stringWithFormat:@"%li",(long)indexPath.row]]];
        }
    }
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CustomCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    if (indexPath.row == 0)
    {
        
    }
    cell.BgvW.backgroundColor=[UIColor whiteColor];
    
    if (indexPath.row % 2 == 0)
    {
        cell.lbl.text=[NSString stringWithFormat:@"%ld",(long)indexPath.row];
    }
    else
    {
        cell.lbl.text=@"";
    }
    
    // drop shadow
     cell.BgvW.layer.shadowColor = [UIColor purpleColor].CGColor;
     cell.BgvW.layer.shadowOffset = CGSizeMake(5, 5);
     cell.BgvW.layer.shadowOpacity = 1;
     cell.BgvW.layer.shadowRadius = 1.0;
     cell.BgvW.layer.masksToBounds = YES;
    
    if (_gameType == 3)
    {
        if (indexPath.row == 6 || indexPath.row == 8 || indexPath.row == 16 || indexPath.row == 18) {
            cell.lbl.text=@"";
            cell.BgvW.backgroundColor=[UIColor clearColor];
            cell.lbl.backgroundColor=[UIColor clearColor];
        }//// 3 X 3
    }
    else if (_gameType == 4)
    {
        if (indexPath.row == 8 || indexPath.row == 10 || indexPath.row == 12 || indexPath.row == 22 || indexPath.row == 24 || indexPath.row == 26 || indexPath.row == 36 || indexPath.row == 38 || indexPath.row == 40) {
            cell.lbl.text=@"";
            cell.BgvW.backgroundColor=[UIColor clearColor];
            cell.lbl.backgroundColor=[UIColor clearColor];
        }//// 4 X 4
    }
    else if (_gameType == 5)
    {
        if (indexPath.row == 10 || indexPath.row == 12 || indexPath.row == 14 || indexPath.row == 16 || indexPath.row == 28 || indexPath.row == 30 || indexPath.row == 32 || indexPath.row == 34 || indexPath.row == 46 || indexPath.row == 48 || indexPath.row == 50 || indexPath.row == 52 || indexPath.row == 64 || indexPath.row == 66 || indexPath.row == 68 || indexPath.row == 70)
        {
            cell.lbl.text=@"";
            cell.BgvW.backgroundColor=[UIColor clearColor];
            cell.lbl.backgroundColor=[UIColor clearColor];
        }////5 X 5
    }
    
    cell.backgroundColor=[UIColor clearColor];
    cell.lbl.textAlignment = NSTextAlignmentCenter;
    
    cell.BgvW.layer.cornerRadius=5;
    
    [UIView transitionWithView:cell.BgvW
                      duration:1.0
                       options:UIViewAnimationOptionTransitionFlipFromRight
                    animations:^{
                        [cell.BgvW setFrame:cell.BgvW.bounds];
                        cell.BgvW.transform = CGAffineTransformMakeRotation(0.0);
                    }
                    completion:^(BOOL finished) {}];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize retValue;
   
    if (_gameType == 3)
    {
         retValue.height = 50;
         retValue.width = self.view.frame.size.width / 6;
    }
    else if(_gameType == 4)
    {
         retValue.height = 45;
         retValue.width = self.view.frame.size.width / 9;
    }
    else if(_gameType == 5)
    {
        retValue.height = 30;
        retValue.width = self.view.frame.size.width / 12;
    }

    return retValue;
}

- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    //    return UIEdgeInsetsMake(50, 20, 50, 20);
    return UIEdgeInsetsMake(0, 0, 0, 5);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10.0;
}

- (void)pan:(UIPanGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateChanged || recognizer.state == UIGestureRecognizerStateEnded)
    {
        UIView *draggedButton = recognizer.view;
        CGPoint translation = [recognizer translationInView:self.view];
        
        CGRect newButtonFrame = draggedButton.frame;
        newButtonFrame.origin.x += translation.x;
        newButtonFrame.origin.y += translation.y;
        
        if(translation.y > 0)
        {
            newButtonFrame.origin.x += translation.x + 1;
            newButtonFrame.size.width  = newButtonFrame.size.width + 1;
        }
        else
        {
            newButtonFrame.origin.x += translation.x - 1;
            newButtonFrame.size.width  = newButtonFrame.size.width - 1;
        }
        
        if (draggedButton.frame.size.width  >= self.view.frame.size.width - 20)
        {
            if(translation.y > 0)
            {
                newButtonFrame.origin.x += translation.x - 1;
                newButtonFrame.size.width  = newButtonFrame.size.width - 1;
            }
            else
            {
                
            }
        }
        else
        {
            
        }
        draggedButton.frame = CGRectMake(self.view.frame.size.width/2 - newButtonFrame.size.width/2,newButtonFrame.origin.y,newButtonFrame.size.width,newButtonFrame.size.height);
        
        [recognizer setTranslation:CGPointZero inView:self.view];
    }
}

- (void)didReceiveMemoryWarning
{
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


- (IBAction)btnDrag:(id)sender
{
    
}

- (IBAction)btnDragExit:(id)sender
{
    
}

- (IBAction)onClickEqual:(UIButton *)sender
{
    NSInteger Value=[[_arrayForSelected objectAtIndex:[_arrayForSelected count] - 1] integerValue];
    
    float firstValue;
    NSIndexPath *indexFirstValue;
    
    float secondValue;
    NSIndexPath *indexSecondValue;
    
    NSIndexPath *index=[NSIndexPath indexPathForRow:Value inSection:0];
    
    CustomCell *cellForSymbol=(CustomCell*)[self.collectionVw cellForItemAtIndexPath:index];
    
    if (_gameType == 3)
    {
        if (Value == 1)
        {
            indexFirstValue=[NSIndexPath indexPathForRow:0 inSection:0];
            indexSecondValue=[NSIndexPath indexPathForRow:2 inSection:0];
        }
        else if (Value == 3)
        {
            indexFirstValue=[NSIndexPath indexPathForRow:2 inSection:0];
            indexSecondValue=[NSIndexPath indexPathForRow:4 inSection:0];
        }
        else if (Value ==5)
        {
            indexFirstValue=[NSIndexPath indexPathForRow:0 inSection:0];
            indexSecondValue=[NSIndexPath indexPathForRow:10 inSection:0];
        }
        else if (Value == 7)
        {
            indexFirstValue=[NSIndexPath indexPathForRow:2 inSection:0];
            indexSecondValue=[NSIndexPath indexPathForRow:12 inSection:0];
        }
        else if (Value == 9)
        {
            indexFirstValue=[NSIndexPath indexPathForRow:4 inSection:0];
            indexSecondValue=[NSIndexPath indexPathForRow:14 inSection:0];
        }
        else if (Value == 11)
        {
            indexFirstValue=[NSIndexPath indexPathForRow:10 inSection:0];
            indexSecondValue=[NSIndexPath indexPathForRow:12 inSection:0];
        }
        else if (Value == 13)
        {
            indexFirstValue=[NSIndexPath indexPathForRow:12 inSection:0];
            indexSecondValue=[NSIndexPath indexPathForRow:14 inSection:0];
        }
        else if (Value == 15)
        {
            indexFirstValue=[NSIndexPath indexPathForRow:10 inSection:0];
            indexSecondValue=[NSIndexPath indexPathForRow:20 inSection:0];
        }
        else if (Value == 17)
        {
            indexFirstValue=[NSIndexPath indexPathForRow:12 inSection:0];
            indexSecondValue=[NSIndexPath indexPathForRow:22 inSection:0];
        }
        else if (Value == 19)
        {
            indexFirstValue=[NSIndexPath indexPathForRow:14 inSection:0];
            indexSecondValue=[NSIndexPath indexPathForRow:24 inSection:0];
        }
        else if (Value == 21)
        {
            indexFirstValue=[NSIndexPath indexPathForRow:20 inSection:0];
            indexSecondValue=[NSIndexPath indexPathForRow:22 inSection:0];
        }
        else if (Value == 23)
        {
            indexFirstValue=[NSIndexPath indexPathForRow:22 inSection:0];
            indexSecondValue=[NSIndexPath indexPathForRow:24 inSection:0];
        }
    }
    else if (_gameType == 4)
    {
        if (Value == 1)
        {
            indexFirstValue=[NSIndexPath indexPathForRow:0 inSection:0];
            indexSecondValue=[NSIndexPath indexPathForRow:2 inSection:0];
        }
        else if (Value == 3)
        {
            indexFirstValue=[NSIndexPath indexPathForRow:2 inSection:0];
            indexSecondValue=[NSIndexPath indexPathForRow:4 inSection:0];
        }
        else if (Value ==5)
        {
            indexFirstValue=[NSIndexPath indexPathForRow:4 inSection:0];
            indexSecondValue=[NSIndexPath indexPathForRow:6 inSection:0];
        }
        else if (Value == 7)
        {
            indexFirstValue=[NSIndexPath indexPathForRow:0 inSection:0];
            indexSecondValue=[NSIndexPath indexPathForRow:14 inSection:0];
        }
        else if (Value == 9)
        {
            indexFirstValue=[NSIndexPath indexPathForRow:2 inSection:0];
            indexSecondValue=[NSIndexPath indexPathForRow:16 inSection:0];
        }
        else if (Value == 11)
        {
            indexFirstValue=[NSIndexPath indexPathForRow:4 inSection:0];
            indexSecondValue=[NSIndexPath indexPathForRow:18 inSection:0];
        }
        else if (Value == 13)
        {
            indexFirstValue=[NSIndexPath indexPathForRow:6 inSection:0];
            indexSecondValue=[NSIndexPath indexPathForRow:20 inSection:0];
        }
        else if (Value == 15)
        {
            indexFirstValue=[NSIndexPath indexPathForRow:14 inSection:0];
            indexSecondValue=[NSIndexPath indexPathForRow:16 inSection:0];
        }
        else if (Value == 17)
        {
            indexFirstValue=[NSIndexPath indexPathForRow:16 inSection:0];
            indexSecondValue=[NSIndexPath indexPathForRow:18 inSection:0];
        }
        else if (Value == 19)
        {
            indexFirstValue=[NSIndexPath indexPathForRow:18 inSection:0];
            indexSecondValue=[NSIndexPath indexPathForRow:20 inSection:0];
        }
        else if (Value == 21)
        {
            indexFirstValue=[NSIndexPath indexPathForRow:14 inSection:0];
            indexSecondValue=[NSIndexPath indexPathForRow:28 inSection:0];
        }
        else if (Value == 23)
        {
            indexFirstValue=[NSIndexPath indexPathForRow:16 inSection:0];
            indexSecondValue=[NSIndexPath indexPathForRow:30 inSection:0];
        }
        else if (Value == 25)
        {
            indexFirstValue=[NSIndexPath indexPathForRow:18 inSection:0];
            indexSecondValue=[NSIndexPath indexPathForRow:32 inSection:0];
        }
        else if (Value == 27)
        {
            indexFirstValue=[NSIndexPath indexPathForRow:20 inSection:0];
            indexSecondValue=[NSIndexPath indexPathForRow:34 inSection:0];
        }
        else if (Value == 29)
        {
            indexFirstValue=[NSIndexPath indexPathForRow:28 inSection:0];
            indexSecondValue=[NSIndexPath indexPathForRow:30 inSection:0];
        }
        else if (Value == 31)
        {
            indexFirstValue=[NSIndexPath indexPathForRow:30 inSection:0];
            indexSecondValue=[NSIndexPath indexPathForRow:32 inSection:0];
        }
        else if (Value == 33)
        {
            indexFirstValue=[NSIndexPath indexPathForRow:32 inSection:0];
            indexSecondValue=[NSIndexPath indexPathForRow:34 inSection:0];
        }
        else if (Value == 35)
        {
            indexFirstValue=[NSIndexPath indexPathForRow:28 inSection:0];
            indexSecondValue=[NSIndexPath indexPathForRow:42 inSection:0];
        }
        else if (Value == 37)
        {
            indexFirstValue=[NSIndexPath indexPathForRow:30 inSection:0];
            indexSecondValue=[NSIndexPath indexPathForRow:44 inSection:0];
        }
        else if (Value == 39)
        {
            indexFirstValue=[NSIndexPath indexPathForRow:32 inSection:0];
            indexSecondValue=[NSIndexPath indexPathForRow:46 inSection:0];
        }
        else if (Value == 41)
        {
            indexFirstValue=[NSIndexPath indexPathForRow:34 inSection:0];
            indexSecondValue=[NSIndexPath indexPathForRow:48 inSection:0];
        }
        else if (Value == 43)
        {
            indexFirstValue=[NSIndexPath indexPathForRow:42 inSection:0];
            indexSecondValue=[NSIndexPath indexPathForRow:44 inSection:0];
        }
        else if (Value == 45)
        {
            indexFirstValue=[NSIndexPath indexPathForRow:44 inSection:0];
            indexSecondValue=[NSIndexPath indexPathForRow:46 inSection:0];
        }
        else if (Value == 47)
        {
            indexFirstValue=[NSIndexPath indexPathForRow:46 inSection:0];
            indexSecondValue=[NSIndexPath indexPathForRow:48 inSection:0];
        }
    }
    else if (_gameType == 5)
    {
        if (Value == 1)
        {
            indexFirstValue=[NSIndexPath indexPathForRow:0 inSection:0];
            indexSecondValue=[NSIndexPath indexPathForRow:2 inSection:0];
        }
        else if (Value == 3)
        {
            indexFirstValue=[NSIndexPath indexPathForRow:2 inSection:0];
            indexSecondValue=[NSIndexPath indexPathForRow:4 inSection:0];
        }
        else if (Value ==5)
        {
            indexFirstValue=[NSIndexPath indexPathForRow:4 inSection:0];
            indexSecondValue=[NSIndexPath indexPathForRow:6 inSection:0];
        }
        else if (Value == 7)
        {
            indexFirstValue=[NSIndexPath indexPathForRow:6 inSection:0];
            indexSecondValue=[NSIndexPath indexPathForRow:8 inSection:0];
        }
        else if (Value == 9)
        {
            indexFirstValue=[NSIndexPath indexPathForRow:0 inSection:0];
            indexSecondValue=[NSIndexPath indexPathForRow:18 inSection:0];
        }
        else if (Value == 11)
        {
            indexFirstValue=[NSIndexPath indexPathForRow:2 inSection:0];
            indexSecondValue=[NSIndexPath indexPathForRow:20 inSection:0];
        }
        else if (Value == 13)
        {
            indexFirstValue=[NSIndexPath indexPathForRow:4 inSection:0];
            indexSecondValue=[NSIndexPath indexPathForRow:22 inSection:0];
        }
        else if (Value == 15)
        {
            indexFirstValue=[NSIndexPath indexPathForRow:6 inSection:0];
            indexSecondValue=[NSIndexPath indexPathForRow:24 inSection:0];
        }
        else if (Value == 17)
        {
            indexFirstValue=[NSIndexPath indexPathForRow:8 inSection:0];
            indexSecondValue=[NSIndexPath indexPathForRow:26 inSection:0];
        }
        else if (Value == 19)
        {
            indexFirstValue=[NSIndexPath indexPathForRow:18 inSection:0];
            indexSecondValue=[NSIndexPath indexPathForRow:20 inSection:0];
        }
        else if (Value == 21)
        {
            indexFirstValue=[NSIndexPath indexPathForRow:20 inSection:0];
            indexSecondValue=[NSIndexPath indexPathForRow:22 inSection:0];
        }
        else if (Value == 23)
        {
            indexFirstValue=[NSIndexPath indexPathForRow:22 inSection:0];
            indexSecondValue=[NSIndexPath indexPathForRow:24 inSection:0];
        }
        else if (Value == 25)
        {
            indexFirstValue=[NSIndexPath indexPathForRow:24 inSection:0];
            indexSecondValue=[NSIndexPath indexPathForRow:26 inSection:0];
        }
        else if (Value == 27)
        {
            indexFirstValue=[NSIndexPath indexPathForRow:18 inSection:0];
            indexSecondValue=[NSIndexPath indexPathForRow:36 inSection:0];
        }
        else if (Value == 29)
        {
            indexFirstValue=[NSIndexPath indexPathForRow:20 inSection:0];
            indexSecondValue=[NSIndexPath indexPathForRow:38 inSection:0];
        }
        else if (Value == 31)
        {
            indexFirstValue=[NSIndexPath indexPathForRow:22 inSection:0];
            indexSecondValue=[NSIndexPath indexPathForRow:40 inSection:0];
        }
        else if (Value == 33)
        {
            indexFirstValue=[NSIndexPath indexPathForRow:24 inSection:0];
            indexSecondValue=[NSIndexPath indexPathForRow:42 inSection:0];
        }
        else if (Value == 35)
        {
            indexFirstValue=[NSIndexPath indexPathForRow:26 inSection:0];
            indexSecondValue=[NSIndexPath indexPathForRow:44 inSection:0];
        }
        else if (Value == 37)
        {
            indexFirstValue=[NSIndexPath indexPathForRow:36 inSection:0];
            indexSecondValue=[NSIndexPath indexPathForRow:38 inSection:0];
        }
        else if (Value == 39)
        {
            indexFirstValue=[NSIndexPath indexPathForRow:38 inSection:0];
            indexSecondValue=[NSIndexPath indexPathForRow:40 inSection:0];
        }
        else if (Value == 41)
        {
            indexFirstValue=[NSIndexPath indexPathForRow:40 inSection:0];
            indexSecondValue=[NSIndexPath indexPathForRow:42 inSection:0];
        }
        else if (Value == 43)
        {
            indexFirstValue=[NSIndexPath indexPathForRow:42 inSection:0];
            indexSecondValue=[NSIndexPath indexPathForRow:44 inSection:0];
        }
        else if (Value == 45)
        {
            indexFirstValue=[NSIndexPath indexPathForRow:36 inSection:0];
            indexSecondValue=[NSIndexPath indexPathForRow:54 inSection:0];
        }
        else if (Value == 47)
        {
            indexFirstValue=[NSIndexPath indexPathForRow:38 inSection:0];
            indexSecondValue=[NSIndexPath indexPathForRow:56 inSection:0];
        }
        else if (Value == 49)
        {
            indexFirstValue=[NSIndexPath indexPathForRow:40 inSection:0];
            indexSecondValue=[NSIndexPath indexPathForRow:58 inSection:0];
        }
        else if (Value == 51)
        {
            indexFirstValue=[NSIndexPath indexPathForRow:42 inSection:0];
            indexSecondValue=[NSIndexPath indexPathForRow:60 inSection:0];
        }
        else if (Value == 53)
        {
            indexFirstValue=[NSIndexPath indexPathForRow:44 inSection:0];
            indexSecondValue=[NSIndexPath indexPathForRow:62 inSection:0];
        }
        else if (Value == 55)
        {
            indexFirstValue=[NSIndexPath indexPathForRow:54 inSection:0];
            indexSecondValue=[NSIndexPath indexPathForRow:56 inSection:0];
        }
        else if (Value == 57)
        {
            indexFirstValue=[NSIndexPath indexPathForRow:56 inSection:0];
            indexSecondValue=[NSIndexPath indexPathForRow:58 inSection:0];
        }
        else if (Value == 59)
        {
            indexFirstValue=[NSIndexPath indexPathForRow:58 inSection:0];
            indexSecondValue=[NSIndexPath indexPathForRow:60 inSection:0];
        }
        else if (Value == 61)
        {
            indexFirstValue=[NSIndexPath indexPathForRow:60 inSection:0];
            indexSecondValue=[NSIndexPath indexPathForRow:62 inSection:0];
        }
        else if (Value == 63)
        {
            indexFirstValue=[NSIndexPath indexPathForRow:54 inSection:0];
            indexSecondValue=[NSIndexPath indexPathForRow:72 inSection:0];
        }
        else if (Value == 65)
        {
            indexFirstValue=[NSIndexPath indexPathForRow:56 inSection:0];
            indexSecondValue=[NSIndexPath indexPathForRow:74 inSection:0];
        }
        else if (Value == 67)
        {
            indexFirstValue=[NSIndexPath indexPathForRow:58 inSection:0];
            indexSecondValue=[NSIndexPath indexPathForRow:76 inSection:0];
        }
        else if (Value == 69)
        {
            indexFirstValue=[NSIndexPath indexPathForRow:60 inSection:0];
            indexSecondValue=[NSIndexPath indexPathForRow:78 inSection:0];
        }
        else if (Value == 71)
        {
            indexFirstValue=[NSIndexPath indexPathForRow:62 inSection:0];
            indexSecondValue=[NSIndexPath indexPathForRow:80 inSection:0];
        }
        else if (Value == 73)
        {
            indexFirstValue=[NSIndexPath indexPathForRow:72 inSection:0];
            indexSecondValue=[NSIndexPath indexPathForRow:74 inSection:0];
        }

        else if (Value == 75)
        {
            indexFirstValue=[NSIndexPath indexPathForRow:74 inSection:0];
            indexSecondValue=[NSIndexPath indexPathForRow:76 inSection:0];
        }
        else if (Value == 77)
        {
            indexFirstValue=[NSIndexPath indexPathForRow:76 inSection:0];
            indexSecondValue=[NSIndexPath indexPathForRow:78 inSection:0];
        }
        else if (Value == 79)
        {
            indexFirstValue=[NSIndexPath indexPathForRow:78 inSection:0];
            indexSecondValue=[NSIndexPath indexPathForRow:80 inSection:0];
        }
    }
    
    CustomCell *cell=(CustomCell*)[self.collectionVw cellForItemAtIndexPath:indexFirstValue];
    
    firstValue = [cell.lbl.text floatValue];
    
    cell=(CustomCell*)[self.collectionVw cellForItemAtIndexPath:indexSecondValue];
    
    secondValue = [cell.lbl.text floatValue];
    
    NSString *str=cellForSymbol.lbl.text;
    
    if (_isDevice)
    {
        if ([str isEqualToString:@"-"])
        {
            self.resultLabel.text = [NSString stringWithFormat:@"%0.2f",firstValue - secondValue + [self.resultLabel.text floatValue]];
        }
        else if ([str isEqualToString:@"+"])
        {
            self.resultLabel.text = [NSString stringWithFormat:@"%0.2f",firstValue + secondValue + [self.resultLabel.text floatValue]];
        }
        else if ([str isEqualToString:@"*"])
        {
            self.resultLabel.text = [NSString stringWithFormat:@"%0.2f",firstValue * secondValue + [self.resultLabel.text floatValue]];
        }
        else if ([str isEqualToString:@"/"])
        {
            self.resultLabel.text = [NSString stringWithFormat:@"%0.2f",firstValue / secondValue + [self.resultLabel.text floatValue]];
        }
    }
    else
    {
        if ([str isEqualToString:@"-"])
        {
            self.resultOfSystem.text = [NSString stringWithFormat:@"%0.2f",firstValue - secondValue + [self.resultOfSystem.text floatValue]];
        }
        else if ([str isEqualToString:@"+"])
        {
            self.resultOfSystem.text = [NSString stringWithFormat:@"%0.2f",firstValue + secondValue + [self.resultOfSystem.text floatValue]];
        }
        else if ([str isEqualToString:@"*"])
        {
            self.resultOfSystem.text = [NSString stringWithFormat:@"%0.2f",firstValue * secondValue + [self.resultOfSystem.text floatValue]];
        }
        else if ([str isEqualToString:@"/"])
        {
            self.resultOfSystem.text = [NSString stringWithFormat:@"%0.2f",firstValue / secondValue + [self.resultOfSystem.text floatValue]];
        }
    }
    
    if (_gameType == 3)
    {
        if ([_arrayForSelected count] == 12)
        {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Success" message:@"Game Completed" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        else
        {
            if (_isDevice)
            {
                [self performSelector:@selector(deivceClick) withObject:self afterDelay:0.5];
            }
            else
            {
                
            }
        }
    }
    else if (_gameType == 4)
    {
        if ([_arrayForSelected count] == 24)
        {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Success" message:@"Game Completed" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        else
        {
            if (_isDevice)
            {
                [self performSelector:@selector(deivceClick) withObject:self afterDelay:0.5];
            }
            else
            {
                
            }
        }
    }
    else if (_gameType == 5)
    {
        if ([_arrayForSelected count] == 40)
        {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Success" message:@"Game Completed" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        else
        {
            if (_isDevice)
            {
                [self performSelector:@selector(deivceClick) withObject:self afterDelay:0.5];
            }
            else
            {
                
            }
        }
    }
    
    self.collectionVw.userInteractionEnabled = YES;
    self.collectionVw.alpha = 1;
    
    self.btnEqual.alpha = 0.7;
    self.btnEqual.userInteractionEnabled = NO;
}

-(void)deivceClick
{
    NSInteger index = arc4random() % [_arrayForNeedToSelect count];
    
    index=[[_arrayForNeedToSelect objectAtIndex:index] integerValue];
    [self.collectionVw selectItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionCenteredVertically];
    
    [self collectionView:self.collectionVw didSelectItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
}

#pragma mark - Exit
- (IBAction)ronClickRefresh:(UIBarButtonItem *)sender
{
    self.resultLabel.text=[NSString stringWithFormat:@"0.0"];
    self.resultOfSystem.text=[NSString stringWithFormat:@"0.0"];
    [self refresh];
}

@end