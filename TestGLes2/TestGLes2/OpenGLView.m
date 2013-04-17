//
//  OpenGLView.m
//  TestGLes2
//
//  Created by Vincent Tang on 13-4-15.
//  Copyright (c) 2013年 Vincent Tang. All rights reserved.
//
typedef struct {
    float Position[3];
    float Color[4];
} Vertex;

const Vertex Vertices[] = {
//    {{1, -1, 0}, {1, 0, 0, 1}},
//    {{1, 1, 0}, {0, 1, 0, 1}},
//    {{-1, 1, 0}, {0, 0, 1, 1}},
//    {{-1, -1, 0}, {0, 0, 0, 1}}
    {{1, -1, 0}, {1, 0, 0, 1}},
    {{1, 1, 0}, {1, 0, 0, 1}},
    {{-1, 1, 0}, {0, 1, 0, 1}},
    {{-1, -1, 0}, {0, 1, 0, 1}},
    {{1, -1, -1}, {1, 0, 0, 1}},
    {{1, 1, -1}, {1, 0, 0, 1}},
    {{-1, 1, -1}, {0, 1, 0, 1}},
    {{-1, -1, -1}, {0, 1, 0, 1}}
};

const GLubyte Indices[] = {
//    0, 1, 2,
//    2, 3, 0
    // Front
    0, 1, 2,
    2, 3, 0,
    // Back
    4, 6, 5,
    4, 7, 6,
    // Left
    2, 7, 3,
    7, 6, 2,
    // Right
    0, 4, 1,
    4, 1, 5,
    // Top
    6, 2, 1,
    1, 6, 5,
    // Bottom
    0, 3, 7,
    0, 7, 4
};

#import "OpenGLView.h"
#import "CC3GLMatrix.h"

@implementation OpenGLView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupLayer];
        [self setupContext];
        [self setupDepthBuffer];
        [self setupRenderBuffer];
        
        [self setupFrameBuffer];
        
        [self compileShaders];
        [self setupVBOs];
        
//        [self render:nil];
        [self setupDisplayLink];
    }
    return self;
}

+ (Class)layerClass
{
    return [CAEAGLLayer class];
}

//因为缺省的话，CALayer是透明的。而透明的层对性能负荷很大，特别是OpenGL的层。
- (void)setupLayer
{
    _eaglLayer = (CAEAGLLayer *)self.layer;
    _eaglLayer.opacity = YES;
}

- (void)setupContext
{
    EAGLRenderingAPI api = kEAGLRenderingAPIOpenGLES2;
    _context = [[EAGLContext alloc] initWithAPI:api];
    if (!_context)
    {
        NSLog(@"gl上下文初始化失败");
        exit(1);
    }
    if (![EAGLContext setCurrentContext:_context])
    {
        NSLog(@"设置gl上下文失败");
        exit(1);
    }
}

- (void)setupRenderBuffer
{
//    调用glGenRenderbuffers来创建一个新的render buffer object。这里返回一个唯一的integer来标记render buffer（这里把这个唯一值赋值到_colorRenderBuffer）。有时候你会发现这个唯一值被用来作为程序内的一个OpenGL 的名称。（反正它唯一嘛）
    glGenRenderbuffers(1, &_colorRenderBuffer);
    
//     调用glBindRenderbuffer ，告诉这个OpenGL：我在后面引用GL_RENDERBUFFER的地方，其实是想用_colorRenderBuffer。其实就是告诉OpenGL，我们定义的buffer对象是属于哪一种OpenGL对象
    glBindRenderbuffer(GL_RENDERBUFFER, _colorRenderBuffer);
    
//    最后，为render buffer分配空间。renderbufferStorage
    [_context renderbufferStorage:GL_RENDERBUFFER fromDrawable:_eaglLayer];
}

- (void)setupDepthBuffer
{
    glGenRenderbuffers(1, &_depthRenderBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, _depthRenderBuffer);
    glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, self.frame.size.width, self.frame.size.height);
    
    
}

//Frame buffer也是OpenGL的对象，它包含了前面提到的render buffer，以及其它后面会讲到的诸如：depth buffer、stencil buffer 和 accumulation buffer。
//
//　　前两步创建frame buffer的动作跟创建render buffer的动作很类似。（反正也是用一个glBind什么的）
//
//　　而最后一步  glFramebufferRenderbuffer 这个才有点新意。它让你把前面创建的buffer render依附在frame buffer的GL_COLOR_ATTACHMENT0位置上。
- (void)setupFrameBuffer
{
    GLuint frameBuffer;
    glGenFramebuffers(1, &frameBuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, frameBuffer);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, _depthRenderBuffer);

    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, _colorRenderBuffer);
    

    
}


- (void)render:(CADisplayLink *)displayLink
{
    NSLog(@"stamp %f",displayLink.timestamp);
    NSLog(@"stamp %f",displayLink.duration);
    NSLog(@"");
//     调用glClearColor ，设置一个RGB颜色和透明度，接下来会用这个颜色涂满全屏。
    glClearColor(0, 103/255.0, 103/255.0, 20/255.0);
    
//      调用glClear来进行这个“填色”的动作（大概就是photoshop那个油桶嘛）。还记得前面说过有很多buffer的话，这里我们要用到GL_COLOR_BUFFER_BIT来声明要清理哪一个缓冲区。
    glClear(GL_DEPTH_BUFFER_BIT | GL_COLOR_BUFFER_BIT);
    glEnable(GL_DEPTH_TEST);
    
    
    //给_projectionUniform 传值
    CC3GLMatrix *projection = [CC3GLMatrix matrix];
    float h = 4.0f *self.frame.size.height/self.frame.size.width;
    [projection populateFromFrustumLeft:-2 andRight:2 andBottom:-h/2 andTop:h/2 andNear:4 andFar:10];
    glUniformMatrix4fv(_projectionUniform, 1, 0, projection.glMatrix);
    
    CC3GLMatrix *modelView = [CC3GLMatrix matrix];
    [modelView populateFromTranslation:CC3VectorMake(sin(CACurrentMediaTime()), sin(CACurrentMediaTime()), -7)];
    _currentRotation += displayLink.duration*90;
    [modelView rotateBy:CC3VectorMake(_currentRotation, _currentRotation, 0)];
    glUniformMatrix4fv(_modelViewUniform, 1, 0, modelView.glMatrix);
    
//  调用glViewport 设置UIView中用于渲染的部分。这个例子中指定了整个屏幕。但如果你希望用更小的部分，你可以更变这些参数。
    glViewport(0, 0, self.frame.size.width, self.frame.size.height);
    
/*    调用glVertexAttribPointer来为vertex shader的两个输入参数配置两个合适的值
 第二段这里，是一个很重要的方法，让我们来认真地看看它是如何工作的：
 
 　　·第一个参数，声明这个属性的名称，之前我们称之为glGetAttribLocation
 
 　　·第二个参数，定义这个属性由多少个值组成。譬如说position是由3个float（x,y,z）组成，而颜色是4个float（r,g,b,a）
 
 　　·第三个，声明每一个值是什么类型。（这例子中无论是位置还是颜色，我们都用了GL_FLOAT）
 
 　　·第四个，嗯……它总是false就好了。
 
 　　·第五个，指 stride 的大小。这是一个种描述每个 vertex数据大小的方式。所以我们可以简单地传入 sizeof（Vertex），让编译器计算出来就好。
 
 　　·最后一个，是这个数据结构的偏移量。表示在这个结构中，从哪里开始获取我们的值。Position的值在前面，所以传0进去就可以了。而颜色是紧接着位置的数据，而position的大小是3个float的大小，所以是从 3 * sizeof(float) 开始的。
 */
    glVertexAttribPointer(_positionSlot, 3, GL_FLOAT, GL_FALSE, sizeof(Vertex), 0);
    NSLog(@"%ld",sizeof(Vertex));
    glVertexAttribPointer(_colorSlot, 4, GL_FLOAT, GL_FALSE, sizeof(Vertex), (GLvoid *)(sizeof(float)*3));
    
    /*
     调用glDrawElements ，它最后会在每个vertex上调用我们的vertex shader，以及每个像素调用fragment shader，最终画出我们的矩形。
     
     　　它也是一个重要的方法，我们来仔细研究一下：
     
     　　·第一个参数，声明用哪种特性来渲染图形。有GL_LINE_STRIP 和 GL_TRIANGLE_FAN。然而GL_TRIANGLE是最常用的，特别是与VBO 关联的时候。
     
     　　·第二个，告诉渲染器有多少个图形要渲染。我们用到C的代码来计算出有多少个。这里是通过个 array的byte大小除以一个Indice类型的大小得到的。
     
     　　·第三个，指每个indices中的index类型
     
     　　·最后一个，在官方文档中说，它是一个指向index的指针。但在这里，我们用的是VBO，所以通过index的array就可以访问到了（在GL_ELEMENT_ARRAY_BUFFER传过了），所以这里不需要.
     */
    glDrawElements(GL_TRIANGLES, sizeof(Indices)/sizeof(Indices[0]), GL_UNSIGNED_BYTE, 0);
    
    
//     调用OpenGL context的presentRenderbuffer方法，把缓冲区（render buffer和color buffer）的颜色呈现到UIView上。
    [_context presentRenderbuffer:GL_RENDERBUFFER];
}



- (GLuint)compileShader:(NSString*)shaderName withType:(GLenum)shaderType {
    
    // 1
    NSString* shaderPath = [[NSBundle mainBundle] pathForResource:shaderName
                                                           ofType:@"glsl"];
    NSError* error;
    NSString* shaderString = [NSString stringWithContentsOfFile:shaderPath
                                                       encoding:NSUTF8StringEncoding error:&error];
    if (!shaderString) {
        NSLog(@"Error loading shader: %@", error.localizedDescription);
        exit(1);
    }
    
    // 2调用 glCreateShader来创建一个代表shader 的OpenGL对象。这时你必须告诉OpenGL，你想创建 fragment shader还是vertex shader。所以便有了这个参数：shaderType
    GLuint shaderHandle = glCreateShader(shaderType);
    
    // 3调用glShaderSource ，让OpenGL获取到这个shader的源代码。（就是我们写的那个）这里我们还把NSString转换成C-string
    const char* shaderStringUTF8 = [shaderString UTF8String];
    int shaderStringLength = [shaderString length];
    glShaderSource(shaderHandle, 1, &shaderStringUTF8, &shaderStringLength);
    
    // 4
    glCompileShader(shaderHandle);
    
    // 5
    GLint compileSuccess;
    glGetShaderiv(shaderHandle, GL_COMPILE_STATUS, &compileSuccess);
    if (compileSuccess == GL_FALSE) {
        GLchar messages[256];
        glGetShaderInfoLog(shaderHandle, sizeof(messages), 0, &messages[0]);
        NSString *messageString = [NSString stringWithUTF8String:messages];
        NSLog(@"%@", messageString);
        exit(1);
    }
    
    return shaderHandle;
    
}

- (void)compileShaders {
    
    // 1
    GLuint vertexShader = [self compileShader:@"SimpleVertex"
                                     withType:GL_VERTEX_SHADER];
    GLuint fragmentShader = [self compileShader:@"SimpleFragment"
                                       withType:GL_FRAGMENT_SHADER];
    
    // 2 调用了glCreateProgram glAttachShader  glLinkProgram 连接 vertex 和 fragment shader成一个完整的program。
    GLuint programHandle = glCreateProgram();
    glAttachShader(programHandle, vertexShader);
    glAttachShader(programHandle, fragmentShader);
    glLinkProgram(programHandle);
    
    // 3
    GLint linkSuccess;
    glGetProgramiv(programHandle, GL_LINK_STATUS, &linkSuccess);
    if (linkSuccess == GL_FALSE) {
        GLchar messages[256];
        glGetProgramInfoLog(programHandle, sizeof(messages), 0, &messages[0]);
        NSString *messageString = [NSString stringWithUTF8String:messages];
        NSLog(@"%@", messageString);
        exit(1);
    }
    
    // 4调用 glUseProgram  让OpenGL真正执行你的program
    glUseProgram(programHandle);
    
    // 5最后，调用 glGetAttribLocation 来获取指向 vertex shader传入变量的指针。以后就可以通过这写指针来使用了。还有调用 glEnableVertexAttribArray来启用这些数据。（因为默认是 disabled的。）
    
    
    _colorSlot = glGetAttribLocation(programHandle, "SourceColor");
    _positionSlot = glGetAttribLocation(programHandle, "Position");
    _projectionUniform = glGetUniformLocation(programHandle, "Projection");
    _modelViewUniform = glGetUniformLocation(programHandle, "Modelview");
    glEnableVertexAttribArray(_positionSlot);
    glEnableVertexAttribArray(_colorSlot);
}
- (void)setupVBOs
{
    GLuint vertextBuffer;
    glGenBuffers(1, &vertextBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, vertextBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(Vertices), Vertices, GL_STATIC_DRAW);
    
    GLuint indexBuffer;
    
    glGenBuffers(1, &indexBuffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, indexBuffer);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(Indices), Indices, GL_STATIC_DRAW);
    

}

- (void)setupDisplayLink
{
    CADisplayLink *displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(render:)];
    [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}


@end
