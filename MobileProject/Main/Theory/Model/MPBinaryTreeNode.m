//
//  MPBinaryTreeNode.m
//  MobileProject
//
//  Created by wujunyang on 2017/10/30.
//  Copyright © 2017年 wujunyang. All rights reserved.
//

#import "MPBinaryTreeNode.h"

@implementation MPBinaryTreeNode

-(instancetype)initTreeNodeWithValue:(NSInteger)nodeValue withLeftTreeNode:(MPBinaryTreeNode *)leftTreeNode withRightTreeNode:(MPBinaryTreeNode *)rightTreeNode
{
    self=[super init];
    if (self) {
        _nodeValue=nodeValue;
        _leftBinaryTreeNode=leftTreeNode;
        _rightBinaryTreeNode=rightTreeNode;
    }
    return self;
}


@end
