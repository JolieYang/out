//
//  InputMoodViewController.m
//  Out
//
//  Created by Jolie_Yang on 16/8/29.
//  Copyright © 2016年 Jolie_Yang. All rights reserved.
//

// 问题列表:
// ?1.[ok] 预输入时打印textView s s s。 字符为ssss时，打印长度为4，而微博是按2来算。Reply: 只是一个约定而已，将字母，数字等按两个字符为一个长度而已。
// ?2.去除空格失败
// ?3. 主页面进入该页面是会有点卡顿

// TODO:
// 1.[done] #隐藏导航栏右边按钮#TextView里有文本就显示导航栏勾选，无则不显示 1) 第一次进入界面是默认隐藏还是等输入后再添加导航栏右边按钮呢
// 2. TextView明明设置距离上边是2，运行后则调到下面去了。字数多的时候又会顶到之前设置的约束上
// 3. 主页面进入该页面是会有点卡顿
// 4. 上网看到资料说在textViewDidChange统计会导致输入时卡卡的，有待进一步测试看看是否这样
// 5.[done] 计算字数时特殊情况处理: 1) emoji 使用length为2 ,通过[str lengthOfBytesUsingEncoding:NSUTF32StringEncoding] / 4 为1； 2) 英文字母字符数字为两个代表一个长度。
// 6.[done] 输入文字后去除placeholder
// 7.[done] 输入文字时textView是垂直居中左对齐，而不是顶部左对齐  [new]默认为顶部左对齐，之前在textView区域拖了一个Label，设置完约束后就是这样了。
// 8. 更改导航栏返回图标和右边图标
// 9.[done] 字数统计时超过100字符时统计的字符数显示为红色
// 10.[done]  字数统计超过100字符弹框显示“超出100字限制”

//  UI:
// 1. 导航栏图标尺寸 58 @2x  #757575
#import "InputMoodViewController.h"
#import "StringLengthHelper.h"
#import "OutAlertViewController.h"

#define LIMIT_TEXT_LENGTH 100

#define YLog(formatString, ...) NSLog((@"%s" formatString), __PRETTY_FUNCTION__, ##__VA_ARGS__);

@interface InputMoodViewController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *inputTextView;
@property (weak, nonatomic) IBOutlet UILabel *textLengthLB;
@property (nonatomic, strong) UILabel *placeHolderLB;

@property (nonatomic, assign) BOOL hasAddedNavRight; // 是否已添加过导航栏右边按钮
@end

@implementation InputMoodViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.inputTextView.delegate = self;
    self.navigationItem.title = @"InputMood";
    // 设置导航栏返回(左边)按钮
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = backItem;
    self.inputTextView.contentMode = UIViewContentModeTop;
    [self addInputTextViewPlaceHolder];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.inputTextView becomeFirstResponder];
}

- (void)addInputTextViewPlaceHolder {
    self.placeHolderLB = [[UILabel alloc] initWithFrame:CGRectMake(5, 8, [[UIScreen mainScreen] bounds].size.width - 20, 36)];
    self.placeHolderLB.text = @"想说点什么呢?";
    self.placeHolderLB.textColor = [UIColor grayColor];
    self.placeHolderLB.alpha = 0.5f;
    self.placeHolderLB.font = self.inputTextView.font;
    [self.placeHolderLB sizeToFit];
    [self.inputTextView addSubview: self.placeHolderLB];
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didEndEdit {
    // 超出100字限制
    if ([StringLengthHelper length:self.inputTextView.text] > 100) {
        UIAlertController *alertController = [OutAlertViewController lenghtExceedLimit];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    if (_finishMoodBlock) {
        _finishMoodBlock();
    }
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    UITextRange *selectedRange = [textView markedTextRange];
    NSString *newText = [textView textInRange:selectedRange];
    // ?2. 去除空格失败
//    NSString *failedStrip = [newText stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    // m1
//    NSString *textStr = newText;
//    NSString *stripSpaceStr = [textStr stringByReplacingOccurrencesOfString:@" " withString:@""];
//    int length = [self strLength:textView.text] - [self strLength:newText] + [self strLength:stripSpaceStr];
    // m2--取巧
    int length = [StringLengthHelper length:textView.text] - (floor)(newText.length/2.0);
    if (length > 100) {
        NSString *limitStr = [NSString stringWithFormat:@"%d/%d", length, LIMIT_TEXT_LENGTH];
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:limitStr];
        [attStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, limitStr.length - 4)];
        self.textLengthLB.attributedText = attStr;
    } else {
        self.textLengthLB.text = [NSString stringWithFormat:@"%d/%d", length, LIMIT_TEXT_LENGTH];
    }
    if (length == 0) {
        // 隐藏导航栏右边按钮
        [self hideNavRightItem: YES];
        // 显示placeHolder
        self.placeHolderLB.hidden = NO;
    }
}

// 点击键盘上的
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    // 空textView，点击清除键 text.length==0，不显示
    if (textView.text.length == 0 && text.length > 0) {
        // 显示导航栏右边按钮
        [self hideNavRightItem:NO];
        self.placeHolderLB.hidden = YES;
    }
    
    return YES;
}

#pragma mark Tool

// 隐藏或显示导航栏右边按钮
- (void)hideNavRightItem:(BOOL)hide {
    // 显示导航栏右边按钮
    if (hide == NO && !self.hasAddedNavRight) {
        [self addNavRightItem];
    }
    NSArray *subviews = self.navigationController.navigationBar.subviews;
    if (subviews.count < 5) return;
    UIView *navRightItem = [subviews objectAtIndex:3];// 0 1 是固定的 ,然后显示UINavigationButton，根据加入的顺序，viewDidload中添加了导航栏左边按钮(index为2), 添加了右边按钮则index为3
    [navRightItem setHidden:hide];
}

// 设置导航栏右边按钮
- (void)addNavRightItem {
    UIBarButtonItem *checkItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_check"] style:UIBarButtonItemStylePlain target:self action:@selector(didEndEdit)];
    self.navigationItem.rightBarButtonItem = checkItem;
    self.hasAddedNavRight = YES;
}

@end
