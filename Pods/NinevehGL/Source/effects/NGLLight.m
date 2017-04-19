/*
 *	Copyright (c) 2011-2015 NinevehGL. More information at: http://nineveh.gl
 *
 *	Permission is hereby granted, free of charge, to any person obtaining a copy
 *	of this software and associated documentation files (the "Software"), to deal
 *	in the Software without restriction, including without limitation the rights
 *	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 *	copies of the Software, and to permit persons to whom the Software is
 *	furnished to do so, subject to the following conditions:
 *
 *	The above copyright notice and this permission notice shall be included in
 *	all copies or substantial portions of the Software.
 *
 *	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 *	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 *	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 *	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 *	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 *	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 *	THE SOFTWARE.
 */

#import "NGLLight.h"

#pragma mark -
#pragma mark Constants
#pragma mark -
//**********************************************************************************************************
//
//	Constants
//
//**********************************************************************************************************


#pragma mark -
#pragma mark Private Interface
#pragma mark -
//**********************************************************************************************************
//
//	Private Interface
//
//**********************************************************************************************************


#pragma mark -
#pragma mark Public Interface
#pragma mark -
//**********************************************************************************************************
//
//	Public Interface
//
//**********************************************************************************************************

@implementation NGLLight

#pragma mark -
#pragma mark Properties
//**************************************************
//	Properties
//**************************************************

@dynamic type, color, attenuation, values;

- (NGLLightType) type { return _values.type; }
- (void) setType:(NGLLightType)value
{
	_values.type = value;
}

- (NGLvec4) color { return _values.color; }
- (void) setColor:(NGLvec4)value
{
	_values.color = value;
}

- (float) attenuation { return _values.attenuation; }
- (void) setAttenuation:(float)value
{
	_values.attenuation = nglClamp(value, 0.1f, 1000.0f);
}

- (NGLLightValues *) values { return &_values; }

#pragma mark -
#pragma mark Constructors
//**************************************************
//	Constructors
//**************************************************

- (id) init
{
	if ((self = [super init]))
	{
		// Default settings.
		self.y = 1.0f;
		self.z = 2.0f;
		_values.type = NGLLightTypePoint;
		_values.position = (NGLvec4){self.x,self.y,self.z,1.0f};
		_values.color = nglColorMake(1.0f, 1.0f, 1.0f, 1.0f);
		_values.attenuation = 2.0f;
	}
	
	return self;
}

#pragma mark -
#pragma mark Private Methods
//**************************************************
//	Private Methods
//**************************************************


#pragma mark -
#pragma mark Self Public Methods
//**************************************************
//	Self Public Methods
//**************************************************

+ (NGLLight *) defaultLight
{
	// Persistent instance.
	static NGLLight *_default = nil;
	
	// Allocates once with Grand Central Dispatch (GCD) routine. Thread safe.
	static dispatch_once_t safer;
	dispatch_once(&safer, ^(void)
	{
		_default = [[NGLLight alloc] init];
	});
	
	return _default;
}

#pragma mark -
#pragma mark Override Public Methods
//**************************************************
//	Override Public Methods
//**************************************************

- (id) copyInstance
{
	return self;
}

- (id) copyWithZone:(NSZone *)zone
{
	return self;
}

- (void) setX:(float)value
{
	super.x = _values.position.x = value;
}

- (void) setY:(float)value
{
	super.y = _values.position.y = value;
}

- (void) setZ:(float)value
{
	super.z = _values.position.z = value;
}

- (id) retain
{
	return self;
}

- (oneway void) release
{
	// Does nothing here.
}

- (id) autorelease
{
	return self;
}

- (NSUInteger) retainCount
{
    return NGL_MAX_32;
}

- (void) dealloc
{
	[super dealloc];
}

@end
