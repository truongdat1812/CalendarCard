//
//  StaticData.h
//  CalendarCreator
//
//  Created by Truong Dat on 8/13/13.
//  Copyright (c) 2013 Truong Dat. All rights reserved.
//

#import <Foundation/Foundation.h>

//detect iphone5 and ipod5
#define IS_WIDESCREEN ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )
#define IS_IPHONE ( [ [ [ UIDevice currentDevice ] model ] isEqualToString: @"iPhone" ] )
#define IS_IPOD   ( [ [ [ UIDevice currentDevice ] model ] isEqualToString: @"iPod touch" ] )
#define IS_IPHONE_5 ( IS_IPHONE && IS_WIDESCREEN )

@interface StaticData : NSObject
{

}

+ (UIImage *)convertImageToGrayScale:(UIImage *)image;
+(StaticData *)getInstance;
@end
