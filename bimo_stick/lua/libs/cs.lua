if (CS) then return end

CS = {}

if (SERVER) then
	util.AddNetworkString("CS_SendChat")
	function CS.Chat(ply, tab)
		net.Start("CS_SendChat")
		net.WriteTable(tab)
		if (ply) then
			net.Send(ply)
		else
			net.Broadcast()
		end
	end
elseif (CLIENT) then
	net.Receive("CS_SendChat", function()
		local tab = net.ReadTable()
		chat.AddText(unpack(tab))
	end)
end