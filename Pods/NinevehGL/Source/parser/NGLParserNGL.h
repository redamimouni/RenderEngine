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

#import "NGLRuntime.h"
#import "NGLParserMesh.h"

/*!
 *					<strong>(Internal only)</strong> Loads, parses, constructs and saves the NinevehGL
 *					Binary files (.ngl).
 *
 *					<img src="http://nineveh.gl/imgs/ninevehgl_binary_file.png" style="float:right;"
 *					height="300px;" alt="NinevehGL Binary file"/>
 *					The NinevehGL Binary files is managed internally by the NinevehGL's core. These
 *					<strong>NGL Files</strong> is generated every time a new mesh is loaded from a 3D file.
 *					Independent of the 3D file format, the NinevehGL takes the parsed output and saves it
 *					locally, using bit streaming. The local path is:
 *
 *						- <em>&lt;Application_Home&gt;/Library/NinevehGL/</em>
 *
 *					This local path is properly backed-up by the iTunes/iCloud. That means if your
 *					application has been updated, the cached files on the user's device will not be erased.
 *					NinevehGL will compare the both files, the cached .ngl and the original 3D file.
 *					If the original 3D file has a newer version, it will be used instead the .ngl file,
 *					otherwise the cached NinevehGL Binary file will be used.
 *
 *					The binary file is linked with he original one by the name. For example, a cached file
 *					<code>wall.ngl</code> represents a 3D file with name <code>wall.&lt;extension&gt;</code>.
 *					So is advisible to avoid repeating the same name to two different 3D files, like wall.obj
 *					and wall.dae. Because in this case, NinevehGL will cache only one binary file to
 *					both files.
 *
 *					There are many advantages with the NinevehGL Binary file, it's lighter, cleaner and
 *					OpenGL Friendly. But the greatest advantage is the performance when loading and parsing.
 *					As it's a bit stream and is already in the OpenGL formats, it's loaded and parsed
 *					<strong>850% faster</strong> (around 85 times faster than the original file). When
 *					running on iPhone 4 its benchmark is 0.08 secs for each 300.000 vertices with
 *					position, normals, texture coordinates, tangent and bitangent for each of them,
 *					plus materials.
 *
 *					NGL Binary file also can be loaded directly. In this case, no new cached file will be
 *					generated. By using this optimized file directly you can save space and loading time.
 *					NGL Binary file has 70% of size compared to an OBJ file and 25% of size compared to an
 *					COLLADA file.
 *	
 *					There are two ways to generate a NGL Binary file:
 *
 *						- Using the online tool at <a href="http://nineveh.gl/binary" target="_blank">
 *							http://nineveh.gl/binary</a> in the official NinevehGL Web Site;
 *						- Automatically generated by NinevehGL Parse API.
 *
 *					The NinevehGL Binary file format follows the following data flow:
 *
 *					<pre>
 *
 *					|--- 4 bytes (float)            NGL Binary file version
 *					|
 *					|--- 4 bytes (unsigned int)     Count - Elements Node
 *					|   |
 *					|   |--- 1 byte (unsigned char)     component
 *					|   |--- 1 byte (unsigned char)     start
 *					|   |--- 1 byte (unsigned char)     length
 *					|   |--- 1 byte (unsigned char)     offsetInFace
 *					|
 *					|--- 4 bytes (unsigned int)     Count - Indices
 *					|--- 4 bytes (unsigned int)     Count - Structures
 *					|--- 4 bytes (unsigned int)     Stride
 *					|
 *					|--- x bytes (unsigned short)   Indices array
 *					|--- x bytes (float)            Structure array
 *					|
 *					|--- 4 bytes (unsigned int)     Count - Materials Node
 *					|   |
 *					|   |--- 2 bytes (unsigned short)   Identifier
 *					|   |--- 2 bytes (unsigned short)   Name length
 *					|   |--- x bytes (char)             Name
 *					|   |
 *					|   |--- 4 bytes (float)            Alpha
 *					|   |--- 16 bytes (float)           Ambient color
 *					|   |--- 16 bytes (float)           Diffuse color
 *					|   |--- 16 bytes (float)           Emissive color
 *					|   |--- 16 bytes (float)           Specular color
 *					|   |--- 4 bytes (float)            Specular level
 *					|   |--- 4 bytes (float)            Reflection level
 *					|   |--- 4 bytes (float)            Shininess
 *					|   |--- 4 bytes (float)            Refraction
 *					|   |
 *					|   |--- 4 bytes (unsigned int)     Count - Texture Node
 *					|           |
 *					|           |--- 2 bytes (unsigned short)   Map kind (alpha, ambient, diffuse, ...)
 *					|           |--- 2 bytes (unsigned short)   Name length
 *					|           |--- x bytes (char)             Name
 *					|           |
 *					|           |--- 1 byte (unsigned char)     Texture type (2d or 3d)
 *					|           |--- 1 byte (unsigned char)     Quality
 *					|           |--- 1 byte (unsigned char)     Repeat
 *					|           |--- 1 byte (unsigned char)     Optimize
 *					|
 *					|--- 4 bytes (unsigned int)     Count - Surface Node
 *					    |
 *					    |--- 2 bytes (unsigned short)   Identifier
 *					    |          
 *					    |--- 4 bytes (unsigned int)     Start data
 *					    |--- 4 bytes (unsigned int)     Length data
 *
 *					</pre>
 *	
 *					The parsing time is increased by the number of nodes in the NGL Binary file. So how less
 *					nodes exist in the file, faster will be the parsing time.
 */
@interface NGLParserNGL : NGLParserMesh
{
@private
	// Helpers
	unsigned int			_rangeIndex;
}

/*!
 *					Indicates if a NGL Binary has a  valid binary cache for it, that means, if the
 *					binary file exists and is newer than the original 3D file.
 *
 *	@param			named
 *					In NinevehGL the "named" parameter is always related to the NinevehGL Path API, so you
 *					can inform the only the file's name or full path. The full path is related to the file
 *					system. If only the file's name is informed, NinevehGL will search for the file at the
 *					global path.
 *
 *	@result			A BOOL data type representing if there is a valid cache for the informed path.
 */
- (BOOL) hasCache:(NSString *)named;

/*!
 *					Loads and parse a NGL Binary file from a local path.
 *
 *					Based on a path to an original 3D file, this method will search for a NGL Binary file
 *					and compare both files. If the NGL Binary file is newer than the original one, it will
 *					be loaded and the property <code>#isCached#</code> will be turned to YES.
 *
 *	@param			named
 *					In NinevehGL the "named" parameter is always related to the NinevehGL Path API, so you
 *					can inform the only the file's name or full path. The full path is related to the file
 *					system. If only the file's name is informed, NinevehGL will search for the file at the
 *					global path.
 *
 *	@see			isCached
 */
- (void) decodeCache:(NSString *)named;

/*!
 *					Saves a NGL Binary file based on a parsed mesh.
 *
 *					Based on a path to an original 3D file, this method will create and save a NGL Binary
 *					File.
 *
 *	@param			mesh
 *					A #NGLParserMesh# containing a parsed file.
 *
 *	@param			named
 *					In NinevehGL the "named" parameter is always related to the NinevehGL Path API, so you
 *					can inform the only the file's name or full path. The full path is related to the file
 *					system. If only the file's name is informed, NinevehGL will search for the file at the
 *					global path.
 */
- (void) encodeCache:(NGLParserMesh *)mesh withName:(NSString *)named;

@end