addEventHandler("onPlayerLogin", root, 
function ()
	setElementData (source, "Cuenta", getAccountName(getPlayerAccount(source)))
	setTimer (function (source)
		local nm = getElementData(source, "nivelMinero")
		if nm and tonumber(nm) ~= nil then else
			setElementData  (source, "nivelMinero", 0)
		end
	end, 1000, 1, source)
end)

function playerLoginFre (thePreviousAccount, theCurrentAccount, autoLogin)
  if  not (isGuestAccount (getPlayerAccount (source))) then
    local accountData = getAccountData (theCurrentAccount, "funmodev2-money")
    if (accountData) then
		local nivelMinero = getAccountData(theCurrentAccount,"nivelMinero")
		setElementData(source,"nivelMinero",nivelMinero)
		setElementData( source, "picando", false)
        setElementData( source, "probabilidadMaterial", 0)
        setElementData( source, "conMaterialesMineria", false)
    end   
  end
end
addEventHandler ("onPlayerLogin", getRootElement(), playerLoginFre)

function onLogout ()
	kickPlayer (source, nil, "Logging out is disallowed.")
end
addEventHandler ("onPlayerLogout", getRootElement(), onLogout)

function onQuitFre (quitType, reason, responsibleElement)
  if not (isGuestAccount (getPlayerAccount (source))) then
    account = getPlayerAccount (source)
    if (account) then
		setAccountData (account, "funmodev2-money", tostring (getPlayerMoney (source)))
		local nivelMinero = getElementData(source,"nivelMinero")
		setAccountData (account,"nivelMinero",nivelMinero)
	end
  end
end
addEventHandler ("onPlayerQuit", getRootElement(), onQuitFre)