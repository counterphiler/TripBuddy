//
//  HelloWorldViewController.m
//  RichTextEditing
//
//  Created by Bowen Zhang on 8/16/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import "HelloWorldViewController.h"
#import "MobileCoreServices/MobileCoreServices.h"

@interface HelloWorldViewController ()

@end

@implementation HelloWorldViewController

@synthesize webView;
@synthesize timer;
@synthesize imagePath;

BOOL currentBoldStatus;
BOOL currentItalicStatus;
BOOL currentUnderlineStatus;

int currentFontSize;
NSString *currentForeColor;
NSString *currentFontName;

BOOL currentUndoStatus;
BOOL currentRedoStatus;



- (void)viewDidLoad
{
    [super viewDidLoad];
    NSBundle *bundle = [NSBundle mainBundle];
    NSURL *indexFileURL = [bundle URLForResource:@"index" withExtension:@"html"];
    [webView loadRequest:[NSURLRequest requestWithURL:indexFileURL]];
//    NSArray *paths1 = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
//    NSString *documentsDir = [paths1 objectAtIndex:0];
//    NSString *filePath = [NSString stringWithFormat:@"%@%@", documentsDir, @"first.html"];
//    NSString *htmlString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
//    NSString *filePath2 = [NSString stringWithFormat:@"%@%@", documentsDir, @"first.html"];
//    NSString *htmlString2 = [NSString stringWithContentsOfFile:filePath2 encoding:NSUTF8StringEncoding error:nil];
//    NSRange range = [htmlString2 rangeOfString:@"<body>"];
//    NSRange endRange = [htmlString2 rangeOfString:@"</body>"];
//    NSRange usefulStr = NSMakeRange(range.location+8, endRange.location-24);
//    htmlString2 = [htmlString2 substringWithRange:usefulStr];
//    NSRange range1 = [htmlString rangeOfString:@"</div>"];
//    
//    htmlString = [NSString stringWithFormat:@"%@%@%@", [htmlString substringToIndex:range1.location+6], htmlString2, [htmlString substringFromIndex:range1.location+6]];
//    
//    
//    [webView loadHTMLString:htmlString baseURL:nil];
//    webView.scalesPageToFit = YES;
    
//    NSMutableArray *items = [[NSMutableArray alloc] init];
    
//    UIBarButtonItem *bold = [[UIBarButtonItem alloc] initWithTitle:@"B" style:UIBarButtonItemStyleBordered target:self action:@selector(bold)];
//    UIBarButtonItem *italic = [[UIBarButtonItem alloc] initWithTitle:@"I" style:UIBarButtonItemStyleBordered target:self action:@selector(italic)];
//    UIBarButtonItem *underline = [[UIBarButtonItem alloc] initWithTitle:@"U" style:UIBarButtonItemStyleBordered target:self action:@selector(underline)];
    
//    [items addObject:underline];
//    [items addObject:italic];
//    [items addObject:bold];
    
//    self.navigationItem.rightBarButtonItems = items;
    
    [self checkSelection:self];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(checkSelection:) userInfo:nil repeats:YES];
	
    UIMenuItem *highlightMenuItem = [[UIMenuItem alloc] initWithTitle:@"Highlight" action:@selector(highlight)];
    [[UIMenuController sharedMenuController] setMenuItems:[NSArray arrayWithObject:highlightMenuItem]];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)checkSelection:(id)sender {
    BOOL boldEnabled = [[webView stringByEvaluatingJavaScriptFromString:@"document.queryCommandState('Bold')"] boolValue];
    BOOL italicEnabled = [[webView stringByEvaluatingJavaScriptFromString:@"document.queryCommandState('Italic')"] boolValue];
    BOOL underlineEnabled = [[webView stringByEvaluatingJavaScriptFromString:@"document.queryCommandState('Underline')"] boolValue];
    
    NSMutableArray *items = [[NSMutableArray alloc] init];
    
    UIBarButtonItem *bold = [[UIBarButtonItem alloc] initWithTitle:(boldEnabled) ? @"[B]" : @"B" style:UIBarButtonItemStyleBordered target:self action:@selector(bold)];
    UIBarButtonItem *italic = [[UIBarButtonItem alloc] initWithTitle:(italicEnabled) ? @"[I]" : @"I" style:UIBarButtonItemStyleBordered target:self action:@selector(italic)];
    UIBarButtonItem *underline = [[UIBarButtonItem alloc] initWithTitle:(underlineEnabled) ? @"[U]" : @"U" style:UIBarButtonItemStyleBordered target:self action:@selector(underline)];
    
    [items addObject:underline];
    [items addObject:italic];
    [items addObject:bold];
    
    if (currentBoldStatus != boldEnabled || currentItalicStatus != italicEnabled || currentUnderlineStatus != underlineEnabled || sender == self) {
        self.navigationItem.rightBarButtonItems = items;
        currentBoldStatus = boldEnabled;
        currentItalicStatus = italicEnabled;
        currentUnderlineStatus = underlineEnabled;
    }
    
    NSString *currentColor = [webView stringByEvaluatingJavaScriptFromString:@"document.queryCommandValue('backColor')"];
    BOOL isYellow = [currentColor isEqualToString:@"rgb(255, 255, 0)"];
    UIMenuItem *highlightMenuItem = [[UIMenuItem alloc] initWithTitle:(isYellow) ? @"De-Highlight" : @"Highlight" action:@selector(highlight)];
    [[UIMenuController sharedMenuController] setMenuItems:[NSArray arrayWithObject:highlightMenuItem]];


    [items removeAllObjects];
    
   
    
    UIBarButtonItem *plusFontSize = [[UIBarButtonItem alloc] initWithTitle:@"+" style:UIBarButtonItemStyleBordered target:self action:@selector(fontSizeUp)];
    UIBarButtonItem *minusFontSize = [[UIBarButtonItem alloc] initWithTitle:@"-" style:UIBarButtonItemStyleBordered target:self action:@selector(fontSizeDown)];
    
    int size = [[webView stringByEvaluatingJavaScriptFromString:@"document.queryCommandValue('fontSize')"] intValue];
    if (size == 7)
        plusFontSize.enabled = NO;
    else if (size == 1)
        minusFontSize.enabled = NO;
    
    [items addObject:plusFontSize];
    [items addObject:minusFontSize];
    
//    if (currentFontSize != size || sender == self) {
//        self.navigationItem.leftBarButtonItems = items;
//        currentFontSize = size;
//    }
    
    UIBarButtonItem *undo = [[UIBarButtonItem alloc] initWithTitle:@"Undo" style:UIBarButtonItemStyleBordered target:self action:@selector(undo)];
    UIBarButtonItem *redo = [[UIBarButtonItem alloc] initWithTitle:@"Redo" style:UIBarButtonItemStyleBordered target:self action:@selector(redo)];
    
    BOOL undoAvailable = [[webView stringByEvaluatingJavaScriptFromString:@"document.queryCommandEnabled('undo')"] boolValue];
    BOOL redoAvailable = [[webView stringByEvaluatingJavaScriptFromString:@"document.queryCommandEnabled('redo')"] boolValue];
    
    if (!undoAvailable)
        [undo setEnabled:NO];
    
    if (!redoAvailable)
        [redo setEnabled:NO];
    
    [items addObject:undo];
    [items addObject:redo];
    
    UIBarButtonItem *insertPhoto = [[UIBarButtonItem alloc] initWithTitle:@"Photo" style:UIBarButtonItemStyleBordered target:self action:@selector(insertPhoto:)];
    [items addObject:insertPhoto];

    if (currentFontSize != size || currentUndoStatus != undoAvailable || currentRedoStatus != redoAvailable || sender == self) {
        self.navigationItem.leftBarButtonItems = items;
        currentFontSize = size;
        currentUndoStatus = undoAvailable;
        currentRedoStatus = redoAvailable;
    }
    
    }

- (void)insertPhoto:(id)sender {
        [webView stringByEvaluatingJavaScriptFromString:@"prepareInsertImage()"];
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];//,kUTTypeVideo,kUTTypeImage, kUTTypeMovie
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.delegate = self;
    
    imagePicker.allowsEditing = YES;//YES in image
    [self presentViewController:imagePicker animated:YES completion:nil];
    
//    UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
//    [popover presentPopoverFromBarButtonItem:(UIBarButtonItem *)sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
//    imagePickerPopover = popover;
}

- (void)undo {
    [webView stringByEvaluatingJavaScriptFromString:@"document.execCommand('undo')"];
}

- (void)redo {
    [webView stringByEvaluatingJavaScriptFromString:@"document.execCommand('redo')"];
}

- (void)fontSizeUp {
    [timer invalidate]; // Stop it while we work
    
    int size = [[webView stringByEvaluatingJavaScriptFromString:@"document.queryCommandValue('fontSize')"] intValue] + 1;
    [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.execCommand('fontSize', false, '%i')", size]];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(checkSelection:) userInfo:nil repeats:YES];
}

- (void)fontSizeDown {
    [timer invalidate]; // Stop it while we work
    
    int size = [[webView stringByEvaluatingJavaScriptFromString:@"document.queryCommandValue('fontSize')"] intValue] - 1;
    [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.execCommand('fontSize', false, '%i')", size]];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(checkSelection:) userInfo:nil repeats:YES];
}

- (void)highlight {
    NSString *currentColor = [webView stringByEvaluatingJavaScriptFromString:@"document.queryCommandValue('backColor')"];
    if ([currentColor isEqualToString:@"rgb(255, 255, 0)"]) {
        [webView stringByEvaluatingJavaScriptFromString:@"document.execCommand('backColor', false, 'white')"];
    } else {
        [webView stringByEvaluatingJavaScriptFromString:@"document.execCommand('backColor', false, 'yellow')"];
    }
}

static int i = 0;

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    // Obtain the path to save to
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    imagePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"photo%i.png", i]];
    
    // Extract image from the picker and save it
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:@"public.image"]){
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        NSData *data = UIImagePNGRepresentation(image);
        [data writeToFile:imagePath atomically:YES];
        
    }
    

//    [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.execCommand('insertImage', false, '%@')", imagePath]];
    [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"insertImage('%@')", imagePath]];
    
//    NSString *docValue = [@"document.getElementsByTagName('img')[0].src=" stringByAppendingString:imagePath];
//    
//    NSString *html = [webView stringByEvaluatingJavaScriptFromString:docValue];
//    NSLog(@"Content format = %@", html);
//    NSString *replaceImage = [@"<img src=" stringByAppendingString:imagePath];
//    replaceImage = [replaceImage stringByAppendingString:@">"];
//    html = [html stringByReplacingOccurrencesOfString:@"<img src=\"pnda3.jpg\">" withString:replaceImage];
    
    NSString *html1 = [webView stringByEvaluatingJavaScriptFromString:@"document.body.outerHTML"];
    NSLog(@"Content format = %@", html1);
    NSString *planToSave = [[@"<html>" stringByAppendingString:html1] stringByAppendingString:@"</html>"];
    NSArray *paths1 = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [paths1 objectAtIndex:0];
    NSString *filePath = [NSString stringWithFormat:@"%@%@", documentsDir, @"first.html"];
    NSString *helloStr = planToSave;
    [helloStr writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    i++;
}


- (void) bold {
    [webView stringByEvaluatingJavaScriptFromString:@"document.execCommand(\"Bold\")"];
}

- (void)italic {
    [webView stringByEvaluatingJavaScriptFromString:@"document.execCommand(\"Italic\")"];
}

- (void)underline {
    [webView stringByEvaluatingJavaScriptFromString:@"document.execCommand(\"Underline\")"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
