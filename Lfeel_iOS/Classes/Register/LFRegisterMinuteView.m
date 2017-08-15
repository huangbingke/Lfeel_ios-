//
//  LFRegisterMinuteView.m
//  Lfeel_iOS
//
//  Created by kvi on 2017/2/23.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import "LFRegisterMinuteView.h"
@interface LFRegisterMinuteView ()<UITableViewDelegate,UITableViewDataSource>
///选择尺寸
@property (weak, nonatomic) IBOutlet UIButton *selectXLBtn;
///点击取消按钮
@property (weak, nonatomic) IBOutlet UIButton *didClickCannceBtn;
@property (weak, nonatomic) IBOutlet UITextField *heightTextFeild;
@property (weak, nonatomic) IBOutlet UITextField *wightTextFeild;
@property (weak, nonatomic) IBOutlet UITextField *theChestTextFeild;

@property (weak, nonatomic) IBOutlet UITextField *waistlineTextFeild;

@property (weak, nonatomic) IBOutlet UITextField *hipLineTextFeild;
@property (weak, nonatomic) IBOutlet UIButton *footageBtn;
@property (weak, nonatomic) IBOutlet UILabel *fooTageLabel;
@property (weak, nonatomic)  UITableView *TabbleView;

@end




@implementation LFRegisterMinuteView
{
    NSArray * array;
    NSDictionary * dictMessage;
}



-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if(self = [super initWithCoder:aDecoder])
    {
        SLLog2(@"sssss");
        
        array = @[@"S",@"M",@"L",@"XL",@"2XL",@"3XL"];
        UITableView * tabbleView = [[UITableView alloc]initWithFrame:Rect(Fit375(15), Fit375(40),Fit375(235), Fit375(300)) style:UITableViewStylePlain];
        tabbleView.dataSource = self;
        tabbleView.delegate =self;
        [self addSubview:tabbleView];
        tabbleView.hidden = YES;
        tabbleView.backgroundColor = HexColorInt32_t(ff0000);
        
        self.TabbleView = tabbleView;
        
        [tabbleView reloadData];
        
    }
    return self;
}

- (IBAction)selectXL:(id)sender {
    
    
    
//    [self.TabbleView reloadData];
    if (self.didClickSelectedXLBtnBlock ) {
        self.didClickSelectedXLBtnBlock();
    }
   
    self.TabbleView.hidden = NO;
    SLLog2(@"选择");
}
///取消
- (IBAction)didClickCannceBtn:(id)sender {
    
    if (self.didClickCannceBtnBlock) {
        self.didClickCannceBtnBlock();
    }
    SLLog2(@"取消");
    [self setHeight:@"" andWeight:@"" andThechest:@"" andWaistline:@"" andHipline:@"" andFootage:@""];
    
}


-(void)setHeight:(NSString *)height andWeight:(NSString *)weight andThechest:(NSString *)thechest  andWaistline:(NSString *)waistline andHipline:(NSString *)hipline andFootage:(NSString *)footage{
    
    self.heightTextFeild.text =height;
    self.wightTextFeild.text = weight;
    self.theChestTextFeild.text = thechest;
    self.waistlineTextFeild.text = waistline;
    self.hipLineTextFeild.text = hipline;
    
    self.footageBtn.titleLabel.text = footage;
    dictMessage = @{@"height":height,@"weight":weight,@"thechest":thechest,
                    @"waistline":waistline,@"hipline":hipline,@"footage":footage
                    };
}
- (IBAction)TapSaveBtn:(id)sender {
    SLLog2(@"保存");
    
    
    [self setHeight:self.heightTextFeild.text andWeight:self.wightTextFeild.text andThechest:self.theChestTextFeild.text andWaistline:self.waistlineTextFeild.text andHipline:self.hipLineTextFeild.text andFootage:self.footageBtn.titleLabel.text];
    
    if (self.didClickSaveBtnBlock) {
        self.didClickSaveBtnBlock(dictMessage);
    }
    
    
}

-(void)TapSelectXL:(UIButton *)button{
    SLLog2(@"sele at :%zd",button.tag);
    SLLog2(@"array[indexPath.row] %@",array[button.tag-10]);
    [self.footageBtn setTitle:array[button.tag - 10]];
    self.TabbleView.hidden = YES;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self rm_fitAllConstraint];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return array.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static  NSString * ID = @"Reg";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        
    }
    cell.textLabel.text = array[indexPath.row];
    UIButton * button  = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame =Rect(0, 0, cell.width, cell.height);
    button.tag = indexPath.row+10;
    [button addTarget:self action:@selector(TapSelectXL:)];
    [cell.contentView addSubview: button];
    
    
    
    
    return cell;
}

 
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

 
 
    

    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return Fit375(40);
}

-(BOOL)canBecomeFocused
{
    return YES;
}




@end
