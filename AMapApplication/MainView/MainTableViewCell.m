//
//  MainTableViewCell.m
//  AMapApplication
//

#import "MainTableViewCell.h"
#import "Masonry.h"

@interface MainTableViewCell()

@end

@implementation MainTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
  if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
  {
    self.nameLabel = [[UILabel alloc]init];
    [self.contentView addSubview:self.nameLabel];
    self.valueLabel = [[UILabel alloc]init];
    [self.contentView addSubview:self.valueLabel];
    self.locationBtn = [[UIButton alloc]init];
    [self.locationBtn setImage:[UIImage imageNamed:@"list_btn_location"] forState:UIControlStateNormal];
    [self.locationBtn addTarget:self action:@selector(forwardMapView) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.locationBtn];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.mas_equalTo(self.contentView).offset(10.0);
      make.width.mas_equalTo(@40);
      make.top.bottom.mas_equalTo(self.contentView);
    }];
    
    [self.locationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
      make.right.mas_equalTo(self.contentView).offset(-10);
      make.centerY.mas_equalTo(self.contentView.mas_centerY);
      make.width.mas_equalTo(@18);
      make.height.mas_equalTo(@30);
    }];
    [self.valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.mas_equalTo(self.nameLabel.mas_right).offset(5);
      make.top.bottom.mas_equalTo(self.contentView);
      make.right.mas_equalTo(self.locationBtn.mas_left).offset(-10);
    }];
  }
  self.selectionStyle = UITableViewCellSelectionStyleNone;
  return self;
}

-(void)setCurrentVO:(MainVCVO *)currentVO
{
  _currentVO = currentVO;
   self.nameLabel.text = currentVO.name;
  if(currentVO.isShowLocationBtn)
  {
    self.locationBtn.hidden = NO;
  }
  else
  {
    self.locationBtn.hidden = YES;
  }
}

-(void)forwardMapView
{
  __weak __typeof(self) weakSelf = self;
  if(self.delegate && [self.delegate respondsToSelector:@selector(didTouchMap:)])
  {
    [self.delegate didTouchMap:^(NSString *address) {
      __strong __typeof(weakSelf) strongSelf = weakSelf;
      strongSelf.valueLabel.text = address;
    }];
  }
}
@end
