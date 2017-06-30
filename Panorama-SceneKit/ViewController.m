//
//  ViewController.m
//  Panorama-SceneKit
//
//  Created by www.skyfox.org on 2017/6/29.
//  Copyright © 2017年 Jakey. All rights reserved.
//

#import "ViewController.h"
#import <CoreMotion/CoreMotion.h>
@interface ViewController ()
{
    SCNNode *_cameraNode;
    CMMotionManager *_motionManager;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"park_2048" ofType:@"jpg"];
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    
    // Set the scene
    self.sceneView.scene = [[SCNScene alloc]init];
    self.sceneView.showsStatistics = YES;
    self.sceneView.allowsCameraControl = YES;
    
    //Create node, containing a sphere, using the panoramic image as a texture
    SCNSphere *sphere =   [SCNSphere sphereWithRadius:20.0];
    sphere.firstMaterial.doubleSided = YES;
    sphere.firstMaterial.diffuse.contents = image;
    
    SCNNode *sphereNode = [SCNNode nodeWithGeometry:sphere];
    sphereNode.position = SCNVector3Make(0,0,0);
    [self.sceneView.scene.rootNode addChildNode:sphereNode];

    
    // Camera, ...
    _cameraNode = [[SCNNode alloc]init];
    _cameraNode.camera = [[SCNCamera alloc]init];
    _cameraNode.position = SCNVector3Make(0, 0, 0);
    [self.sceneView.scene.rootNode addChildNode:_cameraNode];
    
    _motionManager = [[CMMotionManager alloc]init];
    
    if (_motionManager.isDeviceMotionAvailable) {
        
        _motionManager.deviceMotionUpdateInterval = 1.0 / 60.0;
        [_motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMDeviceMotion * _Nullable motion, NSError * _Nullable error) {
            
            CMAttitude *attitude = motion.attitude;
            
            _cameraNode.eulerAngles = SCNVector3Make(attitude.roll - M_PI/2.0, attitude.yaw, attitude.pitch);
        }];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
