//
//  WAMapDetailController.m
//

#import "WAMapDetailController.h"
#import "WAMapDetailViewController.h"
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import "Masonry.h"
#import "WAMapPoiView.h"
#import "WAMapPoiCell.h"


#define DefaultLocationTimeout  6
#define DefaultReGeocodeTimeout 3

@interface WAMapDetailController()<AMapLocationManagerDelegate,AMapSearchDelegate,WASearchResultTableDelegate>

@property (nonatomic, strong) AMapLocationManager *locationManager;

//通过逆地理解析得到的POI列表
@property (nonatomic, strong) NSMutableArray<AMapPOI *> *poiArray;

//通过关键字搜索得到的POI列表
@property (nonatomic, strong) NSArray<AMapPOI *> *searchPoiAry;

@property (nonatomic, strong) WAMapPoiView *mapPoiView;

@property (nonatomic, strong)AMapPOI *selectedPOI;

@property(nonatomic, copy) SelectMapLocation selectBlock;

@property (nonatomic, strong) AMapSearchAPI *search;
//当前所在的城市，POI搜索需要
@property (nonatomic, copy) NSString *currentCity;

@end

@implementation WAMapDetailController

-(instancetype)initWithBlock:(SelectMapLocation)aBlock
{
  self = [super init];
  if(self)
  {
    self.selectBlock = aBlock;
  }
  return self;
}
-(void)startLocation
{
  __weak __typeof(self) weakSelf = self;
  
  [self.mapVC.mapView removeAnnotations:self.mapVC.mapView.annotations];
  [self.locationManager requestLocationWithReGeocode:NO completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
    if (error)
    {
      NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
      
      if (error.code == AMapLocationErrorLocateFailed)
      {
        return;
      }
    }
    
    if (location)
    {
      __strong __typeof(weakSelf) strongSelf = weakSelf;
      [strongSelf.mapVC.mapView setZoomLevel:15.1 animated:NO];
      [strongSelf.mapVC.mapView setCenterCoordinate:location.coordinate animated:YES];
      //进行逆地址编码
      [strongSelf searchReGeocodeWithCoordinate:location.coordinate];
      }
  }];
}

//逆地址编码
- (void)searchReGeocodeWithCoordinate:(CLLocationCoordinate2D)coordinate
{
  AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
  regeo.location = [AMapGeoPoint locationWithLatitude:coordinate.latitude longitude:coordinate.longitude];
  regeo.requireExtension = YES;
  
  [self.search AMapReGoecodeSearch:regeo];
}

//POI搜索
- (void)searchPoiByKeyword:(NSString *)keyword
{
  [self.search cancelAllRequests];
  self.mapVC.backView.alpha = 0;
  self.mapPoiView.pois = nil;
  [self.mapPoiView.searchResultTable reloadData];
  UIView *lastView = [self.mapVC.view.subviews lastObject];
  if(![lastView isKindOfClass:WAMapPoiView.class])
  {
    [self.mapVC.view addSubview:self.mapPoiView];
  }
  [self.mapPoiView.indicatorView startAnimating];
  self.mapPoiView.topHeight.offset(0);
  AMapPOIKeywordsSearchRequest *request = [[AMapPOIKeywordsSearchRequest alloc] init];
  request.keywords = keyword;
  request.requireSubPOIs = YES;
  request.city = self.currentCity;
  [self.search AMapPOIKeywordsSearch:request];
}

#pragma mark - AMapSearchDelegate
- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error
{
  NSLog(@"Error: %@", error);
}

/* 逆地理编码回调. */
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
  if (response.regeocode != nil)
  {
    self.currentCity = response.regeocode.addressComponent.city;
    [self.poiArray removeAllObjects];
    AMapPOI *addressPoi = [[AMapPOI alloc]init];
    addressPoi.name = @"[位置]";
    addressPoi.address = response.regeocode.formattedAddress;
    AMapGeoPoint *point = [[AMapGeoPoint alloc]init];
    point.longitude = request.location.longitude;
    point.latitude = request.location.latitude;
    addressPoi.location = point;
    [self.poiArray addObject:addressPoi];
    self.selectedPOI = addressPoi;
    [self.poiArray addObjectsFromArray:response.regeocode.pois];
    [self.mapVC.tableView reloadData];
  }
}
/* POI 搜索回调. */
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
  [self.mapPoiView.indicatorView stopAnimating];
  self.mapPoiView.topHeight.offset(-(self.mapPoiView.indicatorView.frame.size.height+10));
  if(response.pois.count>0)
  {
    self.searchPoiAry = response.pois;
    self.mapPoiView.pois = response.pois;
    [self.mapPoiView.searchResultTable reloadData];
  }
}

#pragma mark - MAMapView Delegate
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
//  if ([annotation isKindOfClass:[MAPointAnnotation class]])
//  {
//    static NSString *pointReuseIndetifier = @"pointReuseIndetifier";
//    
//    MAAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
//    if (annotationView == nil)
//    {
//      annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndetifier];
//    }
//    
//    annotationView.canShowCallout = NO;
//    annotationView.image = [UIImage imageNamed:@"map_btn_location_shop.png"];
//    annotationView.draggable = NO;
//    return annotationView;
//  }
  
  return nil;
}

- (void)mapView:(MAMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
  
}
- (void)mapView:(MAMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
  
  
}

- (void)mapView:(MAMapView *)mapView mapWillMoveByUser:(BOOL)wasUserAction
{
  
}

- (void)mapView:(MAMapView *)mapView mapDidMoveByUser:(BOOL)wasUserAction
{
  if(wasUserAction)
  {
    CLLocationCoordinate2D coordinate = mapView.centerCoordinate;
    NSLog( @"%@", [NSString stringWithFormat:@"long%f ====  lat%f",coordinate.longitude, coordinate.latitude]);
    [self searchReGeocodeWithCoordinate:coordinate];
  }
}

- (void)mapView:(MAMapView *)mapView mapDidZoomByUser:(BOOL)wasUserAction
{
  
}
- (void)mapView:(MAMapView *)mapView mapWillZoomByUser:(BOOL)wasUserAction
{
  
}

-(AMapLocationManager *)locationManager
{
  if(!_locationManager)
  {
    _locationManager = [[AMapLocationManager alloc] init];
    [_locationManager setDelegate:self];
    [_locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    [_locationManager setPausesLocationUpdatesAutomatically:NO];
    [_locationManager setAllowsBackgroundLocationUpdates:YES];
    [_locationManager setLocationTimeout:DefaultLocationTimeout];
    [_locationManager setReGeocodeTimeout:DefaultReGeocodeTimeout];
  }
  return _locationManager;
}


-(AMapSearchAPI*)search
{
  if(!_search)
  {
    _search = [[AMapSearchAPI alloc] init];
    _search.delegate = self;
  }
  return _search;
}

-(NSMutableArray *)poiArray
{
  if(!_poiArray)
  {
    _poiArray = [[NSMutableArray alloc]init];
  }
  return _poiArray;
}

-(WAMapPoiView *)mapPoiView
{
  if(!_mapPoiView)
  {
    self.mapPoiView = [[WAMapPoiView alloc]initWithFrame:CGRectMake(0, 20.0f+40.0f, self.mapVC.view.frame.size.width, self.mapVC.view.frame.size.height-20.0f-40.0f) withPois:nil];
    self.mapPoiView.delegate = self;
  }
  return _mapPoiView;
}
#pragma mark tableview代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return self.poiArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return 60.0f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *identifier = @"POICell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
  if(!cell)
  {
    cell = [[WAMapPoiCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
  }
  WAMapPoiCell *poiCell = (WAMapPoiCell *)cell;
  poiCell.poiNameLabel.text = self.poiArray[indexPath.row].name;
  poiCell.addressLabel.text = self.poiArray[indexPath.row].address;
  if(indexPath.row == 0)
  {
    poiCell.selectImageView.hidden = NO;
  }
  else
  {
    poiCell.selectImageView.hidden = YES;
  }

  return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  if(indexPath.row != 0)
  {
    WAMapPoiCell *firstcell = (WAMapPoiCell *)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    firstcell.selectImageView.hidden = YES;
  }
  WAMapPoiCell *cell = (WAMapPoiCell *)[tableView cellForRowAtIndexPath:indexPath];
  cell.selectImageView.hidden = NO;
  AMapPOI *poi = self.poiArray[indexPath.row];
  self.selectedPOI = poi;
  CLLocationCoordinate2D coordinate;
  coordinate.longitude = poi.location.longitude;
  coordinate.latitude = poi.location.latitude;
  [self.mapVC.mapView setCenterCoordinate:coordinate animated:YES];
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
  WAMapPoiCell *cell = (WAMapPoiCell *)[tableView cellForRowAtIndexPath:indexPath];
  cell.selectImageView.hidden = YES;
}

#pragma mark UISearchBar代理
//开始编辑
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
  [searchBar setShowsCancelButton:YES animated:YES];
  [self upMapView];
  
  for (UIView *searchbuttons in [searchBar.subviews[0] subviews])
  {
    if ([searchbuttons isKindOfClass:[UIButton class]])
    {
      UIButton *cancelButton = (UIButton*)searchbuttons;
      cancelButton.enabled = YES;
      [cancelButton setTitleColor:[UIColor colorWithRed:51.0/255.0 green:170.0/255.0 blue:255.0/255.0 alpha:1.0] forState:UIControlStateNormal];
      UIImage *bgImg = [[UIImage alloc]init];
      [cancelButton setBackgroundImage:bgImg forState:UIControlStateNormal];
      [cancelButton setBackgroundImage:bgImg forState:UIControlStateHighlighted];
      [cancelButton setTitleShadowColor:[UIColor clearColor] forState:UIControlStateNormal];
      [cancelButton.titleLabel setShadowOffset:CGSizeMake(0, 0)];
      cancelButton.titleLabel.font = [UIFont systemFontOfSize:14];
      break;
    }
  }
  return YES;
}

//键盘回车
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
  [searchBar resignFirstResponder];
  [searchBar setShowsCancelButton:NO animated:YES];

  [self searchPoiByKeyword:searchBar.text];
}

//搜索框输入
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
  if ([@"" isEqualToString:searchText]) {
    searchBar.placeholder = @"请输入搜索地址";
    [self.search cancelAllRequests];
    [self.mapPoiView removeFromSuperview];
    self.mapVC.backView.alpha = 0.3;
  }
  else
  {
    [self searchPoiByKeyword:searchText];
  }
}
//searchbar 取消按钮点击
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
  if(self.mapPoiView)
  {
    [self.mapPoiView removeFromSuperview];
  }
  [searchBar setShowsCancelButton:NO animated:YES];
  [searchBar resignFirstResponder];
  [self downMapView];
}

-(void)upMapView
{
  self.mapVC.searchBarTopHeight.offset(-40.0);
  self.mapVC.tableHeight.equalTo(@(TableViewHeight+64.0));
  [UIView animateWithDuration:0.2 animations:^{
    [self.mapVC.view layoutIfNeeded];
    [self.mapVC.backView setAlpha:0.3];
  } completion:^(BOOL finished) {
  }];
}

-(void)downMapView
{
  self.mapVC.searchBarTopHeight.offset(0);
  self.mapVC.tableHeight.mas_equalTo(TableViewHeight);
  [UIView animateWithDuration:0.2 animations:^{
    [self.mapVC.view layoutIfNeeded];
    [self.mapVC.backView setAlpha:0];
  } completion:^(BOOL finished) {
    
  }];
}
#pragma mark WASearchResultTableDelegate代理
-(void)tableViewBeginScrool
{
  [self.mapVC.searchBar resignFirstResponder];
}

-(void)tableViewDidSelect:(NSIndexPath *)indexPath
{
  [self.mapVC.searchBar setShowsCancelButton:NO animated:YES];
  [self.mapVC.searchBar resignFirstResponder];
  AMapPOI * mapPoi = self.searchPoiAry[indexPath.row];
  CLLocationCoordinate2D coordinate;
  coordinate.latitude = mapPoi.location.latitude;
  coordinate.longitude = mapPoi.location.longitude;
  [self.mapVC.mapView setCenterCoordinate:coordinate animated:YES];
  //进行逆地理解析
  [self searchReGeocodeWithCoordinate:coordinate];
  [self downMapView];
  
}

-(void)refreshMap
{
  [self startLocation];
}

-(void)sureButton
{
  [self.mapVC.navigationController popViewControllerAnimated:YES];
  self.selectBlock(self.selectedPOI.address, self.selectedPOI.location.latitude, self.selectedPOI.location.longitude);
}

@end
