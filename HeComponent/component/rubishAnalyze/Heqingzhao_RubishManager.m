//
//  Heqingzhao_RubishManager.m
//  HeComponent
//
//  Created by qingzhao on 2019/6/6.
//  Copyright © 2019年 qingzhao. All rights reserved.
//

#import "Heqingzhao_RubishManager.h"
#import <UIKit/UIKit.h>
#import <objc/runtime.h>

@interface Heqingzhao_RubishManager()

@property(nonatomic, strong)NSMutableArray* arrayAllClassName;
@property(nonatomic, strong)NSMutableDictionary* dicUsedClassName;

@property(nonatomic, strong)NSMutableDictionary* dicAllImageName;
@property(nonatomic, strong)NSMutableDictionary* dicUsedImageName;

@property(nonatomic, strong)NSMutableArray* arrayAllXibName;
@property(nonatomic, strong)NSMutableDictionary* dicUsedXibName;

@end

@implementation Heqingzhao_RubishManager

+ (instancetype)sharedManager{
    static Heqingzhao_RubishManager* manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (NSMutableArray *)arrayAllClassName{
    if(!_arrayAllClassName){
        _arrayAllClassName = [NSMutableArray array];
    }
    return _arrayAllClassName;
}

- (BOOL)skipClassName:(NSString*)clsName{
    if(self.arrayClassPreStr.count > 0){
        for(NSString* strPre in self.arrayClassPreStr){
            if([clsName hasPrefix:strPre])
                return NO;
        }
        return YES;
    }
    return NO;
}

- (void)collectAllClassName{
    unsigned int count;
    Class* clsBuf = objc_copyClassList(&count);
    NSMutableArray* arrayClassName = self.arrayAllClassName;
    for(unsigned int i = 0; i < count; ++ i){
        NSString* clsName = NSStringFromClass(clsBuf[i]);
        if(![self skipClassName:clsName]){
            [arrayClassName addObject:clsName];
        }
    }
}

- (NSMutableDictionary *)arrayUsedClassName{
    if(!_dicUsedClassName){
        _dicUsedClassName = [NSMutableDictionary dictionary];
    }
    return _dicUsedClassName;
}

- (void)collectUsedClassName:(NSString*)clsName{
    if(clsName.length == 0)
        return ;
//    NSLog(@"%@",clsName);
    [self.dicUsedClassName setObject:@"1" forKey:clsName];
}

- (NSMutableDictionary *)dicAllImageName{
    if(!_dicAllImageName){
        _dicAllImageName = [NSMutableDictionary dictionary];
    }
    return _dicAllImageName;
}

- (void)collectAllImageName{
    NSMutableDictionary* dicAllImage = self.dicAllImageName;
    NSArray* arrayImage = [[NSBundle mainBundle] pathsForResourcesOfType:@".png" inDirectory:nil];
    for(NSString* imagePath in arrayImage){
        NSString* imageName = [imagePath pathComponents].lastObject;
        imageName = [imageName componentsSeparatedByString:@"@"].firstObject;
        if(imageName.length > 0){
            [dicAllImage setObject:@"1" forKey:imageName];
        }
    }
}

- (NSMutableDictionary *)dicUsedImageName{
    if(!_dicUsedImageName){
        _dicUsedImageName = [NSMutableDictionary dictionary];
    }
    return _dicUsedImageName;
}

- (void)collectUsedImageName:(NSString*)imgName{
    if(imgName.length == 0)
        return ;
    [self.dicUsedImageName setObject:@"1" forKey:imgName];
}

- (NSMutableArray *)arrayAllXibName{
    if(!_arrayAllXibName){
        _arrayAllXibName = [NSMutableArray array];
    }
    return _arrayAllXibName;
}

- (void)collectAllXibName{
    NSMutableArray* arrayAllXib = self.arrayAllXibName;
    NSArray* arrayXib = [[NSBundle mainBundle] pathsForResourcesOfType:@".nib" inDirectory:nil];
    for(NSString* xibPath in arrayXib){
        NSString* xibName = [xibPath pathComponents].lastObject;
        xibName = [xibName componentsSeparatedByString:@"."].firstObject;
        if(xibName.length > 0){
            [arrayAllXib addObject:xibName];
        }
    }
}

- (NSMutableDictionary *)dicUsedXibName{
    if(!_dicUsedXibName){
        _dicUsedXibName = [NSMutableDictionary dictionary];
    }
    return _dicUsedXibName;
}

- (void)collectUsedXibName:(NSString*)xibName{
    if(xibName.length == 0)
        return ;
    [self.dicUsedXibName setObject:@"1" forKey:xibName];
}

- (void)analyzeUnUsedResource{
    NSString* strPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    
    NSMutableString* strUnUsedClass = [[NSMutableString alloc] init];
    NSMutableDictionary* dicUsedClassName = self.dicUsedClassName;
    for(NSString* clsName in self.arrayAllClassName){
        NSString* isExisted = [dicUsedClassName objectForKey:clsName];
        if(isExisted.length == 0){
            [strUnUsedClass appendString:clsName];
            [strUnUsedClass appendString:@"\n"];
        }
    }
    NSString* classNamePath = [strPath stringByAppendingPathComponent:@"unusedClass.txt"];
    [strUnUsedClass writeToFile:classNamePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    NSMutableString* strUnUsedImage = [[NSMutableString alloc] init];
    NSMutableDictionary* dicUsedImage = self.dicUsedImageName;
    NSArray* arrayAllImage = self.dicAllImageName.allKeys;
    for(NSString* image in arrayAllImage){
        NSString* isExisted = [dicUsedImage objectForKey:image];
        if(isExisted == 0){
            [strUnUsedImage appendString:image];
            [strUnUsedImage appendString:@"\n"];
        }
    }
    NSString* imageNamePath = [strPath stringByAppendingPathComponent:@"unusedImage.txt"];
    [strUnUsedImage writeToFile:imageNamePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    NSMutableString* strUnUsedXib = [[NSMutableString alloc] init];
    NSMutableDictionary* dicUsedXibName = self.dicUsedXibName;
    for(NSString* xibName in self.arrayAllXibName){
        NSString* isExisted = [dicUsedXibName objectForKey:xibName];
        if(isExisted == 0){
            [strUnUsedXib appendString:xibName];
            [strUnUsedXib appendString:@"\n"];
        }
    }
    NSString* xibNamePath = [strPath stringByAppendingPathComponent:@"unusedXib.txt"];
    [strUnUsedXib writeToFile:xibNamePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

@end
