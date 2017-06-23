//
//  ViewController.m
//  AMapApplication
//

#import "MainViewController.h"
#import "Masonry.h"

@interface MainViewController ()

@end

@implementation MainViewController

-(instancetype)init
{
  self = [super init];
  if(self)
  {
    self.mainController = [[MainController alloc]init];
    self.mainController.mainVC = self;
  }
  return self;
}
- (void)viewDidLoad
{
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor whiteColor];
  UINavigationBar *bar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 44.0)];
  [self.view addSubview:bar];
  [self.view addSubview:self.tableView];
  [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.right.mas_equalTo(self.view);
    make.top.mas_equalTo(bar.mas_bottom);
    make.bottom.mas_equalTo(self.view);
  }];
}


- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

-(UITableView *)tableView
{
  if(!_tableView)
  {
    _tableView = [[UITableView alloc]init];
    _tableView.delegate = self.mainController;
    _tableView.dataSource = self.mainController;
  }
  return _tableView;
}

@end
