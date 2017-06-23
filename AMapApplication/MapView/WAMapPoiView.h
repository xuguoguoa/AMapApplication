//
//  WAMapPoiView.h
//

#import <UIKit/UIKit.h>
#import "Masonry.h"

@protocol WASearchResultTableDelegate <NSObject>

-(void)tableViewBeginScrool;

-(void)tableViewDidSelect:(NSIndexPath *)indexPath;

@end

@interface WAMapPoiView : UIView<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) UITableView *searchResultTable;

@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;

@property(nonatomic, strong) NSArray *pois;

@property(nonatomic, assign) id<WASearchResultTableDelegate> delegate;

@property(nonatomic, strong) MASConstraint *topHeight;

-(instancetype)initWithFrame:(CGRect)frame withPois:(NSArray *)pois;

@end
