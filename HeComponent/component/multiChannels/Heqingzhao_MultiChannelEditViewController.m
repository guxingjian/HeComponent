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
#import "Heqingzhao_ImageLoader.h"
#import <AudioToolbox/AudioToolbox.h>
#import "Heqingzhao_AppContext.h"

@interface Heqingzhao_MultiChannelEditViewController ()<Heqingzhao_MultiChannelEditCellProtocol>

@property(nonatomic, strong)UICollectionView* collectionView;
@property(nonatomic, readwrite)NSMutableArray* tempSelectedTabConfigs;
@property(nonatomic, readwrite)NSMutableArray* tempUnselectedTabConfigs;
@property(nonatomic, assign)BOOL channelEditting;

@end

@implementation Heqingzhao_MultiChannelEditViewController

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
    
    UIButton* btnBack = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    [btnBack setImage:[Heqingzhao_ImageLoader loadImage:@"navi_back"] forState:UIControlStateNormal];
    [btnBack addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* backItem = [[UIBarButtonItem alloc] initWithCustomView:btnBack];
    
    UIButton* btnSave = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    [btnSave addTarget:self action:@selector(saveChannels:) forControlEvents:UIControlEventTouchUpInside];
    [btnSave setTitle:@"保存" forState:UIControlStateNormal];
    [btnSave setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btnSave.titleLabel.font = [UIFont systemFontOfSize:15];
    UIBarButtonItem* btnItem = [[UIBarButtonItem alloc] initWithCustomView:btnSave];
    
    if(self.navigationController){
        self.navigationItem.rightBarButtonItem = btnItem;
        self.navigationItem.leftBarButtonItem = backItem;
        return ;
    }
    
    CGFloat fNaviHeight = [[Heqingzhao_AppContext sharedAppContext] topNaviHeight];
    UIView* topView = [[UIView alloc] initWithFrame:CGRectMake(0, fNaviHeight - 64, self.view.width, 64)];
    topView.backgroundColor = [UIColor colorWithHexString:@"#F3F4F9"];
    [self.view addSubview:topView];
    
    UINavigationBar* naviBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 64)];
    naviBar.barTintColor = topView.backgroundColor;
    UINavigationItem* naviItem = [[UINavigationItem alloc] initWithTitle:self.title];
    naviItem.rightBarButtonItem = btnItem;
    naviItem.leftBarButtonItem = backItem;
    naviBar.items = @[naviItem];
    [topView addSubview:naviBar];
}

- (void)backAction:(UIButton*)btn{
    if(self.navigationController){
        [self.navigationController popViewControllerAnimated:YES];
        return ;
    }
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

- (void)saveChannels:(UIButton*)btn{
    if(self.channelEditting){
        self.channelEditting = NO;
        [self reloadSelectedCellsEditting];
    }
    if([self.delegate respondsToSelector:@selector(saveSelectedConfig:unSelectedConfig:)]){
        [self.delegate saveSelectedConfig:self.tempSelectedTabConfigs unSelectedConfig:self.tempUnselectedTabConfigs];
    }
}

- (void)buildCollectionView{
    UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 15;
    layout.minimumInteritemSpacing = 10;
    layout.sectionInset = UIEdgeInsetsMake(15, 15, 0, 15);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    CGFloat fNaviHeight = [[Heqingzhao_AppContext sharedAppContext] topNaviHeight];
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

- (void)reloadSelectedCellsEditting{
    for(NSInteger i = 0; i < self.tempSelectedTabConfigs.count; ++ i){
        NSIndexPath* indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        Heqingzhao_MultiChannelEditCell* cell = (Heqingzhao_MultiChannelEditCell*)[_collectionView cellForItemAtIndexPath:indexPath];
        if(!cell)
            continue;
        cell.editting = self.channelEditting;
    }
}

- (void)panGesAction:(UILongPressGestureRecognizer*)gestureRecognizer{
    UICollectionView* colView = self.collectionView;
    CGPoint pt = [gestureRecognizer locationInView:colView];
    NSIndexPath* indexPath = [colView indexPathForItemAtPoint:pt];
    if(UIGestureRecognizerStateBegan == gestureRecognizer.state){
        if(1 == indexPath.section)
            return ;
        [colView beginInteractiveMovementForItemAtIndexPath:indexPath];
        self.channelEditting = YES;
        [self reloadSelectedCellsEditting];
        AudioServicesPlaySystemSound(1520);
    }else if(UIGestureRecognizerStateEnded == gestureRecognizer.state){
        [colView endInteractiveMovement];
        
        // to do ... 跨section拖动
        
    }else if(UIGestureRecognizerStateChanged == gestureRecognizer.state){
        [colView updateInteractiveMovementTargetPosition:pt];
    }else{
        [colView cancelInteractiveMovement];
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
    NSInteger nRet = 0;
    if(0 == section){
        nRet = self.tempSelectedTabConfigs.count;
    }else if(1 == section){
        nRet = self.tempUnselectedTabConfigs.count;
    }
    return nRet;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(collectionView.width, 50);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{

    UICollectionReusableView* suplementView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"sectionTitle" forIndexPath:indexPath];

    NSString* strTitle = nil;
    if(0 == indexPath.section){
        strTitle = @"长按编辑频道";
    }else if(1 == indexPath.section){
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
    return CGSizeMake(70, 32);
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
        [cell setStatus:!indexPath.section];
        cell.delegate = self;
        if(self.channelEditting && 0 == indexPath.section){
            cell.editting = YES;
        }else{
            cell.editting = NO;
        }
    }
    
    return cell;
}

- (NSIndexPath *)collectionView:(UICollectionView *)collectionView targetIndexPathForMoveFromItemAtIndexPath:(NSIndexPath *)originalIndexPath toProposedIndexPath:(NSIndexPath *)proposedIndexPath{
    if(1 == proposedIndexPath.section){
        return nil;
    }
    return proposedIndexPath;
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
        NSMutableArray* arrayTempArray = self.tempSelectedTabConfigs;
        NSInteger nBeginIndex = sourceIndexPath.row;
        NSInteger nEndIndex = destinationIndexPath.row;
        [self adjustArray:arrayTempArray withBeginIndex:nBeginIndex endIndex:nEndIndex];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if(0 == indexPath.section)
        return ;
    
    if(indexPath.row < self.tempUnselectedTabConfigs.count){
        
        Heqingzhao_MultiChannelEditCell* editCell = (Heqingzhao_MultiChannelEditCell*)[collectionView cellForItemAtIndexPath:indexPath];
        [editCell setStatus:1];
        [editCell setEditting:self.channelEditting];
        Heqingzhao_MultiChannelConfig* config = [self.tempUnselectedTabConfigs objectAtIndex:indexPath.row];
        [self.tempUnselectedTabConfigs removeObject:config];
        [self.tempSelectedTabConfigs addObject:config];
        [collectionView moveItemAtIndexPath:indexPath toIndexPath:[NSIndexPath indexPathForRow:self.tempSelectedTabConfigs.count - 1 inSection:0]];
    
    }
}

- (void)willRemoveeditCell:(Heqingzhao_MultiChannelEditCell *)cell{
    [cell setStatus:0];
    [cell setEditting:NO];
    
    NSIndexPath* indexPath = [self.collectionView indexPathForCell:cell];
    Heqingzhao_MultiChannelConfig* config = [self.tempSelectedTabConfigs objectAtIndex:indexPath.row];
    [self.tempSelectedTabConfigs removeObject:config];
    [self.tempUnselectedTabConfigs insertObject:config atIndex:0];
    [self.collectionView moveItemAtIndexPath:indexPath toIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
}

@end
