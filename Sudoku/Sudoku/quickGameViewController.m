//
//  quickGameViewController.m
//  Sudoku
//
//  Created by Xia Zhiyong on 12-2-15.
//  Copyright 2012年 amoeba workshop. All rights reserved.
//

#import "quickGameViewController.h"
//#import "levelData.h"



@implementation quickGameViewController

@synthesize levelImgview;
@synthesize selectView;
//@synthesize nextLevelBt;
@synthesize allLevelImg, currentLevelImg;
@synthesize infoView;
@synthesize infoImgview;

@synthesize bigLevel, smallLevel, allSmallLevel;

@synthesize timeCount, minuteNum;
@synthesize emptyTagsArr;
//@synthesize levelIndexArr;
@synthesize originalLevelArr;

@synthesize gameOver, isPlaying;
@synthesize gameFinished;

@synthesize appDelegate;
@synthesize soundIsOpen, helpIsOpen;

@synthesize hourImgview01, hourImgview02;
@synthesize minuteImgview01, minuteImgview02;
@synthesize secondImgview01, secondImgview02;
@synthesize clearBt;



const int squareLine_q = 31;

int hours_q;
int minutes_q;
int seconds_q;

int btIndex_q;	// 当前空位的tag
int btNum_q;	// 当前空位中填的数字


extern int *allLevel1[100];		// 外部变量...!!!
extern int *allLevel2[100];		// 外部变量...!!!
extern int *allLevel3[100];		// 外部变量...!!!
extern int *allLevel4[100];		// 外部变量...!!!




- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
		
		emptyTagsArr = [[NSMutableArray alloc]init];		// 初始化空位数组...每一关均不同 
		//levelIndexArr = [[NSArray alloc]init];	// 关卡...始终不变
		originalLevelArr = [[NSMutableArray alloc]init];	// 保存原始随机数...
		gameOver = NO;	// 默认游戏未结束
		
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
	bigLevel = appDelegate.quickLevel;		// 难度
	allSmallLevel = appDelegate.quickNum;	// 关数
	minuteNum = appDelegate.timeCount;		// 时长...原始的分
	soundIsOpen = appDelegate.soundIsOpen;	// 音效
	helpIsOpen = appDelegate.showHelp;		// 提示
	
	timeCount = minuteNum * 60;				// 时长...转为秒
	smallLevel = 1;							// 当前关默认为1
	
	[infoView setFrame:CGRectMake(-320, 0, 320, 640)];
	[self.view addSubview:infoView];
	[infoImgview setFrame:CGRectMake(23, 129, 273, 257)];
	
	NSLog(@"......<快速游戏>......难度=%d, 关卡数=%d, 时长=%d", bigLevel, allSmallLevel, timeCount);
	
	selectView.hidden = YES;	// 可选的填充数字栏隐藏
	
	clearBt.hidden = YES;		// 开始时清除bt隐藏
	
	[self getRandomLevelIndex];
	
	[self initBigLevelPic];
	
	[self initSmallLevelNum];
	
	[self getDefaultNum];
	
	[self initGameNumberBt];
	
	[self fixCoordinate];
	
}




// 视图出现时,开始计时...
- (void)viewDidAppear:(BOOL)animated {
	
	countTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(startGameCount) userInfo:nil repeats:YES];	
	
}




// 获取快速游戏的关卡随机数...
- (void)getRandomLevelIndex {
	
	
	for (int i = 0; i < allSmallLevel; i++) {
	
		int randomIndex = 0;
		
		getRandomNum:
		randomIndex = arc4random()%99;	// 0~98
		NSNumber *randomNum = [NSNumber numberWithInt:randomIndex];
		
		for (int j = 0; j < [originalLevelArr count]; j++) {	// 若发现有重复的,则重新取随机数...
			
			int myRandom = [(NSNumber *)[originalLevelArr objectAtIndex:j] intValue];
			
			if (myRandom == randomIndex) {

				goto getRandomNum;
			}
			
		}
		
		[originalLevelArr addObject:randomNum];	// 取随机数...无序...!!!
		
	}
	
	
}



// 对随机数进行排序...
- (NSArray *)getOrderedLevelArr {

	NSArray *finalRandomArr = [[[NSArray alloc]init] autorelease];
		
	// 将取得的随机数按大小重新排列...
	finalRandomArr = [originalLevelArr sortedArrayUsingComparator: ^(id obj1, id obj2) { 
		
		if ([obj1 integerValue] > [obj2 integerValue]) { 
			return (NSComparisonResult)NSOrderedDescending; 
		}else if ([obj1 integerValue] < [obj2 integerValue]) { 
			return (NSComparisonResult)NSOrderedAscending; 
		}else {
			return (NSComparisonResult)NSOrderedSame;
		} 
		
	}]; 
		
	//NSLog(@"<3>......finalRandomArr retainCount: %d", [finalRandomArr retainCount]);
	
	for (NSNumber *n in finalRandomArr) {
		
		NSLog(@"~~~~~~<%d>~~~~~~", [n intValue]);
	}
	
	return finalRandomArr;
	
}



- (void)initBigLevelPic {

	switch (bigLevel) {
		case 1:
			
			[levelImgview setImage:[UIImage imageNamed:@"level_1.png"]];
			
			break;
		case 2:
			
			[levelImgview setImage:[UIImage imageNamed:@"level_2.png"]];
			
			break;
		case 3:
			
			[levelImgview setImage:[UIImage imageNamed:@"level_3.png"]];
			
			break;
		case 4:
			
			[levelImgview setImage:[UIImage imageNamed:@"level_4.png"]];
			
			break;
		case 5:
			
			[levelImgview setImage:[UIImage imageNamed:@"level_5.png"]];
			
			break;
		default:
			break;
	}
	
	
}



// 初始化小关索引图片...
- (void)initSmallLevelNum {
	
	NSString *allStr = [NSString stringWithFormat:@"%d.png", allSmallLevel];
	NSString *currentStr = [NSString stringWithFormat:@"%d.png", smallLevel];
	
	[allLevelImg setImage:[UIImage imageNamed:allStr]];
	[currentLevelImg setImage:[UIImage imageNamed:currentStr]];
	
}




// 获取当前小关的默认布局信息...
- (void)getDefaultNum {
	
	//NSLog(@"<总关数>...原始关数:%d", originalLevelArr.count);
	
	//NSLog(@"<当前关数索引>...当前小关:%d", smallLevel);
	
	NSArray *myArray;
	myArray = [self getOrderedLevelArr];	// 对象的直接赋值不增加引用计数...???
	
	//NSLog(@"<1>......myArray retainCount: %d", [myArray retainCount]);
	
	[myArray retain];
	
	//NSLog(@"<2>......myArray retainCount: %d", [myArray retainCount]);
	
	//NSLog(@"<总关数>...排序后的关数:%d", myArray.count);
	
	// 取得当前小关的索引
	int currentIndex = [[myArray objectAtIndex:smallLevel-1] intValue];
	
	[myArray release];
	
	//NSLog(@"<3>......myArray retainCount: %d", [myArray retainCount]);
	
	//extern int *allLevel1[100];
	
	int *tempNum;
	
	switch (bigLevel) {
		case 1:
			
			tempNum = allLevel1[currentIndex - 1];
			
			break;
		case 2:
			
			tempNum = allLevel2[currentIndex - 1];
			
			break;
		case 3:
			
			tempNum = allLevel3[currentIndex - 1];
			
			break;
		case 4:
			
			tempNum = allLevel4[currentIndex - 1];
			
			break;
		case 5:
			
			tempNum = allLevel1[currentIndex - 1];
			
			break;
		default:
			break;
	}
	
	//int *tempNum = allLevel1[currentIndex];
	int n = 0;
	
	for ( int i = 0; i < 9; i++) {
		
		for (int j = 0; j < 9; j++) {
			
			n = i*9 + j;
			
			numLayout[i][j] = *(tempNum + n);			// 最终的布局...不断更新
			origin_numLayout[i][j] = *(tempNum + n);	// 原始的布局...不变
			//NSLog(@"<默认>当前布局:%d...<<<<<<<<<<<<<<",numLayout[i][j]);
			
		}
		
	}
	
}




// 初始化81个棋子bt
- (void)initGameNumberBt {
	
	int n = 0;
	//int emptyNum = 0;
	int cardNum = 0;
	
	for (int i = 0; i < 9; i++) {
		
		for (int j = 0; j < 9; j++) {
			
			n++;
			
			cardNum = numLayout[i][j];
			
			NSString *numStr = [NSString stringWithFormat:@"bt%d_1.png", cardNum];
			
			UIButton *numBt = [UIButton buttonWithType:UIButtonTypeCustom];	// 自动释放...!!!
			[numBt setFrame:CGRectMake(8 + squareLine_q*j + 3.2*j, 108 + squareLine_q*i + 3.2*i, squareLine_q, squareLine_q)];
			numBt.tag = n;
			[numBt setImage:[UIImage imageNamed:numStr] forState:UIControlStateNormal];
			
			// 判断空位...
			if (cardNum == 0) {
				
				// 只要当前bt为空位,则将其tag保存在空位数组中...
				NSNumber *emptyNum = [NSNumber numberWithInt:n];
				[emptyTagsArr addObject:emptyNum];
				
				[numBt addTarget:self action:@selector(fillTheNumber:) forControlEvents:UIControlStateHighlighted];
				
			}else {
				
				numBt.userInteractionEnabled = NO;
								
			}
			
			[self.view addSubview:numBt];
			
			allNumberBtArr[i][j] = numBt;
			
		}
		
	}
	
	NSLog(@"当前游戏界面上空位数为:%d...", emptyTagsArr.count);
	
	
}




// 开始计时...
- (void)startGameCount {
	
	//timeCount--;
	hours_q = timeCount / 3600;
	minutes_q = timeCount / 60;
	seconds_q = timeCount % 60;
    	
	//[self updateTimeLabel];
	
	[self showChangedTimePic];
	
	timeCount--;
	
	if (timeCount == 0) {
		
		NSLog(@"timeOver....!!!");
		
		if (countTimer) {
			[countTimer invalidate];
			countTimer = nil;
		}
		
		// 空位不可再点击
		for (NSNumber *myNum in emptyTagsArr) {
			
			int realNum = [myNum intValue];		// 获得空位的tag
			int i = (realNum-1) / 9;
			int j = (realNum-1) % 9;
			
			UIButton *gameBt = allNumberBtArr[i][j];
			gameBt.userInteractionEnabled = NO;		// Program received signal:  “EXC_BAD_ACCESS”.
			
		}
		
	}
	
}



/*
// 更新计时...
- (void)updateTimeLabel {			// Program received signal:  “EXC_BAD_ACCESS”.
	

	NSString *timeStr = [[[NSString alloc]init] autorelease];
	
	if (hours_q >= 10 && minutes_q >= 10 && seconds_q >= 10) {
		
		timeStr = [timeStr stringByAppendingFormat:@"%d:%d:%d", hours_q, minutes_q, seconds_q];
		//[timeLb setText:[NSString stringWithFormat:@"%d:%d:%d",hours_q,minutes_q,seconds_q]];
		
	}else if (hours_q >= 10 && minutes_q >= 10 && seconds_q < 10) {
		
		timeStr = [timeStr stringByAppendingFormat:@"%d:%d:0%d", hours_q, minutes_q, seconds_q];
		//[timeLb setText:[NSString stringWithFormat:@"%d:%d:0%d",hours_q,minutes_q,seconds_q]];
		
	}else if (hours_q >= 10 && minutes_q < 10 && seconds_q < 10) {
		
		timeStr = [timeStr stringByAppendingFormat:@"%d:0%d:0%d", hours_q, minutes_q, seconds_q];
		//[timeLb setText:[NSString stringWithFormat:@"%d:0%d:0%d",hours_q,minutes_q,seconds_q]];
		
	}else if (hours_q >= 10 && minutes_q < 10 && seconds_q >= 10) {
		
		timeStr = [timeStr stringByAppendingFormat:@"%d:0%d:%d", hours_q, minutes_q, seconds_q];
		//[timeLb setText:[NSString stringWithFormat:@"%d:0%d:%d",hours_q,minutes_q,seconds_q]];
		
	}else if (hours_q < 10 && minutes_q >= 10 && seconds_q >= 10) {
		
		timeStr = [timeStr stringByAppendingFormat:@"0%d:%d:%d", hours_q, minutes_q, seconds_q];
		//[timeLb setText:[NSString stringWithFormat:@"0%d:%d:%d",hours_q,minutes_q,seconds_q]];
		
	}else if (hours_q < 10 && minutes_q >= 10 && seconds_q < 10) {
		
		timeStr = [timeStr stringByAppendingFormat:@"0%d:%d:0%d", hours_q, minutes_q, seconds_q];
		//[timeLb setText:[NSString stringWithFormat:@"0%d:%d:0%d",hours_q,minutes_q,seconds_q]];
		
	}else if (hours_q < 10 && minutes_q < 10 && seconds_q >= 10) {
		
		timeStr = [timeStr stringByAppendingFormat:@"0%d:0%d:%d", hours_q, minutes_q, seconds_q];
		//[timeLb setText:[NSString stringWithFormat:@"0%d:0%d:%d",hours_q,minutes_q,seconds_q]];
		
	}else if (hours_q < 10 && minutes_q < 10 && seconds_q < 10) {
		
		timeStr = [timeStr stringByAppendingFormat:@"0%d:0%d:0%d", hours_q, minutes_q, seconds_q];
		//[timeLb setText:[NSString stringWithFormat:@"0%d:0%d:0%d",hours_q,minutes_q,seconds_q]];
		
	}
	
	timeLb.text = timeStr;
	
	
}
*/




// 显示计时图片
- (void)showChangedTimePic {

	
	if (hours_q == 0) {	// 不满一小时
		
		[hourImgview01 setImage:[UIImage imageNamed:@"0.png"]];
		[hourImgview02 setImage:[UIImage imageNamed:@"0.png"]];
		
	}else {				// 满了一小时
		
		int h_num1 = hours_q / 10;
		int h_num2 = hours_q % 10;
		
		NSString *num1_h_str = [NSString stringWithFormat:@"%d.png", h_num1];
		NSString *num2_h_str = [NSString stringWithFormat:@"%d.png", h_num2];
		
		[hourImgview01 setImage:[UIImage imageNamed:num1_h_str]];
		[hourImgview02 setImage:[UIImage imageNamed:num2_h_str]];
		
	}
	
	/****************************************/
	
	if (minutes_q == 0) {	// 不满一分钟
		
		[minuteImgview01 setImage:[UIImage imageNamed:@"0.png"]];
		[minuteImgview02 setImage:[UIImage imageNamed:@"0.png"]];
		
	}else {					// 满了一分钟
		
		int m_num1 = minutes_q / 10;
		int m_num2 = minutes_q % 10;
		
		NSString *num1_m_str = [NSString stringWithFormat:@"%d.png", m_num1];
		NSString *num2_m_str = [NSString stringWithFormat:@"%d.png", m_num2];
		
		[minuteImgview01 setImage:[UIImage imageNamed:num1_m_str]];
		[minuteImgview02 setImage:[UIImage imageNamed:num2_m_str]];
		
	}
	
	/****************************************/
	
	if (seconds_q >= 10) {	// 满了10秒...
		
		int s_num1 = seconds_q / 10;	// 十位
		int s_num2 = seconds_q % 10;	// 个位
		
		NSString *num1_str = [NSString stringWithFormat:@"%d.png", s_num1];
		NSString *num2_str = [NSString stringWithFormat:@"%d.png", s_num2];
		
		[secondImgview01 setImage:[UIImage imageNamed:num1_str]];
		[secondImgview02 setImage:[UIImage imageNamed:num2_str]];
		
	}else {					// 不足10秒...
		
		NSString *num_str = [NSString stringWithFormat:@"%d.png", seconds_q];
		[secondImgview01 setImage:[UIImage imageNamed:@"0.png"]];
		[secondImgview02 setImage:[UIImage imageNamed:num_str]];
		
	}
	
	
}



// 对坐标进行微调
- (void)fixCoordinate {
	
	for (int i = 0; i < 9; i++) {
		
		for (int j = 0; j < 9; j++) {
			
			UIButton *currentBt = (UIButton *)allNumberBtArr[i][j];
			
			CGRect currentRect;
			currentRect = currentBt.frame;
			
			if (i == 5 || i == 8) {
				currentRect.origin.y -= 1;
			}
			
			if (j == 5 || j == 8) {
				currentRect.origin.x -= 1;
			}
			
			currentBt.frame = currentRect;
			
		}
		
	}
	
}



// 点击空位来选数字...
- (void)fillTheNumber:(id)sender {
	
	UIButton *fillBt = (UIButton *)sender;
	btIndex_q = fillBt.tag;
	//NSLog(@"用户点击的bt之tag为:%d", btIndex_q);
	
	int i = (btIndex_q-1) / 9;
	int j = (btIndex_q-1) % 9;
	int currentNum = numLayout[i][j];
	
	btNum_q = currentNum;	// 获取当前空位的数字...若未填,则为0
	
	// 首先更改当前选中的空位图片...
	// 反应快速
	if (currentNum == 0) { 
		[fillBt setImage:[UIImage imageNamed:@"select.png"] forState:UIControlStateNormal];
		clearBt.hidden = YES;	// 若无数字,则清除键不可用
	}else {
		NSString *numStr = [NSString stringWithFormat:@"bt%d_2.png", currentNum];
		[fillBt setImage:[UIImage imageNamed:numStr] forState:UIControlStateNormal];
		clearBt.hidden = NO;	// 若有数字,则清除键可用
	}
	
	// 去掉选中效果...对所有空位进行刷新...!!!
	[self removeAllSelectedImg];
	
	selectView.hidden = NO;	
	
	if (helpIsOpen) {	// 若提示打开,则显示提示功能...
		
		[self showHelpInfo];
		
	}
	
}




// 去掉选中状态...
- (void)removeAllSelectedImg {
	
	// 去掉所有空位(包括已填数字的空位)的选中状态
	for (NSNumber *myNum in emptyTagsArr) {
		
		int realNum = [myNum intValue];		// 获得空位的tag
		
		if (realNum == btIndex_q) {
			continue;
		}
		
		int m = (realNum-1) / 9;
		int n = (realNum-1) % 9;
		//NSLog(@"所有的空位索引为: <%d, %d>, tag=%d", m, n, realNum);
		NSString *realStr = [NSString stringWithFormat:@"bt%d.png", numLayout[m][n]];
		UIButton *realBt = allNumberBtArr[m][n];
		[realBt setImage:[UIImage imageNamed:realStr] forState:UIControlStateNormal];
		
	}
	
}




// 增加提示信息...
- (void)showHelpInfo {

	for (int i = 0; i < 9; i++) {	// 清空提示数组
		
		originalHelp[i] = NO;
		updatedHelp[i] = NO;
		
	}
	
	[self analyseOriginalNumLayout];	// 填充
	
	[self analyseUpdatedNumLayout];		// 填充
	
	[self settingHelpAction];
	
}




// 对原始数字布局进行分析
- (void)analyseOriginalNumLayout {

	int row_empty = (btIndex_q - 1) / 9;							// 当前空位的行
	int column_empty = (btIndex_q - 1) % 9;							// 当前空位的列
	int square_empty = (row_empty / 3) * 3 + column_empty /3;		// 当前空位所在的九宫的索引
	
	[self analyseLineForOriginal:row_empty];
	
	[self analyseColumnForOriginal:column_empty];
	
	[self analyseSquareForOriginal:square_empty];
	
	
}



- (void)analyseLineForOriginal:(int)row {
	

	for (int i = 0; i < 9; i++) {
		
		if (origin_numLayout[row][i] == 1) {
			
			originalHelp[0] = YES;
			
		}else if (origin_numLayout[row][i] == 2) {
			
			originalHelp[1] = YES;
			
		}else if (origin_numLayout[row][i] == 3) {
			
			originalHelp[2] = YES;
			
		}else if (origin_numLayout[row][i] == 4) {
			
			originalHelp[3] = YES;
			
		}else if (origin_numLayout[row][i] == 5) {
			
			originalHelp[4] = YES;
			
		}else if (origin_numLayout[row][i] == 6) {
			
			originalHelp[5] = YES;
			
		}else if (origin_numLayout[row][i] == 7) {
			
			originalHelp[6] = YES;
			
		}else if (origin_numLayout[row][i] == 8) {
			
			originalHelp[7] = YES;
			
		}else if (origin_numLayout[row][i] == 9) {
			
			originalHelp[8] = YES;
			
		}
		
	}	// 遍历当前行的9个棋格...
	
	
}



- (void)analyseColumnForOriginal:(int)column {

	
	for (int i = 0; i < 9; i++) {
		
		if (origin_numLayout[i][column] == 1) {
			
			originalHelp[0] = YES;
			
		}else if (origin_numLayout[i][column] == 2) {
			
			originalHelp[1] = YES;
			
		}else if (origin_numLayout[i][column] == 3) {
			
			originalHelp[2] = YES;
			
		}else if (origin_numLayout[i][column] == 4) {
			
			originalHelp[3] = YES;
			
		}else if (origin_numLayout[i][column] == 5) {
			
			originalHelp[4] = YES;
			
		}else if (origin_numLayout[i][column] == 6) {
			
			originalHelp[5] = YES;
			
		}else if (origin_numLayout[i][column] == 7) {
			
			originalHelp[6] = YES;
			
		}else if (origin_numLayout[i][column] == 8) {
			
			originalHelp[7] = YES;
			
		}else if (origin_numLayout[i][column] == 9) {
			
			originalHelp[8] = YES;
			
		}
		
	}	// 遍历当前列的9个棋格...
	
	
}



- (void)analyseSquareForOriginal:(int)square {

	
	for (int i = 0; i < 9; i++) {
		
		if (origin_numLayout[(square/3)*3 + i/3][(square%3)*3 + i%3] == 1) {
			
			originalHelp[0] = YES;
			
		}else if (origin_numLayout[(square/3)*3 + i/3][(square%3)*3 + i%3] == 2) {
			
			originalHelp[1] = YES;
			
		}else if (origin_numLayout[(square/3)*3 + i/3][(square%3)*3 + i%3] == 3) {
			
			originalHelp[2] = YES;
			
		}else if (origin_numLayout[(square/3)*3 + i/3][(square%3)*3 + i%3] == 4) {
			
			originalHelp[3] = YES;
			
		}else if (origin_numLayout[(square/3)*3 + i/3][(square%3)*3 + i%3] == 5) {
			
			originalHelp[4] = YES;
			
		}else if (origin_numLayout[(square/3)*3 + i/3][(square%3)*3 + i%3] == 6) {
			
			originalHelp[5] = YES;
			
		}else if (origin_numLayout[(square/3)*3 + i/3][(square%3)*3 + i%3] == 7) {
			
			originalHelp[6] = YES;
			
		}else if (origin_numLayout[(square/3)*3 + i/3][(square%3)*3 + i%3] == 8) {
			
			originalHelp[7] = YES;
			
		}else if (origin_numLayout[(square/3)*3 + i/3][(square%3)*3 + i%3] == 9) {
			
			originalHelp[8] = YES;
			
		}
		
	}
	
	
}



// 对更新后的数字布局进行分析
- (void)analyseUpdatedNumLayout {
	
	// 默认当前空位bt没有 非空且重复 的情况
	BOOL notEmptyAndRepeated = NO;
	
	int row_empty = (btIndex_q - 1) / 9;							// 当前空位的行
	int column_empty = (btIndex_q - 1) % 9;							// 当前空位的列
	int square_empty = (row_empty / 3) * 3 + column_empty /3;		// 当前空位所在的九宫的索引
	
	
	if (btNum_q != 0) {		// 若当前空位已填数字,则需要判断当前所填数字是否有重复
		
		int repeatNum = 0;	// 初始重复个数为0
		
		int num1 = [self checkRepeatedInLine:row_empty];
		int num2 = [self checkRepeatedInColumn:column_empty];
		int num3 = [self checkRepeatedInSquare:square_empty];
		
		repeatNum = num1 + num2 + num3;
		
		if (repeatNum > 3) {	// 大于3,说明必有重复...等于3说明不重复...
			
			//NSLog(@"有重复...<前提是空位上有数字>");
			
			// 若有重复,则此空位上的数字当作未填...
			// 不作进一步处理...
			
		}else if (repeatNum == 3) {
			
			//NSLog(@"没有重复...<前提是空位上有数字>");
			
			// 若没有重复,则在bool型的布局中将当前空位设置为no...
			// 然后再作分析...
			
			notEmptyAndRepeated = YES;
			
		}

		
	}	// 当前空位中已填数字...
	
	
	[self analyseLineForUpdated:row_empty];
	
	[self analyseColumnForUpdated:column_empty];
	
	[self analyseSquareForUpdated:square_empty];
	
	
	if (notEmptyAndRepeated == YES) {
		
		updatedHelp[btNum_q - 1] = NO;	// 满足情况时,假设当前空位没有填数字...
		
	}
	
}



// 获得当前数字在行中的个数...检查重复用...
- (int)checkRepeatedInLine:(int)row {

	int num = 0;
	
	for (int i = 0; i < 9; i++) {
		
		if (numLayout[row][i] == btNum_q) {
			
			num++;
			
		}
		
	}
	
	return num;
	
}

- (int)checkRepeatedInColumn:(int)column {
	
	int num = 0;
	
	for (int i = 0; i < 9; i++) {
		
		if (numLayout[i][column] == btNum_q) {
			
			num++;
			
		}
		
	}
	
	return num;
	
	
}

- (int)checkRepeatedInSquare:(int)square {
	
	int num = 0;
	
	for (int i = 0; i < 9; i++) {
		
		if (numLayout[(square/3)*3 + i/3][(square%3)*3 + i%3] == btNum_q) {
			
			num++;
			
		}
		
	}
	
	return num;
	
}





- (void)analyseLineForUpdated:(int)row {
	
	
	for (int i = 0; i < 9; i++) {
		
		if (numLayout[row][i] == 1) {
			
			updatedHelp[0] = YES;
			
		}else if (numLayout[row][i] == 2) {
			
			updatedHelp[1] = YES;
			
		}else if (numLayout[row][i] == 3) {
			
			updatedHelp[2] = YES;
			
		}else if (numLayout[row][i] == 4) {
			
			updatedHelp[3] = YES;
			
		}else if (numLayout[row][i] == 5) {
			
			updatedHelp[4] = YES;
			
		}else if (numLayout[row][i] == 6) {
			
			updatedHelp[5] = YES;
			
		}else if (numLayout[row][i] == 7) {
			
			updatedHelp[6] = YES;
			
		}else if (numLayout[row][i] == 8) {
			
			updatedHelp[7] = YES;
			
		}else if (numLayout[row][i] == 9) {
			
			updatedHelp[8] = YES;
			
		}
		
	}	// 遍历当前行的9个棋格...
	
	
}



- (void)analyseColumnForUpdated:(int)column {
	
	
	for (int i = 0; i < 9; i++) {
		
		if (numLayout[i][column] == 1) {
			
			updatedHelp[0] = YES;
			
		}else if (numLayout[i][column] == 2) {
			
			updatedHelp[1] = YES;
			
		}else if (numLayout[i][column] == 3) {
			
			updatedHelp[2] = YES;
			
		}else if (numLayout[i][column] == 4) {
			
			updatedHelp[3] = YES;
			
		}else if (numLayout[i][column] == 5) {
			
			updatedHelp[4] = YES;
			
		}else if (numLayout[i][column] == 6) {
			
			updatedHelp[5] = YES;
			
		}else if (numLayout[i][column] == 7) {
			
			updatedHelp[6] = YES;
			
		}else if (numLayout[i][column] == 8) {
			
			updatedHelp[7] = YES;
			
		}else if (numLayout[i][column] == 9) {
			
			updatedHelp[8] = YES;
			
		}
		
	}	// 遍历当前列的9个棋格...
	
	
}



- (void)analyseSquareForUpdated:(int)square {
	
	
	for (int i = 0; i < 9; i++) {
		
		if (numLayout[(square/3)*3 + i/3][(square%3)*3 + i%3] == 1) {
			
			updatedHelp[0] = YES;
			
		}else if (numLayout[(square/3)*3 + i/3][(square%3)*3 + i%3] == 2) {
			
			updatedHelp[1] = YES;
			
		}else if (numLayout[(square/3)*3 + i/3][(square%3)*3 + i%3] == 3) {
			
			updatedHelp[2] = YES;
			
		}else if (numLayout[(square/3)*3 + i/3][(square%3)*3 + i%3] == 4) {
			
			updatedHelp[3] = YES;
			
		}else if (numLayout[(square/3)*3 + i/3][(square%3)*3 + i%3] == 5) {
			
			updatedHelp[4] = YES;
			
		}else if (numLayout[(square/3)*3 + i/3][(square%3)*3 + i%3] == 6) {
			
			updatedHelp[5] = YES;
			
		}else if (numLayout[(square/3)*3 + i/3][(square%3)*3 + i%3] == 7) {
			
			updatedHelp[6] = YES;
			
		}else if (numLayout[(square/3)*3 + i/3][(square%3)*3 + i%3] == 8) {
			
			updatedHelp[7] = YES;
			
		}else if (numLayout[(square/3)*3 + i/3][(square%3)*3 + i%3] == 9) {
			
			updatedHelp[8] = YES;
			
		}
		
	}
	
	
}




// 对可选数字bt的逻辑处理
- (void)settingHelpAction {
	
	
	BOOL hasPlayer = NO;	// 默认没有填数字...
	
	// 判断是否在原始布局的基础上已经填了数字...
	// 即更新后的布局与原始布局是否相同
	for (int i = 0; i < 9; i++) {
		
		if (originalHelp[i] != updatedHelp[i]) {
			
			hasPlayer = YES;
			break;
		}
		
	}
	
	
	// 对原始布局进行分析
	for (int i = 0; i < 9; i++) {	// 对9个bt设置图片
		
		int myTag = 101 + i;
		UIButton *numBt = (UIButton *)[self.view viewWithTag:myTag];
		
		if (originalHelp[i] == NO) {	// 可选
			
			NSString *numStr = [NSString stringWithFormat:@"num%d_1.png", i+1];
			[numBt setImage:[UIImage imageNamed:numStr] forState:UIControlStateNormal];
			numBt.userInteractionEnabled = YES;
			
		}else {							// 不可选
			
			NSString *numStr = [NSString stringWithFormat:@"num%d.png", i+1];
			[numBt setImage:[UIImage imageNamed:numStr] forState:UIControlStateNormal];
			numBt.userInteractionEnabled = NO;
			
		}
		
	}
	
	
	// 对更新后的布局进行分析
	if (hasPlayer == YES) {
				
		for (int i = 0; i < 9; i++) {	// 对9个bt设置图片
			
			int myTag = 101 + i;
			UIButton *numBt = (UIButton *)[self.view viewWithTag:myTag];
			
			if (updatedHelp[i] == NO) {
				
				NSString *numStr = [NSString stringWithFormat:@"num%d_2.png", i+1];
				[numBt setImage:[UIImage imageNamed:numStr] forState:UIControlStateNormal];
				//numBt.userInteractionEnabled = YES;
				
			}
			
		}
		
	}
	
	
}





// 选好数字后对空位进行填充...
- (IBAction)selectTheNumber:(id)sender {
	
	UIButton *numBt = (UIButton *)sender;
	//NSLog(@"tag=%d", numBt.tag);
	
	int realTag;
	realTag = numBt.tag % 100;
	//NSLog(@"realNum=%d", realTag);

	/*
	// 需对当前点击的数字进行判断...若有重复则不可选...!!!
	if (helpIsOpen) {	// 前提是提示已开启...
		
		BOOL isRepeated;
		isRepeated = [self checkCurrentNumberIsRepeatedOrNot:realTag];
		
		if (isRepeated == YES) {	// 返回yes表示有重复...
			//NSLog(@"有重复,请重新选择数字...!!!");
			return;
		}
		
	}
	*/
	
	selectView.hidden = YES;	// 重新隐藏可选数字栏
	
	// 给空位填充图片
	NSString *imgStr = [NSString stringWithFormat:@"bt%d_2.png", realTag];
	int i = (btIndex_q-1) / 9;
	int j = (btIndex_q-1) % 9;
	UIButton *currentBt = allNumberBtArr[i][j];
	[currentBt setImage:[UIImage imageNamed:imgStr] forState:UIControlStateNormal];
	
	// 在当前空位上保存所选的数字
	numLayout[i][j] = realTag;	// 更新布局...!!!
	
	[self checkGameOverOrNot];
	
}




// 若当前空位已填数字,则可点击来清除该数字...
// 平时不可用...
// 只有当用户点击某一空位,且此空位上已填有数字时
- (IBAction)clearCurrentEmptyNum {

	
	int i = (btIndex_q-1) / 9;
	int j = (btIndex_q-1) % 9;
	
	UIButton *currentBt = allNumberBtArr[i][j];
	[currentBt setImage:[UIImage imageNamed:@"select.png"] forState:UIControlStateNormal];
	
	numLayout[i][j] = 0;	// 更新布局信息
	
	clearBt.hidden = YES;

	btNum_q = 0;
	
	if (helpIsOpen) {	// 若提示打开,则显示提示功能...
		
		[self showHelpInfo];
		
	}
	
	
}




// 检查当前数字是否重复...
- (BOOL)checkCurrentNumberIsRepeatedOrNot:(int)numSelected {

	BOOL repeat_h;
	BOOL repeat_v;
	BOOL repeat_s;
	
	int row_empty = (btIndex_q-1) / 9;							// 当前空位的行
	int column_empty = (btIndex_q-1) % 9;						// 当前空位的列
	int square_empty = (row_empty / 3) * 3 + column_empty /3;	// 当前空位所在的九宫的索引
	
	//NSLog(@"当前空位的索引信息: <%d, %d>...%d", row_empty, column_empty, square_empty);
	
	repeat_h = [self checkCurrentHorizontalLine:row_empty forCurrentNum:numSelected];
	repeat_v = [self checkCurrentVerticalLine:column_empty forCurrentNum:numSelected];
	repeat_s = [self checkCurrentSquare:square_empty forCurrentNum:numSelected];
	
	if (repeat_h == YES || repeat_v == YES || repeat_s == YES) {
		
		return YES;	// 有重复
		
	}else {
		
		return NO;	// 无重复
	
	}
	
}




// 检查当前行中是否有相同的数字
- (BOOL)checkCurrentHorizontalLine:(int)row forCurrentNum:(int)numSelected {

	BOOL isRepeated = NO;
	
	for (int i = 0; i < 9; i++) {
		
		if (numLayout[row][i] == numSelected) {
		
			isRepeated = YES;
			break;
			
		}
		
	}
	
	return isRepeated;
	
}




// 检查当前列中是否有相同的数字
- (BOOL)checkCurrentVerticalLine:(int)column forCurrentNum:(int)numSelected {

	BOOL isRepeated = NO;
	
	for (int i = 0; i < 9; i++) {
		
		if (numLayout[i][column] == numSelected) {
			
			isRepeated = YES;
			break;
			
		}
		
	}
	
	return isRepeated;
		
}




// 检查当前九宫中是否有相同的数字
- (BOOL)checkCurrentSquare:(int)sIndex forCurrentNum:(int)numSelected {

	BOOL isRepeated = NO;
	
	for (int i = 0; i < 9; i++) {
		
		if (numLayout[(sIndex/3)*3 + i/3][(sIndex%3)*3 + i%3] == numSelected) {
			
			isRepeated = YES;	// 发现有重复的,设置为yes,并跳出for...
			break;
			
		}
		
	}
	
	return isRepeated;
	
}




// 检查游戏是否结束...
- (void)checkGameOverOrNot {
	
	// 若所有数字均已填完,则需进行胜负判断...
	if ([self allNumberFilled] == YES) {
		
		if ([self gameIsOver] == YES) {
			
			NSLog(@">>>>>>>>>>>...胜利...<<<<<<<<<<<");
			
			if (smallLevel == allSmallLevel) {
				gameOver = YES;	// 快速游戏结束...
			}
			[self showGameOverInfo];
			
		}
		
	}else {
		
		//NSLog(@"游戏未结束,还有空位没有填完...");
		
	}
	
}





// 所有的数字是否已填充完
- (BOOL)allNumberFilled {
	
	BOOL fillOver = YES;
	
	for (NSNumber *myNum in emptyTagsArr) {
		
		int realNum = [myNum intValue];		// 获得空位的tag
		int m = (realNum-1) / 9;
		int n = (realNum-1) % 9;
		
		if (numLayout[m][n] == 0) {		// 只要找到没有填的空位,则返回no...
			
			fillOver = NO;
			break;
			
		}
		
	}
	
	return fillOver;
	
}




// 游戏是否结束...
- (BOOL)gameIsOver {
	
	// 开始默认游戏结束...
	BOOL isOver = YES;	
	
	// 依次遍历9个行、列、宫...
	for (int i = 0; i < 9; i++) {
		
		BOOL h = [self checkEveryHorizontalLine:i];
		BOOL v = [self checkEveryVerticalLine:i];
		BOOL s = [self checkEverySquare:i];
		
		if (h == YES || v == YES || s == YES) {		// 返回yes说明有重复...不符...!!!
			
			isOver = NO;	// 只要找到一个不符合条件的,则直接返回no, 并退出for...
			break;
		}
		
	}
	
	return isOver;
	
}




// 看每一行是否有重复...前提是所有空位均已填完
// 返回no表示无重复...
- (BOOL)checkEveryHorizontalLine:(int)row {
	
	BOOL isRepeated = NO;
	
	for (int i = 0; i < 9; i++) {
		
		for (int j = i+1; j < 9; j++) {
			
			if (numLayout[row][i] == numLayout[row][j]) {
				isRepeated = YES;	// 发现有重复的,设置为yes,并跳出for...
				break;
			}
			
		}
		
	}
	
	return isRepeated;
	
}




// 看每一列是否有重复...前提是所有空位均已填完
- (BOOL)checkEveryVerticalLine:(int)column {
	
	BOOL isRepeated = NO;
	
	for (int i = 0; i < 9; i++) {
		
		for (int j = i+1; j < 9; j++) {
			
			if (numLayout[i][column] == numLayout[j][column]) {
				isRepeated = YES;	// 发现有重复的,设置为yes,并跳出for...
				break;
			}
			
		}
		
	}
	
	return isRepeated;
	
}




// 看每一九宫是否有重复...前提是所有空位均已填完
- (BOOL)checkEverySquare:(int)sIndex {
	
	BOOL isRepeated = NO;
	
	for (int i = 0; i < 9; i++) {
		
		for (int j = i+1; j < 9; j++) {
			
			//int m = (sIndex/3)*3 + i/3;
			//int n = (sIndex%3)*3 + i%3;
			//NSLog(@"......<%d, %d>......", m, n);
			
			if (numLayout[(sIndex/3)*3 + i/3][(sIndex%3)*3 + i%3] == numLayout[(sIndex/3)*3 + j/3][(sIndex%3)*3 + j%3]) {
				isRepeated = YES;	// 发现有重复的,设置为yes,并跳出for...
				break;
			}
			
		}
		
	}
	
	return isRepeated;
	
}




// 显示胜利提示...
- (void)showGameOverInfo {
	
	if (countTimer) {
		[countTimer invalidate];
		countTimer = nil;
	}
	
	NSString *infoStr = [[[NSString alloc]init] autorelease];
	
	if (gameOver == YES) {
		
		//infoStr = [NSString stringWithFormat:"游戏结束"];
		infoStr = @"游戏结束";
		
	}else {
		
		//infoStr = [NSString stringWithFormat:"当前关完成,请点击进入下一关"];
		infoStr = @"当前关完成,请点击进入下一关";
		
		smallLevel++;
		NSLog(@"当前快速游戏的关卡为:%d", smallLevel);
		
	}

	UIAlertView *infoAlert = [[UIAlertView alloc]initWithTitle:infoStr message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
	infoAlert.delegate = self;
	[infoAlert show];
	[infoAlert release];
	
	
}




- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

	if (buttonIndex == 0) {
		
		NSLog(@"点击警告栏的确定键...");
		
		if (gameOver == NO) {
			
			NSLog(@"进入下一关...");
			[self goToNextLevel];
			
			countTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(startGameCount) userInfo:nil repeats:YES];
			
		}else {
			
			// 游戏结束后,点击无效..
			
			// 空位不可再点击
			for (NSNumber *myNum in emptyTagsArr) {
				
				int realNum = [myNum intValue];		// 获得空位的tag
				int i = (realNum-1) / 9;
				int j = (realNum-1) % 9;
				
				UIButton *gameBt = allNumberBtArr[i][j];
				gameBt.userInteractionEnabled = NO;
				
			}
			
		}
		
	}	// 点击确定键
	
}




- (void)goToNextLevel {

	[emptyTagsArr removeAllObjects];
	
	// 清空数组...
	for (int i = 0; i < 9; i++) {
		
		for (int j = 0; j < 9; j++) {
			
			numLayout[i][j] = 0;
			
			UIButton *numBt = allNumberBtArr[i][j];
			[numBt removeFromSuperview];
			numBt = nil;
			
		}
		
	}
	
	NSLog(@"goToNextLevel...!!!");
	
	[self initSmallLevelNum];
	
	[self getDefaultNum];
	
	[self initGameNumberBt];
	
	[self fixCoordinate];
	
}




// 返回...
- (IBAction)backHome {
    
	// 返回时需停止计时器...否则会出问题...定时器一直在后台运行...
	// 弹出提示时定时器也要停
	if (countTimer) {
		[countTimer invalidate];
		countTimer = nil;
	}
	
	if (gameOver == YES) {
		
		// 游戏已结束
		
		[self dismissModalViewControllerAnimated:YES];
				
	}else {
		
		// 游戏未结束
		
		[self.view bringSubviewToFront:infoView];
		
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.4];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[infoView setFrame:CGRectMake(0, 0, 320, 640)];
		[UIView commitAnimations];
		
	}

    
}




- (IBAction)ensureBackhome {

	//[infoView removeFromSuperview];
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.4];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDidStopSelector:@selector(afterAnimation)];
	[infoView setFrame:CGRectMake(320, 0, 320, 640)];
	[UIView commitAnimations];
		
}




- (IBAction)cancelBackhome {
	
	//[infoView removeFromSuperview];
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.4];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[infoView setFrame:CGRectMake(-320, 0, 320, 640)];
	[UIView commitAnimations];
		
	countTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(startGameCount) userInfo:nil repeats:YES];
	
}





- (void)afterAnimation {

	[self dismissModalViewControllerAnimated:YES];
	
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

	for (int i = 0; i < 9; i++) {
		
		for (int j = 0; j < 9; j++) {
			
			UIButton *numBt = allNumberBtArr[i][j];
			[numBt removeFromSuperview];
			numBt = nil;
			
		}
		
	}
	
	[emptyTagsArr release];
	[originalLevelArr release];
	
	if (countTimer) {
		[countTimer invalidate];
		countTimer = nil;
	}
	
	[levelImgview release];
	levelImgview = nil;
	
	[selectView release];
	selectView = nil;
	
	[allLevelImg release];
	allLevelImg = nil;
	
	[currentLevelImg release];
	currentLevelImg = nil;
	
	[hourImgview01 release];
	hourImgview01 = nil;
	
	[hourImgview02 release];
	hourImgview02 = nil;
	
	[minuteImgview01 release];
	minuteImgview01 = nil;
	
	[minuteImgview02 release];
	minuteImgview02 = nil;
	
	[secondImgview01 release];
	secondImgview01 = nil;
	
	[secondImgview02 release];
	secondImgview02 = nil;
	
	[clearBt release];
	clearBt = nil;
	
	[infoView release];
	infoView = nil;
	
	[infoImgview release];
	infoImgview = nil;
	
	
	[super dealloc];
	
}



@end
