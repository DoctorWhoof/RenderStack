Namespace renderstack
'Allows render items to be drawn sorted by y coordinate.

#Import "renderitem"
#Import "<mojo>"

Using mojo..
Using std..

Class RenderStack

	Global depthSort := True
	
	Private
	Global items := New Stack< RenderItem >
	Global batches := 0
	
	Public
	Function Add( img:Image, left:Double, top:Double, width:Double, height:Double, depth:Double, color:Color = Color.White ) 
		Local newitem := New RenderItem
		newitem.depth = depth
		newitem.img = img
		newitem.left = left
		newitem.top = top
		newitem.width = width
		newitem.height = height
		newitem.right = left + width
		newitem.bottom = top + height
		items.Push( newitem )
	End

	Function Draw( canvas:Canvas )
		'Sort by depth
		If depthSort
			items.Sort( Lambda:Int( a:RenderItem, b:RenderItem )
				Return a.depth <=> b.depth
			End )
		End
		'Draw batches, grouping images that share the same texture (image atlas) together
		batches = 0
		If items.Length <> 0
			Local prev := items[0]
			Local uvStack := New Stack<Float>
			Local vertStack:= New Stack<Float>
			
			For Local n := 0 Until items.Length
				Local i := items[ n ]
	
				If ( i.img.Texture <> prev.img.Texture )
					DrawBatch( canvas, prev.img, vertStack, uvStack )
				End

				Local uvLeft := Float(i.img.Rect.Left) / i.img.Texture.Width
				Local uvRight := Float(i.img.Rect.Right) / i.img.Texture.Width
				Local uvTop := Float(i.img.Rect.Top) / i.img.Texture.Height
				Local uvBottom := Float(i.img.Rect.Bottom) / i.img.Texture.Height
				
				uvStack.Push( uvLeft )
				uvStack.Push( uvTop )
				uvStack.Push( uvRight )
				uvStack.Push( uvTop )
				uvStack.Push( uvRight )
				uvStack.Push( uvBottom )
				uvStack.Push( uvLeft )
				uvStack.Push( uvBottom )
				
				vertStack.Push( i.left )
				vertStack.Push( i.top )
				vertStack.Push( i.right )
				vertStack.Push( i.top )
				vertStack.Push( i.right )
				vertStack.Push( i.bottom )
				vertStack.Push( i.left )
				vertStack.Push( i.bottom )
				
				prev = i
			Next
			DrawBatch( canvas, prev.img, vertStack, uvStack )		
		End		
		items.Clear()
	End
	
	Private
	Function DrawBatch( canvas:Canvas, img:Image, vertStack:Stack<Float>, uvStack:Stack<Float> )
		Local uvs :Float[] = uvStack.ToArray()
		Local verts :Float[] = vertStack.ToArray()
		canvas.DrawPrimitives( 4, verts.Length/8, verts.Data, 8, uvs.Data, 8, Null, 0, img, Null )
		uvStack.Clear()
		vertStack.Clear()
		uvs = Null
		verts = Null
		batches += 1
	End

End
