//
//  Sudoku.m
//  Sudoku
//
//  Created by John on 14/01/2014.
//  Copyright (c) 2014 John Tomkins. All rights reserved.
//

#import "Sudoku.h"
#import "Cell.h"

@implementation Sudoku

+ (NSArray *)generateSudokuWithHoles:(NSInteger)holes withUniqueSolution:(BOOL)unique
{
    NSMutableArray *boards = [[NSMutableArray alloc]init];
    
    BOOL validSudoku = NO;
    
    while (!validSudoku) {
        NSMutableArray *generatedSudoku = [self generateBoard];
        NSMutableArray *copy = [[NSMutableArray alloc]initWithArray:generatedSudoku copyItems:YES];
        NSMutableArray *dugBoard = [self digBoard:copy numberOfHoles:holes WithUniqueSolution:unique];
        
        if (unique) {
            
            NSMutableArray *solvedBoard = [self solveBoard:dugBoard];
            
            if ([self doesBoard:generatedSudoku MatchBoard:solvedBoard]) { // if the solution matches the complete board
                
                // add the boards to the boards array and terminate the loop.
                [boards addObject:generatedSudoku];
                [boards addObject:dugBoard];
                validSudoku = YES;
            }
            
        } else {
            // unique solution is not needed, so the complete and dug boards can be returned
            [boards addObject:generatedSudoku];
            [boards addObject:dugBoard];
            break;
        }
        
    }
    
    return boards;
}

+ (NSMutableArray *) generateBoard
{
    NSLog(@"Started Generating");
    static NSInteger sudokuSize = 81;
    
    // 81 empty cell objects
    NSMutableArray *sudoku = [[NSMutableArray alloc]init];
    for (int i = 1; i <= sudokuSize; i++) {
        Cell *cell = [[Cell alloc]init];
        [sudoku addObject:cell];
    }
    
    // create a matching array for the available values for each cell in sudoku array
    NSMutableArray *availableValues = [[NSMutableArray alloc]init];
    for (int i = 1; i <= sudokuSize; i++) {
        NSMutableArray *array = [[NSMutableArray alloc]init];
        for (int i = 1; i <= 9; i++) {
            [array addObject:[NSNumber numberWithInteger:i]];
        }
        [availableValues addObject:array];
    }
    
    NSInteger counter = 0; // cell count
    
    while (counter != sudokuSize) { // while board is not complete, do:
        
        NSInteger availableCount = [[availableValues objectAtIndex:counter]count];
        
        if (availableCount != 0) { // if there are still some numbers available for this cell:
            
            // randomly select one of the available values
            NSInteger randomValue = [self randomSudokuValueWithLower:0
                                                           WithUpper:[[availableValues objectAtIndex:counter]count]];
            
            NSInteger availableNumber = [[[availableValues objectAtIndex:counter]objectAtIndex:randomValue]integerValue];
            
            Cell *proposedCell = [self createCellWithIndex:counter
                                                WithNumber:availableNumber];
            
            if (![self conflictsWithCells:sudoku
                         WithProposedCell:proposedCell]) { // if the proposed cell does not conflict:
                
                [sudoku replaceObjectAtIndex:counter
                                  withObject:proposedCell]; // add the proposed cell to the board
                
                [[availableValues objectAtIndex:counter]removeObjectAtIndex:randomValue]; // remove the value from the available values
                counter++; // go to next cell
                
            } else {  // number is not valid so remove it from the available numbers:
                
                [[availableValues objectAtIndex:counter]removeObjectAtIndex:randomValue];
            }
            
        } else { // otherwise refill the available numbers for this cell with 1-9, replace the previous cell with an empty cell and go back a cell
            
            for (int i = 1; i <= 9; i++) {
                [[availableValues objectAtIndex:counter]addObject:[NSNumber numberWithInteger:i]];
            }
            
            Cell *emptyCell = [[Cell alloc]init];
            [sudoku replaceObjectAtIndex:(counter - 1) withObject:emptyCell];
            counter--;
        }
    }
    

    NSLog(@"Finished Generating");
    return sudoku;  // 81 cell objects
}

+ (NSMutableArray *) solveBoard:(NSMutableArray *)incompleteBoard
{
    
    NSLog(@"Started solving");
    
    BOOL backtracking = NO;
    
    static NSInteger sudokuSize = 81;
    
    NSMutableArray *solvedSudoku = [incompleteBoard mutableCopy];
    
    NSMutableArray *availableValues = [[NSMutableArray alloc]init];
    for (int i = 1; i <= sudokuSize; i++) {
        NSMutableArray *array = [[NSMutableArray alloc]init];
        for (int i = 1; i <= 9; i++) {
            [array addObject:[NSNumber numberWithInteger:i]];
        }
        [availableValues addObject:array];
    }
    
    NSInteger counter = 0;
    
    while (counter != sudokuSize) {
        
        if ([[solvedSudoku objectAtIndex:counter]dug] == NO) {
            if (backtracking) {
                if (counter > 0) {
                    counter--;
                }
            } else {
                counter++;
                continue;
            }
            
        }
        
        NSInteger availableCount = [[availableValues objectAtIndex:counter]count];
        if (availableCount != 0) { // if there are still some numbers available for this cell:
            
            // randomly select one of the available values
            NSInteger randomValue = [self randomSudokuValueWithLower:0
                                                           WithUpper:[[availableValues objectAtIndex:counter]count]];
            
            NSInteger availableNumber = [[[availableValues objectAtIndex:counter]objectAtIndex:randomValue]integerValue];
            
            Cell *proposedCell = [self createCellWithIndex:counter
                                                WithNumber:availableNumber];
            
            if (![self conflictsWithCells:solvedSudoku
                         WithProposedCell:proposedCell]) { // if the proposed cell does not conflict:
                
                [solvedSudoku replaceObjectAtIndex:counter
                                        withObject:proposedCell]; // add the proposed cell to the board
                
                [[availableValues objectAtIndex:counter]removeObjectAtIndex:randomValue]; // remove the value from the available values
                counter++; // go to next cell
                backtracking = NO;
                
            } else {  // number is not valid so remove it from the available numbers:
                
                [[availableValues objectAtIndex:counter]removeObjectAtIndex:randomValue];
            }
            
        } else { // otherwise refill the available numbers for this cell with 1-9, replace the previous cell with an empty cell and go back a cell
            
            for (int i = 1; i <= 9; i++) {
                [[availableValues objectAtIndex:counter]addObject:[NSNumber numberWithInteger:i]];
            }
            
            Cell *emptyCell = [solvedSudoku objectAtIndex:counter];
            [emptyCell setNumber:0];
            [emptyCell setDug:YES];
            
            
            if (counter > 0) {
                
                if ([[solvedSudoku objectAtIndex:(counter - 1)]dug]){
                    
                    [solvedSudoku replaceObjectAtIndex:(counter - 1) withObject:emptyCell];         
                    
                };
                counter--;
                
            } else {
                
                if ([[solvedSudoku objectAtIndex:counter]dug]){
                    
                    [solvedSudoku replaceObjectAtIndex:(counter) withObject:emptyCell]; // don't want to go too far backwards if counter == 0
                    
                }
            }
            
            backtracking = YES;
        }
    }
    NSLog(@"Finished solving");
    return solvedSudoku;
}



+ (BOOL) conflictsWithCells:(NSMutableArray *)cells WithProposedCell:(Cell *)proposedCell
{
    // check that the proposed cell does not conflict with and cells currently on the board
    
    BOOL conflicts = NO;
    
    for (Cell *cell in cells) {
        if (((cell.row != 0) && (cell.row == proposedCell.row)) ||
            ((cell.column != 0) && (cell.column == proposedCell.column)) ||
            ((cell.sector != 0) && (cell.sector == proposedCell.sector)))
        {
            if (cell.number == proposedCell.number) {
                conflicts = YES;
                break; // conflicts, so break & return YES
            }
        }
        continue; // continue to the next cell
        
    }
    return conflicts;
}

+ (Cell *) createCellWithIndex:(NSInteger)idx WithNumber:(NSInteger)number
{
    // create a cell with given index and value, then calculate it's row, column and sector
    
    Cell *proposedCell = [[Cell alloc]init];
    
    proposedCell.idx = idx;
    proposedCell.number = number;
    proposedCell.row = [self determineRowFromIndex:idx + 1];
    proposedCell.column = [self determineColumnFromIndex:idx + 1];
    proposedCell.sector = [self determineSectorFromIndex:idx + 1];
    proposedCell.dug = YES;
    return proposedCell;
}

+ (NSInteger) determineSectorFromIndex:(NSInteger)index
{
    // Maths to work out the sector of a cell given its index
    
    NSInteger row = [self determineRowFromIndex:index];
    NSInteger column = [self determineColumnFromIndex:index];
    
    if ((row >= 1) && (row < 4) && (column >= 1) && (column < 4)) {
        return 1;
    }
    if ((row >= 4) && (row < 7) && (column >= 1) && (column < 4)) {
        return 2;
    }
    if ((row >= 7) && (row < 10) && (column >= 1) && (column < 4)) {
        return 3;
    }
    if ((row >= 1) && (row < 4) && (column >= 4) && (column < 7)) {
        return 4;
    }
    if ((row >= 4) && (row < 7) && (column >= 4) && (column < 7)) {
        return 5;
    }
    if ((row >= 7) && (row < 10) && (column >= 4) && (column < 7)) {
        return 6;
    }
    if ((row >= 1) && (row < 4) && (column >= 7) && (column < 10)) {
        return 7;
    }
    if ((row >= 4) && (row < 7) && (column >= 7) && (column < 10)) {
        return 8;
    }
    if ((row >= 7) && (row < 10) && (column >= 7) && (column < 10)) {
        return 9;
    }
    
    return 0;
}

+ (NSInteger) determineRowFromIndex:(NSInteger)index
{
    // Maths to work out the row of a cell given its index
    
    if (index % 9 == 0) {
        return 9;
    }
    return index % 9;
}

+ (NSInteger) determineColumnFromIndex:(NSInteger)index
{
    // Maths to work out the column of a cell given its index
    
    if ([self determineRowFromIndex:index] == 9) {
        return index / 9;
    }
    return index / 9 + 1;
}


+ (NSInteger) randomSudokuValueWithLower:(NSInteger)lower WithUpper:(NSInteger)upper
{
    // random number between lower and upper
    if (lower >= 0 && upper <= 9) {
        return arc4random_uniform((uint32_t)upper) + lower;
    }
    return 0;
}

+ (NSMutableArray *) digBoard:(NSMutableArray *)board numberOfHoles:(NSInteger)holes WithUniqueSolution:(BOOL)unique
{
    for (Cell *cell in board) {
        [cell setDug:NO];
    }
    
    NSLog(@"Started Digging");
    
    if (unique) { // check that the sudoku only has one solution each time a hole is dug
        
        NSInteger random;
        NSMutableArray *cannotDigCells = [[NSMutableArray alloc]init];
        
        for (int i = 1; i <= holes; i++) {
            
            BOOL canDig = YES;
            
            random = arc4random_uniform((uint32_t)[board count]); // randomly select a cell
            if (![cannotDigCells containsObject:[NSNumber numberWithInteger:random]]) { // make sure this cell has not been tried before
                
            
                if (![[board objectAtIndex:random]dug]) { // if this cell has not yet been dug
                    
                    for (int j = 1; j <= 9; j++) { // begin replacing the number in this cell with 1 to 9
                    
                        if (j == [[board objectAtIndex:random]number]) {
                            continue;
                        }
                    
                        Cell *tempCell = [self createCellWithIndex:random WithNumber:j];
                    
                        if (![self conflictsWithCells:board WithProposedCell:tempCell]) { // if the cell does not conflict with the board
                            // it must yield multiple solutions, so don't dig it and mark it so it is not tried again
                            [cannotDigCells addObject:[NSNumber numberWithInteger:random]];
                            canDig = NO;
                            break;
                        }
                    }
                } else if (i > 0) {
                    i--;
                }
            
                if (canDig && ![[board objectAtIndex:random]dug]) { // if cell can be dug...
                    // dig it and record it so it is not tried again
                    [cannotDigCells addObject:[NSNumber numberWithInteger:random]];
                    [[board objectAtIndex:random]setNumber:0];
                    [[board objectAtIndex:random]setDug:YES];
                }
            }
        }
    } else { // don't check the sudoku has only one solution, just randomly dig
        
        for (int i = 0; i <= holes; i++) {
            
            NSMutableArray *cannotDigCells = [[NSMutableArray alloc]init];
            NSInteger random = arc4random_uniform((uint32_t)[board count]);
            
            if (![cannotDigCells containsObject:[NSNumber numberWithInteger:random]]) { // make sure this cell has not been tried before

                if (![[board objectAtIndex:random]dug]) {
                
                    [cannotDigCells addObject:[NSNumber numberWithInteger:random]]; // ensure cell is not dug again by adding it to this array
                    [[board objectAtIndex:random]setNumber:0]; // dig cell
                    [[board objectAtIndex:random]setDug:YES];
                
                } else {
                    i--;
                }
            }
        }
    }
    
    NSLog(@"Finished Digging");
    return board;
}

+ (BOOL) doesBoard:(NSMutableArray *)board MatchBoard:(NSMutableArray *)otherBoard
{
    for (int i = 0; i <= 80; i++) {
        if ([[board objectAtIndex:i]number] != [[otherBoard objectAtIndex:i]number]) {
            return NO;
        }
    }
    return YES;
}

@end