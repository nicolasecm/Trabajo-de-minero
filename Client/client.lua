--------BLIP----------
blipMinero = createBlip ( 590.115234375, 873.3759765625, -42.497318267822 ,56, 1, 255, 0, 0, 255, 0, 300 )
--------MARKER----------
markertMinero= createMarker ( 590.115234375, 873.3759765625, -43.497318267822, "cylinder",1.8, 229, 236, 17, 255 )

local sx,sy = guiGetScreenSize()
local px,py = 1440,900
local x,y =  (sx/px), (sy/py)
local marcador = nil
local rid = nil

function PanelMinero()
    window = guiCreateWindow(x*456, y*212, x*520, y*452, "Trabajo Minero", false)
    guiWindowSetSizable(window, false)

    local obtenernombreinicio = getPlayerName(getLocalPlayer())	
    memomision1 = guiCreateMemo(x*10, y*25, x*242, y*417, "" .. obtenernombreinicio ..  " a partir de ahora trabajaras como recolector de basura, tu decides si aceptar o no", false, window)
    guiMemoSetReadOnly(memomision1, true)
    botonaceptar = guiCreateButton(x*279, y*25, x*227, y*76, "Aceptar Trabajo", false, window)
    botonsalir = guiCreateButton(x*278, y*339, x*228, y*82, "Salir", false, window)
    
	showCursor(true)
	addEventHandler("onClientGUIClick", botonaceptar, empezartMinero, false)
	addEventHandler("onClientGUIClick", botonaceptar, dieHandler, false)
	addEventHandler("onClientGUIClick", botonaceptar, salirMinero, false)	
	addEventHandler("onClientGUIClick", botonsalir, salirMinero, false)
end

function dieHandler(p)
	addEventHandler ("onClientRender", getRootElement(), IniciarTrabajo)
	setTimer(function() removeEventHandler("onClientRender",getRootElement(),IniciarTrabajo) end,10000,1)
end

function empezartMinero ()
	showCursor(false)
	triggerServerEvent ( "CambiarTeamTrabajoMinero", getLocalPlayer() ) 
	triggerServerEvent ( "CambiarOcupacionMinero", getLocalPlayer() )
end

function IniciarTrabajo ()
    dxDrawText("Trabajo de Minero iniciado", 212, 611, 820, 646, tocolor(0, 0, 0, 255), 1.6, "sans", "center", "center", false, false, true, false, false)
    dxDrawText("Trabajo de Minero iniciado!", 212, 609, 820, 644, tocolor(0, 0, 0, 255), 1.6, "sans", "center", "center", false, false, true, false, false)
    dxDrawText("Trabajo de Minero iniciado!", 210, 611, 818, 646, tocolor(0, 0, 0, 255), 1.6, "sans", "center", "center", false, false, true, false, false)
    dxDrawText("Trabajo de Minero iniciado!", 210, 609, 818, 644, tocolor(0, 0, 0, 255), 1.6, "sans", "center", "center", false, false, true, false, false)
    dxDrawText("Trabajo de Minero iniciado!", 211, 610, 819, 645, tocolor(119, 119, 119, 255),1.6, "sans", "center", "center", false, false, true, false, false)
end

function salirMinero()
	showCursor(false)
	destroyElement(window)
end

addEventHandler('onClientMarkerHit', markertMinero,
function ( hitPlayer )
	xx,yy,zz = getElementPosition(hitPlayer) 
	if (zz < -39 and zz > -44) then
		if (isPedInVehicle(hitPlayer) == false) then
			if ( getElementType ( hitPlayer ) == "player" ) and ( hitPlayer == localPlayer ) then
				if(getElementData(localPlayer, "Ocupacion" ):find "Minero" ~= nil) then
					outputChatBox("[Minero]#ffffffUsted ya tiene este trabajo", 119, 119, 119,true)
				else
					if(isPedInVehicle (getLocalPlayer()))then
						outputChatBox("[Minero]#ffffffNo puede usarlo si esta en un vehiculo", 119, 119, 119,true)
					else
						if(getElementData(localPlayer, "Ocupacion" ) == "Civil" or getElementData(localPlayer, "Ocupacion") == nil) then
							PanelMinero()
						else
							outputChatBox("[Minero]#ffffff tienes que ser civil para tener este trabajo, usa el comando /civil", 119, 119, 119,true)
						end
					end
				end
			end
		else
			outputChatBox("[Minero]#ffffff No puedes estar en un vehiculo", 119, 119, 119,true)
		end
	end
end )

function replaceModel() 
	txd = engineLoadTXD("Modelos/pico.txd", 326 )
	engineImportTXD(txd, 326)
	dff = engineLoadDFF("Modelos/pico.dff", 326 )
	engineReplaceModel(dff, 326)
end
addEventHandler ( "onClientResourceStart", getResourceRootElement(getThisResource()), replaceModel)

function crearInfoMarkers()
	jugadores = getElementsByType("player",root,true)
	for num, car in ipairs(jugadores) do
		picandoPlayer = getElementData(car,"picando") or false
		if( picandoPlayer == true)then
			local carPosX, carPosY, carPosZ = getElementPosition(car)
			local cx, cy, cz = getCameraMatrix()
			carLocationX, carLocationY = getScreenFromWorldPosition(carPosX,carPosY,carPosZ,100)
			local min_distance = getDistanceBetweenPoints3D( cx, cy, cz, carPosX, carPosY, carPosZ )
			if min_distance < 16 then
				if carLocationX then
					rect1 = dxDrawRectangle(carLocationX-102.5,carLocationY-100-72.5,150,25,tocolor(0,0,0,127.5))
					dxDrawText("Picando Minerales", carLocationX-50-33, carLocationY-100-70, 0, 0, tocolor(255,255,255,127.5), 1, "default-bold")
				end
			end
		end
	end
end
addEventHandler("onClientRender",getRootElement(),crearInfoMarkers)

function SonidoPicar (jugador,tiempoPicar)
	local x,y,z = getElementPosition(jugador)
	local sonidoPiedra = playSound3D ( "Modelos/pico.mp3", x,y,z,false)
    setSoundVolume(sonidoPiedra, 1)
	setSoundSpeed ( sonidoPiedra, 1.3)
	setSoundMaxDistance ( sonidoPiedra, 40 )
	setTimer(function()
		destroyElement(sonidoPiedra)
	end,tiempoPicar, 1)
end
addEvent ("SonidoPicar", true)
addEventHandler ("SonidoPicar", root, SonidoPicar)