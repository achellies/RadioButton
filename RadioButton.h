//
//  RadioButton.h
//  RadioButton
//
//  Created by achellies on 14/08/19.
//  Copyright 2014 achellies. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RadioButtonDelegate <NSObject>
-(void)radioButtonSelectedAtIndex:(NSUInteger)index inGroup:(NSString*)groupId;
@end

@interface RadioButton : UIView

@property (nonatomic, copy) NSString *groupId;
@property (nonatomic, assign) NSUInteger index;
@property (nonatomic, strong)UIButton *button;

-(void)setTitle:(NSString*) title;
-(void)checked:(BOOL) checked;
+(void)addObserverForGroupId:(NSString*)groupId observer:(id<RadioButtonDelegate>)observer;
+(void)removeObserverForGroupId:(NSString*)groupId observer:(id<RadioButtonDelegate>)observer;
@end
