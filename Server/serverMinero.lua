local marcadoresTrabajoMinero= {
	[1]={ 564.02734375, 931.298828125, -43.475772857666, 6},
	[2]={604.423828125, 941.1640625, -40.267929077148, 6},
	[3]={677.201171875, 930.634765625, -41.64787673950, 8},
	[4]={700.34765625, 895.5166015625, -39.499992370605, 8},
	[5]={699.5419921875, 860.96484375, -43.872333526611, 9},
	[6]={662.8408203125, 805.4365234375, -43.9609375, 7},
	[7]={639.3115234375, 820.203125, -43.699489593506, 6},
	[8]={592.158203125, 830.2841796875, -43.509536743164, 4},
	[9]={540.94140625, 828.6962890625, -39.990226745605, 6}
}

function crearMarcadoresMinero()
    markerDejarMateriales = createMarker ( 601.419921875, 867.9912109375, -43.9609375, "cylinder",1.8, 255, 0, 0, 255 )
    blipMark = createBlipAttachedTo(markerDejarMateriales,0,2,255, 0, 0,255,0, 1000, resourceRoot)
    zonaMineros = createColSphere ( 590.115234375, 873.3759765625, -43.497318267822, 290 )
    tablaMarcadores = {}
    tablaBlips = {}
    tablaBlipMark = {}
    table.insert(tablaBlipMark, blipMark)
    local piedra = nil
    for rid, row in ipairs ( marcadoresTrabajoMinero ) do 
        x, y, z = marcadoresTrabajoMinero[rid][1], marcadoresTrabajoMinero[rid][2], marcadoresTrabajoMinero[rid][3] 
        marcamin = createMarker( x, y, z, "cylinder",1.4, 229, 236, 17, 255, resourceRoot)
        bl = createBlipAttachedTo(marcamin,0,2,246, 236, 16,255,0, 1000, resourceRoot)
        table.insert(tablaMarcadores, marcamin)
        table.insert(tablaBlips, bl)
        setElementData( marcamin, "ocupado"..rid, false)
        addEventHandler("onMarkerHit", marcamin, 
        function(hitElement)
            if getElementType (hitElement) ~= "vehicle" then  
                if (isPedInVehicle(hitElement) == false) then
                    if (getElementData(marcamin, "ocupado"..rid) == false and getElementData(hitElement,"Ocupacion"):find "Minero" ~= nil) then
                        if getElementData(hitElement, "conMaterialesMineria") == false then
                            if getPedWeapon ( hitElement) == 15 then
                                px,py,pz = getElementPosition(hitElement)
                                nivelMinero = getElementData(hitElement, "nivelMinero") or 0
                                intervalo1 = (nivelMinero * 20) + 5000
                                tiempopicar = math.random(intervalo1, intervalo1 + 2000)
                                setElementData( marcamin, "ocupado"..rid, true)
                                setElementData( hitElement, "picando", true)
                                setElementData( hitElement, "probabilidadMaterial", math.random(marcadoresTrabajoMinero[rid][4], 20))
                                setPedAnimation( hitElement , "BASEBALL", "bat_4", -1, true, false, false )
                                cancelarAcciones(hitElement)
                                triggerClientEvent(hitElement,"SonidoPicar",hitElement,hitElement,tiempopicar)
                                setTimer (function ( )
                                    setPedAnimation ( hitElement )
                                    setElementData( hitElement, "picando", false)
                                    setTimer (function ( )
                                        setPedAnimation(hitElement,"CARRY","crry_prtial",0,true,false,true,true)
                                        piedra = createObject(2936,px,py,pz)
                                        attachElements(piedra,hitElement, 0,1,0.5)
                                        setElementData( hitElement,"conMaterialesMineria", true)
                                        outputChatBox("[Minero]#ffffffLleva el material a el punto rojo", hitElement, 119, 119, 119, true)
                                    end,100, 1)
                                end,tiempopicar, 1)
                                setTimer (function ( )
                                    setElementData( marcamin, "ocupado"..rid, false)
                                end,tiempopicar*3, 1)
                            else
                                outputChatBox("[Minero]#ffffffNecesita el pico en la mano para poder hacer la actividad", hitElement, 119, 119, 119, true)
                            end
                        else
                            outputChatBox("[Minero]#ffffffEntrega los materiales primero antes de continuar", hitElement, 119, 119, 119, true)
                        end
                    end
                else
                    outputChatBox("[Minero]#ffffff No puedes estar en un vehiculo",hitElement, 119, 119, 119,true)
                end
            end
        end)
    end
    setTimer(function()
        for i,v in ipairs(getElementsByType("player")) do
            local ocupacion = getElementData(v,"Ocupacion")
            for j,k in ipairs(tablaMarcadores) do
                if isElementWithinColShape ( v, zonaMineros ) and ocupacion:find "Minero" ~= nil then
                    setElementVisibleTo ( k, v, true )
                else
                    setElementVisibleTo ( k, v, false )
                end
            end
            for h,l in ipairs(tablaBlips) do
                if isElementWithinColShape ( v, zonaMineros ) and ocupacion:find "Minero" ~= nil then
                    setElementVisibleTo ( l, v, true )
                else
                    setElementVisibleTo ( l, v, false )
                end
            end
            for u,w in ipairs(tablaBlipMark) do
                if isElementWithinColShape ( v, zonaMineros ) and ocupacion:find "Minero" ~= nil and getElementData(v,"conMaterialesMineria") then
                    setElementVisibleTo ( w, v, true )
                else
                    setElementVisibleTo ( w, v, false )
                end
            end
        end
    end, 4000,0)
    addEventHandler("onMarkerHit", markerDejarMateriales, 
        function(hitElement)
            if getElementType (hitElement) ~= "vehicle" then  
                if (isPedInVehicle(hitElement) == false) then
                    if (getElementData(hitElement,"Ocupacion"):find "Minero" ~= nil) then
                        if getElementData( hitElement,"conMaterialesMineria") then
                            nivelM = getElementData(hitElement, "nivelMinero") or 0
                            setElementData( hitElement, "conMaterialesMineria", false)
                            detachElements(piedra, hitElement)
                            destroyElement(piedra)                      
                            probabilidad = getElementData(hitElement, "probabilidadMaterial")
                            cantidadDinero = math.random(3500, 3700)+(probabilidad*10)+(nivelM*30)
                            outputChatBox("[Minero]#ffffffAl intercambiar los materias has recibido $"..cantidadDinero , hitElement, 119, 119, 119, true)
                            givePlayerMoney ( hitElement, cantidadDinero )
                            setElementData( hitElement, "nivelMinero",  nivelM + 1)
                            activarAcciones(hitElement)
                        else
                            outputChatBox("[Minero]#ffffffNo tienes materiales para entregar", hitElement, 119, 119, 119, true)
                        end
                    end
                end
            end
        end)
end
addEventHandler("onResourceStart", root, crearMarcadoresMinero)

function cancelarAcciones(jugador)
    toggleControl ( jugador, "accelerate", false )
    toggleControl ( jugador, "brake_reverse", false )
    toggleControl ( jugador, "handbrake", false )
    toggleControl ( jugador, "fire", false )
    toggleControl ( jugador, "next_weapon", false )
    toggleControl ( jugador, "previous_weapon", false )
    toggleControl ( jugador, "change_camera", false )
    toggleControl ( jugador, "jump", false )
    toggleControl ( jugador, "look_behind", false )
    toggleControl ( jugador, "crouch", false )
    toggleControl ( jugador, "sprint", false )
end

function activarAcciones(jugador)
    toggleControl ( jugador, "accelerate", true )
    toggleControl ( jugador,  "brake_reverse", true )
    toggleControl ( jugador, "handbrake", true )
    toggleControl ( jugador, "fire", true )
    toggleControl ( jugador, "next_weapon", true )
    toggleControl ( jugador, "previous_weapon", true )
    toggleControl ( jugador, "change_camera", true )
    toggleControl ( jugador, "jump", true )
    toggleControl ( jugador, "look_behind", true )
    toggleControl ( jugador, "crouch", true )
    toggleControl ( jugador, "enter_exit",true)
    toggleControl ( jugador, "sprint",true)
end