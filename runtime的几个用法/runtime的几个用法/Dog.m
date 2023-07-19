//
//  Dog.m
//  runtime的几个用法
//
//  Created by 李媛媛 on 2019/5/4.
//  Copyright © 2019年 李媛媛. All rights reserved.
//

#import "Dog.h"

@implementation Dog

// 4. 消息转发（重定向）

// 第一步：消息接收者没有找到对应方法时，会调用此方法，可在此方法中动态添加新方法
// 返回YES表示：相应的selector的实现已经被找到，或者添加新方法到类中， 否则返回NO
+ (BOOL)resolveInstanceMethod:(SEL)sel {
    return NO;
}

// 第二步：当第一步返回了YES却没有添加方法，或返回了NO， 会调用此方法
// 这个可以返回一个 能够响应对应方法的对象。 注意返回self则会死循环
- (id)forwardingTargetForSelector:(SEL)aSelector {
    return nil;
}

// 第三步：第二步返回nil，会调用此方法。 系统向我们询问一个合法的类型编码Type Encoding。
// 这里放回nil，则不会进行下一步，从而无法进行消息处理
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    return [NSMethodSignature signatureWithObjCTypes:"v@:"];
}

// 第四步：此方法处进行 消息转发 ，重写forwardInvocation后，这个doesNotRecognizeSelector方法将不会被调用
- (void)forwardInvocation:(NSInvocation *)anInvocation {
    // 改变方法选择器
    [anInvocation setSelector:@selector(unknown)];
    // 指定消息接收者
    [anInvocation invokeWithTarget:self];
}

- (void)unknown {
    NSLog(@"未实现的方法，转发至此调用");
}

// 如果未重写 forwardInvocation消息转发，则调用此方法
- (void)doesNotRecognizeSelector:(SEL)aSelector {
    NSLog(@"未实现的方法：%@", NSStringFromSelector(aSelector));
}


@end
