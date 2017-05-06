

#import "UDImageLabelButton.h"

#define edge_scale 0.7

@implementation UDImageLabelButton

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.upImageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 0, frame.size.width - 10, edge_scale * frame.size.height)];
        [self addSubview:self.upImageView];
        
        self.downLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, edge_scale * frame.size.height, frame.size.width, (1 - edge_scale) * frame.size.height)];
        self.downLabel.textColor = [UIColor whiteColor];
        self.downLabel.font = [UIFont systemFontOfSize:12.0];
        self.downLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.downLabel];
    }
    
    return self;
}

@end
