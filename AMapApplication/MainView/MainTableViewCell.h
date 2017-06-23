//
//  MainTableViewCell.h
//  AMapApplication
//

#import <UIKit/UIKit.h>
#import "MainVCVO.h"
typedef void(^RefreshLocationBlock) (NSString *address);

@protocol TouchMapBtn <NSObject>

-(void)didTouchMap:(RefreshLocationBlock)aRefreshBlock;

@end

@interface MainTableViewCell : UITableViewCell

@property(nonatomic, strong) UILabel *nameLabel;

@property(nonatomic, strong) UILabel *valueLabel;

@property(nonatomic, strong)UIButton *locationBtn;

@property(nonatomic, strong) MainVCVO *currentVO;

@property(nonatomic, weak) id<TouchMapBtn> delegate;

@end
