//
//  SceneDelegate.mm
//  SampleApp
//
//  Created by Jinwoo Kim on 4/9/24.
//

#import "SceneDelegate.hpp"
#import <objc/message.h>
#import <objc/runtime.h>
#import "DASceneObserver.hpp"

@interface SceneDelegate ()
@property (retain, readonly, nonatomic) DASceneObserver *sceneObserver;
@end

@implementation SceneDelegate

@synthesize sceneObserver = _sceneObserver;

- (void)dealloc {
    [_window release];
    [_sceneObserver release];
    [super dealloc];
}

- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    id fbsScene = ((id (*)(id, SEL))objc_msgSend)(scene, sel_registerName("_scene"));
    
    DASceneObserver *sceneObserver = self.sceneObserver;
    ((void (*)(id, SEL, id))objc_msgSend)(fbsScene, sel_registerName("addObserver:"), sceneObserver);
}

- (DASceneObserver *)sceneObserver {
    if (auto sceneObserver = _sceneObserver) return sceneObserver;
    
    DASceneObserver *sceneObserver = [DASceneObserver new];
    _sceneObserver = [sceneObserver retain];
    return [sceneObserver autorelease];
}

@end
