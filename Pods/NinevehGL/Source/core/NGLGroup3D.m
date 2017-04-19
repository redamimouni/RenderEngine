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

#import "NGLGroup3D.h"

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
#pragma mark Private Category
//**************************************************
//	Private Category
//**************************************************

@interface NGLGroup3D()

// Initializes a new instance.
- (void) initialize;

// Defines the bounding box based on the current group's collection.
- (void) defineBoundingBox;

@end

#pragma mark -
#pragma mark Public Interface
#pragma mark -
//**********************************************************************************************************
//
//	Public Interface
//
//**********************************************************************************************************

@implementation NGLGroup3D

#pragma mark -
#pragma mark Properties
//**************************************************
//	Properties
//**************************************************

#pragma mark -
#pragma mark Constructors
//**************************************************
//	Constructors
//**************************************************

- (id) init
{
	if ((self = [super init]))
	{
		[self initialize];
	}
	
	return self;
}

- (id) initWithObjects:(NGLObject3D *)firstObject, ...
{
	if ((self = [super init]))
	{
		[self initialize];
		
		NGLObject3D *object;
		va_list list;
		
		// Executes the list to work with all elements until get nil.
		va_start(list, firstObject);
		for (object = firstObject; object != nil; object = va_arg(list, NGLObject3D *))
		{
			[self addObject:object];
		}
		va_end(list);
	}
	
	return self;
}

#pragma mark -
#pragma mark Private Methods
//**************************************************
//	Private Methods
//**************************************************

- (void) initialize
{
	// Settings.
	_collection = [[NGLArray alloc] initWithRetainOption];
}

- (void) defineBoundingBox
{
	float vx, vy, vz;
	NGLvec3 vMin, vMax;
	NGLbounds itemBounds;
	NGLObject3D *item = nil;
	
	item = [_collection pointerAtIndex:0];
	itemBounds = item.boundingBox.aligned;
	vMin = itemBounds.min;
	vMax = itemBounds.max;
	
	for (item in _collection)
	{
		itemBounds = item.boundingBox.aligned;
		
		vx = itemBounds.min.x;
		vy = itemBounds.min.y;
		vz = itemBounds.min.z;
		
		// Stores the minimum value for vertices coordinates.
		vMin.x = (vMin.x > vx) ? vx : vMin.x;
		vMin.y = (vMin.y > vy) ? vy : vMin.y;
		vMin.z = (vMin.z > vz) ? vz : vMin.z;
		
		vx = itemBounds.max.x;
		vy = itemBounds.max.y;
		vz = itemBounds.max.z;
		
		// Stores the maximum value for vertices coordinates.
		vMax.x = (vMax.x < vx) ? vx : vMax.x;
		vMax.y = (vMax.y < vy) ? vy : vMax.y;
		vMax.z = (vMax.z < vz) ? vz : vMax.z;
	}
	
	nglBoundingBoxDefine(&_boundingBox, (NGLbounds){vMin, vMax});
}

#pragma mark -
#pragma mark Self Public Methods
//**************************************************
//	Self Public Methods
//**************************************************

- (void) addObject:(NGLObject3D *)object
{
	if ([_collection count] == 0)
	{
		self.pivot = (NGLvec3){object.x,object.y,object.z};
		//[self translateToX:object.x toY:object.y toZ:object.z];
	}
	
	if (![self hasObject:object])
	{
		object.group = self;
		
		[_collection addPointer:object];
	}
}

- (BOOL) hasObject:(NGLObject3D *)object
{
	return [_collection hasPointer:object];
}

- (BOOL) hasObjectWithTag:(int)tag
{
	NGLObject3D *item = nil;
	
	for (item in _collection)
	{
		if (item.tag == tag)
		{
			return YES;
		}
	}
	
	return NO;
}

- (BOOL) hasObjectWithName:(NSString *)name
{
	NGLObject3D *item = nil;
	
	for (item in _collection)
	{
		if ([item.name isEqualToString:name])
		{
			return YES;
		}
	}
	
	return NO;
}

- (void) removeObject:(NGLObject3D *)object
{
	if ([self hasObject:object])
	{
		object.group = nil;
		[_collection removePointer:object];
	}
}

- (void) removeObjectWithTag:(int)tag
{
	NGLObject3D *item = nil;
	
	nglFor (item, _collection)
	{
		if (item.tag == tag)
		{
			item.group = nil;
			[_collection removePointer:item];
		}
	}
}

- (void) removeObjectWithName:(NSString *)name
{
	NGLObject3D *item = nil;
	
	nglFor (item, _collection)
	{
		if ([item.name isEqualToString:name])
		{
			item.group = nil;
			[_collection removePointer:item];
		}
	}
}

- (void) removeAll
{
	NGLObject3D *item = nil;
	
	for (item in _collection)
	{
		item.group = nil;
	}
	
	[_collection removeAll];
}

- (NGLObject3D *) objectWithTag:(int)tag
{
	NGLObject3D *item = nil;
	
	for (item in _collection)
	{
		if (item.tag == tag)
		{
			break;
		}
	}
	
	return item;
}

- (NGLObject3D *) objectWithName:(NSString *)name
{
	NGLObject3D *item = nil;
	
	for (item in _collection)
	{
		if ([item.name isEqualToString:name])
		{
			break;
		}
	}
	
	return item;
}

- (unsigned int) count
{
	return [_collection count];
}

- (void *) nextIterator
{
	return [_collection nextIterator];
}

- (void) resetIterator
{
	[_collection resetIterator];
}

- (NSUInteger) countByEnumeratingWithState:(NSFastEnumerationState *)state
								   objects:(NGL_ARC_ASSIGN id *)stackbuf
									 count:(NSUInteger)len
{
	unsigned int count = [_collection count];
	
	if ((*state).state >= count)
	{
		return 0;
	}
	
	// Runs once. Points mutationPtr to self to avoid error when array changes while looping.
	(*state).itemsPtr = _collection.itemsPointer;
	(*state).state = count;
	(*state).mutationsPtr = _collection.mutationsPointer;
	
	return count;
}

#pragma mark -
#pragma mark Override Public Methods
//**************************************************
//	Override Public Methods
//**************************************************

- (void) dealloc
{
	[self removeAll];
	
	nglRelease(_collection);
	
	[super dealloc];
}

@end
