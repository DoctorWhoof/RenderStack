Namespace renderstack

Struct RenderItem		
	Field depth:Int
	Field img: Image
	Field color: Color
	
	Field left: Double
	Field top: Double
	Field right: Double
	Field bottom: Double
	Field width: Double
	Field height: Double
	
	Field topLeft :Vec2f
	Field topRight :Vec2f
	Field bottomLeft :Vec2f
	Field bottomRight :Vec2f
	
	Field position :Vec2f
	Field rotation :Float
	Field scale :Vec2f
	
	Field uvs := New Stack< Float >
	Field verts := New Stack< Float >
	Field colors := New Stack< UInt >
	Field matrix :AffineMat3f
	
	Method Update()
		matrix = New AffineMat3f
		matrix = matrix.Translate( position )
		If rotation <> 0 Then matrix = matrix.Rotate( rotation )
		matrix = matrix.Scale( scale )
		
		topLeft = matrix.Transform( left, top )
		topRight = matrix.Transform( right, top )
		bottomRight = matrix.Transform( right, bottom )
		bottomLeft = matrix.Transform( left, bottom )
		
		If RenderStack.pixelPerfect
			topLeft.X = Floor( topLeft.X )
			topLeft.Y = Floor( topLeft.Y )
			topRight.X = Floor( topRight.X )
			topRight.Y = Floor( topRight.Y )
			bottomRight.X = Floor( bottomRight.X )
			bottomRight.Y = Floor( bottomRight.Y )
			bottomLeft.X = Floor( bottomLeft.X )
			bottomLeft.Y = Floor( bottomLeft.Y )
		End
		
		verts.Clear()
		verts.Push( topLeft.X)
		verts.Push( topLeft.Y)
		verts.Push( topRight.X )
		verts.Push( topRight.Y )
		verts.Push( bottomRight.X  )
		verts.Push( bottomRight.Y  )
		verts.Push( bottomLeft.X  )
		verts.Push( bottomLeft.Y  )
		
'   		colors.Push( UInt( color.R ) )
'   		colors.Push( UInt( color.G ) )
'   		colors.Push( UInt( color.B ) )
'   		colors.Push( UInt( color.A ) )
	End
	
End