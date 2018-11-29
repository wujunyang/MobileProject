//
//  MPBinaryTreeViewController.m
//  MobileProject
//
//  Created by wujunyang on 2017/10/30.
//  Copyright © 2017年 wujunyang. All rights reserved.
//

#import "MPBinaryTreeViewController.h"

@interface MPBinaryTreeViewController ()

@property(nonatomic,strong)MPBinaryTreeNode *rootTreeNode;

@end

@implementation MPBinaryTreeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    //初始化
    [self createBinaryTree];
    
    //先序遍历
    NSMutableArray *orderArray=[[NSMutableArray alloc]init];
    [MPBinaryTreeViewController preOrderTraverseTree:self.rootTreeNode handler:^(MPBinaryTreeNode *treeNode) {
        [orderArray addObject:@(treeNode.nodeValue)];
    }];
    //输出
    NSLog(@"遍历结果：%@",[orderArray componentsJoinedByString:@","]);
    
    //中序遍历
    NSMutableArray *inOrderArray=[[NSMutableArray alloc]init];
    [MPBinaryTreeViewController inOrderTraverseTree:self.rootTreeNode handler:^(MPBinaryTreeNode *treeNode) {
        [inOrderArray addObject:@(treeNode.nodeValue)];
    }];
    NSLog(@"遍历结果：%@",[inOrderArray componentsJoinedByString:@","]);
    
    //后序遍历
    NSMutableArray *postOrderArray=[[NSMutableArray alloc]init];
    [MPBinaryTreeViewController postOrderTraverseTree:self.rootTreeNode handler:^(MPBinaryTreeNode *treeNode) {
        [postOrderArray addObject:@(treeNode.nodeValue)];
    }];
    NSLog(@"遍历结果：%@",[postOrderArray componentsJoinedByString:@","]);
    
    //二叉树所有节点数
    NSLog(@"二叉树的节点数：%ld",[MPBinaryTreeViewController numberOfNodesInTree:self.rootTreeNode]);
    //二叉树的节点数：6
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 二叉树实现功能

-(void)createBinaryTree
{
    MPBinaryTreeNode *node1=[[MPBinaryTreeNode alloc]initTreeNodeWithValue:10 withLeftTreeNode:nil withRightTreeNode:nil];
    
    MPBinaryTreeNode *node2=[[MPBinaryTreeNode alloc]initTreeNodeWithValue:15 withLeftTreeNode:nil withRightTreeNode:nil];
    
    MPBinaryTreeNode *node3=[[MPBinaryTreeNode alloc]initTreeNodeWithValue:19 withLeftTreeNode:node1 withRightTreeNode:node2];
    
    MPBinaryTreeNode *node4=[[MPBinaryTreeNode alloc]initTreeNodeWithValue:25 withLeftTreeNode:nil withRightTreeNode:nil];
    
    MPBinaryTreeNode *node5=[[MPBinaryTreeNode alloc]initTreeNodeWithValue:27 withLeftTreeNode:node4 withRightTreeNode:nil];
    
    self.rootTreeNode=[[MPBinaryTreeNode alloc]initTreeNodeWithValue:30 withLeftTreeNode:node3 withRightTreeNode:node5];
}

/**
 *  先序遍历
 *  先访问根，再遍历左子树，再遍历右子树
 *  遍历结果：30,19,10,15,27,25
 *  @param rootNode 根节点
 *  @param handler  访问节点处理函数
 */
+ (void)preOrderTraverseTree:(MPBinaryTreeNode *)rootNode handler:(void(^)(MPBinaryTreeNode *treeNode))handler {
    if (rootNode) {
        
        if (handler) {
            handler(rootNode);
        }
        
        [self preOrderTraverseTree:rootNode.leftBinaryTreeNode handler:handler];
        [self preOrderTraverseTree:rootNode.rightBinaryTreeNode handler:handler];
    }
}


/**
 *  中序遍历
 *  先遍历左子树，再访问根，再遍历右子树
 *  遍历结果：10,19,15,30,25,27
 *  @param rootNode 根节点
 *  @param handler  访问节点处理函数
 */
+ (void)inOrderTraverseTree:(MPBinaryTreeNode *)rootNode handler:(void(^)(MPBinaryTreeNode *treeNode))handler {
    if (rootNode) {
        [self inOrderTraverseTree:rootNode.leftBinaryTreeNode handler:handler];
        
        if (handler) {
            handler(rootNode);
        }
        
        [self inOrderTraverseTree:rootNode.rightBinaryTreeNode handler:handler];
    }
}


/**
 *  后序遍历
 *  先遍历左子树，再遍历右子树，再访问根
 *  遍历结果:10,15,19,25,27,30
 *  @param rootNode 根节点
 *  @param handler  访问节点处理函数
 */
+ (void)postOrderTraverseTree:(MPBinaryTreeNode *)rootNode handler:(void(^)(MPBinaryTreeNode *treeNode))handler {
    if (rootNode) {
        [self postOrderTraverseTree:rootNode.leftBinaryTreeNode handler:handler];
        [self postOrderTraverseTree:rootNode.rightBinaryTreeNode handler:handler];
        
        if (handler) {
            handler(rootNode);
        }
    }
}


/**
 *  二叉树的所有节点数
 *
 *  @param rootNode 根节点
 *
 *  @return 所有节点数
 */
+ (NSInteger)numberOfNodesInTree:(MPBinaryTreeNode *)rootNode {
    if (!rootNode) {
        return 0;
    }
    //节点数=左子树节点数+右子树节点数+1（根节点）
    return [self numberOfNodesInTree:rootNode.leftBinaryTreeNode] + [self numberOfNodesInTree:rootNode.rightBinaryTreeNode] + 1;
}


/**
 *  翻转二叉树（又叫：二叉树的镜像）
 *
 *  @param rootNode 根节点
 *
 *  @return 翻转后的树根节点（其实就是原二叉树的根节点）
 */
+ (MPBinaryTreeNode *)invertBinaryTree:(MPBinaryTreeNode *)rootNode {
    if (!rootNode) {
        return nil;
    }
    if (!rootNode.leftBinaryTreeNode && !rootNode.rightBinaryTreeNode) {
        return rootNode;
    }
    
    [self invertBinaryTree:rootNode.leftBinaryTreeNode];
    [self invertBinaryTree:rootNode.rightBinaryTreeNode];
    
    MPBinaryTreeNode *tempNode = rootNode.leftBinaryTreeNode;
    rootNode.leftBinaryTreeNode = rootNode.rightBinaryTreeNode;
    rootNode.rightBinaryTreeNode = tempNode;
    
    return rootNode;
}

@end
