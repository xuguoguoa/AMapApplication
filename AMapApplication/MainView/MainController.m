//
//  MainController.m
//  AMapApplication
//

#import "MainController.h"
#import "MainViewController.h"
#import "MainTableViewCell.h"
#import "MainVCVO.h"
#import "WAMapDetailViewController.h"

@interface MainController()<UITableViewDelegate, UITableViewDataSource, TouchMapBtn>

@property(nonatomic, strong) NSMutableArray *sourceAry;

@property(nonatomic, strong) NSIndexPath *longitudeIndex;

@property(nonatomic, strong) NSIndexPath *latitudeIndex;

@end

@implementation MainController

-(instancetype)init
{
  if(self = [super init])
  {
    [self prepareSourceData];
  }
  return self;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return self.sourceAry.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *const  identifier = @"MainCell";
  MainTableViewCell *cell = [[MainTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
  cell.currentVO = self.sourceAry[indexPath.row];
  cell.delegate = self;
  if([cell.currentVO.code isEqualToString:@"longitude"])
  {
    self.longitudeIndex = indexPath;
  }
  else if([cell.currentVO.code isEqualToString:@"latitude"])
  {
    self.latitudeIndex = indexPath;
  }
  return cell;
}

-(void)prepareSourceData
{
  MainVCVO *vo1 = [[MainVCVO alloc]init];
  vo1.name = @"位置";
  vo1.code = @"address";
  vo1.isShowLocationBtn = YES;
  MainVCVO *vo2 = [[MainVCVO alloc]init];
  vo2.name = @"经度";
  vo2.code = @"longitude";
  MainVCVO *vo3 = [[MainVCVO alloc]init];
  vo3.name = @"纬度";
  vo3.code = @"latitude";
  self.sourceAry = [[NSMutableArray alloc]initWithObjects:vo1,vo2,vo3, nil];
}
-(void)didTouchMap:(RefreshLocationBlock)aRefreshBlock
{
  __weak __typeof(self) weakSelf = self;
  WAMapDetailViewController *mapVC = [[WAMapDetailViewController alloc]initWithBlock:^(NSString *address, double latitude, double longitude) {
    aRefreshBlock(address);
    __strong __typeof(weakSelf) strongSelf = weakSelf;
    MainTableViewCell *longCell = [strongSelf.mainVC.tableView cellForRowAtIndexPath:self.longitudeIndex];
    longCell.valueLabel.text = [NSString stringWithFormat:@"%f",longitude];
    MainTableViewCell *latCell = [strongSelf.mainVC.tableView cellForRowAtIndexPath:self.latitudeIndex];
    latCell.valueLabel.text = [NSString stringWithFormat:@"%f",latitude];
  }];
  [self.mainVC.navigationController pushViewController:mapVC animated:YES];
}
@end
