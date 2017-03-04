
Function LoadSpriteSheet:Image[] ( path:String, numFrames:Int, cellWidth:Int, cellHeight:Int, padding:Int = 0, border:Int = 0, filter:Bool = True, preScale:Float = 1.0 )
 
	Local atlasTexture := Texture.Load( path, Null )
	Assert( atlasTexture, " ~n ~nGameGraphics: Image " + path + " not found.~n ~n" )
 
	Local imgs := New Image[ numFrames ]
	Local atlasImg := New Image( atlasTexture )
	If Not filter Then atlasImg.TextureFilter = TextureFilter.Nearest
 
	Local paddedWidth:= cellWidth + ( padding * 2 )
	Local paddedHeight:= cellHeight + ( padding * 2 )
	Local columns:Int = ( atlasImg.Width - border - border ) / paddedWidth
 
	For Local i:= 0 Until numFrames
	Local col := i Mod columns
	Local x := ( col * paddedWidth ) + padding + border
	Local y := ( ( i / columns ) * paddedHeight ) + padding + border
	imgs[i] = New Image( atlasImg, New Recti( x , y, x + cellWidth, y + cellHeight ) )
	imgs[i].Scale = New Vec2f( preScale, preScale )
	Next
 
	atlasImg = Null
	Return imgs
End