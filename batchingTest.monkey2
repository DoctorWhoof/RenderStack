'Batching test using basic RenderStack class by Ethernaut

#Import "renderstack/renderstack"
#Import "renderstack/spritesheet"
#Import "images/cats.png"

Using renderstack..

Const width := 1024
Const height := 768
Const totalCats := 10000

Function Main()
	New AppInstance
	New Test()
	App.Run()
End


'**********************************************************************************************************************************

Class Test Extends Window

	Field cats := New Stack< Cat >

	Method New()					
		Super.New( "Test", width, height, WindowFlags.Resizable )
		Cat.img = LoadSpriteSheet( "asset::cats.png", 16, 16, 16, 0, 0, False, 4 )
		For Local i := Eachin Cat.img
			i.Handle = New Vec2f(0.5,0.5)
		Next
		For Local n := 0 Until totalCats
			Local kitty := New Cat
			kitty.pos = New Vec2f( Rnd(0, width), Rnd(0, height) )
			kitty.frame = Rnd(0,16)
			cats.Push( kitty )
		Next
		RenderStack.depthSort = False
		Layout = "letterbox"
	End
	
	Method OnMeasure:Vec2i() Override
		Return New Vec2i( width, height )
	End
	
	Method OnRender( canvas:Canvas ) Override		
		App.RequestRender()
		
		If Keyboard.KeyPressed( Key.Space ) Then Cat.batch = Not Cat.batch
		If Keyboard.KeyPressed( Key.Y ) Then RenderStack.depthSort = Not RenderStack.depthSort
		
		For Local kitty := Eachin cats
			kitty.Update( canvas )
		Next
		RenderStack.Draw( canvas )
		
		canvas.Color = Color.Black
		canvas.DrawRect( 5, 5, width/3, 90 )
		canvas.Color = Color.White
		canvas.DrawText( "Render batching: " + ( Cat.batch?"True"Else"False" ) + " (space bar to change)", 10, 10 )
		canvas.DrawText( "Y sorting: " + ( RenderStack.depthSort?"True"Else"False" ) + " (Y key to change)", 10, 30 )
		canvas.DrawText( "Total cats: " + totalCats, 10, 50 )
		canvas.DrawText( "FPS: " + RenderStack.FPS(), 10, 70 )
	End

End


'**********************************************************************************************************************************


Class Cat
	Global img:Image[]
	Global batch:= True
	
	Field frame := 0
	Field pos:= New Vec2f( 100, 100 )
	Field scale := New Vec2f( 1, 1 )
	Field rot := 0.0
	
	Field speed := New Vec2f( Rnd(-1,1), Rnd(-1,1) )
	
	Method Update( canvas:Canvas )
		canvas.Color = Color.White
		pos.X += speed.X
		pos.Y += speed.Y
		rot += 0.05
		If( pos.X >= width ) Or ( pos.X <= 0 ) Then speed.X *= -1
		If( pos.Y >= height) Or ( pos.Y <= 0 ) Then speed.Y *= -1
		If batch
			RenderStack.Add( img[frame], pos.Y, pos, rot, scale )
		Else
			canvas.DrawImage( img[frame], pos.X, pos.Y, rot, scale.X, scale.Y )
		End
	End
End




