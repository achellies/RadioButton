//
//  RadioButton.h
//  RadioButton
//
//  Created by achellies on 14/08/19.
//  Copyright 2014 achellies. All rights reserved.
//

#import "RadioButton.h"

@interface RadioButton()
-(void)defaultInit;
-(void)otherButtonSelected:(id)sender;
-(void)handleButtonTap:(id)sender;
@end

@implementation RadioButton

static NSMutableArray *rb_instances = nil;
static NSMutableDictionary *rb_observers = nil;

#pragma mark - Observer

+(void)addObserverForGroupId:(NSString*)groupId observer:(id<RadioButtonDelegate>)observer{
    if(!rb_observers){
        rb_observers = [[NSMutableDictionary alloc] init];
    }

    if ([groupId length] > 0 && observer) {
        [rb_observers setObject:observer forKey:groupId];
    }
}

+(void)removeObserverForGroupId:(NSString*)groupId observer:(id<RadioButtonDelegate>)observer {
    if (rb_instances) {
        [rb_instances removeObject:observer];
    }
}

#pragma mark - Manage Instances

+(void)registerInstance:(RadioButton*)radioButton{
    if(!rb_instances){
        rb_instances = [[NSMutableArray alloc] init];
    }

    [rb_instances addObject:radioButton];
}

+(void)unRegisterInstance:(RadioButton*)radioButton {
    if (rb_instances) {
        [rb_instances removeObject:radioButton];
    }
}

#pragma mark - Class level handler

+(void)buttonSelected:(RadioButton*)radioButton{

    // Notify observers
    if (rb_observers) {
        id observer= [rb_observers objectForKey:radioButton.groupId];
        
        if(observer && [observer respondsToSelector:@selector(radioButtonSelectedAtIndex:inGroup:)]){
            [observer radioButtonSelectedAtIndex:radioButton.index inGroup:radioButton.groupId];
        }
    }

    // Unselect the other radio buttons
    if (rb_instances) {
        for (int i = 0; i < [rb_instances count]; i++) {
            RadioButton *button = [rb_instances objectAtIndex:i];
            if (![button isEqual:radioButton] && [button.groupId isEqualToString:radioButton.groupId]) {
                [button otherButtonSelected:radioButton];
            }
        }
    }
}

#pragma mark - Public
-(void)checked:(BOOL) checked {
    self.button.selected = checked;
}

-(void)setTitle:(NSString*) title {
    [self.button setTitle:title forState:UIControlStateNormal];
}

#pragma mark - Object Lifecycle

-(id) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self defaultInit];
    }
    return self;
}

-(void)awakeFromNib {
    [super awakeFromNib];
    [self defaultInit];
}

- (void)dealloc
{
    _groupId = nil;
    _button = nil;
    [RadioButton unRegisterInstance:self];
}

#pragma mark - Tap handling

-(void)handleButtonTap:(id)sender{
    [self.button setSelected:YES];
    [RadioButton buttonSelected:self];
}

-(void)otherButtonSelected:(id)sender{
    // Called when other radio button instance got selected
    if(self.button.selected){
        [self.button setSelected:NO];
    }
}

#pragma mark - RadioButton init

-(void)defaultInit{
    // Customize UIButton
    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.button.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    self.button.adjustsImageWhenHighlighted = NO;

    [self.button setImage:[UIImage imageNamed:@"RadioButton-Unselected"] forState:UIControlStateNormal];
    [self.button setImage:[UIImage imageNamed:@"RadioButton-Selected"] forState:UIControlStateSelected];
    [self.button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.button.backgroundColor = [UIColor whiteColor];
    self.button.titleLabel.font = [UIFont systemFontOfSize:20];

    [self.button addTarget:self action:@selector(handleButtonTap:) forControlEvents:UIControlEventTouchUpInside];

    [self addSubview:self.button];

    [RadioButton registerInstance:self];
}


@end
