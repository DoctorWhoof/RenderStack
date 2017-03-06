Namespace renderstack
'Allows render items to be drawn sorted byvdepth and batched for better performance.

#Import "<mojo>"
#Import "renderitem"

Using mojo..
Using std..

Class RenderStack

	Global pixelPerfect:= True
	Global depthSort:= True
	
	Private
	Global items := New Stack< RenderItem >
	Global uvStack := New Stack<Float>
	Global vertStack:= New Stack<Float>
	'Global colorStack:= New Stack<UInt>
	Global batchCount := 0
	
	Global _fps	:= 0.0				'current fps
	Global _fpscount := 0.0			'temporary fps counter
	Global _tick := 0				'stores the current time once every second
	
	
	'**************************************** Public functions ****************************************
	
	Public	
	Function Add( img:Image, depth:Double, pos:Vec2f, rot:Float, scale:Vec2f, color:Color = Color.White ) 
		Local newitem := New RenderItem
		newitem.depth = depth
		newitem.img = img

		newitem.width = img.Width
		newitem.height = img.Height
		newitem.left = - ( newitem.width * img.Handle.X )
		newitem.top = - ( newitem.width * img.Handle.Y )
		newitem.right = newitem.left + newitem.width
		newitem.bottom = newitem.top + newitem.height
		
		Local uvLeft := Float(newitem.img.Rect.Left) / newitem.img.Texture.Width
		Local uvRight := Float(newitem.img.Rect.Right) / newitem.img.Texture.Width
		Local uvTop := Float(newitem.img.Rect.Top) / newitem.img.Texture.Height
		Local uvBottom := Float(newitem.img.Rect.Bottom) / newitem.img.Texture.Height
		
		newitem.uvs.Push( uvLeft )
		newitem.uvs.Push( uvTop )
		newitem.uvs.Push( uvRight )
		newitem.uvs.Push( uvTop )
		newitem.uvs.Push( uvRight )
		newitem.uvs.Push( uvBottom )
		newitem.uvs.Push( uvLeft )
		newitem.uvs.Push( uvBottom )
		
		newitem.position = pos
		newitem.rotation = rot
		newitem.scale = scale
		
		items.Push( newitem )
	End
	

	Function Draw( canvas:Canvas )
		If depthSort
			items.Sort( Lambda:Int( a:RenderItem, b:RenderItem )
				Return a.depth <=> b.depth
			End )
		End	
		batchCount = 0
		If items.Length <> 0
			Local prev := items[0]

			For Local n := 0 Until items.Length
				Local i := items[ n ]
				
				If ( i.img.Texture <> prev.img.Texture )
					DrawBatch( canvas, prev.img )
				End

				i.Update()
				vertStack.AddAll( i.verts )
				uvStack.AddAll( i.uvs )
				'colorStack.Add( i.color.ToARGB() )	'Not working ...
				prev = i
			Next
			DrawBatch( canvas, prev.img )		
		End
		
		canvas.DrawText( "RenderStack: " + items.Length + " items, " + batchCount + " batches", 0, 0 )
		items.Clear()
		GetFPS()
	End
	
	
	Function FPS:Float()
		Return _fps
	End	


	'**************************************** Private functions ****************************************
	
	Private
	Function DrawBatch( canvas:Canvas, img:Image )
		canvas.DrawPrimitives( 4, vertStack.Length/8, vertStack.Data.Data, 8, uvStack.Data.Data, 8, Null, 4, img, Null )
		uvStack.Clear()
		vertStack.Clear()
		'colorStack.Clear()
		batchCount += 1
	End
	

	Function GetFPS()
		If Microsecs() - _tick > 1008000
			_fps = _fpscount
			_tick = Microsecs()
			_fpscount=0
		Else
			_fpscount +=1
		End
	End

End
