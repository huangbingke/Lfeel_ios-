//
//  BarEvaluationCell.h
//  PocketJC
//
//  Created by kvi on 16/10/13.
//  Copyright © 2016年 CHY. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BarEvaluation;
@interface BarEvaluationCell : UITableViewCell
///  cell.data = self.datas[indexPath.row];
@property (nonatomic, strong) LfGoodsDetailEvlutionCommentsListModel * evaluation;

///  放大图片
@property (nonatomic, strong) RACSubject * amplificationImageRAC;
@end

@interface BarEvaluation : NSObject

@property (nonatomic,   copy) NSString * shop_name;
@property (nonatomic,   copy) NSString * date;
@property (nonatomic,   copy) NSString * user_ame;
@property (nonatomic,   copy) NSString * content;
@property (nonatomic,   copy) NSString * replay;
@property (nonatomic, strong) NSArray<UIImage *> * images;

///  行高
@property (nonatomic, assign) CGFloat sl_rowHeight;
@end
