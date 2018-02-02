//
//  ViewController.m
//  仿造淘宝商品详情页
//
//  Created by yixiang on 16/3/23.
//  Copyright © 2016年 yixiang. All rights reserved.
//

#import "YXSuspendTabViewController.h"
#import "YXTabView.h"
#import "YXHeader.h"


@interface YXSuspendTabViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) YXIgnoreHeaderTouchAndRecognizeSimultaneousTableView *tableView;

@property (nonatomic, assign) BOOL isTopIsCanNotMoveTabView;

@property (nonatomic, assign) BOOL isTopIsCanNotMoveTabViewPre;

@property (nonatomic, assign) BOOL canScroll;

@property (nonatomic, strong) YXTabViewStyle *tabViewStyle;

@end

@implementation YXSuspendTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tabViewStyle = [YXTabViewStyle defaultTabViewStyle];
    _tabViewStyle.tabBarBackgroundColor = [UIColor lightGrayColor];
    
    [self initUI];
    
    NSLog(@"main screen rect: %@", NSStringFromCGRect([UIScreen mainScreen].bounds));
    NSLog(@"self view rect: %@", NSStringFromCGRect(self.view.frame));
}

-(void)initUI{
    self.view.backgroundColor = [UIColor greenColor];
    [self initPicView];
    _tableView = [[YXIgnoreHeaderTouchAndRecognizeSimultaneousTableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, _tabViewStyle.bottomBarHeight, 0));
    }];
    
    //透明header
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 250)];
    headView.backgroundColor = [UIColor clearColor];
    _tableView.tableHeaderView = headView;
    
    [self initTopView];
    [self initBottomView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(acceptMsg:) name:kYXLeaveTopNotificationName object:nil];
}

-(void)initPicView{
    UIImageView *picView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetWidth(self.view.frame))];
    picView.image = [UIImage imageNamed:@"avatar"];
    picView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImage:)];
    [picView addGestureRecognizer:tapGesture];
    [self.view addSubview:picView];
}

-(void)clickImage:(UITapGestureRecognizer *)gesture{
    NSLog(@"点击图片操作");
    [self.tableView reloadData];
}


-(void)acceptMsg : (NSNotification *)notification{
    //NSLog(@"%@",notification);
    NSDictionary *userInfo = notification.userInfo;
    NSString *canScroll = userInfo[@"canScroll"];
    if ([canScroll isEqualToString:@"1"]) {
        _canScroll = YES;
    }
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


-(void)initTopView{
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), _tabViewStyle.topBarHeight)];
    topView.backgroundColor = [UIColor orangeColor];
    UILabel *textLabel = [[UILabel alloc] initWithFrame:topView.bounds];
    textLabel.text = @"顶部BAR";
    textLabel.textAlignment = NSTextAlignmentCenter;
    [topView addSubview:textLabel];
    [self.view addSubview:topView];
}

-(void)initBottomView{
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = [UIColor orangeColor];
    UILabel *textLabel = [[UILabel alloc] init];
    textLabel.text = @"底部BAR";
    textLabel.textAlignment = NSTextAlignmentCenter;
    [bottomView addSubview:textLabel];
    [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(bottomView);
    }];
    [self.view addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(_tabViewStyle.bottomBarHeight);
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    CGFloat height = 0.;
    if (section==0) {
        height = 160.;
    }else if(section==1){
        height = 60.;
    }else if(section==2){
        height = CGRectGetHeight(tableView.frame) - self.tabViewStyle.topBarHeight;
    }
    return height;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSInteger section  = indexPath.section;

    if (section==0) {
        UILabel *textlabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, CGRectGetWidth(self.view.frame), 20)];
        [cell.contentView addSubview:textlabel];
        textlabel.text = @"价格区";
        textlabel.textAlignment = NSTextAlignmentCenter;
    }else if(section==1){
        UILabel *textlabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, CGRectGetWidth(self.view.frame), 20)];
        [cell.contentView addSubview:textlabel];
        textlabel.text = @"sku区";
        textlabel.textAlignment = NSTextAlignmentCenter;
    }else if(section==2){
        NSArray *tabConfigArray = @[@{
            @"title":@"图文介绍",
            @"view":@"PicAndTextIntroduceView",
            @"data":@"图文介绍的数据",
            @"position":@0
        },@{
            @"title":@"商品详情",
            @"view":@"ItemDetailView",
            @"data":@"商品详情的数据",
            @"position":@1
        },@{
            @"title":@"评价(273)",
            @"view":@"CommentView",
            @"data":@"评价的数据",
            @"position":@2
        }];
        
        CGRect frame = CGRectMake(0, 0, YX_SCREEN_WIDTH, CGRectGetHeight(tableView.frame) - self.tabViewStyle.topBarHeight);
        YXTabView *tabView = [[YXTabView alloc] initWithFrame:frame tabConfigArray:tabConfigArray style:_tabViewStyle];
        [cell.contentView addSubview:tabView];
    }
    return cell;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat tabOffsetY = [_tableView rectForSection:2].origin.y - self.tabViewStyle.topBarHeight;
    CGFloat offsetY = scrollView.contentOffset.y;
    
    _isTopIsCanNotMoveTabViewPre = _isTopIsCanNotMoveTabView;
    if (offsetY>=tabOffsetY) {//tab滑到了顶端
        scrollView.contentOffset = CGPointMake(0, tabOffsetY);
        _isTopIsCanNotMoveTabView = YES;
    }else{
        _isTopIsCanNotMoveTabView = NO;
    }
    if (_isTopIsCanNotMoveTabView != _isTopIsCanNotMoveTabViewPre) {//临界状态
        if (!_isTopIsCanNotMoveTabViewPre && _isTopIsCanNotMoveTabView) {//滑动到顶端
            //NSLog(@"滑动到顶端");
            [[NSNotificationCenter defaultCenter] postNotificationName:kYXScrollToTopNotificationName object:nil userInfo:@{@"canScroll":@"1"}];
            _canScroll = NO;
        }
        if(_isTopIsCanNotMoveTabViewPre && !_isTopIsCanNotMoveTabView){
            //NSLog(@"离开顶端");
            if (!_canScroll) {
                scrollView.contentOffset = CGPointMake(0, tabOffsetY);
            }
        }
    }
}

@end
