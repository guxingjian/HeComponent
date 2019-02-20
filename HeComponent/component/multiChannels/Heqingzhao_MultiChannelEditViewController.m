//
//  Heqingzhao_MultiChannelEditViewController.m
//  HeComponent
//
//  Created by qingzhao on 2019/2/19.
//  Copyright © 2019年 qingzhao. All rights reserved.
//

#import "Heqingzhao_MultiChannelEditViewController.h"
#import "UIView+view_frame.h"
#import "Heqingzhao_SinglePixelView.h"
#import "UIColor+extension_qingzhao.h"
#import "Heqingzhao_MultiChannelEditCell.h"

@interface Heqingzhao_flowLayout : UICollectionViewFlowLayout

@property(nonatomic, strong)NSMutableDictionary* dicLayout;

@end

@implementation Heqingzhao_flowLayout

@end

@interface Heqingzhao_MultiChannelEditViewController ()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate>

@property(nonatomic, strong)UICollectionView* collectionView;
@property(nonatomic, readwrite)NSIndexPath* movingIndexPath;
@property(nonatomic, readwrite)NSMutableArray* tempSelectedTabConfigs;
@property(nonatomic, readwrite)NSMutableArray* tempUnselectedTabConfigs;
@property(nonatomic, strong)UICollectionReusableView* unSelectedSectionView;

@property(nonatomic, assign)CGFloat fPosY;

@end

@implementation Heqingzhao_MultiChannelEditViewController

- (CGFloat)topNaviHeight{
    return 88;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self buildCollectionView];
    [self setupNavigationBar];
}

- (void)setupNavigationBar{
    if(self.title.length == 0){
        self.title = @"编辑频道";
    }
    
    UIButton* btnSave = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    [btnSave addTarget:self action:@selector(saveChannels:) forControlEvents:UIControlEventTouchUpInside];
    [btnSave setTitle:@"完成" forState:UIControlStateNormal];
    [btnSave setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btnSave.titleLabel.font = [UIFont systemFontOfSize:15];
    UIBarButtonItem* btnItem = [[UIBarButtonItem alloc] initWithCustomView:btnSave];
    
    if(self.navigationController){
        self.navigationItem.rightBarButtonItem = btnItem;
        return ;
    }
    
    CGFloat fNaviHeight = [self topNaviHeight];
    UIView* topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, fNaviHeight)];
    topView.backgroundColor = [UIColor colorWithHexString:@"#F3F4F9"];
    [self.view addSubview:topView];
    
    UINavigationBar* naviBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, fNaviHeight - 44, self.view.width, 44)];
    naviBar.barTintColor = topView.backgroundColor;
    UINavigationItem* naviItem = [[UINavigationItem alloc] initWithTitle:self.title];
    naviItem.rightBarButtonItem = btnItem;
    naviBar.items = @[naviItem];
    [self.view addSubview:naviBar];
}

- (void)saveChannels:(UIButton*)btn{
    
    NSLog(@"selectedConfig: %@", self.tempSelectedTabConfigs);
    NSLog(@"unselectedConfig: %@", self.tempUnselectedTabConfigs);
    
    if([self.delegate respondsToSelector:@selector(saveSelectedConfig:unSelectedConfig:)]){
        [self.delegate saveSelectedConfig:self.tempSelectedTabConfigs unSelectedConfig:self.tempUnselectedTabConfigs];
    }
    
    if(self.navigationController){
        [self.navigationController popViewControllerAnimated:YES];
        return ;
    }
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

- (void)buildCollectionView{
    
    Heqingzhao_flowLayout* layout = [[Heqingzhao_flowLayout alloc] init];
    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = 10;
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 0, 10);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    CGFloat fNaviHeight = [self topNaviHeight];
    UICollectionView* collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, fNaviHeight, self.view.width, self.view.height - fNaviHeight) collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.alwaysBounceVertical = YES;
    [collectionView registerClass:[Heqingzhao_MultiChannelEditCell class] forCellWithReuseIdentifier:@"editCell"];
        [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"sectionTitle"];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
    
    UILongPressGestureRecognizer* tapGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(panGesAction:)];
    [collectionView addGestureRecognizer:tapGes];
    tapGes.delegate = self;
}

- (NSIndexPath*)findTargetIndexPath:(CGPoint)pt{ // 
    UICollectionViewCell* cell = nil;
    CGPoint centerPt = CGPointZero;
    for(NSInteger i = 0; i < self.tempUnselectedTabConfigs.count; ++ i){
        NSIndexPath* indexPath = [NSIndexPath indexPathForRow:i inSection:1];
        cell = [_collectionView cellForItemAtIndexPath:indexPath];
        centerPt = [_collectionView convertPoint:CGPointMake(cell.width/2,cell.height/2) fromView:cell];
        if((pt.x - centerPt.x < 20 && pt.x - centerPt.x > -10) && (pt.y - centerPt.y < 10 && pt.y - centerPt.y > -10)) // 不精准的比较
            return indexPath;
    }
    return [NSIndexPath indexPathForRow:self.tempUnselectedTabConfigs.count inSection:1];
}

- (void)panGesAction:(UILongPressGestureRecognizer*)gestureRecognizer{
    UICollectionView* colView = self.collectionView;
    CGPoint pt = [gestureRecognizer locationInView:colView];
    NSIndexPath* indexPath = [colView indexPathForItemAtPoint:pt];
    if(UIGestureRecognizerStateBegan == gestureRecognizer.state){
        if(1 == indexPath.section)
            return ;
        self.movingIndexPath = indexPath;
        [colView beginInteractiveMovementForItemAtIndexPath:indexPath];
    }else if(UIGestureRecognizerStateEnded == gestureRecognizer.state){
        
        [colView endInteractiveMovement];
        if(pt.y > self.fPosY && self.movingIndexPath){
            
            Heqingzhao_MultiChannelConfig* config = [self.tempSelectedTabConfigs objectAtIndex:self.movingIndexPath.row];
            [self.tempSelectedTabConfigs removeObject:config];
            NSIndexPath* targetIndexPath = [self findTargetIndexPath:pt];
            [self.tempUnselectedTabConfigs insertObject:config atIndex:targetIndexPath.row];
            [colView moveItemAtIndexPath:self.movingIndexPath toIndexPath:targetIndexPath];
            [self updateUnsectedSectionPosY];
        }
        self.movingIndexPath = nil;
    }else if(UIGestureRecognizerStateChanged == gestureRecognizer.state){
        [colView updateInteractiveMovementTargetPosition:pt];
    }else{
        [colView cancelInteractiveMovement];
        self.movingIndexPath = nil;
    }
}

- (void)setSelectedTabConfigs:(NSArray *)selectedTabConfigs{
    _selectedTabConfigs = selectedTabConfigs;
    self.tempSelectedTabConfigs = [NSMutableArray arrayWithArray:selectedTabConfigs];
    [self.collectionView reloadData];
}

- (void)setUnselectedTabConfigs:(NSArray *)unselectedTabConfigs{
    _unselectedTabConfigs = unselectedTabConfigs;
    self.tempUnselectedTabConfigs = [NSMutableArray arrayWithArray:unselectedTabConfigs];
    [self.collectionView reloadData];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if(0 == section){
        return self.tempSelectedTabConfigs.count;
    }else if(1 == section){
        return self.tempUnselectedTabConfigs.count;
    }
    return 0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(collectionView.width, 50);
}

- (void)updateUnsectedSectionPosY{
    dispatch_async(dispatch_get_main_queue(), ^{
        UICollectionReusableView* tempView = self.unSelectedSectionView;
        CGPoint pt = [self.collectionView convertPoint:CGPointMake(0, tempView.height) fromView:tempView];
        self.fPosY = pt.y;
    });
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{

    UICollectionReusableView* suplementView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"sectionTitle" forIndexPath:indexPath];

    NSString* strTitle = nil;
    if(0 == indexPath.section){
        strTitle = @"长按编辑频道";
    }else if(1 == indexPath.section){
        self.unSelectedSectionView = suplementView;
        [self updateUnsectedSectionPosY];
        strTitle = @"添加频道";
    }

    UILabel* labelTitle = [suplementView viewWithTag:1001];
    if(!labelTitle){
        labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, 50)];
        labelTitle.tag = 1001;
        labelTitle.textColor = [UIColor blackColor];
        labelTitle.font = [UIFont systemFontOfSize:16];
        [suplementView addSubview:labelTitle];
    }
    labelTitle.text = strTitle;
    
    UIView* lineView = [suplementView viewWithTag:1002];
    if(!lineView){
        lineView = [[Heqingzhao_SinglePixelHorizontalView alloc] initWithFrame:CGRectMake(15, 49, collectionView.width - 15*2, 1)];
        lineView.tag = 1002;
        [suplementView addSubview:lineView];
    }
    
    return suplementView;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSArray* arrayConfigs = nil;
    if(0 == indexPath.section){
        arrayConfigs = self.tempSelectedTabConfigs;
    }else{
        arrayConfigs = self.tempUnselectedTabConfigs;
    }
    
    if(indexPath.row < arrayConfigs.count){
        return CGSizeMake(80, 32);
    }
    return CGSizeZero;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    Heqingzhao_MultiChannelEditCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"editCell" forIndexPath:indexPath];
    
    NSArray* arrayConfigs = nil;
    if(0 == indexPath.section){
        arrayConfigs = self.tempSelectedTabConfigs;
    }else{
        arrayConfigs = self.tempUnselectedTabConfigs;
    }
    
    if(indexPath.row < arrayConfigs.count){
        Heqingzhao_MultiChannelConfig* config = [arrayConfigs objectAtIndex:indexPath.row];
        [cell setConfig:config];
    }
    cell.indexPath = indexPath;
    return cell;
}

- (void)adjustArray:(NSMutableArray*)arrayImages withBeginIndex:(NSInteger)nBeginIndex endIndex:(NSInteger)nEndIndex{
    NSString* sourceImage = [arrayImages objectAtIndex:nBeginIndex];
    if(nBeginIndex > nEndIndex){
        for(NSInteger i = nBeginIndex; i > nEndIndex; -- i){
            [arrayImages replaceObjectAtIndex:i withObject:[arrayImages objectAtIndex:i - 1]];
        }
        [arrayImages replaceObjectAtIndex:nEndIndex withObject:sourceImage];
    }else{
        for(NSInteger i = nBeginIndex; i < nEndIndex; ++ i){
            [arrayImages replaceObjectAtIndex:i withObject:[arrayImages objectAtIndex:i + 1]];
        }
    }
    [arrayImages replaceObjectAtIndex:nEndIndex withObject:sourceImage];
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath{
    if(1 == indexPath.section)
        return NO;
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    if(0 == sourceIndexPath.section && 0 == destinationIndexPath.section)
    {
        NSMutableArray* arrayTempArray = nil;
        if(0 == sourceIndexPath.section){
            arrayTempArray = self.tempSelectedTabConfigs;
        }else if(1 == sourceIndexPath.section){
            arrayTempArray = self.tempUnselectedTabConfigs;
        }
        
        NSInteger nBeginIndex = sourceIndexPath.row;
        NSInteger nEndIndex = destinationIndexPath.row;
        [self adjustArray:arrayTempArray withBeginIndex:nBeginIndex endIndex:nEndIndex];
        return ;
    }
    
    NSMutableArray* arraySource = nil;
    NSMutableArray* arrayDes = nil;
    if(0 == sourceIndexPath.section && 1 == destinationIndexPath.section){
        arraySource = self.tempSelectedTabConfigs;
        arrayDes = self.tempUnselectedTabConfigs;
    }else if(1 == sourceIndexPath.section && 0 == destinationIndexPath.section){
        arraySource = self.tempUnselectedTabConfigs;
        arrayDes = self.tempSelectedTabConfigs;
    }
    Heqingzhao_MultiChannelConfig* config = [arraySource objectAtIndex:sourceIndexPath.row];
    [arraySource removeObject:config];
    [arrayDes insertObject:config atIndex:destinationIndexPath.row];
    [collectionView reloadData];
}

- (NSIndexPath *)collectionView:(UICollectionView *)collectionView targetIndexPathForMoveFromItemAtIndexPath:(NSIndexPath *)originalIndexPath toProposedIndexPath:(NSIndexPath *)proposedIndexPath{
    if(1 == proposedIndexPath.section){
        return nil;
    }
    return proposedIndexPath;
}

@end
