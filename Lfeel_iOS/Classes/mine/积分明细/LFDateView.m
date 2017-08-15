//
//  LFDateView.m
//  Lfeel_iOS
//
//  Created by kvi on 2017/2/27.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import "LFDateView.h"
#import "GFCalendarView.h"
@interface LFDateView ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *starLabel;
@property (weak, nonatomic) IBOutlet UILabel *endLabel;
@property (weak, nonatomic) IBOutlet UIView *TabbleviEW;
@property (weak, nonatomic) IBOutlet UILabel *titileText;

@end


@implementation LFDateView
{
    GFCalendarView *calendar ,*calendar1;
    UIView * timeView;
    NSString * string ;
    NSArray * array;
    
}




//
- (IBAction)TapAllRecord:(id)sender {
    self.TabbleviEW.hidden = NO;
}

-(void)tapSelectTitle:(UIButton*)sender{
    self.TabbleviEW.hidden = YES;;
    self.titileText.text = array[sender.tag-10];
    
    if (self.didType) {
        self.didType(sender.tag-10);
        }
}


- (IBAction)TapDidStarTime:(id)sender {
    SLLog2(@"开始时间");
    [self setTimerView:self.starLabel];
}
- (IBAction)TapDidEndTime:(id)sender {
    SLLog2(@"结束时间");
    [self setTimerView1:self.endLabel];
    
}


-(void)setTimerView:(UILabel *)titleLebel{
    
    if (calendar== nil) {
        
        CGPoint origin = CGPointMake(10.0, 64.0 + 70.0);
        
        calendar = [[GFCalendarView alloc] initWithFrameOrigin:origin width:kScreenWidth-Fit375(26)];
        calendar.backgroundColor = HexColorInt32_t(ffffff);
        @weakify(calendar);
        @weakify(self);
        // 点击某一天的回调
        calendar.didSelectDayHandler = ^(NSInteger year, NSInteger month, NSInteger day) {
            @strongify(self);
            NSString *starString =[NSString stringWithFormat:@"%ld-%ld-%ld", year, month, day];
            NSString *starString1 =[NSString stringWithFormat:@"%ld-%ld-%ld", year, month, day];
            SLLog2(@"%@ ",starString);
            titleLebel.text = starString;
            
            if (![starString isEqualToString:@""]) {
                calendar_weak_.hidden = YES;
                if (self.didStarTimer) {
                    self.didStarTimer(starString,starString1);
                }
                titleLebel.text = starString;
            }else{
       
            }
        };
        
        [self.window addSubview:calendar];
    }else{
        
        calendar.hidden = NO;
    }

}

-(void)setTimerView1:(UILabel *)titleLebel{
    
    if (calendar1== nil) {
        
        CGPoint origin = CGPointMake(10.0, 64.0 + 70.0);
        
        calendar1 = [[GFCalendarView alloc] initWithFrameOrigin:origin width:kScreenWidth-Fit375(26)];
        calendar1.backgroundColor = HexColorInt32_t(ffffff);
        @weakify(calendar1);
        // 点击某一天的回调
         @weakify(self);
        calendar1.didSelectDayHandler = ^(NSInteger year, NSInteger month, NSInteger day) {
             @strongify(self);
            NSString *starString =[NSString stringWithFormat:@"%ld-%ld-%ld", year, month, day];
            NSString *starString1 =[NSString stringWithFormat:@"%ld-%ld-%ld", year, month, day];
            SLLog2(@"%@ ",starString);
            titleLebel.text = starString;
            
            if (![starString isEqualToString:@""]) {
                calendar1_weak_.hidden = YES;
                
                SLLog2(@"x11111111xxxx");
                titleLebel.text = starString;
                if (self.didendTimer) {
                    self.didendTimer (starString,starString1);
                }
                
            }else{
                SLLog2(@"xxx222222222xx");
            }
            
        };
        
        [self.window addSubview:calendar1];
    }else{
        
        calendar1.hidden = NO;
    }
 
}

 
-(void)awakeFromNib{
    [super awakeFromNib];
    [self.bgView rm_fitAllConstraint];
    string = [self update];
    array = @[@"所有记录",@"积分充值",@"积分提现"];
    UITableView *tabbleView = [[UITableView alloc]initWithFrame:Rect(0, 0, self.TabbleviEW.width, self.TabbleviEW.height +50) style:UITableViewStylePlain];
    tabbleView.dataSource  = self;
    tabbleView.delegate = self;
    [self.TabbleviEW addSubview:tabbleView];
    self.TabbleviEW.hidden = YES;
    self.starLabel.text = [self setupRequestMonth];
    self.endLabel.text = [self update:1];
    
}


//
-(NSString *)update{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970]*1000;
    NSString *timeString = [NSString stringWithFormat:@"%f", a];
    return timeString;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return array.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" ];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = array[indexPath.row];
    
    
    UIButton * button = [UIButton buttonWithType:(UIButtonTypeCustom)];
    button.frame = Rect(0, 0, cell.width, cell.height);
    button.tag = 10+indexPath.row;
    [button addTarget:self action:@selector(tapSelectTitle:)];
    [cell  addSubview:button];
    
    
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SLLog2(@"index path :%zd", indexPath.row);
    
}
//
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    self.TabbleviEW.hidden = YES;;
//    
//    self.titileText.text = array[indexPath.row];
//    
//    if (!self.didType) {
//        self.didType(self.titileText.text);
//    }
//    
//}

-(NSString *)update:(NSInteger)type {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    if (type  == 1) {
        [formatter setDateFormat:@"YYYY-MM-dd"];
    }else{
        [formatter setDateFormat:@"YYYY-MM-dd"];
    }
    //现在时间,你可以输出来看下是什么格式
    
    NSDate *datenow = [NSDate date];
    
    //----------将nsdate按formatter格式转成nsstring
    
    NSString *nowtimeStr = [formatter stringFromDate:datenow];
    
    NSLog(@"nowtimeStr =  %@",nowtimeStr);
    return nowtimeStr;
}



-(void)setHidden1:(BOOL)hidden1{
    self.TabbleviEW.hidden =  hidden1;
    calendar.hidden = hidden1;
    calendar1.hidden = hidden1;
}
- (NSString *)setupRequestMonth
{
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *lastMonthComps = [[NSDateComponents alloc] init];
    //    [lastMonthComps setYear:1]; // year = 1表示1年后的时间 year = -1为1年前的日期，month day 类推
    [lastMonthComps setMonth:-1];
    NSDate *newdate = [calendar dateByAddingComponents:lastMonthComps toDate:currentDate options:0];
    NSString *dateStr = [formatter stringFromDate:newdate];
    NSLog(@"date str = %@", dateStr);
    return dateStr;
}




@end
