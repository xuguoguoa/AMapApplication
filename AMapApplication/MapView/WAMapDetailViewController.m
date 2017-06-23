//
//  WAMapDetailViewController.m
//

#import "WAMapDetailViewController.h"
#import "Masonry.h"
#import <MAMapKit/MAMapKit.h>

@interface WAMapDetailViewController ()

@end

@implementation WAMapDetailViewController

-(instancetype)initWithBlock:(SelectMapLocation)aBlock
{
  self = [super init];
  if(self)
  {
    self.mapController = [[WAMapDetailController alloc]initWithBlock:aBlock];
    self.mapController.mapVC = self;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor whiteColor];
  //添加navigationbar
  [self addNavigationBar];
  
  //添加UISearchBar
  [self.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.right.mas_equalTo(self.view);
    self.searchBarTopHeight = make.top.mas_equalTo(self.navigationBar.mas_bottom);
    make.height.mas_equalTo(@40.0);
  }];
  
  //添加tableview
  [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
    self.tableHeight = make.height.mas_equalTo(TableViewHeight);
    make.left.right.bottom.mas_equalTo(self.view);
  }];
  
  //添加地图（使用高德的地图）
  [self.mapView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.right.mas_equalTo(self.view);
    make.top.mas_equalTo(self.searchBar.mas_bottom);
    make.bottom.mas_equalTo(self.tableView.mas_top);
  }];
  
  //添加地图刷新
  UIButton *refreshBtn = [[UIButton alloc]init];
  refreshBtn.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"map_refresh_.png"]];
  [refreshBtn addTarget:self.mapController action:@selector(refreshMap) forControlEvents:UIControlEventTouchUpInside];
  [self.mapView addSubview:refreshBtn];
  [refreshBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    make.bottom.right.mas_equalTo(self.mapView).offset(-16.0f);
    make.width.height.mas_equalTo(@50);
  }];
  
  //添加遮罩层
  [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.right.bottom.mas_equalTo(self.view);
    make.top.mas_equalTo(self.searchBar.mas_bottom);
  }];
  [self.mapController startLocation];
}

-(void)addNavigationBar
{
  self.navigationBar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 44.0f)];
  [self.view addSubview:self.navigationBar];
  //设置导航栏背景色
  UIImage *image = [UIImage imageNamed:@"nav_bg.png"];
  [self.navigationBar setBackgroundImage:image
                           forBarMetrics:UIBarMetricsDefault];
  //设置导航栏返回按钮
  UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
  backButton.frame = CGRectMake(0, 0, 44, 44);
  [backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
  [backButton setBackgroundImage:[UIImage imageNamed:@"nav_btn_b_back"] forState:UIControlStateNormal];
  
  //返回按钮
  UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
  //间隙，调整返回按钮左边距
  UIBarButtonItem *navSpacer = [[UIBarButtonItem alloc]
                                initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                target:nil action:nil];
  navSpacer.width = -16;
  UINavigationItem *navItem = [[UINavigationItem alloc] init] ;
  [navItem setLeftBarButtonItems:@[navSpacer,backBarButtonItem]];
  
  //导航栏确定按钮
  UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
  sureButton.frame = CGRectMake(0, 0, 44, 44);
  [sureButton addTarget:self.mapController action:@selector(sureButton) forControlEvents:UIControlEventTouchUpInside];
  [sureButton setTitle:@"确定" forState:UIControlStateNormal];
  [sureButton setTitleColor:[UIColor colorWithRed:51.0/255.0 green:170.0/255.0 blue:255.0/255.0 alpha:1.0] forState:UIControlStateNormal];
  sureButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
  UIBarButtonItem *sureBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:sureButton];
  UIBarButtonItem *rightnavSpacer = [[UIBarButtonItem alloc]
                                initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                target:nil action:nil];
  rightnavSpacer.width = -4;
  [navItem setRightBarButtonItems:@[rightnavSpacer,sureBarButtonItem]];

  self.navigationBar.items = [NSArray arrayWithObject:navItem];
}

-(void)backAction
{
  [self.navigationController popViewControllerAnimated:YES];
}

- (UIImage *)imageForColor:(UIColor *)color{
  CGRect rect = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width);
  UIGraphicsBeginImageContext(rect.size);
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextSetFillColorWithColor(context, [color CGColor]);
  CGContextFillRect(context, rect);
  UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return img;
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

-(UISearchBar *)searchBar
{
  if(!_searchBar)
  {
    _searchBar = [[UISearchBar alloc]init];
    _searchBar.delegate = self.mapController;
    [_searchBar setBackgroundImage:[self imageForColor:[UIColor colorWithRed:230.0/255.0 green:233.0/255.0 blue:240.0/255.0 alpha:1]]];
    _searchBar.placeholder = @"请输入搜索地址";
    [self.view addSubview:self.searchBar];
  }
  return _searchBar;
}

-(MAMapView *)mapView
{
  if(!_mapView)
  {
    _mapView = [[MAMapView alloc]init];
    _mapView.delegate = self.mapController;
    _mapView.showsUserLocation = YES;
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"map_btn_location_shop.png"]];
    [self.view addSubview:_mapView];
    [_mapView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.width.mas_equalTo(@28.0);
      make.height.mas_equalTo(@33.0);
      make.centerX.mas_equalTo(_mapView);
      make.centerY.mas_equalTo(_mapView).offset(-33/2);
    }];
  }
  return _mapView;
}

-(UITableView *)tableView
{
  if(!_tableView)
  {
    _tableView = [[UITableView alloc]init];
    _tableView.delegate = self.mapController;
    _tableView.dataSource = self.mapController;
    _tableView.separatorInset = UIEdgeInsetsZero;
    [self.view addSubview:_tableView];
  }
  return _tableView;
}

-(UIView *)backView
{
  if(!_backView)
  {
    _backView = [[UIView alloc]init];
    _backView.backgroundColor = [UIColor blackColor];
    _backView.alpha = 0;
    [self.view addSubview:self.backView];
  }
  return _backView;
}

-(void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
   //设置导航栏标题
  self.navigationBar.topItem.title = @"当前位置";
  NSMutableDictionary *titleTextAttributeDic = [[NSMutableDictionary alloc]initWithCapacity:1];
  [titleTextAttributeDic setObject:[UIFont systemFontOfSize:18.0] forKey:NSFontAttributeName];
  [titleTextAttributeDic setObject:[UIColor colorWithRed:51.0f/255.0f green:51.0f/255.0f blue:51.0f/255.0f alpha:1.0] forKey:NSForegroundColorAttributeName];
  self.navigationBar.titleTextAttributes = titleTextAttributeDic;
}
@end
