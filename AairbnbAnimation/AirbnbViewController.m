//
//  AirbnbViewController.m
//  AairbnbAnimation
//  Created by ian on 16/11/2.
//  Copyright © 2016年 ian. All rights reserved.

#import "AirbnbViewController.h"
#import "AirBackTableView.h"
#import "AirTableView.h"
#import <Masonry.h>

#define kScreenWith [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define HEADER_VIEW_HEIGHT 208
#define HEADER_VIEW_SUBVIEW_TAG 1853

static NSUInteger const kCellNum = 400;
static NSUInteger const kRowHeight = 44;

@interface AirbnbViewController ()<UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>

@property (nonatomic, strong) AirBackTableView *backTableView;
@property (nonatomic, strong) AirTableView *tableView;
@property (nonatomic, strong) UIView *headerBackView;
@property (nonatomic, strong) UIView *singleHeaderView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIView *coverView;
@property (nonatomic, strong) UIView *headerCellContentView;

@property (nonatomic) CGPoint oldOffset;
@property (nonatomic) CGFloat oldAlphaOffset;
@property (nonatomic) BOOL isMoveStop;
@property (nonatomic) BOOL isLittleCanMoveUporDown;

@property (nonatomic) CGPoint oldLittleOffset;
@property (nonatomic) CGPoint oldChildTableViewOffset;

// 上海 日期 人数 的button
@property (nonatomic, strong) UIButton *singleTitleBtn;
// 想去哪儿？
@property (nonatomic, strong) UIButton *whereTitleBtn;
// 何时入住?
@property (nonatomic, strong) UIButton *whenTitleBtn;
// 几人同行？
@property (nonatomic, strong) UIButton *howManyTitleBtn;

@end

@implementation AirbnbViewController


#pragma mark - life style

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self configNavigationBar];
    [self configBackTableView];
    [self configBackHeaderView];
    [self configBottomView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    
}


#pragma mark - private method

- (void)configNavigationBar
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 44, 44);
    [leftBtn setImage:[UIImage imageNamed:@"er_nav_back"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *navigativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    navigativeSpacer.width = -16;
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItems = @[navigativeSpacer, leftItem];
}

- (void)configBackTableView
{
    if (!_backTableView) {
        _backTableView = [[AirBackTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWith, kScreenHeight - 64) style:UITableViewStylePlain];
        [self.view addSubview:_backTableView];
        _backTableView.positionStatus = 0;
        _backTableView.backgroundColor = [UIColor clearColor];
        _backTableView.delegate = self;
        _backTableView.dataSource = self;
        _backTableView.bounces = NO;
        _backTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _backTableView.showsVerticalScrollIndicator = NO;
        self.automaticallyAdjustsScrollViewInsets = NO;
        
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] init];
        panGesture.delegate = self;
        panGesture.minimumNumberOfTouches = 1;
        [panGesture addTarget:self action:@selector(handlePanGesture:)];
        [_backTableView addGestureRecognizer:panGesture];
    }

}

- (void)configBackHeaderView
{
    UIView *singleHeaderView = [[UIView alloc] init];
    [self.view addSubview:singleHeaderView];
    _singleHeaderView = singleHeaderView;
    _singleHeaderView.hidden = YES;
    _singleHeaderView.alpha = 0;
    singleHeaderView.frame = CGRectMake(0, 0, kScreenWith, 57);
    singleHeaderView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *leftImageView = [[UIImageView alloc] init];
    [singleHeaderView addSubview:leftImageView];
    leftImageView.image = [UIImage imageNamed:@"l_search"];
    
    UIButton *titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [singleHeaderView addSubview:titleBtn];
    titleBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [titleBtn setTitleColor:[UIColor colorWithRed:68/255.0f green:68/255.0f blue:68/255.0f alpha:1] forState:UIControlStateNormal];
    [titleBtn setTitle:@"模仿Airbnb的效果" forState:UIControlStateNormal];
    titleBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [titleBtn addTarget:self action:@selector(expandClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _singleTitleBtn = titleBtn;
    
    [leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(singleHeaderView).with.offset(16);
        make.width.height.mas_equalTo(24);
        make.centerY.equalTo(singleHeaderView);
    }];
    
    [titleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftImageView.mas_right).with.offset(8);
        make.top.bottom.equalTo(singleHeaderView);
        make.right.equalTo(singleHeaderView).with.offset(-16);
    }];
    
    UIView *lineView = [[UIView alloc] init];
    [singleHeaderView addSubview:lineView];
    lineView.backgroundColor = [UIColor colorWithRed:221/255.0f green:221/255.0f blue:221/255.0f alpha:1];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(singleHeaderView);
        make.height.mas_equalTo(1);
    }];
}

- (UIButton *)configBackHeaderSubView:(UIView *)view leftImage:(NSString *)imageName titleBtn:(NSString *)title rightBtn:(NSString *)rightText isHaveLine:(BOOL)isHaveLine
{
    UIImageView *leftImage = [[UIImageView alloc] init];
    [view addSubview:leftImage];
    leftImage.image = [UIImage imageNamed:imageName];
    if (view.tag - HEADER_VIEW_SUBVIEW_TAG == 0) {
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeExpendView:)];
        tapGesture.numberOfTapsRequired = 1;
        tapGesture.numberOfTouchesRequired = 1;
        [view addGestureRecognizer:tapGesture];
    }
    
    UIButton *titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [view addSubview:titleBtn];
    titleBtn.tag = view.tag;
    [titleBtn setTitle:title forState:UIControlStateNormal];
    titleBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    titleBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [titleBtn setTitleColor:[UIColor colorWithRed:68/255.0f green:68/255.0f blue:68/255.0f alpha:1] forState:UIControlStateNormal];
    [titleBtn addTarget:self action:@selector(headerViewClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [view addSubview:rightBtn];
    [rightBtn setTitle:rightText forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [rightBtn setTitleColor:[UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1] forState:UIControlStateNormal];
    if (rightText.length < 1) {
        rightBtn.hidden = YES;
    } else {
        rightBtn.hidden = NO;
    }
    [rightBtn addTarget:self action:@selector(clearBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *lineView = [[UIView alloc] init];
    [view addSubview:lineView];
    lineView.backgroundColor = [UIColor colorWithRed:221/255.0f green:221/255.0f blue:221/255.0f alpha:1];
    lineView.hidden = !isHaveLine;
    
    [leftImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).with.offset(16);
        make.width.height.mas_equalTo(24);
        make.centerY.equalTo(view);
    }];
    
    [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view).with.offset(-18);
        make.width.mas_equalTo(60);
        make.centerY.equalTo(view);
    }];
    
    [titleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftImage.mas_right).with.offset(8);
        make.top.bottom.equalTo(view);
        make.right.equalTo(rightBtn.mas_left).with.offset(-8);
    }];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1);
        make.left.equalTo(view).with.offset(48);
        make.right.equalTo(view);
        make.bottom.equalTo(view);
    }];
    return titleBtn;
}

- (void)configBottomView
{
    _bottomView = [[UIView alloc] init];
    _bottomView.frame = CGRectMake(0, kScreenHeight - 47 - 64, kScreenWith, 47);
    _bottomView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:_bottomView];
}

- (void)setHeaderAndBottomHidden:(BOOL)hidden animated:(BOOL)animated
{
    __weak typeof(self) weakSelf = self;
    void (^block)() = ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (hidden) {
            strongSelf.bottomView.frame = CGRectMake(0, kScreenHeight - 47 - 64 + 47, kScreenWith, 47);
            strongSelf.singleHeaderView.frame = CGRectMake(0, - 57, kScreenWith, 57);
        } else {
            strongSelf.bottomView.hidden = NO;
            strongSelf.singleHeaderView.hidden = NO;
            strongSelf.bottomView.frame = CGRectMake(0, kScreenHeight - 47 - 64, kScreenWith, 47);
            strongSelf.singleHeaderView.frame = CGRectMake(0, 0, kScreenWith, 57);
        }
        
    };
    
    void (^completion)(BOOL) = ^(BOOL finished){
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.bottomView.hidden = NO;
        strongSelf.singleHeaderView.hidden = NO;
    };
    
    if (animated) {
        [UIView animateWithDuration:0.24 animations:block completion:completion];
    } else {
        block();
        completion(YES);
    }

}


#pragma mark - tableView Delegate and dataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == _backTableView) {
        return 2;
    } else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _backTableView) {
        return 1;
    } else {
        return kCellNum;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _backTableView) {
        static NSString *cellStr = @"parentTableViewCell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
            cell.backgroundColor = [UIColor clearColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (indexPath.section == 0) {
                
                UIView *headerBackView = [[UIView alloc] init];
                [cell.contentView addSubview:headerBackView];
                _headerCellContentView = cell.contentView;
                _headerBackView = headerBackView;
                headerBackView.backgroundColor = [UIColor whiteColor];
                headerBackView.frame = CGRectMake(0, 0, kScreenWith, HEADER_VIEW_HEIGHT);
                
                for (NSUInteger i = 0; i < 4; i ++) {
                    UIView *view = [[UIView alloc] init];
                    [headerBackView addSubview:view];
                    view.tag = HEADER_VIEW_SUBVIEW_TAG + i;
                    view.frame = CGRectMake(0, i * (HEADER_VIEW_HEIGHT/4.0f), CGRectGetWidth(self.view.frame), HEADER_VIEW_HEIGHT/4.0f);
                    if (i == 0) {
                        [self configBackHeaderSubView:view leftImage:@"l_up" titleBtn:@"" rightBtn:@"清空条件" isHaveLine:NO];
                    } else if (i == 1) {
                        _whereTitleBtn = [self configBackHeaderSubView:view leftImage:@"l_periphery" titleBtn:@"想去哪儿？" rightBtn:@"" isHaveLine:YES];
                    } else if (i == 2) {
                        _whenTitleBtn = [self configBackHeaderSubView:view leftImage:@"l_date" titleBtn:@"何时入住?" rightBtn:@"" isHaveLine:YES];
                    } else if (i == 3) {
                        _howManyTitleBtn = [self configBackHeaderSubView:view leftImage:@"supervisor" titleBtn:@"几人同行？" rightBtn:@"" isHaveLine:NO];
                    }
                    
                }
                
                UIView *lineView = [[UIView alloc] init];
                [headerBackView addSubview:lineView];
                lineView.backgroundColor = [UIColor colorWithRed:221/255.0f green:221/255.0f blue:221/255.0f alpha:1];
                [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.bottom.equalTo(cell);
                    make.height.mas_equalTo(1);
                }];
                
            } else {
                _tableView = [[AirTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
                [cell.contentView addSubview:_tableView];
                _tableView.frame = CGRectMake(0, 0, CGRectGetWidth(_backTableView.frame), CGRectGetHeight(_backTableView.frame));
                _tableView.backgroundColor = [UIColor whiteColor];
                _tableView.positionStatus = 0;
                _tableView.showsVerticalScrollIndicator = YES;
                _tableView.delegate = self;
                _tableView.dataSource = self;
                
            }
            
        }
        
        return cell;

    } else {
        static NSString *cellStr = @"childTableViewCell";
        
        UITableViewCell *cell;
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        cell.textLabel.text = [NSString stringWithFormat:@"--- %ld %ld", (long)tableView.tag, (long)indexPath.row];
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _backTableView) {
        if (indexPath.section == 0) {
            return HEADER_VIEW_HEIGHT;
        } else {
            return _backTableView.frame.size.height;
        }
    } else {
        return kRowHeight;
    }
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (scrollView == _backTableView) {
        _isMoveStop = NO;
        if (_tableView.positionStatus == 1 && _backTableView.positionStatus == 2) {
            _isLittleCanMoveUporDown = YES;
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_isMoveStop) {
        return;
    }
    if (scrollView == _backTableView) {
        
        _headerBackView.alpha = 1 - scrollView.contentOffset.y/(HEADER_VIEW_HEIGHT - 57) * 1.7;
        if (_headerBackView.alpha < 0.1) {
            _headerBackView.hidden = YES;
            if (_oldAlphaOffset < 1) {
                _oldAlphaOffset = scrollView.contentOffset.y;
            }
        } else {
            _headerBackView.hidden = NO;
        }
        
        if (_headerBackView.hidden) {
            _singleHeaderView.hidden = NO;
            _singleHeaderView.alpha = - (_oldAlphaOffset - scrollView.contentOffset.y)/((HEADER_VIEW_HEIGHT - 57) - _oldAlphaOffset);
        } else {
            _singleHeaderView.hidden = YES;
            _singleHeaderView.alpha = - (_oldAlphaOffset - scrollView.contentOffset.y)/((HEADER_VIEW_HEIGHT - 57) - _oldAlphaOffset);
        }

        
        AirTableView *tableview = _tableView;
        
        if (scrollView.contentOffset.y < _oldOffset.y) {
            
//            NSLog(@"下移");
            if (tableview.positionStatus == 0 && _backTableView.positionStatus == 0) {
            }
            
            if (tableview.positionStatus == 0 && _backTableView.positionStatus == 1) {

                [tableview setContentOffset:CGPointZero];
                
                if (_backTableView.contentOffset.y <= 57) {
                    _backTableView.positionStatus = 0;
                }
            }
            
            if (tableview.positionStatus == 0 && _backTableView.positionStatus == 2) {
                
                [tableview setContentOffset:CGPointZero];
                _backTableView.positionStatus = 1;
            }
            
            // 父tableview剩下一行， 子tableView开始滑动
            if (tableview.positionStatus == 1 && _backTableView.positionStatus == 2) {
                if (tableview.contentOffset.y > 57) {
                    [_backTableView setContentOffset:CGPointMake(0, HEADER_VIEW_HEIGHT - 0)];
                }
                if (tableview.contentOffset.y <= 0) {
                    
                    tableview.positionStatus = 0;
                    //    [_backTableView setContentOffset:CGPointMake(0, HEADER_VIEW_HEIGHT - kSingleHeight)];
                }
                
            }
            
            if (tableview.positionStatus == 2 && _backTableView.positionStatus == 2) {
                
            }
            
        } else {
//            NSLog(@"上移");
            // 两个tableview都处于展开正常态
            if (tableview.positionStatus == 0 && _backTableView.positionStatus == 0) {
                [tableview setContentOffset:CGPointZero];
                _backTableView.positionStatus = 1;
            }
            
            // 子tableiview的cell不动，父tableview的cell上移
            if (tableview.positionStatus == 0 && _backTableView.positionStatus == 1) {
                
                [tableview setContentOffset:CGPointZero];
                
                if (_backTableView.contentOffset.y >= HEADER_VIEW_HEIGHT - 57) {
                    _backTableView.positionStatus = 2;
                    [_backTableView setContentOffset:CGPointMake(0, HEADER_VIEW_HEIGHT - 57)];
                }
            }
            
            //
            if (tableview.positionStatus == 0 && _backTableView.positionStatus == 2) {
                [_backTableView setContentOffset:CGPointMake(0, HEADER_VIEW_HEIGHT - 57)];
                tableview.positionStatus = 1;
            }
            
            // 父tableview剩下一行， 子tableView开始滑动
            if (tableview.positionStatus == 1 && _backTableView.positionStatus == 2) {
                if (!_isLittleCanMoveUporDown) {
                     [_backTableView setContentOffset:CGPointMake(0, HEADER_VIEW_HEIGHT - 57)];
                }
               
            }
            
            if (tableview.positionStatus == 2 && _backTableView.positionStatus == 2) {
                
            }
            
        }
        
        _oldOffset = scrollView.contentOffset;
    } else {
        // 此处主要用于那个收缩状态的小View的上移隐藏和下移展示
       // _isLittleCanMoveUporDown
        if (_tableView.positionStatus == 1 && _backTableView.positionStatus == 2) {
            
            if (scrollView.contentOffset.y < _oldLittleOffset.y) {
                NSLog(@"下移");
            } else {
                
                if (_isLittleCanMoveUporDown) {
                    NSLog(@"%f",scrollView.contentOffset.y);

                } else {
                    _oldChildTableViewOffset = scrollView.contentOffset;
                }
            }
            
        }
        _oldLittleOffset = scrollView.contentOffset;
    }
    
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (HEADER_VIEW_HEIGHT - 57 <_backTableView.contentOffset.y && _backTableView.contentOffset.y < HEADER_VIEW_HEIGHT) {
        return;
    }
    
    if (scrollView == _backTableView) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.24];
        
        if (scrollView.contentOffset.y > (HEADER_VIEW_HEIGHT - 57)/2.0f) {
            [_backTableView setContentOffset:CGPointMake(0, HEADER_VIEW_HEIGHT - 57) animated:NO];
        } else {
            [_backTableView setContentOffset:CGPointMake(0, 0) animated:NO];
        }

        [UIView commitAnimations];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (HEADER_VIEW_HEIGHT - 57 <_backTableView.contentOffset.y && _backTableView.contentOffset.y < HEADER_VIEW_HEIGHT) {
        return;
    }
    if (scrollView == _backTableView) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.24];

        if (scrollView.contentOffset.y > (HEADER_VIEW_HEIGHT - 57)/2.0f) {
            [_backTableView setContentOffset:CGPointMake(0, HEADER_VIEW_HEIGHT - 57) animated:NO];
        } else {
            [_backTableView setContentOffset:CGPointMake(0, 0) animated:NO];
        }
        
        [UIView commitAnimations];
    }
}

#pragma mark - 手势调用函数
- (void)handlePanGesture:(UIPanGestureRecognizer *)panGesture
{
    if (!_isLittleCanMoveUporDown) {
        return;
    }
    if (_backTableView.contentOffset.y < HEADER_VIEW_HEIGHT) {
        self.singleHeaderView.frame = CGRectMake(0, 0, kScreenWith, 57);
        return;
    }
    UIScrollView *scroll = (UIScrollView *)_backTableView;
    if (scroll.isDragging || scroll.isDecelerating || scroll.isTracking) {
        CGPoint translation = [panGesture translationInView:_backTableView];
        //显示
        if (_tableView.positionStatus == 1 && _backTableView.positionStatus == 2){
            if (translation.y >= 20) {
                [self setHeaderAndBottomHidden:NO animated:YES];
            }
            //隐藏
            if (translation.y <= -20) {
                [self setHeaderAndBottomHidden:YES animated:YES];
            }
        }

    }
}



#pragma mark - action method

- (void)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)headerViewClick:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    NSUInteger index = btn.tag - HEADER_VIEW_SUBVIEW_TAG;
    if (index == 0) {
        if (_tableView.positionStatus == 0 && _backTableView.positionStatus == 0) {
            [_backTableView setContentOffset:CGPointMake(0, HEADER_VIEW_HEIGHT - 57) animated:YES];
        }
    } else if (index == 1) {
        [self whereToGoAction];
    } else if (index == 2) {
        [self whenToLiveAction];
    } else if (index == 3) {
        [self howManyPeopleAction];
    }
}

- (void)expandClick:(id)sender
{
    [_backTableView setContentOffset:_oldOffset animated:NO];
    if (_coverView) {
        return;
    }
    UIView *coverView = [[UIView alloc] init];
    coverView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    [self.view addSubview:coverView];
    coverView.frame = CGRectMake(0, 0, kScreenWith, kScreenHeight - 47);
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    tapGesture.numberOfTapsRequired = 1;
    tapGesture.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:tapGesture];
    _coverView = coverView;
    
    _isMoveStop = YES;
    [_headerBackView removeFromSuperview];
    [coverView addSubview:_headerBackView];
    _headerBackView.hidden = NO;
    _headerBackView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 46);
    _headerBackView.alpha = 0;
    for (UIView *view in _headerBackView.subviews) {
        view.alpha = 0;
    }
    [UIView animateWithDuration:0.3 animations:^{
        _headerBackView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), HEADER_VIEW_HEIGHT);
        _headerBackView.alpha = 1;
        for (UIView *view in _headerBackView.subviews) {
            view.alpha = 1;
        }
    }];

}

- (void)tapGesture:(id)sender
{
    [UIView animateWithDuration:0.3 animations:^{
        _coverView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [_headerBackView removeFromSuperview];
        [_headerCellContentView addSubview:_headerBackView];
        [_coverView removeFromSuperview];
        _coverView = nil;
    }];
}

- (void)closeExpendView:(id)sender
{
    [self tapGesture:sender];
    if (_tableView.positionStatus == 0 && _backTableView.positionStatus == 0) {
        [_backTableView setContentOffset:CGPointMake(0, HEADER_VIEW_HEIGHT - 57) animated:YES];
    }
}

// 清空条件 点击事件
- (void)clearBtnClick:(id)sender
{
    NSLog(@"清空条件 点击事件");
}

// 想去哪里 点击事件
- (void)whereToGoAction
{
    NSLog(@"想去哪里 点击事件");
}

// 时间 点击事件
- (void)whenToLiveAction
{
    NSLog(@"时间 点击事件");
}

// 几位 点击事件
- (void)howManyPeopleAction
{
    NSLog(@"几位 点击事件");
}

@end
