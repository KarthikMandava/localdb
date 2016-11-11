//
//  MKDBManager.h
//  localDB
//
//  Created by Intellisense Technology on 21/07/16.
//  Copyright © 2016 intellisense Technology. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MKDBManager : NSObject
-(instancetype)initWithDataBaseFileName:(NSString*)fileName;

-(NSArray *)loadDataFromDB:(NSString *)query;

-(void)executeQuery:(NSString *)query;

@property (nonatomic, strong) NSMutableArray *arrColumnNames;

@property (nonatomic) int affectedRows;

@property (nonatomic) long long lastInsertedRowID;

@end
