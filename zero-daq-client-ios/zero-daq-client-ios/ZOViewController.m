//
//  ZOViewController.m
//  zero-daq-client-ios
//
//  Created by Micah Pearlman on 2/18/12.
//  Copyright (c) 2012 Zero Vision. All rights reserved.
//

#import "ZOViewController.h"

#define ZO_HOST @"169.254.1.1"
#define ZO_PORT 2000

@interface ZOViewController () <NSStreamDelegate> {
    NSInputStream*      _inputStream;
    NSOutputStream*     _outputStream;
    NSMutableString*   _buffer;
}

- (void)initNetwork;
@end

@implementation ZOViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self initNetwork];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation ==  UIDeviceOrientationLandscapeLeft || interfaceOrientation == UIDeviceOrientationLandscapeRight);
    } else {
        return YES;
    }
}

#pragma mark - Networking

- (void)initNetwork {
    
    _buffer = [[NSMutableString alloc] init];
    
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    CFStreamCreatePairWithSocketToHost(NULL, (CFStringRef)ZO_HOST, ZO_PORT, &readStream, &writeStream);
    _inputStream = (__bridge NSInputStream *)readStream;
    _outputStream = (__bridge NSOutputStream *)writeStream;
    [_inputStream setDelegate:self];
    [_outputStream setDelegate:self];
    [_inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [_outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [_inputStream open];
    [_outputStream open];
    
    egt0.text = @"OPEN";
    egt1.text = @"CONN";

}

- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode {
    if ( aStream == _inputStream ) {
        switch ( eventCode ) {
            case NSStreamEventOpenCompleted:
                NSLog(@"connect succesful");
                break;
            case NSStreamEventErrorOccurred:
                egt0.text = @"NET";
                egt1.text = @"ERR";
                break;
            case NSStreamEventHasBytesAvailable: {
                uint8_t buffer[1024];
                int len;
                
                while ([_inputStream hasBytesAvailable]) {
                    len = [_inputStream read:buffer maxLength:sizeof(buffer)];
                    if (len > 0) {
                        
                        NSString *output = [[NSString alloc] initWithBytes:buffer length:len encoding:NSASCIIStringEncoding];
                        [_buffer appendFormat:output];
                        NSArray* readings = [_buffer componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
                        if ( [readings count] > 0 ) {
                            for (NSString* reading in readings ) {
                                NSArray* components = [reading componentsSeparatedByString:@","];
                                if ( [components count] >= 2) {
                                    NSString* egtNumber = [components objectAtIndex:0];
                                    NSString* reading = [components objectAtIndex:1];
                                    float value = [reading floatValue];
                                    float f = (value * 0.25) * 9.0/5.0 + 32;
                                    if ( [egtNumber compare:@"f0"] == NSOrderedSame ) {
                                        egt0.text = [NSString stringWithFormat:@"%4.0f",f];
                                    } else if ( [egtNumber compare:@"f1"] == NSOrderedSame ) {
                                        egt1.text = [NSString stringWithFormat:@"%4.0f",f];
                                    } 


                                }
                            }
                            [_buffer setString:@""];
                        }
                        
                        
                        if (nil != output) {
                            NSLog(@"%@", output);
                        }
                    }
                }
            } break;
                
            default:
                break;
        }
    }
}

@end
