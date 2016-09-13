//
//  ViewController.m
//  ScrollView
//
//  Created by 赵天旭 on 16/9/13.
//  Copyright © 2016年 ZTX. All rights reserved.
//

#import "ViewController.h"
#import "TXScrollView.h"
#import "UIImageEffects.h"

@interface ViewController ()<TXScrollViewDelegate>

@property (nonatomic,strong)TXScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray * itmeArray;
@property (nonatomic, strong) UIImageView * imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.imageView = [[UIImageView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:self.imageView];
    self.imageView.backgroundColor = [UIColor lightGrayColor];
    
    self.itmeArray = [NSMutableArray array];
    for (NSInteger i = 0; i < 8; i++) {
        
        [self.itmeArray addObject:[UIImage imageNamed:[NSString stringWithFormat:@"%ld.jpg",(long)i]]];
    }
    
    self.imageView.image = [self blurViewByLightEffectWithImage:self.itmeArray[0]];
    
    self.scrollView = [[TXScrollView alloc] initWithFrame:self.view.frame];
    self.scrollView.delegate = self;
    self.scrollView.isOpenDelete = YES;
    self.scrollView.itmeArray = self.itmeArray;
    [self.view addSubview:self.scrollView];
}

//变换背景蒙版
-(void)scrolIndex:(NSInteger)index
{
    if (self.itmeArray.count > index) {
        self.imageView.image = [self blurViewByLightEffectWithImage:self.itmeArray[index]];
    }
}

- (UIImage *)blurViewByLightEffectWithImage:(UIImage *)screenImage
{
    UIImage * blurImage = [UIImageEffects imageByApplyingLightEffectToImage:screenImage];
    return blurImage;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
