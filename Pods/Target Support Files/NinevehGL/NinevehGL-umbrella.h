#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "NGLEase.h"
#import "NGLTween.h"
#import "NGLCamera.h"
#import "NGLContext.h"
#import "NGLCopying.h"
#import "NGLCoreEngine.h"
#import "NGLCoreMesh.h"
#import "NGLCoreTimer.h"
#import "NGLDataType.h"
#import "NGLError.h"
#import "NGLFunctions.h"
#import "NGLGlobal.h"
#import "NGLGroup3D.h"
#import "NGLMesh.h"
#import "NGLMeshElements.h"
#import "NGLObject3D.h"
#import "NGLRuntime.h"
#import "NGLTexture.h"
#import "NGLThread.h"
#import "NGLTimer.h"
#import "NGLView.h"
#import "NGLFog.h"
#import "NGLLight.h"
#import "NGLMaterial.h"
#import "NGLMaterialMulti.h"
#import "NGLShaders.h"
#import "NGLShadersMulti.h"
#import "NGLSurface.h"
#import "NGLSurfaceMulti.h"
#import "NGLES2Buffers.h"
#import "NGLES2Engine.h"
#import "NGLES2Functions.h"
#import "NGLES2Mesh.h"
#import "NGLES2Polygon.h"
#import "NGLES2Program.h"
#import "NGLES2Textures.h"
#import "NGLBoundingBox.h"
#import "NGLMath.h"
#import "NGLMatrix.h"
#import "NGLQuaternion.h"
#import "NGLVector.h"
#import "NinevehGL.h"
#import "NGLParserDAE.h"
#import "NGLParserImage.h"
#import "NGLParserMesh.h"
#import "NGLParserMTL.h"
#import "NGLParserNGL.h"
#import "NGLParserOBJ.h"
#import "NGLSLConstructor.h"
#import "NGLSLSource.h"
#import "NGLSLVariables.h"
#import "NGLArray.h"
#import "NGLDebug.h"
#import "NGLGestures.h"
#import "NGLIterator.h"
#import "NGLRegEx.h"

FOUNDATION_EXPORT double NinevehGLVersionNumber;
FOUNDATION_EXPORT const unsigned char NinevehGLVersionString[];

