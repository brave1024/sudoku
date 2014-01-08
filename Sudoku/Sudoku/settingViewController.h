//
//  settingViewController.h
//  Sudoku
//
//  Created by Xia Zhiyong on 12-2-15.
//  Copyright 2012年 amoeba workshop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SudokuAppDelegate.h"


@interface settingViewController : UIViewController {

    bool musicIsOpen;	//　音乐　
	bool soundIsOpen;	//　音效
	bool showHelp;		//　提示
	int gameLevel;		//　难度
	int numOfLevel;		//　关卡
	int gameTime;		//　计时
	
    SudokuAppDelegate *appDelegate;
	
}


@property (nonatomic, retain) IBOutlet UIButton *musicOpenBt, *musicCloseBt;
@property (nonatomic, retain) IBOutlet UIButton *soundOpenBt, *soundCloseBt;
@property (nonatomic, retain) IBOutlet UIButton *helpOpenBt, *helpCloseBt;

@property (nonatomic, assign)  SudokuAppDelegate *appDelegate;

@property (nonatomic, retain) IBOutlet UIImageView *levelImgview;
@property (nonatomic, retain) IBOutlet UIImageView *numberImgview;
//@property (nonatomic, retain) IBOutlet UILabel *timeLb;

@property (nonatomic, retain) IBOutlet UIImageView *timeImgview;



- (IBAction)musicOpenAction;
- (IBAction)musicCloseAction;

- (IBAction)soundOpenAction;
- (IBAction)soundCloseAction;

- (IBAction)helpOpenAction;
- (IBAction)helpCloseAction;

- (IBAction)levelSubtractAction;
- (IBAction)levelAddAction;

- (IBAction)numberSubtractAction;
- (IBAction)numberAddAction;

- (IBAction)timeSubtractAction;
- (IBAction)timeAddAction;


- (void)settingLevel;
- (void)settingNumber;
- (void)settingTime;



- (IBAction)backHome;



@end
