//
//  WAMapPoiCell.m
//

#import "WAMapPoiCell.h"
#import "Masonry.h"

@implementation WAMapPoiCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if(self)
  {
    //添加选中imageView
    self.selectImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"list_ic_selected_.png"]];
    [self.contentView addSubview:self.selectImageView];
    [self.selectImageView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.right.mas_equalTo(self.contentView).offset(-16.0);
      make.width.height.mas_equalTo(@14.0);
      make.centerY.mas_equalTo(self.contentView.mas_centerY);
    }];

    //添加poi名字label
    self.poiNameLabel = [[UILabel alloc]init];
    self.poiNameLabel.font = [UIFont systemFontOfSize:16.0];
    self.poiNameLabel.textColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0];
    [self.contentView addSubview:self.poiNameLabel];
    [self.poiNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.mas_equalTo(self.contentView).offset(16.0);
      make.top.mas_equalTo(self.contentView).offset(12.0);
      make.right.mas_equalTo(self.selectImageView.mas_left).offset(-8.0);
      make.height.mas_equalTo(@16.0);
    }];
    //添加行政地址label
    self.addressLabel = [[UILabel alloc]init];
    self.addressLabel.font = [UIFont systemFontOfSize:12.0];
    self.addressLabel.textColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0];
    [self.contentView addSubview:self.addressLabel];
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.mas_equalTo(self.contentView).offset(16.0);
      make.right.mas_equalTo(self.selectImageView.mas_left).offset(-8.0);
      make.top.mas_equalTo(self.poiNameLabel.mas_bottom).offset(8.0);
      make.height.mas_equalTo(@12.0);
    }];
    
    //去掉选中效果
    self.selectionStyle = UITableViewCellSelectionStyleNone;
  }
  return self;
}


@end
