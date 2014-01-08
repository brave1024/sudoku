//
//  SudokuViewController.m
//  Sudoku
//
//  Created by Xia Zhiyong on 12-2-15.
//  Copyright 2012年 amoeba workshop. All rights reserved.
//

#import "SudokuViewController.h"
#import "LevelSelectViewController.h"
#import "playGameViewController.h"
#import "quickGameViewController.h"
#import "settingViewController.h"
#import "aboutUsViewController.h"



@implementation SudokuViewController

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
		
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}



- (IBAction)startGame {

    LevelSelectViewController *levelSelect = [[LevelSelectViewController alloc]initWithNibName:@"LevelSelectViewController" bundle:nil];
    
    [self presentModalViewController:levelSelect animated:YES];
    
    [levelSelect release];
    
}


- (IBAction)quickGame {

    quickGameViewController *quickGame = [[quickGameViewController alloc]initWithNibName:@"quickGameViewController" bundle:nil];
    
    [self presentModalViewController:quickGame animated:YES];
    
    [quickGame release];
    
}


- (IBAction)setting {

    settingViewController *setting = [[settingViewController alloc]initWithNibName:@"settingViewController" bundle:nil];
    
    [self presentModalViewController:setting animated:YES];

    [setting release];
    
}


- (IBAction)aboutUs {

    aboutUsViewController *aboutUs = [[aboutUsViewController alloc]initWithNibName:@"aboutUsViewController" bundle:nil];
    
    [self presentModalViewController:aboutUs animated:YES];
    
    [aboutUs release];
    
}


- (IBAction)moreGame {

    
    
    
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
    
    if (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        return YES;
    }else {
        return  NO;
    }
    
}

@end
