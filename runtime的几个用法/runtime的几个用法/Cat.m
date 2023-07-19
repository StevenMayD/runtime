//
//  Cat.m
//  runtime的几个用法
//
//  Created by 李媛媛 on 2019/5/3.
//  Copyright © 2019年 李媛媛. All rights reserved.
//

#import "Cat.h"

#import <objc/runtime.h>

@implementation Cat

+ (void)load {
    NSLog(@"在load方法里做runtime方法替换，会带来4毫秒延迟，建议放置到initialize中执行");
}

+ (void)initialize {
    
    // 2. 动态交换方法实现：class_getInstanceMethod需引入 <objc/runtime.h>
    Method eatMethod = class_getInstanceMethod(self, @selector(eat:));
    Method drinkMethod = class_getInstanceMethod(self, @selector(drink:));
    method_exchangeImplementations(eatMethod, drinkMethod);
}


- (void)eat:(NSString *)msg {
    NSLog(@"吃饭_%@", msg);
}

- (void)drink:(NSString *)msg {
    NSLog(@"喝水_%@", msg);
}

// 3. 动态解析及添加c方法
+ (BOOL)resolveInstanceMethod:(SEL)sel {
    NSLog(@"当对象不能响应所调用的方法是，会调用resolveInstanceMethod");
    if(sel == @selector(run)){ // 不带参数方法
        class_addMethod([self class], sel, (IMP)myRun, "v@:");
        return YES;
    } else if (sel == @selector(click:)) { // 带参数方法
        class_addMethod([self class], sel, (IMP)myClick, "v@:");
        return YES;
    }
    return [super resolveInstanceMethod:sel];
}


void myRun(id self, SEL _cmd){
    NSLog(@"跑步");
}

NSString* myClick(id self, SEL _cmd, NSArray* param){
    NSLog(@"已点击");
    return [NSString stringWithFormat:@"%@_%@_帅帅", param[0], param[1]];
}


@end
