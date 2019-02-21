//
//  PopCollectionView.m
//  EditCollectionView
//
//  Created by wdyzmx on 2018/4/13.
//  Copyright © 2018年 wdyzmx. All rights reserved.
//

#import "PopCollectionView.h"
#define rowMargin 10
#define columnMargin 10
#define sectionEdgeInsets UIEdgeInsetsMake(10, 10, 10, 10)

@interface PopCollectionView ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>{
    NSInteger startSection;
    NSInteger endSection;
    NSInteger startItem;
    NSInteger endItem;
}

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGesture;
@property (nonatomic, strong) NSMutableArray *selectedArr;
@property (nonatomic, strong) NSMutableArray *unselectedArr;
@end

@implementation PopCollectionView

-(instancetype)initWithFrame:(CGRect)frame selectedArray:(NSArray *)selectedArr unselectedArray:(NSArray *)unselectedArr{
    if (self = [super initWithFrame:frame]) {
        [self initData];//初始化数据
        self.selectedArr = [NSMutableArray arrayWithArray:selectedArr];
        self.unselectedArr = [NSMutableArray arrayWithArray:unselectedArr];
        [self addSubview:self.collectionView];
    }
    return self;
}
-(void)initData{
    startSection = 0;
    endSection = 0;
    startItem = 0;
    endItem = 0;
}
#pragma mark ========== UICollectionViewDataSource ==========
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section==0) {
        return self.selectedArr.count;
    }else{
        return self.unselectedArr.count;
    }
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellid" forIndexPath:indexPath];
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    cell.backgroundColor = [UIColor grayColor];
    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
    [cell.contentView addSubview:lb];
    lb.userInteractionEnabled = YES;
    if (indexPath.section==0) {
        lb.text = self.selectedArr[indexPath.item];
    }else{
        lb.text = self.unselectedArr[indexPath.item];
    }
    lb.textAlignment = NSTextAlignmentCenter;
    lb.font = [UIFont systemFontOfSize:12.0];
    lb.textColor = [UIColor whiteColor];
    return cell;
}
-(BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
-(void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    NSLog(@"起点==%ld", sourceIndexPath.item);
    NSLog(@"终点==%ld", destinationIndexPath.item);
    startItem = sourceIndexPath.item;
    endItem = destinationIndexPath.item;
    [self updateDataSource];
}
#pragma mark ========== UICollectionViewDelegateFlowLayout ==========
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGSize size = CGSizeMake((self.frame.size.width-sectionEdgeInsets.left-sectionEdgeInsets.right-columnMargin*3)/4, (self.frame.size.width-sectionEdgeInsets.left-sectionEdgeInsets.right-columnMargin*3)/4/2);
    return size;
}
#pragma mark ========== UICollectionViewDelegate UICollectionReusableView ==========
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
        reusableView.backgroundColor = [UIColor grayColor];
        for (UIView *view in reusableView.subviews) {
            [view removeFromSuperview];
        }
        UILabel *lb = [[UILabel alloc] initWithFrame:reusableView.bounds];
        [reusableView addSubview:lb];
        if (indexPath.section==0) {
            lb.text = @"已选择";
        }else{
            lb.text = @"未选择";
        }
        return reusableView;
    }
    return nil;
    
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(self.frame.size.width, 30);
}
#pragma mark ========== 手势longPress ==========
-(void)longPress:(UILongPressGestureRecognizer *)longPress{
    CGPoint point = [longPress locationInView:self.collectionView];
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:point];
    if (longPress.state==UIGestureRecognizerStateBegan) {
        startSection = indexPath.section;
        [self.collectionView beginInteractiveMovementForItemAtIndexPath:indexPath];
    }
    else if (longPress.state==UIGestureRecognizerStateChanged) {
        [self.collectionView updateInteractiveMovementTargetPosition:point];
    }
    else if (longPress.state==UIGestureRecognizerStateEnded) {
        endSection = indexPath.section;
        if (startSection!=endSection) {//只有同一section内可以移动item
            [self.collectionView cancelInteractiveMovement];
        }else{
            [self.collectionView endInteractiveMovement];
        }
    }else{
        [self.collectionView cancelInteractiveMovement];
    }
}
#pragma mark ========== 更新数据 ==========

-(void)updateDataSource{
    if (startSection==0) {
        [self.selectedArr exchangeObjectAtIndex:startItem withObjectAtIndex:endItem];
    }
    if (endSection==0) {
        [self.unselectedArr exchangeObjectAtIndex:startItem withObjectAtIndex:endItem];
    }
}
#pragma mark ========== 懒加载 ==========
-(UICollectionView *)collectionView{
    if (_collectionView==nil) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        flowLayout.minimumLineSpacing = columnMargin;
        flowLayout.minimumInteritemSpacing = rowMargin;
        flowLayout.sectionInset = sectionEdgeInsets;
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellid"];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
        //添加长按手势
        self.longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
        [_collectionView addGestureRecognizer:self.longPressGesture];
    }
    return _collectionView;
}
-(NSMutableArray *)selectedArr{
    if (_selectedArr==nil) {
        _selectedArr = [NSMutableArray array];
    }
    return _selectedArr;
}
-(NSMutableArray *)unselectedArr{
    if (_unselectedArr==nil) {
        _unselectedArr = [NSMutableArray array];
    }
    return _unselectedArr;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
