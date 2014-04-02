//
//  ImageSaver.m
//
//
//  Created by Raphael Pinto on 01/04/2014.
//
//
// The MIT License (MIT)
// Copyright (c) 2012 Raphael Pinto.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.



#import "ImageSaver.h"
#import "ImageSaverDelegate.h"
#import <AssetsLibrary/AssetsLibrary.h>



@implementation ImageSaver



#pragma mark -
#pragma mark Data Management Methods



- (void)saveImageToDisk:(UIImage*)_Image delegate:(id<ImageSaverDelegate>)_Delegate
{
    ALAuthorizationStatus status = [ALAssetsLibrary authorizationStatus];
    
    if (status == ALAuthorizationStatusDenied || status == ALAuthorizationStatusRestricted)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Attention"
                                                        message:@"Please give this app permission to access your photo library in your settings app!"
                                                       delegate:nil
                                              cancelButtonTitle:@"Close"
                                              otherButtonTitles:nil, nil];
        [alert show];
        
        [_Delegate imageSaverAuthorizationDenied:self];
    }
    else
    {
        [self retain];
        self.mDelegate = _Delegate;
        UIImageWriteToSavedPhotosAlbum(_Image, self, @selector(image: hasBeenSavedInPhotoAlbumWithError: usingContextInfo:), nil);
    }
}


- (void)image:(UIImage *)image hasBeenSavedInPhotoAlbumWithError:(NSError *)error usingContextInfo:(void*)ctxInfo
{
    if (error)
    {
        [self.mDelegate imageSaverAuthorizationDenied:self];
    }
    else
    {
        [self.mDelegate imageSaverDidSave:self];
    }
    
    [self release];
}



@end
