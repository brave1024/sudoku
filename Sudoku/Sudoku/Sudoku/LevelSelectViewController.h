//
//  LevelSelectViewController.h
//  Sudoku
//
//  Created by Xia Zhiyong on 12-2-15.
//  Copyright 2012年 amoeba workshop. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LevelSelectViewController : UIViewController <UIScrollViewDelegate> {

    UIScrollView *levelScrollView;
    
	// 使用c二维数组来保存相关ui
    UIButton *allButtonArr[11][9];			// 所有99小关bt
	UILabel *allLabelNumArr[11][9];			// 各小关的编号lb
	UILabel *allLabel_PlayingArr[11][9];		// 各小关的正在进行游戏提示
	UILabel *allLabel_TimeArr[11][9];			// 各小关当前开启的游戏的计时
	UILabel *allBestTimeInfoArr[11][9];				// 各小关最佳时长提示
	UILabel *allLabel_firstTime[11][9];				// 各小关第一高分:时间
	UILabel *allLabel_firstDate[11][9];				// 各小关第一高分:日期
	UILabel *allLabel_secondTime[11][9];			// 各小关第二高分:时间
	UILabel *allLabel_secondDate[11][9];			// 各小关第二高分:日期
	UILabel *allLabel_thirdTime[11][9];				// 各小关第三高分:时间
	UILabel *allLabel_thirdDate[11][9];				// 各小关第三高分:日期
	
	int bigLevel;		// 获取当前用户保存的大关索引
	UIButton *veryEasyBt;
	UIButton *easyBt;
	UIButton *normalBt;
	UIButton *hardBt;
	UIButton *veryHardBt;
	UIButton *whatBt;

	BOOL hideLevelShow;	// 隐藏大关是否开启...
	int smallOpenNum;	// 当前大关下,小关的开启个数
	
	UIPageControl *pageController;
	UIAlertView *waitAlert;
	BOOL firstCome;
    
}


@property (nonatomic, retain) IBOutlet UIScrollView *levelScrollView;
//@property (nonatomic, retain) UIButton *allButtonArr;

@property int bigLevel;
@property (nonatomic, retain) IBOutlet UIButton *veryEasyBt, *easyBt, *normalBt, *hardBt, *veryHardBt, *whatBt;
@property BOOL hideLevelShow;
@property int smallOpenNum;

@property (nonatomic, retain) IBOutlet UIPageControl *pageController;
@property (nonatomic, retain) UIAlertView *waitAlert;



- (void)checkAllBigLevelStatus;
- (void)setBigLevelImg;
- (IBAction)setGameVeryEasy;
- (IBAction)setGameEasy;
- (IBAction)setGameNormal;
- (IBAction)setGameHard;
- (IBAction)setGameVeryHard;
- (IBAction)setGameWhat;


- (void)initLevelBt;
- (void)resettingLevelBtForAllFiveLevel;
- (void)setEverySmallLevel;
- (void)showTimeCountInfo:(int)currentCount forTimeString:(NSString **)timeStr;
- (void)selectHideLevel;


- (IBAction)changePage;
- (IBAction)backHome;
- (IBAction)HelpView;



@end


