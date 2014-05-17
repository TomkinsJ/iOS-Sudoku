//
//  Cell.m
//  Sudoku
//
//  Created by John on 14/01/2014.
//  Copyright (c) 2014 John Tomkins. All rights reserved.
//

#import "Cell.h"

@implementation Cell

@synthesize idx;
@synthesize number;
@synthesize row;
@synthesize column;
@synthesize sector;
@synthesize dug;

+ (Cell *) Cell
{	
	Cell *cell = [[Cell alloc] init];
	return cell;
}

- (Cell *) init
{
	self = [super init];
    dug = NO;
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    id copy = [[[self class] alloc] init];
    
    if (copy)
    {
        // copy instance variables
        [copy setIdx:self.idx];
        [copy setNumber:self.number];
        [copy setRow:self.row];
        [copy setColumn:self.column];
        [copy setSector:self.sector];
        [copy setDug:self.dug];
    }
    
    return copy;
}


@end
