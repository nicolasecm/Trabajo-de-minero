sx,sy = guiGetScreenSize()
textsToDraw = {}
maxrange = 14
addEventHandler("onClientRender",root,
    function()
        for a,b in pairs(textsToDraw) do
            x,y,z = b[1],b[2],b[3]
            scx,scy = getScreenFromWorldPosition (x,y,z)
            camX,camY,camZ = getCameraMatrix()
            if scx and scy and getDistanceBetweenPoints3D(camX,camY,camZ,x,y,z+5) <= maxrange then 
            dxDrawFramedText(b[4],scx-0.5*dxGetTextWidth(b[4],2,"sans"),scy+30-0.5*dxGetFontHeight(2,"sans"),sx, sy+5,tocolor ( b[5], b[6], b[7], 255 ), 2,"sans")
            end
        end
    end
)

function AgregarTextoMarcadores(x,y,z,text,r,g,b)
    table.insert(textsToDraw,{x,y,z,text,r,g,b})
end

function dxDrawFramedText ( message , left , top , width , height , color , scale , font , alignX , alignY , clip , wordBreak , postGUI , frameColor )
	color = color or tocolor ( 255 , 255 , 255 , 255 )
	frameColor = frameColor or tocolor ( 0 , 0 , 0 , 255 )
	scale = scale or 1
	font = font or "sans"
	alignX = alignX or "left"
	alignY = alignY or "top"
	clip = clip or false
	wordBreak = wordBreak or false
	postGUI = postGUI or false
	dxDrawText ( message , left + 1 , top + 1 , width + 1 , height + 1 , frameColor , scale , font , alignX , alignY , clip , wordBreak , postGUI )
	dxDrawText ( message , left + 1 , top - 1 , width + 1 , height - 1 , frameColor , scale , font , alignX , alignY , clip , wordBreak , postGUI )
	dxDrawText ( message , left - 1 , top + 1 , width - 1 , height + 1 , frameColor , scale , font , alignX , alignY , clip , wordBreak , postGUI )
	dxDrawText ( message , left - 1 , top - 1 , width - 1 , height - 1 , frameColor , scale , font , alignX , alignY , clip , wordBreak , postGUI )
	dxDrawText ( message , left , top , width , height , color , scale , font , alignX , alignY , clip , wordBreak , postGUI )
end

AgregarTextoMarcadores( 590.115234375, 873.3759765625, -41.497318267822,"Trabajo Minero",255,255,255)
AgregarTextoMarcadores( 601.419921875, 867.9912109375, -41.9609375,"Entregar Materiales",255,255,255)