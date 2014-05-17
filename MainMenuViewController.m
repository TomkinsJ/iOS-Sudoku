//
//  ViewController.m
//  Sudoku
//
//  Created by John on 24/02/2014.
//  Copyright (c) 2014 John Tomkins. All rights reserved.
//

#import "MainMenuViewController.h"

@interface MainMenuViewController ()

@end

@implementation MainMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainMenuBackground.jpg"]];
    [self.view addSubview: background];
    background.frame = self.view.bounds;
    [self.view sendSubviewToBack: background];
    self.view.backgroundColor = [UIColor clearColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
