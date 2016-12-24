//////////////////////////////////////////////////////////////////////////////////////
//
//  Copyright 2012 Freshplanet (http://freshplanet.com | opensource@freshplanet.com)
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
//////////////////////////////////////////////////////////////////////////////////////

#import "AirDatePicker.h"
#import <UIKit/UIKit.h>

FREContext AirDatePickerCtx = nil;

@interface AirDatePicker ()

@property (nonatomic,retain) UIPopoverController *popover;

-(void)dateChanged:(id)sender;

@end

@implementation AirDatePicker

@synthesize popover = _popover;
@synthesize datePicker = _datePicker;

#pragma mark - Singleton

static AirDatePicker *sharedInstance = nil;
static NSDate *minimumDate = nil;
static NSDate *maximumDate = nil;

+ (AirDatePicker *)sharedInstance
{
    if (!sharedInstance)
    {
        sharedInstance = [[super allocWithZone:NULL] init];
    }
    return sharedInstance;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [self sharedInstance];
}

- (id)copy
{
    return self;
}

#pragma mark - UIDatePicker

-(void) showDatePickerPhone:(NSDate *)date
{
    NSLog(@"[AirDatePicker] entering showDatePickerPhone");
    UIView *rootView = [[[[UIApplication sharedApplication] keyWindow] rootViewController] view];
    
    self.datePicker = [[UIDatePicker alloc] init];
    self.datePicker.datePickerMode = UIDatePickerModeTime;

    if(minimumDate != nil)
    {
        self.datePicker.minimumDate = minimumDate;
    }
    
    if(maximumDate != nil)
    {
        self.datePicker.maximumDate = maximumDate;
    }
    
    ///////////datepicker/////////////
    
    self.datePicker.minuteInterval = 1;
    self.datePicker.hidden = NO;
    self.datePicker.date = date;
    self.datePicker.backgroundColor = [UIColor colorWithRed:255/255 green:255/255 blue:255/255 alpha:1.0];
//    [self.datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
    
    CGRect datePickerFrame = self.datePicker.frame;
    datePickerFrame.origin.y = rootView.bounds.size.height - datePickerFrame.size.height;
    self.datePicker.frame = datePickerFrame;
    
    [rootView addSubview:self.datePicker];
    NSLog(@"[AirDatePicker] exiting showDatePickerPhone");
    
    /////////////button bg////////////
    
    self.btn_bg = [[UIView alloc] initWithFrame:CGRectMake(0, datePickerFrame.origin.y - 40, rootView.bounds.size.width, 40)];
    self.btn_bg.backgroundColor = [UIColor whiteColor];
    [rootView addSubview:self.btn_bg];
    
    
    /////////////button//////////////
    
    self.button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.button.frame = CGRectMake(rootView.bounds.size.width - 60, datePickerFrame.origin.y - 40, 50.0, 40.0);
    [self.button setTitle:@"선택" forState:UIControlStateNormal];
    UIColor* color = [UIColor colorWithRed:88/255 green:88/255 blue:88/255 alpha:1.0];
    [self.button setTitleColor:color forState:UIControlStateNormal];
    [self.button setTintColor:[UIColor colorWithRed:255/255 green:255/255 blue:255/255 alpha:1.0]];
    [self.button addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventTouchUpInside];
    
    [rootView addSubview:self.button];
}

- (void) showDatePickerPad:(NSDate*)date anchor:(CGRect)anchor
{
    self.datePicker=[[UIDatePicker alloc] initWithFrame:CGRectMake(0,0,300,216)];
    self.datePicker.datePickerMode = UIDatePickerModeTime;
    
    if(minimumDate != nil) {
        self.datePicker.minimumDate = minimumDate;
    }
    
    if(maximumDate != nil) {
        self.datePicker.maximumDate = maximumDate;
    }
    
    self.datePicker.hidden = NO;
    self.datePicker.date = date;
    [self.datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
    

    UIView *rootView = [[[[UIApplication sharedApplication] keyWindow] rootViewController] view];
    UIViewController *popoverViewController = [[UIViewController alloc] init];
    UIView *popoverView = [[UIView alloc] init];
    [popoverView addSubview:self.datePicker];
    popoverViewController.view = popoverView;
    
    CGRect anchory = CGRectMake(anchor.origin.x, anchor.origin.y, 300, 216);

    self.popover = [[UIPopoverController alloc] initWithContentViewController:popoverViewController];
    self.popover.popoverContentSize = CGSizeMake(300, 216);
    self.popover.delegate = self;
    self.popover.passthroughViews = [NSArray arrayWithObject:rootView];
    [self.popover presentPopoverFromRect:anchory inView:rootView permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}

- (void) removeDatePicker
{
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        [self.popover dismissPopoverAnimated:YES];
        self.popover.delegate = nil;
        self.popover = nil;
    }
    else
    {
        [self.datePicker removeFromSuperview];
        [self.button removeFromSuperview];
        [self.btn_bg removeFromSuperview];
    }
}

#pragma mark - UIPopoverControllerDelegate

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    if (self.popover)
    {
        [self.popover dismissPopoverAnimated:YES];
        self.popover = nil;
    }
}

#pragma mark - UIAlertViewDelegate

- (void)dateChanged:(id) sender
{
    // Use date picker to write out the date in a %Y-%m-%d format
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"HHmm"];
    NSString *formatedDate = [df stringFromDate:self.datePicker.date];
    
    // send data to actionscript
    FREDispatchStatusEventAsync(AirDatePickerCtx, (const uint8_t *)"CHANGE", (const uint8_t *)[formatedDate UTF8String]);
}

@end


#pragma mark - C interface

DEFINE_ANE_FUNCTION(AirDatePickerDisplayDatePicker)
{
    uint32_t stringLength;
    
    NSString *year = nil;
    NSString *month = nil;
    NSString *day = nil;
    
    // Retrieve year
    const uint8_t *yearString;
    if (FREGetObjectAsUTF8(argv[0], &stringLength, &yearString) == FRE_OK)
    {
        year = [NSString stringWithUTF8String:(char *)yearString];
    }
    
    // Retrieve month
    const uint8_t *monthString;
    if (FREGetObjectAsUTF8(argv[1], &stringLength, &monthString) == FRE_OK)
    {
        month = [NSString stringWithUTF8String:(char *)monthString];
    }
    
    // Retrieve day
    const uint8_t *dayString;
    if (FREGetObjectAsUTF8(argv[2], &stringLength, &dayString) == FRE_OK)
    {
        day = [NSString stringWithUTF8String:(char *)dayString];
    }
    
    // Build an NSDate instance from the AS3 data.
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"HH:mm"];  // According to the tr35-10 standard, date format should be MMMM/dd/yyyy.
    NSDate *date = [df dateFromString:[NSString stringWithFormat:@"%@:%@",month,day]];
    
    // Extract Anchor for UIPopoverController (iPad only) or default to top right corner
    CGRect anchor;
    if (argc > 3)
    {
        // Extract Anchor properties
        FREObject anchorObject = argv[3];
        FREObject anchorX, anchorY, anchorWidth, anchorHeight, thrownException;
        FREGetObjectProperty(anchorObject, (const uint8_t *)"x", &anchorX, &thrownException);
        FREGetObjectProperty(anchorObject, (const uint8_t *)"y", &anchorY, &thrownException);
        FREGetObjectProperty(anchorObject, (const uint8_t *)"width", &anchorWidth, &thrownException);
        FREGetObjectProperty(anchorObject, (const uint8_t *)"height", &anchorHeight, &thrownException);
        
        // Convert anchor properties to double
        double x, y, width, height;
        FREGetObjectAsDouble(anchorX, &x);
        FREGetObjectAsDouble(anchorY, &y);
        FREGetObjectAsDouble(anchorWidth, &width);
        FREGetObjectAsDouble(anchorHeight, &height);
        
        // make a CGRect type
        CGFloat scale = [[UIScreen mainScreen] scale];
        anchor = CGRectMake(x/scale, y/scale, width/scale, height/scale);
        
        NSLog(@"[AirDatePicker] x, y, width, height = %f %f %f %f", anchor.origin.x, anchor.origin.y, anchor.size.width, anchor.size.height);
    }
    else
    {
        UIViewController *rootViewController = [[[UIApplication sharedApplication] keyWindow] rootViewController];
        anchor = CGRectMake(rootViewController.view.bounds.size.width - 100, 0, 100, 1); // Default anchor: Top right corner
    }
    
    // show date picker for iPad/iPhone
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        [[AirDatePicker sharedInstance] showDatePickerPad:date anchor:anchor];
    }
    else
    {
        [[AirDatePicker sharedInstance] showDatePickerPhone:date];
    }

    
    return nil;
}

DEFINE_ANE_FUNCTION(AirDatePickerRemoveDatePicker)
{
    [[AirDatePicker sharedInstance] removeDatePicker];
    
    return nil;
}

DEFINE_ANE_FUNCTION(setMinDate)
{
    NSLog(@"Entering setMinDate");
    if(argc == 1) {
        double millis;
        FREResult result = FREGetObjectAsDouble(argv[0], &millis);
        if (result == FRE_OK) {
            minimumDate = [NSDate dateWithTimeIntervalSince1970:(millis * 0.001)];
        } else {
            NSLog(@"Problem setting minimum date:");
            switch (result) {
                case FRE_TYPE_MISMATCH:
                    NSLog(@" -> FRE_TYPE_MISMATCH");
                    break;
                case FRE_WRONG_THREAD:
                    NSLog(@" -> FRE_WRONG_THREAD");
                    break;
                case FRE_INVALID_ARGUMENT:
                    NSLog(@" -> FRE_INVALID_ARGUMENT");
                    break;
                case FRE_INVALID_OBJECT:
                    NSLog(@" -> FRE_INVALID_OBJECT");
                    break;
            }
        }
    }
    NSLog(@"Exiting setMinDate");
    return nil;
}

DEFINE_ANE_FUNCTION(clearMinDate)
{
    minimumDate = NULL;
    return nil;
}

DEFINE_ANE_FUNCTION(setMaxDate)
{
    NSLog(@"Entering setMaxDate");
    if(argc == 1) {
        double millis;
        FREResult result = FREGetObjectAsDouble(argv[0], &millis);
        if (result == FRE_OK) {
            maximumDate = [NSDate dateWithTimeIntervalSince1970:(millis * 0.001)];
        } else {
            NSLog(@"Problem setting maximum date");
            switch (result) {
                case FRE_TYPE_MISMATCH:
                    NSLog(@" -> FRE_TYPE_MISMATCH");
                    break;
                case FRE_WRONG_THREAD:
                    NSLog(@" -> FRE_WRONG_THREAD");
                    break;
                case FRE_INVALID_ARGUMENT:
                    NSLog(@" -> FRE_INVALID_ARGUMENT");
                    break;
                case FRE_INVALID_OBJECT:
                    NSLog(@" -> FRE_INVALID_OBJECT");
                    break;
            }
        }
    }
    NSLog(@"Exiting setMaxDate");
    return nil;
}

DEFINE_ANE_FUNCTION(clearMaxDate)
{
    maximumDate = NULL;
    return nil;
}


#pragma mark - ANE setup

void AirDatePickerContextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx, uint32_t* numFunctionsToTest, const FRENamedFunction** functionsToSet)
{
    // Register the links btwn AS3 and ObjC. (dont forget to modify the nbFuntionsToLink integer if you are adding/removing functions)
    NSInteger nbFuntionsToLink = 6;
    *numFunctionsToTest = nbFuntionsToLink;
    
    FRENamedFunction* func = (FRENamedFunction*) malloc(sizeof(FRENamedFunction) * nbFuntionsToLink);
    
    func[0].name = (const uint8_t*) "AirDatePickerDisplayDatePicker";
    func[0].functionData = NULL;
    func[0].function = &AirDatePickerDisplayDatePicker;

    func[1].name = (const uint8_t*) "AirDatePickerRemoveDatePicker";
    func[1].functionData = NULL;
    func[1].function = &AirDatePickerRemoveDatePicker;
    
    func[2].name = (const uint8_t*) "setMinimumDate";
    func[2].functionData = NULL;
    func[2].function = &setMinDate;
    
    func[3].name = (const uint8_t*) "setMaximumDate";
    func[3].functionData = NULL;
    func[3].function = &setMaxDate;
    
    func[4].name = (const uint8_t*) "clearMinimumDate";
    func[4].functionData = NULL;
    func[4].function = &clearMinDate;
    
    func[5].name = (const uint8_t*) "clearMaximumDate";
    func[5].functionData = NULL;
    func[5].function = &clearMaxDate;
    
    *functionsToSet = func;
    
    AirDatePickerCtx = ctx;
}

void AirDatePickerContextFinalizer(FREContext ctx) { }

void AirDatePickerInitializer(void** extDataToSet, FREContextInitializer* ctxInitializerToSet, FREContextFinalizer* ctxFinalizerToSet)
{
	*extDataToSet = NULL;
	*ctxInitializerToSet = &AirDatePickerContextInitializer;
	*ctxFinalizerToSet = &AirDatePickerContextFinalizer;
}

void AirDatePickerFinalizer(void* extData) { }