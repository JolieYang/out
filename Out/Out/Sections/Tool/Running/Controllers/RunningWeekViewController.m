//
//  RunningWeekViewController.m
//  Out
//
//  Created by Jolie_Yang on 2017/4/10.
//  Copyright © 2017年 Jolie_Yang. All rights reserved.
//

#import "RunningWeekViewController.h"
#import "RunningAddPartyViewController.h"
#import "CenterTitleTableViewCell.h"
#import "RunningRecordColumnTableViewCell.h"
#import "RunningMemberRecordTableViewCell.h"
#import "RunningRecordFundsTableViewCell.h"
#import "RunningRecordManager.h"
#import "RunningWeekManager.h"
#import "RunningWeek.h"
#import "DateHelper.h"

static NSString *recordTitleTableViewCellIdentifier = @"RunningMemberRecordColumnTitleTableViewCell";
static NSString *recordTableViewCellIdentifier = @"RunningMemberRecordTableViewCell";

@interface RunningWeekViewController ()<UITableViewDataSource,UITableViewDelegate, UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *fundsTitle;
@property (nonatomic, strong) NSMutableArray *recordsArray;
@end

@implementation RunningWeekViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupViews];
    [self setupDatas];
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
- (void)setupViews {
    [self addNavRightItem];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)setupDatas {
    self.fundsTitle = [NSMutableArray arrayWithArray:[self defaultFoundsTitle]];
    [self updateFoundsTitle];
    NSArray *recordsArray = [RunningRecordManager getRecordsWithWeekId:self.week.weekId];
    if (recordsArray.count == 0) {
        recordsArray = [RunningRecordManager addAllMembersRecordWithWeekId:self.week.weekId];
    }
    self.recordsArray = [NSMutableArray arrayWithArray:recordsArray];
}
    
- (void)updateFoundsTitle {
    if (self.week.isParty) {
        [self.fundsTitle insertObject:@"腐败花销" atIndex:2];
    }
}
- (NSArray *)defaultFoundsTitle {
    return @[@"当期经费", @"上期经费", @"累计经费"];
}
    
- (void)addNavRightItem {
    UIBarButtonItem *titleItem = [[UIBarButtonItem alloc] initWithTitle:@"截图" style:UIBarButtonItemStylePlain target:self action:@selector(sreenShotTableView)];
    UIBarButtonItem *partyItem = [[UIBarButtonItem alloc] initWithTitle:@"腐败" style:UIBarButtonItemStylePlain target:self action:@selector(partyCost)];
    self.navigationItem.rightBarButtonItems = @[titleItem,partyItem];
}

- (void)partyCost {
    RunningAddPartyViewController *vc = [[RunningAddPartyViewController alloc] initWithNibName:NSStringFromClass([RunningAddPartyViewController class]) bundle:nil];
    vc.weekId = self.week.weekId;
    vc.successAddPartyCostBlock = ^(RunningWeek *week) {
        self.week = week;
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:3] withRowAnimation:UITableViewRowAnimationFade];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (BOOL)sreenShotTableView {
    UIImage* image = nil;
    CGSize tableViewContentSize = CGSizeMake(self.tableView.contentSize.width, self.tableView.contentSize.height+56);// tip: apple's bug
    UIGraphicsBeginImageContext(tableViewContentSize);
    
    //保存tableView当前的偏移量
    CGPoint savedContentOffset = self.tableView.contentOffset;
    CGRect saveFrame = self.tableView.frame;
    
    //将tableView的偏移量设置为(0,0)
    self.tableView.contentOffset = CGPointZero;
    self.tableView.frame = CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, tableViewContentSize.width, tableViewContentSize.height);
    
    //在当前上下文中渲染出tableView
    [self.tableView.layer renderInContext: UIGraphicsGetCurrentContext()];
    //截取当前上下文生成Image
    image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    //恢复tableView的偏移量
    self.tableView.contentOffset = savedContentOffset;
    self.tableView.frame = saveFrame;
    
    
    if (image != nil) {
        UIImageWriteToSavedPhotosAlbum(image,nil,nil,nil);
        return YES;
    }else {
        return NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 0;
    } else if (section == 3) {
        return 0;
    }else {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 28;
    } else if (indexPath.section == 1) {
        return 30;
    } else {
        return 30;
    }
}

#pragma mark UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        NSString *fromDate = [self timeStringFromUnix:self.week.fromUnix];
        NSString *endDate = [self timeStringFromUnix:self.week.endUnix];
        NSString *title = [NSString stringWithFormat:@"%ld月第%ld周(%@~%@)", (long)self.week.month, (long)self.week.weekOfMonth, fromDate, endDate];
        CenterTitleTableViewCell *cell = [CenterTitleTableViewCell initWithTitle: title];
        return cell;
    } else if (indexPath.section == 1) {
        RunningRecordColumnTableViewCell *cell = [RunningRecordColumnTableViewCell loadFromNib];
        return cell;
    } else if (indexPath.section == 2) {
        RunningMemberRecordTableViewCell *cell = [[RunningMemberRecordTableViewCell alloc] initWithDataModel:self.recordsArray[indexPath.row]];
        cell.updateWeekRecordContributionBlock = ^(RunningWeek *week) {
            self.week = week;
            [self updateFoundsTitle];
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:3] withRowAnimation:UITableViewRowAnimationFade];
        };
        cell.checkBtnClickBlock = ^(BOOL checkted) {
            [self.view endEditing:YES];
        };
        return cell;
    } else if (indexPath.section == 3) {
        NSInteger sum;
        if (indexPath.row == 0) {
            sum = self.week.weekContribution;
        } else if (indexPath.row == 1) {
            sum = self.week.preSumContribution;
        } else if (indexPath.row == 2) {
            if (self.week.isParty) {
                sum = self.week.partyCost;
            } else {
                sum = self.week.sumContribution;
            }
        } else {
            sum = self.week.sumContribution;
        }
        RunningRecordFundsTableViewCell *cell = [[RunningRecordFundsTableViewCell alloc] initWithTitle:self.fundsTitle[indexPath.row] sum:sum];
        return cell;
    } else {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        
        return cell;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return 1;
    } else if (section == 2) {
        return self.recordsArray.count;
    } else if (section == 3) {
        return self.fundsTitle.count;
    }else {
        return 0;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}



#pragma mark Keyboard
- (void)keyboardWillShow:(NSNotification *)notification {
    CGFloat viewY = [self getEditingTextFieldYFromTableView:self.tableView];
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGFloat keyboardEndY = value.CGRectValue.origin.y;
    // 动画
    NSNumber *duration = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    [UIView animateWithDuration:duration.doubleValue animations:^{
        if (viewY > keyboardEndY) {
//            self.tableView.contentOffset = CGPointMake(0, self.tableView.contentOffset.y + viewY - keyboardEndY);// ps: 如果设置contentOffset则调整位置后键盘并不会弹出，需要在点击一次才会弹出键盘
            CGRect rect = self.tableView.frame;
            rect.origin.y +=  keyboardEndY - viewY;
            self.tableView.frame = rect;
        }
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    CGRect rect = self.tableView.frame;
    rect.origin.y = 0;
    self.tableView.frame = rect;
}

- (CGFloat)getEditingTextFieldYFromTableView:(UITableView *)tableView {
    CGFloat y = 0;
    for (UITableViewCell *tableViewCell in tableView.visibleCells) {
        if ([tableViewCell isKindOfClass:[RunningMemberRecordTableViewCell class]]) {
            RunningMemberRecordTableViewCell *cell = (RunningMemberRecordTableViewCell *)tableViewCell;
            if (cell.remarksTF.isEditing || cell.contributionMoneyTF.isEditing) {
                y += tableViewCell.frame.origin.y + tableViewCell.frame.size.height + 64;
                y = y - (tableView.contentOffset.y + 64);
                return y;
            }
        }
    }
    y = -1;
    return y;
}

#pragma mark Date Tool
- (NSString *)timeStringFromUnix:(NSTimeInterval)unix {
    return [DateHelper dateStringFromTimeInterval:unix dateFormat:@"yyyy.MM.dd"];
}

@end
