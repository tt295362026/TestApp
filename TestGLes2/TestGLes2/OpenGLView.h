//
//  OpenGLView.h
//  TestGLes2
//
//  Created by Vincent Tang on 13-4-15.
//  Copyright (c) 2013年 Vincent Tang. All rights reserved.
//



#import <UIKit/UIKit.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>
#import <QuartzCore/QuartzCore.h>

@interface OpenGLView : UIView
{
    CAEAGLLayer *_eaglLayer;
    EAGLContext *_context;
    GLuint _colorRenderBuffer;
    GLuint _positionSlot;
    GLuint _colorSlot;
    GLuint _projectionUniform;
    GLuint _modelViewUniform;
    GLfloat _currentRotation;
    GLuint _depthRenderBuffer;
}
@end
