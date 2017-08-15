//
//  LFIntergerDetailViewController.m
//  Lfeel_iOS
//
//  Created by kvi on 2017/2/27.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import "LFIntergerDetailViewController.h"
#import "LFIntergerDetailCell.h"
#import "LFDateView.h"

@interface LFIntergerDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
///  <#Description#>
@property (nonatomic, strong) LFDateView * DateHeaderView;
@property (nonatomic, strong)NSMutableArray <LFIntegralModel *> * datas;
@property (nonatomic ,strong) UITableView * tabbleView;
@end

@implementation LFIntergerDetailViewController
{
    UIView * headerView;
    NSString * endTimer1,*starTimer1,*starpage,*endTimer2,*starTimer2;
    NSInteger integralType1;
    
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _datas = [NSMutableArray array];
    starpage = @"0";
    [self setupNavigationBar];
    [self CreateView];
    [self HTTPRequestpersonal];
    [self TapView];
    
}

-(void)TapView{
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapViewHied:)];
    [self.view addGestureRecognizer:tap];
}
-(void)tapViewHied:(UITapGestureRecognizer *)tap{
    self.DateHeaderView.hidden1 = YES;
}

/// 初始化NavigaitonBar
- (void)setupNavigationBar {
    
    @weakify(self);
    
    self.ts_navgationBar = [TSNavigationBar navWithTitle:@"乐荟币明细" backAction:^{
        @strongify(self);
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
}



-(void)HTTPRequestpersonal {
    NSString * url = @"personal/integralDetailed.htm?";
    LFParameter * param = [LFParameter new];
    param.loginKey = user_loginKey;
    
    if (_iSBooll == YES) {
        NSString * str = [self update:2];
        param.endDate = str;
        param.startDate = [self setupRequestMonth];
    }
    else{
        param.endDate = endTimer1;
        param.startDate = starTimer1;
    }
    
    param.startPage = starpage;
  
    if ( self ->integralType1 < 0) {
        
        param.integralType = @"0";
    }else{
        param.integralType = stringWithInt(self->integralType1) ;
    }
    
    
 
   [TSNetworking POSTWithURL:url paramsModel:param completeBlock:^(id request) {
        SLLog(request);
        if ([request[@"result"] integerValue]!= 200) {
            SVShowError(request[@"msg"]);
            return ;
        }
       NSArray * arr = [NSArray yy_modelArrayWithClass:[LFIntegralModel class] json:request[@"integralList"]];
       
       
       
        [self.datas  addObjectsFromArray:arr];
        [self.tabbleView  reloadData];
    } failBlock:^(NSError *error) {
        SLLog(error);
    }];
}



-(void)CreateView {
    UITableView * tabbleView = [[UITableView alloc]initWithFrame:Rect(0, 64, kScreenWidth, kScreenHeight-64) style:UITableViewStylePlain];
    tabbleView.delegate = self;
    tabbleView.dataSource = self;
    self.tabbleView = tabbleView;
    [self.view addSubview:tabbleView];
    tabbleView.tableFooterView = [UIView new];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datas.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    LFIntergerDetailCell* cell = [LFIntergerDetailCell cellWithTableView:tableView];
    [cell setModel:self.datas[indexPath.row]];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return Fit375(66);
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (headerView != nil) {
        return  headerView;
    }
    
    headerView = [[UIView alloc]initWithFrame:Rect(0, 0, kScreenWidth, Fit375(156))];
    
    self.DateHeaderView  = [LFDateView creatViewFromNib];
    self.DateHeaderView.frame = Rect(0, 0, headerView.width, headerView.height);
    @weakify(self);
    
    self.DateHeaderView.didendTimer =^(NSString *endTimer,NSString * endtimer){
        @strongify(self);
        self ->endTimer1 = endTimer;
        self -> endTimer2 = endtimer;
        self.iSBooll =NO;
        
        if (self.datas.count >0) {
        [self.datas removeAllObjects];
        }
        [self HTTPRequestpersonal];
 
    };
    self.DateHeaderView.didStarTimer =^(NSString *starTimer,NSString *startimer){
        @strongify(self);
       self->starTimer1 = starTimer;
        self ->starTimer2 = starTimer;
        self.iSBooll =NO;
        if (self.datas.count >0) {
            [self.datas removeAllObjects];
        }
        [self HTTPRequestpersonal];
    };
    
    self.DateHeaderView.didType =^(NSInteger type){
        @strongify(self);
        self ->  integralType1 = type;
        if (self.datas.count >0) {
            [self.datas removeAllObjects];
        }
        [self HTTPRequestpersonal];
        
    };
    [headerView addSubview:self.DateHeaderView];
    return headerView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return Fit375(156);
}
///判断时间开始时间结束时间大小
-(NSString * )rutunDate:(NSString *)date22{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
        NSDate* date = [formatter dateFromString:date22]; //------------将字符串按formatter转成nsdate
    SLLog2(@"date");
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
    SLLog2(@"string ：%@",timeSp);
    return timeSp;
    
}
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
    return nowtimeStr;
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
