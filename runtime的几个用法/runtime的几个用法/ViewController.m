//
//  ViewController.m
//  runtime的几个用法
//
//  Created by 李媛媛 on 2019/5/3.
//  Copyright © 2019年 李媛媛. All rights reserved.
//

#import "ViewController.h"
#import "Cat.h"
#import "Dog.h"

#import <objc/message.h> // 使用runtime需引入

@interface ViewController ()

@end

@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    

    // 1. 消息机制 : objc_msgSend
    // 通过类名获取类
    Class catClass = objc_getClass("Cat"); // 引入<objc/message.h>
    // 给对象发消息：类Class实际上也是对象，同样能接收消息，向对象发送alloc消息

    Cat *cat = objc_msgSend(catClass, @selector(alloc));
    // 给对象cat发消息
    objc_msgSend(cat, @selector(init));
    objc_msgSend(cat, @selector(eat:), @"吃");
    /* 使用 objc_msgSend(); 总是报错误  : Too many arguments to function call, expected 0, have 2
    这样修改一下设置就可以了
    Project -> Build Settings -> 搜索enable strict -> 将Enable Strict Checking of objc_msgSend Calls 设置为No
     */
    
    // 2. 动态交换方法实现 见Cat.m :     method_exchangeImplementations(func1, func2)
    [cat eat:@"吃"];
    [cat drink: @"喝"];
    
    
    // 3. 动态解析及添加方法 见Cat.m :    class_addMethod
    [cat performSelector:@selector(run)]; // 调用不存在的run方法
    
    NSString* clickResult=[cat performSelector:@selector(click:) withObject:[NSArray arrayWithObjects:@"你好", @"吗", nil]]; // 调用不存在的带参数的click方法
    NSLog(@"%@",clickResult);
    
    NSLog(@"--------------------------------------------");
    
    
    // 4. 消息转发 见 Dog.m ：
    Dog *dog = [[Dog alloc] init];
    [dog performSelector:@selector(funk)];
    
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
