//
//  Sudoku.h
//  Sudoku
//
//  Created by John on 14/01/2014.
//  Copyright (c) 2014 John Tomkins. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Cell.h"

@interface Sudoku : NSObject

+ (NSArray *)generateSudokuWithHoles:(NSInteger)holes withUniqueSolution:(BOOL)unique;

+ (NSMutableArray *) generateBoard;

+ (NSMutableArray *) solveBoard:(NSMutableArray *)incompleteBoard;

+ (BOOL) conflictsWithCells:(NSMutableArray *)cells WithProposedCell:(Cell *)proposedCell;

+ (Cell *) createCellWithIndex:(NSInteger)idx WithNumber:(NSInteger)number;

+ (NSInteger) determineRowFromIndex:(NSInteger)index;

+ (NSInteger) determineColumnFromIndex:(NSInteger)index;

+ (NSInteger) determineSectorFromIndex:(NSInteger)index;

+ (NSInteger) randomSudokuValueWithLower:(NSInteger)lower WithUpper:(NSInteger)upper;

+ (NSMutableArray *) digBoard:(NSMutableArray *)board numberOfHoles:(NSInteger)holes WithUniqueSolution:(BOOL)unique;

+ (BOOL) doesBoard:(NSMutableArray *)board MatchBoard:(NSMutableArray *)otherBoard;

@end
