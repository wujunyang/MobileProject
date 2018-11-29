//
//  MPBinaryTreeNode.h
//  MobileProject
//
//  Created by wujunyang on 2017/10/30.
//  Copyright © 2017年 wujunyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MPBinaryTreeNode : NSObject

//节点值
@property(nonatomic,assign)NSInteger nodeValue;

//左节点
@property(nonatomic,strong)MPBinaryTreeNode *leftBinaryTreeNode;

//右节点
@property(nonatomic,strong)MPBinaryTreeNode *rightBinaryTreeNode;

//初始化
-(instancetype)initTreeNodeWithValue:(NSInteger)nodeValue withLeftTreeNode:(MPBinaryTreeNode *)leftTreeNode withRightTreeNode:(MPBinaryTreeNode *)rightTreeNode;

@end
