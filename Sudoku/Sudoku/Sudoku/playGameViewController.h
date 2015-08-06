//
//  playGameViewController.h
//  Sudoku
//
//  Created by Xia Zhiyong on 12-2-15.
//  Copyright 2012年 amoeba workshop. All rights reserved.
//


// 一般游戏界面


#import <UIKit/UIKit.h>
#import "SudokuAppDelegate.h"


@interface playGameViewController : UIViewController {

	UIImageView *levelImgview;	// 级别图片
	UIView *selectView;			// 选择数字
	UIButton *nextLevelBt;		// 下一关bt
	UIImageView *doubleImg;		// 十位
	UIImageView *singleImg;		// 个位
	
	int bigLevel;
	int smallLevel;
	int allSmallLevel;
	
	UIButton *allNumberBtArr[9][9];	// 保存各游戏点击bt
	int numLayout[9][9];			// 保存最终布局
	int origin_numLayout[9][9];		// 保存原始布局...从原始布局中读取空位坐标...
	int randomNum[9];				// 随机数1~9
	//BOOL emptyLayout[9][9];			// 保存空位布局
	BOOL originalHelp[9];				// 原始布局分析后的结果
	BOOL updatedHelp[9];				// 最终布局分析后的结果
	
	int timeCount;				// 计时...
	//NSString *DateString;		// 日期字符串
	NSTimer *countTimer;
	
	//int emptyTags[81];	//　保存各空位的tag
	NSMutableArray *emptyTagsArr;
	
	BOOL gameOver;
	BOOL isPlaying;
	
	BOOL gameFinished;
	int overNum;
	
	SudokuAppDelegate *appDelegate;
	BOOL soundIsOpen;
	BOOL helpIsOpen;
	
	// 计时图片
	UIImageView *hourImgview01;
	UIImageView *hourImgview02;
	
	UIImageView *minuteImgview01;
	UIImageView *minuteImgview02;
	
	UIImageView *secondImgview01;
	UIImageView *secondImgview02;
	
	UIView *infoView;
	UIImageView *infoImgview;
	
	UIView *gameOverView;
	
	
}


@property (nonatomic, retain)IBOutlet UIImageView *levelImgview;
@property (nonatomic, retain)IBOutlet UIView *selectView;
@property (nonatomic, retain)IBOutlet UIButton *nextLevelBt;
@property (nonatomic, retain)IBOutlet UIImageView *doubleImg, *singleImg;

@property int bigLevel, smallLevel, allSmallLevel;

@property int timeCount;
//@property (nonatomic, retain) NSString *DateString;
@property (nonatomic, retain) NSMutableArray *emptyTagsArr;

@property BOOL gameOver, isPlaying;
@property BOOL gameFinished;
@property int overNum;

@property (nonatomic, assign) SudokuAppDelegate *appDelegate;
@property BOOL soundIsOpen, helpIsOpen;

@property (nonatomic, retain) IBOutlet UIImageView *hourImgview01, *hourImgview02;
@property (nonatomic, retain) IBOutlet UIImageView *minuteImgview01, *minuteImgview02;
@property (nonatomic, retain) IBOutlet UIImageView *secondImgview01, *secondImgview02;

@property (nonatomic, retain) IBOutlet UIView *infoView;
@property (nonatomic, retain) IBOutlet UIImageView *infoImgview;

@property (nonatomic, retain) IBOutlet UIView *gameOverView;


- (void)initSomeProperty;
- (void)initBigLevelImg;
- (void)initSmallLevelNum;
- (void)initGameNumberLayout;
- (void)initGameNumberBt;

- (void)getDefaultNum;
- (void)getRandomNum;
- (void)changeLayoutByRandomNum;
- (void)getNumForLayout;
- (void)fillCurrentNumArr:(int [9][9])tempArr;

- (void)fixCoordinate;

- (void)startGameCount;
//- (void)updateTimeLabel;
- (void)showChangedTimePic;

- (void)showHelpInfo;
- (void)analyseOriginalNumLayout;
- (void)analyseLineForOriginal:(int)row;
- (void)analyseColumnForOriginal:(int)column;
- (void)analyseSquareForOriginal:(int)square;

- (void)analyseUpdatedNumLayout;
- (void)analyseLineForUpdated:(int)row;
- (void)analyseColumnForUpdated:(int)column;
- (void)analyseSquareForUpdated:(int)square;
- (int)checkRepeatedInLine:(int)row;
- (int)checkRepeatedInColumn:(int)column;
- (int)checkRepeatedInSquare:(int)square;

- (void)settingHelpAction;

- (IBAction)backHome;
- (IBAction)restart;
- (IBAction)goToNextLevel;

- (void)saveDataBeforeBackhome;
- (void)restartCurrentLevel;

- (void)removeAllSelectedImg;
- (IBAction)selectTheNumber:(id)sender;
- (void)checkGameOverOrNot;
- (BOOL)allNumberFilled;
- (BOOL)gameIsOver;

- (BOOL)checkCurrentNumberIsRepeatedOrNot:(int)numSelected;
- (BOOL)checkCurrentHorizontalLine:(int)row forCurrentNum:(int)numSelected;
- (BOOL)checkCurrentVerticalLine:(int)column forCurrentNum:(int)numSelected;
- (BOOL)checkCurrentSquare:(int)sIndex forCurrentNum:(int)numSelected;

- (BOOL)checkEveryHorizontalLine:(int)row;
- (BOOL)checkEveryVerticalLine:(int)column;
- (BOOL)checkEverySquare:(int)sIndex;
- (void)showGameOverInfo;
- (void)getCurrentDate;
- (void)checkAndSaveGameRecord;
- (void)refreshNewSmallLevel;
- (void)nextLevelAction;

- (IBAction)ensureBackhome;
- (IBAction)cancelBackhome;

- (IBAction)gameOverAction;



@end


