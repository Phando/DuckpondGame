//
//  Properties.h
//  Duckhunt
//
//  Created by Joe Andolina on 8/21/15.
//  Copyright (c) 2015 Joe Andolina. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PropertiesManager : NSObject

@property (nonatomic) NSInteger screenOffset;
@property (nonatomic) CGFloat screenSize;

@property (nonatomic) NSInteger gameSkill;
@property (nonatomic) NSInteger gameRounds;
@property (nonatomic) NSInteger gameAmmo;
@property (nonatomic) NSInteger gameScene;

@property (nonatomic) CGFloat gameGlitch;
@property (nonatomic) CGFloat gameScale;
@property (nonatomic) CGFloat gameSpeed;
@property (nonatomic) CGFloat gameTime;

@property (nonatomic) CGFloat duck1Speed;
@property (nonatomic) CGFloat duck1Min;
@property (nonatomic) CGFloat duck1Max;

@property (nonatomic) CGFloat duck2Speed;
@property (nonatomic) CGFloat duck2Min;
@property (nonatomic) CGFloat duck2Max;

@property (nonatomic) CGFloat duck3Speed;
@property (nonatomic) CGFloat duck3Min;
@property (nonatomic) CGFloat duck3Max;

@property (nonatomic) CGFloat playerSensitivity1;
@property (nonatomic) NSPoint playerOffset1;

@property (nonatomic) CGFloat playerSensitivity2;
@property (nonatomic) NSPoint playerOffset2;

+ (instancetype)sharedManager;

-(void)resetDefaults;
-(void)saveDefaults;

@end
