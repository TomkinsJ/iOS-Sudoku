//
//  Cell.h
//  Sudoku
//
//  Created by John on 14/01/2014.
//  Copyright (c) 2014 John Tomkins. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Cell : NSObject <NSCopying>

@property (nonatomic, assign) NSInteger idx;
@property (nonatomic, assign) NSInteger number;
@property (nonatomic, assign) NSInteger row;
@property (nonatomic, assign) NSInteger column;
@property (nonatomic, assign) NSInteger sector;
@property (nonatomic, assign) BOOL dug;

- (id)copyWithZone:(NSZone *)zone;

@end
