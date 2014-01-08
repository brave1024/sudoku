//
//  settingViewController.m
//  Sudoku
//
//  Created by Xia Zhiyong on 12-2-15.
//  Copyright 2012年 amoeba workshop. All rights reserved.
//

#import "settingViewController.h"
#import "UserInfo.h"


@implementation settingViewController

@synthesize musicOpenBt, musicCloseBt;
@synthesize soundOpenBt, soundCloseBt;
@synthesize helpOpenBt, helpCloseBt;

@synthesize appDelegate;

@synthesize levelImgview;
@synthesize numberImgview;
//@synthesize timeLb;

@synthesize timeImgview;



NSString *openSelectedStr = @"open_1.png";
NSString *openStr = @"open.png";

NSString *closeSelectedStr = @"close_1.png";
NSString *closeStr = @"close.png";






- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	
	userInfo = [NSUserDefaults standardUserDefaults];
	
	
	appDelegate = [[UIApplication sharedApplication]delegate];
	musicIsOpen = appDelegate.musicIsOpen;
	soundIsOpen = appDelegate.soundIsOpen;
	showHelp = appDelegate.showHelp;
	gameLevel = appDelegate.quickLevel;	// 难度
	numOfLevel = appDelegate.quickNum;	// 关卡
	gameTime = appDelegate.timeCount;	// 计时
	
	
	// 音乐
	if (musicIsOpen) {
		
		[musicOpenBt setImage:[UIImage imageNamed:openSelectedStr] forState:UIControlStateNormal];
		[musicCloseBt setImage:[UIImage imageNamed:closeStr] forState:UIControlStateNormal];
		
	}else {
		
		[musicOpenBt setImage:[UIImage imageNamed:openStr] forState:UIControlStateNormal];
		[musicCloseBt setImage:[UIImage imageNamed:closeSelectedStr] forState:UIControlStateNormal];
		
	}

	// 音效
	if (soundIsOpen) {
		
		[soundOpenBt setImage:[UIImage imageNamed:openSelectedStr] forState:UIControlStateNormal];
		[soundCloseBt setImage:[UIImage imageNamed:closeStr] forState:UIControlStateNormal];
		
	}else {
		
		[soundOpenBt setImage:[UIImage imageNamed:openStr] forState:UIControlStateNormal];
		[soundCloseBt setImage:[UIImage imageNamed:closeSelectedStr] forState:UIControlStateNormal];
		
	}
	
	// 帮助
	if (showHelp) {
		
		[helpOpenBt setImage:[UIImage imageNamed:openSelectedStr] forState:UIControlStateNormal];
		[helpCloseBt setImage:[UIImage imageNamed:closeStr] forState:UIControlStateNormal];
		
	}else {
		
		[helpOpenBt setImage:[UIImage imageNamed:openStr] forState:UIControlStateNormal];
		[helpCloseBt setImage:[UIImage imageNamed:closeSelectedStr] forState:UIControlStateNormal];
		
	}
	
	
	[self settingLevel];
	[self settingNumber];
	[self settingTime];

	
}



- (IBAction)backHome {
    
    [self dismissModalViewControllerAnimated:YES];
    
}



- (IBAction)musicOpenAction {

	//NSLog(@"musicOpenAction");
	
	if (musicIsOpen == NO) {
		
		musicIsOpen = YES;
		appDelegate.musicIsOpen = YES;
		[userInfo setBool:YES forKey:@"music"];
		
		[musicOpenBt setImage:[UIImage imageNamed:openSelectedStr] forState:UIControlStateNormal];
		[musicCloseBt setImage:[UIImage imageNamed:closeStr] forState:UIControlStateNormal];
		
	}
	
}

- (IBAction)musicCloseAction {

	//NSLog(@"musicCloseAction");
	
	if (musicIsOpen == YES) {
		
		musicIsOpen = NO;
		appDelegate.musicIsOpen = NO;
		[userInfo setBool:NO forKey:@"music"];
		
		[musicOpenBt setImage:[UIImage imageNamed:openStr] forState:UIControlStateNormal];
		[musicCloseBt setImage:[UIImage imageNamed:closeSelectedStr] forState:UIControlStateNormal];
		
	}
	
}



- (IBAction)soundOpenAction {

	//NSLog(@"soundOpenAction");
	
	if (soundIsOpen == NO) {
	
		soundIsOpen = YES;
		appDelegate.soundIsOpen = YES;
		[userInfo setBool:YES forKey:@"sound"];
		
		[soundOpenBt setImage:[UIImage imageNamed:openSelectedStr] forState:UIControlStateNormal];
		[soundCloseBt setImage:[UIImage imageNamed:closeStr] forState:UIControlStateNormal];
		
	}
	
}

- (IBAction)soundCloseAction {

	//NSLog(@"soundCloseAction");
	
	if (soundIsOpen == YES) {
		
		soundIsOpen = NO;
		appDelegate.soundIsOpen = NO;
		[userInfo setBool:NO forKey:@"sound"];
		
		[soundOpenBt setImage:[UIImage imageNamed:openStr] forState:UIControlStateNormal];
		[soundCloseBt setImage:[UIImage imageNamed:closeSelectedStr] forState:UIControlStateNormal];
		
	}
	
}



- (IBAction)helpOpenAction {

	//NSLog(@"helpOpenAction");
	
	if (showHelp == NO) {
		
		showHelp = YES;
		appDelegate.showHelp = YES;
		[userInfo setBool:YES forKey:@"showHelp"];
		
		[helpOpenBt setImage:[UIImage imageNamed:openSelectedStr] forState:UIControlStateNormal];
		[helpCloseBt setImage:[UIImage imageNamed:closeStr] forState:UIControlStateNormal];
		
	}
	
}

- (IBAction)helpCloseAction {

	//NSLog(@"helpCloseAction");
	
	if (showHelp == YES) {
		
		showHelp = NO;
		appDelegate.showHelp = NO;
		[userInfo setBool:NO forKey:@"showHelp"];
		
		[helpOpenBt setImage:[UIImage imageNamed:openStr] forState:UIControlStateNormal];
		[helpCloseBt setImage:[UIImage imageNamed:closeSelectedStr] forState:UIControlStateNormal];
		
	}
	
}



- (IBAction)levelSubtractAction {

	//NSLog(@"levelSubtractAction");
	
	if (gameLevel == 1) {
		
		gameLevel = 5;
		
	}else {
		
		gameLevel--;
		
	}

	[self settingLevel];
		
}

- (IBAction)levelAddAction {

	//NSLog(@"levelAddAction");
	
	if (gameLevel == 5) {
		
		gameLevel = 1;
		
	}else {
		
		gameLevel++;
		
	}
		
	[self settingLevel];
		
}



- (IBAction)numberSubtractAction {

	//NSLog(@"numberSubtractAction");
	
	if (numOfLevel == 1) {
		
		numOfLevel = 9;
		
	}else {
		
		numOfLevel--;
		
	}

	[self settingNumber];
	
}

- (IBAction)numberAddAction {

	//NSLog(@"numberAddAction");
	
	if (numOfLevel == 9) {
		
		numOfLevel = 1;
		
	}else {
		
		numOfLevel++;
		
	}
	
	[self settingNumber];
		
}



- (IBAction)timeSubtractAction {

	//NSLog(@"timeSubtractAction");
	
	if (gameTime == 10) {
		
		gameTime = 90;
		
	}else {
		
		gameTime -= 10;
		
	}

	[self settingTime];
	
	
}

- (IBAction)timeAddAction {

	//NSLog(@"timeAddAction");
	
	if (gameTime == 90) {
		
		gameTime = 10;
		
	}else {
		
		gameTime +=10;
		
	}
	
	[self settingTime];
		
}




- (void)settingLevel {

	// 难度
	switch (gameLevel) {
		case 1:
			
			[levelImgview setImage:[UIImage imageNamed:@"veryEasy.png"]];
			
			break;
		case 2:
			
			[levelImgview setImage:[UIImage imageNamed:@"easy.png"]];
			
			break;
		case 3:
			
			[levelImgview setImage:[UIImage imageNamed:@"normal.png"]];
			
			break;
		case 4:
			
			[levelImgview setImage:[UIImage imageNamed:@"hard.png"]];
			
			break;
		case 5:
			
			[levelImgview setImage:[UIImage imageNamed:@"veryHard.png"]];
			
			break;
		default:
			break;
	}
	
	
	[userInfo setInteger:gameLevel forKey:@"quickLevel"];
	
	appDelegate.quickLevel = gameLevel;

}



- (void)settingNumber {

	// 关卡数
	switch (numOfLevel) {
		case 1:
			
			[numberImgview setImage:[UIImage imageNamed:@"1.png"]];
			
			break;
		case 2:
			
			[numberImgview setImage:[UIImage imageNamed:@"2.png"]];
			
			break;
		case 3:
			
			[numberImgview setImage:[UIImage imageNamed:@"3.png"]];
			
			break;
		case 4:
			
			[numberImgview setImage:[UIImage imageNamed:@"4.png"]];
			
			break;
		case 5:
			
			[numberImgview setImage:[UIImage imageNamed:@"5.png"]];
			
			break;
		case 6:
			
			[numberImgview setImage:[UIImage imageNamed:@"6.png"]];
			
			break;
		case 7:
			
			[numberImgview setImage:[UIImage imageNamed:@"7.png"]];
			
			break;
		case 8:
			
			[numberImgview setImage:[UIImage imageNamed:@"8.png"]];
			
			break;
		case 9:
			
			[numberImgview setImage:[UIImage imageNamed:@"9.png"]];
			
			break;
		default:
			break;
	}
	
	
	[userInfo setInteger:numOfLevel forKey:@"quickNum"];
	
	appDelegate.quickNum = numOfLevel;
	
	
	NSLog(@"当前关卡选择数为:%d", numOfLevel);
	
}



- (void)settingTime {
	
	// 计时
	switch (gameTime) {
		case 10:
			
			[timeImgview setImage:[UIImage imageNamed:@"1.png"]];
			
			break;
		case 20:
			
			[timeImgview setImage:[UIImage imageNamed:@"2.png"]];
			
			break;
		case 30:
			
			[timeImgview setImage:[UIImage imageNamed:@"3.png"]];
			
			break;
		case 40:
			
			[timeImgview setImage:[UIImage imageNamed:@"4.png"]];
			
			break;
		case 50:
			
			[timeImgview setImage:[UIImage imageNamed:@"5.png"]];
			
			break;
		case 60:
			
			[timeImgview setImage:[UIImage imageNamed:@"6.png"]];
			
			break;
		case 70:
			
			[timeImgview setImage:[UIImage imageNamed:@"7.png"]];
			
			break;
		case 80:
			
			[timeImgview setImage:[UIImage imageNamed:@"8.png"]];
			
			break;
		case 90:
			
			[timeImgview setImage:[UIImage imageNamed:@"9.png"]];
			
			break;
		default:
			break;
	}
	
	
	[userInfo setInteger:gameTime forKey:@"timeCount"];
	appDelegate.timeCount = gameTime;
	
}





- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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



- (void)dealloc {
		
	[musicOpenBt release];
	musicOpenBt = nil;
	
	[musicCloseBt release];
	musicCloseBt = nil;
	
	[soundOpenBt release];
	soundOpenBt = nil;
	
	[soundCloseBt release];
	soundCloseBt = nil;
	
	[helpOpenBt release];
	helpOpenBt = nil;
	
	[helpCloseBt release];
	helpCloseBt = nil;
	
	[levelImgview release];
	levelImgview = nil;
	
	[numberImgview release];
	numberImgview = nil;
	
	//[timeLb release];
	//timeLb = nil;
	
	[super dealloc];
	
}



@end



