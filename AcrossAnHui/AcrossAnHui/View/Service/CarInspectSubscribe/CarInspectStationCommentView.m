//
//  CarInspectStationCommentView.m
//  AcrossAnHui
//
//  Created by ztd on 2017/8/9.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CarInspectStationCommentView.h"
#import "CWStarRateView.h"
#import "CCarSubscribeCommentStationView.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "TextViewContentTool.h"

@interface CarInspectStationCommentView()<UITextViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,CWStarRateViewDelegate>{
    long _value;
}

@property (nonatomic,strong)TPKeyboardAvoidingScrollView *baseScroView;
@property (nonatomic,retain) CWStarRateView * starView;
@property (nonatomic,strong) CCarSubscribeCommentStationView * headerView;
@property (nonatomic,strong)UITextView *textView;
@property (nonatomic,strong)UILabel *palorLabal;
@property (nonatomic,strong)UILabel *countLabel;//计数Label
@property (nonatomic,copy)NSString *commentString;//提交评价String
@property (nonatomic,copy)NSString *currentString;
@property (nonatomic,strong)NSUserDefaults *userDefault;
@property (nonatomic,strong)NSMutableArray *imageArray;//图片数组

@end

@implementation CarInspectStationCommentView

- (instancetype)initWithFrame:(CGRect)frame model:(SubscribeModel *)model {
    if (self = [super initWithFrame:frame]) {
        _model = model;
        [self initUI];
    }
    return self;
}

-(void)initUI{
        self.baseScroView = [[TPKeyboardAvoidingScrollView alloc]init];
        [self addSubview:self.baseScroView];
    
        //界面设置
        _headerView = [[CCarSubscribeCommentStationView alloc]initWithFrame:CGRectZero];
        self.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0];
        UILabel *labelComment = [[UILabel alloc]init];
        labelComment.text = @"我要评分";
        labelComment.font = [UIFont systemFontOfSize:15];
        [self.baseScroView addSubview:self.headerView];
        [self.baseScroView addSubview:labelComment];
    
        self.starView=[[CWStarRateView alloc]initWithFrame:CGRectMake(self.frame.size.width-120,130,110,20) numberOfStars:5 photostr:@"huang"] ;
        self.starView.delegate=self;
        self.starView.allowIncompleteStar = YES;
        self.starView.hasAnimation = NO;
        [self.baseScroView addSubview:self.starView];
        self.starView.scorePercent = 1.0;
        [self.starView addGesture];
    
        _value = 5;
        UIView *textViewBgView = [[UIView alloc]initWithFrame:CGRectZero];
        [self.baseScroView addSubview:textViewBgView];
        textViewBgView.backgroundColor = [UIColor whiteColor];
        self.textView = [[UITextView alloc]init];
        self.textView.delegate = self;
        self.palorLabal = [[UILabel alloc]init];
        [textViewBgView addSubview:self.textView];
        [textViewBgView addSubview:self.palorLabal];
    
        self.palorLabal.text = @"亲,给个评价吧!";
        self.palorLabal.textColor = [UIColor colorWithRed:168/255.0 green:168/255.0 blue:168/255.0 alpha:1];
        self.palorLabal.font = [UIFont systemFontOfSize:15];
        self.palorLabal.enabled = NO;
    
        self.countLabel = [[UILabel alloc]init];
        [textViewBgView addSubview:self.countLabel];
        self.countLabel.text = @"0/100";
        self.countLabel.textAlignment = NSTextAlignmentRight;
        
        UILabel *uploadLabel = [[UILabel alloc]init];
        [self.baseScroView  addSubview:uploadLabel];
    
        uploadLabel.text = @"上传图片";
        uploadLabel.font = [UIFont systemFontOfSize:15];
        CGFloat buttonWidth = self.frame.size.width/4;
        CGFloat sepWidth = buttonWidth/4;
        UIView *photoBgView = [[UIView alloc]init];
        [self.baseScroView addSubview:photoBgView];
    
        photoBgView.backgroundColor = [UIColor whiteColor];
        for (int i= 0; i <3; i++) {
            UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake((i+1)*sepWidth+i*buttonWidth,photoBgView.frame.origin.y+10,buttonWidth, buttonWidth)];
            [photoBgView addSubview:button];
            button.tag = 1000+i;
            [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            [button setBackgroundImage:[UIImage imageNamed:@"zwtphoto.png"] forState:UIControlStateNormal];
            
            if (i==0) {
                self.onePhotoBtn = button;
            }
            
            if (i==1) {
                self.twoPhotoBtn = button;
            }
            
            if (i==2) {
                self.threePhotoBtn = button;
            }
        }
        UIButton *commentButton = [[UIButton alloc]init];
        [self.baseScroView addSubview:commentButton];
    
        [commentButton addTarget:self action:@selector(commentAction) forControlEvents:UIControlEventTouchUpInside];
        [commentButton setTitle:@"提交评价" forState:UIControlStateNormal];
        commentButton.layer.cornerRadius = 5.0;
        [commentButton setBackgroundColor:[UIColor colorWithRed:20/255.0 green:155/255.0 blue:213/255.0 alpha:1.0]];
    
        [self.baseScroView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(0));
            make.right.equalTo(@0);
            make.top.equalTo(@(0));
            make.bottom.equalTo(@0);
        }];
    
        [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(0));
            make.width.equalTo(@(CTXScreenWidth));
            make.top.equalTo(@(10));
            make.height.equalTo(@110);
        }];
    
        [labelComment mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(10));
            make.right.equalTo(@0);
            make.top.equalTo(self.headerView.mas_bottom).offset(15);
            make.height.equalTo(@15);
        }];
    
        [textViewBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(0));
            make.right.equalTo(@(CTXScreenWidth));
            make.top.equalTo(labelComment.mas_bottom).offset(15);
            make.height.equalTo(@150);
        }];
        [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(textViewBgView.mas_left).offset(10);
            make.width.equalTo(@(CTXScreenWidth-20));
            make.top.equalTo(textViewBgView.mas_top).offset(5);
            make.height.equalTo(@125);
        }];
        [self.palorLabal mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(textViewBgView.mas_left).offset(12);
            make.width.equalTo(@(CTXScreenWidth-20));
            make.top.equalTo(textViewBgView.mas_top).offset(12);
            make.height.equalTo(@15);
        }];
        [uploadLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(textViewBgView.mas_left).offset(10);
            make.width.equalTo(@(CTXScreenWidth-20));
            make.top.equalTo(textViewBgView.mas_bottom).offset(10);
            make.height.equalTo(@15);
        }];
        [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(textViewBgView.mas_left).offset(10);
            make.width.equalTo(@(CTXScreenWidth-20));
            make.bottom.equalTo(textViewBgView.mas_bottom).offset(-5);
            make.height.equalTo(@15);
        }];
        [photoBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(textViewBgView.mas_left).offset(0);
            make.right.equalTo(textViewBgView.mas_right).offset(0);
            make.top.equalTo(uploadLabel.mas_bottom).offset(10);
            make.height.equalTo(@(buttonWidth+20));
        }];
        [commentButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@20);
            make.width.equalTo(@(CTXScreenWidth-40));
            make.top.equalTo(photoBgView.mas_bottom).offset(10);
            make.height.equalTo(@(40));
        }];
}

-(void)layoutSubviews{
    if (CTXScreenWidth==320) {
        self.baseScroView.contentSize = CGSizeMake(self.frame.size.width,CTXScreenHeight+10);
    } else {
    }
}

-(void)refreshData:(CarInspectStationModel *)stationModel{

    [self.headerView setStationList:stationModel];
}

-(void)commentAction{
    _value = (long) self.starView.scorePercent * 5;
    
    NSString *content = [TextViewContentTool isContaintContent:self.textView.text];
    if (!content) {
        [self showTextHubWithContent:@"请输入评价信息"];
        return;
    }
    
    NSString * starStr = [NSString stringWithFormat:@"%ld", _value];
    if (submitListener) {
        submitListener(starStr, content, self.model.stationid);
    }
}

- (void)buttonAction:(UIButton *)button{
    self.currentString = [NSString stringWithFormat:@"%li",(long)button.tag];
    if (button.tag ==1000) {
        //第一张图
    }else if (button.tag ==1001){
        //第二张图
    }else if(button.tag ==1002){
        //第三张图片
    }

    if (_submitPhotoListener) {
        _submitPhotoListener((int)button.tag);
    }
}

-(void)getChangeBtnImage:(int)tag data:(NSData *)data{
    UIButton *button = (UIButton *)[self viewWithTag:tag];
    [button setImage:[UIImage imageWithData:data] forState:UIControlStateNormal];
}

#pragma mark - textViewDelegate

- (void)textViewDidChange:(UITextView *)textView {
    if(textView.text.length == 0){
        self.palorLabal.text = @"亲,给个评价吧!";
    }else{
        self.palorLabal.text = @"";
    }
    self.countLabel.text = [NSString stringWithFormat:@"%lu/100",(unsigned long)textView.text.length];
    if (textView.text.length==100) {
        self.commentString = textView.text;
    }else if (textView.text.length >100){
        self.textView.text = self.commentString;
        [self showTextHubWithContent:@"输入字数在100字以内"];
        self.countLabel.text = [NSString stringWithFormat:@"%lu/100",(unsigned long)self.commentString.length];
    }
}

- (void)starRateView:(CWStarRateView *)starRateView scroePercentDidChange:(CGFloat)newScorePercent{
    
    self.starView.scorePercent = newScorePercent;
}

-(void)setSubmitListener:(void (^)(NSString *, NSString *, NSString *))listener{
    submitListener = listener;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text; {
    
    if ([@"\n" isEqualToString:text] == YES) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

@end
