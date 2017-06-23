//
//  WAMapPoiView.m
//

#import "WAMapPoiView.h"
#import <AMapSearchKit/AMapSearchAPI.h>
#import "WAMapPoiCell.h"

@implementation WAMapPoiView

-(instancetype)initWithFrame:(CGRect)frame withPois:(NSArray *)pois
{
  self = [super initWithFrame:frame];
  if(self)
  {
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.indicatorView];
    [self addSubview:self.searchResultTable];
    [self.searchResultTable mas_makeConstraints:^(MASConstraintMaker *make) {
      self.topHeight = make.top.mas_equalTo(self.indicatorView.mas_bottom).mas_offset(0);
      make.left.right.bottom.mas_equalTo(self);
    }];
    self.pois = pois;
  }
  return self;
}
-(UITableView *)searchResultTable
{
  if(!_searchResultTable)
  {
    _searchResultTable = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    _searchResultTable.delegate = self;
    _searchResultTable.dataSource = self;
    _searchResultTable.separatorInset = UIEdgeInsetsZero;
    _searchResultTable.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
  }
  return _searchResultTable;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return self.pois.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return 60.0f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *const identifier = @"PoiReuseCell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
  if(!cell)
  {
    cell = [[WAMapPoiCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
  }
  WAMapPoiCell *poiCell = (WAMapPoiCell *)cell;
  AMapPOI *poi = (AMapPOI *)self.pois[indexPath.row];
  NSString *addressStr = [NSString stringWithFormat:@"%@%@%@",poi.province,poi.city,poi.address];
  poiCell.poiNameLabel.text = poi.name;
  poiCell.addressLabel.text = addressStr;
  poiCell.selectImageView.hidden = YES;
  return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  [self removeFromSuperview];
  if(self.delegate && [self.delegate respondsToSelector:@selector(tableViewDidSelect:)])
  {
    [self.delegate tableViewDidSelect:indexPath];
  }
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
  if(self.delegate && [self.delegate respondsToSelector:@selector(tableViewBeginScrool)])
  {
    [self.delegate tableViewBeginScrool];
  }
}

-(UIActivityIndicatorView *)indicatorView
{
  if(!_indicatorView)
  {
    _indicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _indicatorView.center = CGPointMake(self.frame.size.width/2, _indicatorView.frame.size.width/2 +10);
  }
  return _indicatorView;
}

@end
