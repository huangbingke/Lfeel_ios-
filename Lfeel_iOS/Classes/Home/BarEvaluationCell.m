//
//  BarEvaluationCell.m
//  PocketJC
//
//  Created by kvi on 16/10/13.
//  Copyright © 2016年 CHY. All rights reserved.
//

#import "BarEvaluationCell.h"
#import "SLDevider.h"
#import "MWPhotoBrowser.h"
#import "NSAttributedString+YYText.h"
#import "CWStarRateView.h"

@interface BarEvaluationCell ()
@property (weak, nonatomic)  UILabel *dateLabel;
@property (weak, nonatomic)  UILabel *userName;
@property (weak, nonatomic)  UIImageView *userIcon;

@property (weak, nonatomic)  UIImageView *goodIcon;

@property (weak, nonatomic)  UILabel *contentsLabel;
@property (strong, nonatomic)  UIView *barImageView;
@property (weak, nonatomic)  UILabel *replayLabel;
@property (nonatomic, strong) NSMutableSet<UIImageView *> * imageViews;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ImageViewConstrint;

///  CWStarRateView
@property (nonatomic, strong) CWStarRateView * starView;
@property (nonatomic, strong)UIView * bgView1;

@end


@implementation BarEvaluationCell
{
    //      UIView * barImageView;
    NSArray * dic;
    
}




-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UIImageView *userIcon = [[UIImageView alloc]init];
        userIcon.image = [UIImage imageNamed:@"女性"];
        userIcon.contentMode = UIViewContentModeScaleToFill;
        [self.contentView addSubview:userIcon];
        self.userIcon = userIcon;
        
        UILabel * userName = [UILabel labelWithText:@"" font:12 textColor:HexColorInt32_t(333333) frame:CGRectZero];
        [self.contentView addSubview:userName];
        self.userName = userName;
        
       
        
        UILabel *contensLabel = [UILabel labelWithText:@"这个酒吧非常棒，气氛很好！" font:12 textColor:HexColorInt32_t(777777) frame:CGRectZero];
    
        [self.contentView addSubview:contensLabel];
        self.contentsLabel = contensLabel;
        
        UILabel *replayLabel = [UILabel labelWithText:@"" font:12 textColor:HexColorInt32_t(777777) frame:CGRectZero];
        [self.contentView addSubview:replayLabel];
        self.replayLabel = replayLabel;
        
        
        UIView * bgView = [[UIView alloc]init];
        [self.contentView addSubview:bgView];
        self.barImageView = bgView;
        
        
        UIImageView * iamgeView1 = nil;
        for (NSInteger i = 0; i < 4; i ++) {
            UIImageView *imageVie = [[UIImageView alloc]init];
            imageVie.backgroundColor = [UIColor clearColor];
            imageVie.hidden = YES;
            imageVie.tag = 10+i;
            [bgView addSubview:imageVie];
            imageVie.userInteractionEnabled = YES;
            
            [imageVie mas_makeConstraints:^(MASConstraintMaker *make) {
                if (iamgeView1) {
                    make.left.equalTo(iamgeView1.mas_right).offset(14);
                }else{
                    make.left.offset(16);
                }
                make.top.offset(0);
                make.width.mas_equalTo((kScreenWidth  - 70)/4  );
                make.height.mas_equalTo(67);
            }];
            
            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoClick:)];
            imageVie.userInteractionEnabled = YES;
            [imageVie addGestureRecognizer:tap];
            

            iamgeView1 = imageVie;
            
        }
        
        
        SLDevider * devider = [[SLDevider alloc]init];
        devider.backgroundColor = HexColorInt32_t(e5e5e5);
        [self.contentView addSubview:devider];
        
       
        CGFloat H = Fit375(34);
        userIcon.backgroundColor = HexColorInt32_t(ff0000);
        [userIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.and.left.offset(16);
            make.height.mas_equalTo(H);
            make.width.mas_equalTo(H);
        }];
        [userIcon layoutSubviews];
        [userIcon layoutIfNeeded];
        userIcon.cornerRadius = H/2;
       
        [userName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(userIcon.mas_centerY).offset(-5);
            make.left.equalTo(userIcon.mas_right).offset(Fit375(16));
        }];

        [contensLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(userName.mas_left).offset(0);
            make.top.equalTo(userName.mas_bottom).offset(13);
            make.right.offset(-16);
        }];
    
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(contensLabel.mas_bottom).offset(7);
            make.left.offset(0);
            make.width.mas_equalTo(kScreenWidth);
            make.height.mas_equalTo(67);
        }];
      
        [devider mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_bottom).offset(-1);
            make.left.offset(16);
            make.right.offset(kScreenWidth);
            make.height.mas_equalTo(1);
        }];
       
    }
    return self;
}

- (void)setEvaluation:(LfGoodsDetailEvlutionCommentsListModel *)evaluation{
    
    _evaluation = evaluation;
    self.replayLabel.hidden = YES;
    self.barImageView.hidden = YES;
    
    self.userName.text = evaluation.commentsName;
    self.contentsLabel.text = evaluation.content;
    [self.userIcon sd_setImageWithURL:[NSURL URLWithString:evaluation.commentIoc] placeholderImage:[UIImage imageNamed:@"女性"]];

   
    if (evaluation.commentsImg.count > 0 ) {
        self.replayLabel.hidden = NO;
        self.barImageView.hidden = NO;
        [self.replayLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.barImageView.mas_bottom).offset(9);
            make.left.offset(16);
            make.right.offset(-16);
        }];
        
        NSInteger i = 0;
        [self.barImageView.subviews makeObjectsPerformSelector:@selector(setHidden:) withObject:@(YES)];
        
        for (LfGoodsDetailEvlutionCommentsImgModel  * dict in evaluation.commentsImg) {
              UIImageView * imageV = (UIImageView *)[self.barImageView viewWithTag:10+i];
            imageV.hidden = NO;
            [imageV sd_setImageWithURL:[NSURL URLWithString:dict.imgUrl] placeholderImage:SLPlaceHolder];
            i++;
        }
    }
    
}


-(void)_seleTapImageViewBig:(UIButton *)sender{
    [self.amplificationImageRAC sendNext:sender];
}
-(RACSubject *)amplificationImageRAC{
    
    if (!_amplificationImageRAC) {
        _amplificationImageRAC = [RACSubject subject];
    }
    return _amplificationImageRAC;
}

- (void)dealloc{
    [self clearTmpPics];
    
}
- (void)clearTmpPics
{
  [[SDImageCache sharedImageCache] clearMemory];//可有可无
    
}

- (void)photoClick:(UITapGestureRecognizer *)tap {
    NSInteger tag = tap.view.tag - 10;
    NSMutableArray * photos = @[].mutableCopy;
    
   
    for (LfGoodsDetailEvlutionCommentsImgModel *dict in self.evaluation.commentsImg) {
        NSString * url = dict.imgUrl;
        MWPhoto * photo = [MWPhoto photoWithURL:[NSURL URLWithString:url]];
        [photos addObject:photo];
    }
   
    
    MWPhotoBrowser * controller = [[MWPhotoBrowser alloc] initWithPhotos:photos];
    [controller setCurrentPhotoIndex:tag];
    controller.enableSwipeToDismiss = NO;
    controller.displayActionButton = NO;
    controller.alwaysShowControls = YES;
    
    
    UITabBarController * vc = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    UINavigationController * nav = [vc.viewControllers objectAtIndex:vc.selectedIndex];
    nav.navigationBar.hidden = NO;
    [nav pushViewController:controller animated:YES];
}


@end

@implementation BarEvaluation



@end
