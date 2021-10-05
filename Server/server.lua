function CambiarTeam()
	local team = getTeamFromName("Trabajadores")
	setPlayerTeam( source, team)
	local resp = getElementModel(source)
	setElementData  (source, "SkinF", resp)
	setElementModel(source, 27)
	setPlayerNametagColor (source, 229,236,17)
	giveWeapon ( source, 15 , 15, true)
end
addEvent( "CambiarTeamTrabajoMinero", true)
addEventHandler( "CambiarTeamTrabajoMinero", getRootElement(), CambiarTeam)

function darPlataMinero (total)
	givePlayerMoney ( source, total)
end
addEvent( "darPlataMinero", true)
addEventHandler( "darPlataMinero", getRootElement(), darPlataMinero)

function CambiarOcupacionMinero()
	nivelMinero = getElementData(source, "nivelMinero") or 0
    setElementData(source,"Ocupacion", "Minero (Nivel "..nivelMinero..")", true)
	setElementData(source,"VehiTrabajo", 0, true)
end
addEvent( "CambiarOcupacionMinero", true)
addEventHandler( "CambiarOcupacionMinero", getRootElement(), CambiarOcupacionMinero)