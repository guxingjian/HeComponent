//
//  Heqz_MultiChannelTopBarTabItem.m
//  HeComponent
//
//  Created by qingzhao on 2019/2/14.
//  Copyright © 2019年 qingzhao. All rights reserved.
//

#import "Heqz_MultiChannelConfig.h"

@interface Heqz_MultiChannelTopBarConfig()

@property(nonatomic, assign)CGSize normalSize;
@property(nonatomic, assign)CGSize selectedSize;

@end

@implementation Heqz_MultiChannelTopBarConfig

- (NSString *)selectedTitle{
    if(!_selectedTitle)
        return _normalTitle;
    return _selectedTitle;
}

- (UIFont *)selectedFont{
    if(!_selectedFont)
        return _normalFont;
    return _selectedFont;
}

- (UIColor *)selectedTextColor{
    if(!_selectedTextColor)
        return _normalTextColor;
    return _selectedTextColor;
}

- (CGSize)normalSize{
    if(CGSizeEqualToSize(CGSizeZero, _normalSize)){
        if(!self.normalFont)
            return CGSizeZero;
        
        CGSize sizeNormal = [self.normalTitle boundingRectWithSize:CGSizeMake(1000, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.normalFont} context:nil].size;
        _normalSize = sizeNormal;
    }
    return _normalSize;
}

- (CGSize)selectedSize{
    if(CGSizeEqualToSize(CGSizeZero, _selectedSize)){
        if(!self.selectedFont)
            return CGSizeZero;
        
        CGSize sizeSelected = [self.selectedTitle boundingRectWithSize:CGSizeMake(1000, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.selectedFont} context:nil].size;
        _selectedSize = sizeSelected;
    }
    return _selectedSize;
}

- (CGFloat)maxWidth{
    if(self.normalSize.width > self.selectedSize.width)
        return self.normalSize.width;
    return self.selectedSize.width;
}

- (CGFloat)maxHeight{
    if(self.normalSize.height > self.selectedSize.height)
        return self.normalSize.height;
    return self.selectedSize.height;
}

- (CGFloat)selectedScale{
    if(0 == _selectedScale){
        return 1;
    }
    return _selectedScale;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if(self = [super init]){
        self.normalTitle = [aDecoder decodeObjectForKey:@"normalTitle"];
        NSString* strFontName = [aDecoder decodeObjectForKey:@"normalFont_fontName"];
        if(strFontName.length > 0){
            self.normalFont = [UIFont fontWithName:strFontName size:[aDecoder decodeFloatForKey:@"normalFont_pointSize"]];
        }else{
            self.normalFont = [UIFont systemFontOfSize:[aDecoder decodeFloatForKey:@"normalFont_pointSize"]];
        }
        self.normalTextColor = [UIColor colorWithRed:[aDecoder decodeFloatForKey:@"normalTextColor_r"] green:[aDecoder decodeFloatForKey:@"normalTextColor_g"] blue:[aDecoder decodeFloatForKey:@"normalTextColor_b"] alpha:[aDecoder decodeFloatForKey:@"normalTextColor_a"]];
        
        self.selectedTitle = [aDecoder decodeObjectForKey:@"selectedTitle"];
        strFontName = [aDecoder decodeObjectForKey:@"selectedFont_fontName"];
        if(strFontName.length > 0){
            self.selectedFont = [UIFont fontWithName:strFontName size:[aDecoder decodeFloatForKey:@"selectedFont_pointSize"]];
        }else{
            self.selectedFont = [UIFont systemFontOfSize:[aDecoder decodeFloatForKey:@"selectedFont_pointSize"]];
        }
       self.selectedTextColor = [UIColor colorWithRed:[aDecoder decodeFloatForKey:@"selectedTextColor_r"] green:[aDecoder decodeFloatForKey:@"selectedTextColor_g"] blue:[aDecoder decodeFloatForKey:@"selectedTextColor_b"] alpha:[aDecoder decodeFloatForKey:@"selectedTextColor_a"]];
        self.selectedScale = [aDecoder decodeFloatForKey:@"selectedScale"];;
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.normalTitle forKey:@"normalTitle"];
    if(self.normalFont.fontName.length > 0){
        [aCoder encodeObject:self.normalFont.fontName forKey:@"normalFont_fontName"];
    }
    [aCoder encodeFloat:self.normalFont.pointSize forKey:@"normalFont_pointSize"];
    
    CGFloat colorBuffer[4] = {};
    [self.normalTextColor getRed:(CGFloat*)colorBuffer green:((CGFloat*)colorBuffer + 1) blue:((CGFloat*)colorBuffer + 2) alpha:((CGFloat*)colorBuffer + 3)];
    [aCoder encodeFloat:colorBuffer[0] forKey:@"normalTextColor_r"];
    [aCoder encodeFloat:colorBuffer[1] forKey:@"normalTextColor_g"];
    [aCoder encodeFloat:colorBuffer[2] forKey:@"normalTextColor_b"];
    [aCoder encodeFloat:colorBuffer[3] forKey:@"normalTextColor_a"];
    
    [aCoder encodeObject:self.selectedTitle forKey:@"selectedTitle"];
    
    if(self.selectedFont.fontName.length > 0){
        [aCoder encodeObject:self.selectedFont.fontName forKey:@"selectedFont_fontName"];
    }
    [aCoder encodeFloat:self.selectedFont.pointSize forKey:@"selectedFont_pointSize"];
    
    [self.selectedTextColor getRed:(CGFloat*)colorBuffer green:((CGFloat*)colorBuffer + 1) blue:((CGFloat*)colorBuffer + 2) alpha:((CGFloat*)colorBuffer + 3)];
    [aCoder encodeFloat:colorBuffer[0] forKey:@"selectedTextColor_r"];
    [aCoder encodeFloat:colorBuffer[1] forKey:@"selectedTextColor_g"];
    [aCoder encodeFloat:colorBuffer[2] forKey:@"selectedTextColor_b"];
    [aCoder encodeFloat:colorBuffer[3] forKey:@"selectedTextColor_a"];
    [aCoder encodeFloat:self.selectedScale forKey:@"selectedScale"];
}

+ (BOOL)supportsSecureCoding{
    return YES;
}

@end

@implementation Heqz_MultiChannelConfig

- (BOOL)isEqual:(id)object{
    if(![object isKindOfClass:[self class]])
        return NO;
    
    Heqz_MultiChannelConfig* config = (Heqz_MultiChannelConfig*)object;
    return [self.itemIdentifier isEqualToString:config.itemIdentifier];
}

- (Heqz_MultiChannelTopBarConfig *)topBarConfig{
    if(!_topBarConfig){
        _topBarConfig = [[Heqz_MultiChannelTopBarConfig alloc] init];
    }
    return _topBarConfig;
}

- (NSString *)itemIdentifier{
    if(!_itemIdentifier){
        _itemIdentifier = self.topBarConfig.normalTitle;
    }
    return _itemIdentifier;
}

- (NSString *)description{
    return [NSString stringWithFormat:@"%@_%@", [super description], self.itemIdentifier];
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.itemIdentifier forKey:@"itemIdentifier"];
//    [aCoder encodeBool:self.status forKey:@"status"];
    [self.topBarConfig encodeWithCoder:aCoder];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if(self = [super init]){
        self.itemIdentifier = [aDecoder decodeObjectForKey:@"itemIdentifier"];
//        self.status = [aDecoder decodeBoolForKey:@"status"];
        self.topBarConfig = [[Heqz_MultiChannelTopBarConfig alloc] initWithCoder:aDecoder];
    }
    return self;
}

- (NSString *)contentResuseIdentifier{
    if(!_contentResuseIdentifier){
        return self.itemIdentifier;
    }
    return _contentResuseIdentifier;
}

//- (id)copy{
//    Heqz_MultiChannelConfig* cfg = [[Heqz_MultiChannelConfig alloc] init];
//    cfg.
//}

+ (BOOL)supportsSecureCoding{
    return YES;
}

+ (void)saveConfigArray:(NSArray *)array dataKey:(NSString *)key{
    if(array.count == 0)
        return ;
    
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray* arrayTemp = [NSMutableArray array];
    NSArray* arrayConfig = [array copy];
    for(Heqz_MultiChannelConfig* config in arrayConfig){
        if(![config isKindOfClass:[Heqz_MultiChannelConfig class]])
            continue ;
        NSData* data = nil;
        if(@available(iOS 12.0, *)){
            NSError* error = nil;
            data =[NSKeyedArchiver archivedDataWithRootObject:config requiringSecureCoding:YES error:&error];
            if(error)
                continue;
        }else{
            data = [NSKeyedArchiver archivedDataWithRootObject:config];
        }
        if(!data)
            continue;
        
        [arrayTemp addObject:data];
    }
    [userDefaults setObject:[NSArray arrayWithArray:arrayTemp] forKey:key];
    [userDefaults synchronize];
}

+ (NSArray *)getConfigArrayWithKey:(NSString *)key{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray* arrayConfig = [userDefaults objectForKey:key];
    
    NSMutableArray* arrayItems = [NSMutableArray array];
    for(NSInteger i = 0; i < arrayConfig.count; ++ i){
        NSData* data = [arrayConfig objectAtIndex:i];
        Heqz_MultiChannelConfig* config = nil;
        if(@available(iOS 12.0, *)){
            NSError* error = nil;
            config = [NSKeyedUnarchiver unarchivedObjectOfClass:self fromData:data error:&error];
            if(error)
                continue;
        }else{
            config = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        }
        if(!config)
            continue;
        [arrayItems addObject:config];
    }
    
    return arrayItems;
}

+ (NSArray *)getConfigArrayWithKey:(NSString *)key contentProvider:(id<Heqz_MultiChannelConfigProtocol>)contentProvider{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray* arrayConfig = [userDefaults objectForKey:key];
    
    NSMutableArray* arrayItems = [NSMutableArray array];
    for(NSInteger i = 0; i < arrayConfig.count; ++ i){
        NSData* data = [arrayConfig objectAtIndex:i];
        Heqz_MultiChannelConfig* config = nil;
        if(@available(iOS 12.0, *)){
            NSError* error = nil;
            config = [NSKeyedUnarchiver unarchivedObjectOfClass:self fromData:data error:&error];
            if(error)
                continue;
        }else{
            config = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        }
        if(!config)
            continue;
        config.contentProvider = contentProvider;
        [arrayItems addObject:config];
    }
    
    return arrayItems;
}

+ (NSArray *)configArrayWithArray:(NSArray *)arrayConfig insertConfig:(Heqz_MultiChannelConfig *)config atIndex:(NSInteger (^)(Heqz_MultiChannelConfig *cfg, NSInteger nIndex))indexBlock{
    
    NSInteger nRet = -1;
    for(NSInteger i = 0; i< arrayConfig.count; ++ i){
        Heqz_MultiChannelConfig* tempCfg = [arrayConfig objectAtIndex:i];
        if(-1 == nRet){
            nRet = indexBlock(tempCfg, i);
        }
        if([config.itemIdentifier isEqualToString:tempCfg.itemIdentifier]){
            nRet = -1;
            break;
        }
    }
    if(nRet < 0 || nRet > arrayConfig.count)
        return arrayConfig;
    
    NSMutableArray* arrayTemp = [NSMutableArray arrayWithArray:arrayConfig];
    [arrayTemp insertObject:config atIndex:nRet];
    return arrayTemp;
}

@end

