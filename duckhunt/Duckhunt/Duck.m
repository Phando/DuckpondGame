//
//  Duck.m
//  Duckhunt
//
//  Created by Joe Andolina on 4/20/15.
//  Copyright (c) 2015 Joe Andolina. All rights reserved.
//

#import "Duck.h"
#import "ApplicationModel.h"
#import "Properties.h"

#define kDuckWidth  86.0
#define kDuckHeight 75.0

@implementation Duck
{
    NSArray *animTex;
    CGFloat minDistance;
    CGFloat maxDistance;
    NSTimer *timer;
    SKEmitterNode *explosion;
    SKEmitterNode *trail;
    
    NSInteger direction;
    Properties *props;
    
    SKAction *flap;
    SKAction *move;
    SKAction *group;
}

+(BOOL)yesOrNo
{
    int tmp = (arc4random() % 30)+1;
    if(tmp % 5 == 0)
        return YES;
    return NO;
}

+(float)getDuckFlightTime:(float)lowerBound and:(float)upperBound
{
    float diff = upperBound - lowerBound;
    return (((float) (arc4random() % ((unsigned)RAND_MAX + 1)) / RAND_MAX) * diff) + lowerBound;
}


-(id)initWithType:(DuckType)duckType
{
    ApplicationModel *model = [ApplicationModel sharedModel];
    self = [super initWithColor:[NSColor clearColor] size:CGSizeMake(kDuckWidth, kDuckHeight)];
    
    if( self )
    {
        [self setName:@"duck"];
        [self setDuckType:duckType];
        props = model.props;
        
        switch( duckType )
        {
            case DuckTypeEasy :
                self.speed = props.duck1Speed;
                minDistance = props.duck1Min;
                maxDistance = props.duck1Max;
                break;
            case DuckTypeNormal :
                self.speed = props.duck2Speed;
                minDistance = props.duck2Min;
                maxDistance = props.duck2Max;
                break;
            case DuckTypeHard :
                self.speed = props.duck3Speed;
                minDistance = props.duck3Min;
                maxDistance = props.duck3Max;
                break;
        }
        
        // Property change handlers
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleScale:) name:@"gameScaleChanged" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleSpeed:) name:@"duckSpeedChanged" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleMin:) name:@"duckMinChanged" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleMax:) name:@"duckMaxChanged" object:nil];
    }
    return self;
}

-(BOOL)isFlying
{
    return timer != nil;
}

-(void)handleScale:(NSNotification*)notification
{
    [self setScale:props.gameScale];
}

-(void)handleSpeed:(NSNotification*)notification
{
    NSInteger value = [notification.object integerValue];
    
    if( self.duckType == DuckTypeEasy && value == 1)
    {
        self.speed = props.duck1Speed;
    }
    
    if( self.duckType == DuckTypeNormal && value == 2)
    {
        self.speed = props.duck2Speed;
    }
    
    if( self.duckType == DuckTypeHard && value == 3)
    {
        self.speed = props.duck3Speed;
    }
}


-(void)handleMax:(NSNotification*)notification
{
    NSInteger value = [notification.object integerValue];
    
    if( self.duckType == DuckTypeEasy && value == 1)
    {
        maxDistance = props.duck1Max;
    }
    
    if( self.duckType == DuckTypeNormal && value == 2)
    {
        maxDistance = props.duck2Max;
    }
    
    if( self.duckType == DuckTypeHard && value == 3)
    {
        maxDistance = props.duck3Max;
    }
}



-(void)handleMin:(NSNotification*)notification
{
    NSInteger value = [notification.object integerValue];
    
    if( self.duckType == DuckTypeEasy && value == 1)
    {
        minDistance = props.duck1Min;
    }
    
    if( self.duckType == DuckTypeNormal && value == 2)
    {
        minDistance = props.duck2Min;
    }
    
    if( self.duckType == DuckTypeHard && value == 3)
    {
        minDistance = props.duck3Min;
    }
}



-(void)reroute
{
    [timer invalidate];
    timer = nil;
    
    if( self.isShot )
    {
        return;
    }
    if([Duck yesOrNo])
    {
        _lat = arc4random()%3;
    }
    if([Duck yesOrNo])
    {
        _lng = arc4random()%2;
    }
    [self setLat:_lat lng:_lng];
}

-(void)setLat:(DuckLat)latDir lng:(DuckLng)lngDir
{
    if( !self.parent )
    {
        return;
    }
    
    [self removeAllActions];
    _lat = latDir;
    _lng = lngDir;
    direction = lngDir == DuckLngEast ? 1.0 : -1.0;
    
    switch( latDir )
    {
        case DuckLatNorth:  [self flyN]; break;
        case DuckLatEven:   [self flyE]; break;
        case DuckLatSouth:  [self flyS]; break;
    }
    
    float flightTime = [Duck getDuckFlightTime:minDistance and:maxDistance];
    timer = [NSTimer scheduledTimerWithTimeInterval:flightTime target:self selector:@selector(reroute) userInfo:nil repeats:NO];
}

-(void)flyN
{
    flap = [SKAction animateWithTextures:[[ApplicationModel sharedModel]textures:self.duckType action:@"climb"] timePerFrame:0.2];
    move = [SKAction moveBy:CGVectorMake(props.gameGlitch * direction, props.gameGlitch) duration:props.gameSpeed];
    move.timingMode = SKActionTimingLinear;
    
    group = [SKAction group:@[
                              [SKAction repeatActionForever:flap],
                              [SKAction repeatActionForever:move]]];
   
    group.timingMode = SKActionTimingLinear;
    self.xScale = props.gameScale * direction;
    self.yScale = props.gameScale;
    [self runAction:[SKAction repeatActionForever:group]];
}

-(void)flyE
{
    flap = [SKAction animateWithTextures:[[ApplicationModel sharedModel]textures:self.duckType action:@"fly"] timePerFrame:0.2];
    move = [SKAction moveBy:CGVectorMake(props.gameGlitch * direction, 0) duration:props.gameSpeed];
    move.timingMode = SKActionTimingLinear;
    
    group = [SKAction group:@[
                              [SKAction repeatActionForever:flap],
                              [SKAction repeatActionForever:move]]];
    
    group.timingMode = SKActionTimingLinear;
    self.xScale = props.gameScale * direction;
    self.yScale = props.gameScale;
    [self runAction:[SKAction repeatActionForever:group]];

}

-(void)flyS
{
    flap = [SKAction animateWithTextures:[[ApplicationModel sharedModel]textures:self.duckType action:@"fly"] timePerFrame:0.2];
    move = [SKAction moveBy:CGVectorMake(props.gameGlitch * direction, -props.gameGlitch) duration:props.gameSpeed];
    move.timingMode = SKActionTimingLinear;
    
    group = [SKAction group:@[
                              [SKAction repeatActionForever:flap],
                              [SKAction repeatActionForever:move]]];
    
    group.timingMode = SKActionTimingLinear;
    self.xScale = props.gameScale * direction;
    self.yScale = props.gameScale;
    [self runAction:[SKAction repeatActionForever:group]];
}

-(void)shoot
{
    [timer invalidate];
    timer = nil;
    [self removeAllActions];
    self.isShot = YES;
    self.speed = 1.0;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Trail" ofType:@"sks"];
    SKEmitterNode *node = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    [node setPosition:CGPointMake(0, self.size.height-30)];
       
    [self setTexture:[[ApplicationModel sharedModel]texture:self.duckType action:@"shot"]];
    SKAction *delay = [SKAction waitForDuration:0.6];
    SKAction *spin = [SKAction animateWithTextures:[[ApplicationModel sharedModel]textures:self.duckType action:@"fall"] timePerFrame:0.1 ];
    SKAction *fall = [SKAction repeatActionForever:spin];
    move = [SKAction moveToY:-25.0 duration:self.position.y/720];
    move.timingMode = SKActionTimingEaseIn;

    [self runAction:delay completion:^{
        [self addChild:node];
        [self runAction:[SKAction group:@[fall, move]] completion:^{
            [node removeFromParent];
            [self removeFromParent];
        }];

    }];
}

@end
