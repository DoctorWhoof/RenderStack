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
	Field lastFrame := 0

	Method New()					
		Super.New( "Test", width, height, WindowFlags.Resizable )
		Cat.img = LoadSpriteSheet( "asset::cats.png", 16, 16, 16, 0, 0, False, 3 )
		For Local i := Eachin Cat.img
			i.Handle = New Vec2f(0,0)
		Next
		For Local n := 0 Until totalCats
			Local kitty := New Cat
			kitty.pos = New Vec2f( Rnd(0, 1024), Rnd(0, 768) )
			kitty.frame = Rnd(0,16)
			cats.Push( kitty )
		Next
	End
	
	Method OnRender( canvas:Canvas ) Override		
		App.RequestRender()
		
		If Keyboard.KeyPressed( Key.Space ) Then Cat.batch = Not Cat.batch
		
		For Local kitty := Eachin cats
			kitty.Render( canvas )
		Next
		
		RenderStack.Draw( canvas )
		
		canvas.Color = Color.Black
		canvas.DrawRect( 5, 5, width/3, 80 )
		canvas.Color = Color.White
		canvas.DrawText( "Time per frame: " + String( ( Microsecs() - lastFrame ) / 1000.0 ).Slice( 0, 6 ) + "ms", 10, 10 )
		canvas.DrawText( "Render batching: " + ( Cat.batch?"True"Else"False" ) + " (space bar to change)", 10, 30 )
		canvas.DrawText( "Total cats: " + totalCats, 10, 50 )
		lastFrame = Microsecs()
	End

End


'**********************************************************************************************************************************


Class Cat
	Global img:Image[]
	Global batch:= True
	
	Field frame := 0
	Field pos:= New Vec2f
	Field speed := New Vec2f( Rnd(-1,1), Rnd(-1,1) )
	
	Method Render( canvas:Canvas )
		canvas.Color = Color.White
		pos.X += speed.X
		pos.Y += speed.Y
		If( pos.X >= width ) Or ( pos.X <= 0 ) Then speed.X *= -1
		If( pos.Y >= height) Or ( pos.Y <= 0 ) Then speed.Y *= -1
		If batch
			RenderStack.Add( img[frame], pos.X, pos.Y, img[frame].Width, img[frame].Height, 0 )
		Else
			canvas.DrawImage( img[frame], pos.X, pos.Y )
		End
	End
End




