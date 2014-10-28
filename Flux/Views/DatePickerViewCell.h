//
//  DatePickerViewCell.h
//  Flux
//
//  Created by hdd on 26/10/2014.
//  Copyright (c) 2014 Rhys Powell. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DatePickerViewCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UILabel *cellLabel;
@property (strong, nonatomic) NSURL *cellURL;

- (DatePickerViewCell *)copy;
@end
