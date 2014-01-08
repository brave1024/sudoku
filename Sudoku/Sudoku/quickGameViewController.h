//
//  quickGameViewController.h
//  Sudoku
//
//  Created by Xia Zhiyong on 12-2-15.
//  Copyright 2012年 amoeba workshop. All rights reserved.
//


// 快速游戏界面


#import <UIKit/UIKit.h>
#import "SudokuAppDelegate.h"



@interface quickGameViewController : UIViewController <UIAlertViewDelegate>{

	UIImageView *levelImgview;	// 级别图片
	UIView *selectView;			// 选择数字
	//UIButton *nextLevelBt;		// 下一关bt
	UIImageView *allLevelImg;		// 总关卡数
	UIImageView *currentLevelImg;	// 当前关卡数

	UIView *infoView;
	UIImageView *infoImgview;
	
	int bigLevel;
	int smallLevel;
	int allSmallLevel;

	UIButton *allNumberBtArr[9][9];		// 保存各游戏点击bt
	int numLayout[9][9];				// 保存最终布局
	int origin_numLayout[9][9];			// 保存原始布局...从原始布局中读取空位坐标...
	NSMutableArray *emptyTagsArr;		// 保存各空位的tag
	//NSArray *levelIndexArr;			// 保存排序后的关卡随机数
	NSMutableArray *originalLevelArr;	// 保存原始关卡随机数
	BOOL originalHelp[9];				// 原始布局分析后的结果
	BOOL updatedHelp[9];				// 最终布局分析后的结果
	
	int timeCount;				// 计时...
	NSTimer *countTimer;
	int minuteNum;

	BOOL gameOver;
	BOOL isPlaying;

	BOOL gameFinished;
	
	SudokuAppDelegate *appDelegate;
	
	// 计时图片
	UIImageView *hourImgview01;
	UIImageView *hourImgview02;
	
	UIImageView *minuteImgview01;
	UIImageView *minuteImgview02;
	
	UIImageView *secondImgview01;
	UIImageView *secondImgview02;
	
	UIButton *clearBt;
	
	BOOL soundIsOpen;
	BOOL helpIsOpen;
		
	
}


@property (nonatomic, retain)IBOutlet UIImageView *levelImgview;
@property (nonatomic, retain)IBOutlet UIView *selectView;
//@property (nonatomic, retain)IBOutlet UIButton *nextLevelBt;
@property (nonatomic, retain)IBOutlet UIImageView *allLevelImg, *currentLevelImg;

@property (nonatomic, retain)IBOutlet UIView *infoView;
@property (nonatomic, retain)IBOutlet UIImageView *infoImgview;

@property int bigLevel, smallLevel, allSmallLevel;

@property int timeCount;
@property (nonatomic, retain) NSMutableArray *emptyTagsArr;
@property (nonatomic, retain) NSMutableArray *originalLevelArr;
@property int minuteNum;

@property BOOL gameOver, isPlaying;
@property BOOL gameFinished;

@property (nonatomic, assign) SudokuAppDelegate *appDelegate;

@property (nonatomic, retain) IBOutlet UIImageView *hourImgview01, *hourImgview02;
@property (nonatomic, retain) IBOutlet UIImageView *minuteImgview01, *minuteImgview02;
@property (nonatomic, retain) IBOutlet UIImageView *secondImgview01, *secondImgview02;

@property (nonatomic, retain) IBOutlet UIButton *clearBt;

@property BOOL soundIsOpen, helpIsOpen;



- (void)getRandomLevelIndex;
- (NSArray *)getOrderedLevelArr;
- (void)initBigLevelPic;
- (void)initSmallLevelNum;
- (void)getDefaultNum;
- (void)fixCoordinate;

- (void)initGameNumberBt;

- (void)startGameCount;
//- (void)updateTimeLabel;
- (void)showChangedTimePic;

- (void)fillTheNumber:(id)sender;

- (IBAction)backHome;

- (void)removeAllSelectedImg;
- (IBAction)selectTheNumber:(id)sender;

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

- (BOOL)checkCurrentNumberIsRepeatedOrNot:(int)numSelected;
- (BOOL)checkCurrentHorizontalLine:(int)row forCurrentNum:(int)numSelected;
- (BOOL)checkCurrentVerticalLine:(int)column forCurrentNum:(int)numSelected;
- (BOOL)checkCurrentSquare:(int)sIndex forCurrentNum:(int)numSelected;

- (void)checkGameOverOrNot;
- (BOOL)allNumberFilled;
- (BOOL)gameIsOver;
- (BOOL)checkEveryHorizontalLine:(int)row;
- (BOOL)checkEveryVerticalLine:(int)column;
- (BOOL)checkEverySquare:(int)sIndex;
- (void)showGameOverInfo;
- (void)goToNextLevel;


- (IBAction)clearCurrentEmptyNum;

- (IBAction)ensureBackhome;
- (IBAction)cancelBackhome;



@end


