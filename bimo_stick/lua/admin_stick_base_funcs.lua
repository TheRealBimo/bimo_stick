
-- All base tools are here. Please put your custom tools in the admin_stick_extra_funcs.lua file.

function Stick_SendChat(ply, msg)
	local tab = table.Copy(StickConfig.NotificationPrefix)
	table.insert(tab, msg)
	CS.Chat(ply, tab)
end

AddStickTool("[EA] Freeze Player", {
	Description = "Freezes the target.",
	Icon = "icon16/application_xp_terminal.png",
	CanTarget = targetply,
	OnRun = function(Player, Trace)
		local ply = Trace.Entity
		if (ply:IsFrozen()) then
			ply:Freeze(false)
			ply:EmitSound("npc/metropolice/vo/allrightyoucango.wav")
			Stick_SendChat(Player, "Unfrozen " .. tostring(ply))
			Stick_SendChat(ply, "You have been unfrozen")
		else
			ply:Freeze(true)
			ply:EmitSound("npc/metropolice/vo/holdit.wav")
			Stick_SendChat(Player, "Frozen " .. tostring(ply))
			Stick_SendChat(ply, "You have been frozen")
		end
	end
})

AddStickTool("[SA] God Mode", {
	Description = "Enabled/Disables God Mode for yourself.",
	Icon = "icon16/application_xp_terminal.png",
	CanTarget = anything,
	OnRun = function(Player)
		if (Player.stickGod) then
			Player:GodDisable()
			Stick_SendChat(Player, "Disabled god mode")
			Player.stickGod = false
		else
			Player:GodEnable()
			Stick_SendChat(Player, "Enabled god mode")
			Player.stickGod = true
		end
	end
})

AddStickTool("[A] Restore Health", {
	Description = "Restores the target to full health.",
	Icon = "icon16/application_xp_terminal.png",
	CanTarget = targetply,
	OnRun = function(Player, Trace)
		local ply = Trace.Entity
		ply:SetHealth(ply:GetMaxHealth())
		Stick_SendChat(Player, "Restored " .. tostring(ply) .. " to full health")
		Stick_SendChat(ply, "You have been restored to full health")
	end
})

AddStickTool("[EA] Slay Player", {
	Description = "Slays the target player.",
	Icon = "icon16/application_xp_terminal.png",
	CanTarget = targetply,
	OnRun = function(Player, Trace)
		Trace.Entity:Kill()
		Stick_SendChat(Player, "Slayed " .. tostring(Trace.Entity))
	end
})

AddStickTool("[EA] Respawn Player", {
	Description = "Slays target and spawns them in the spot they died.",
	Icon = "icon16/application_xp_terminal.png",
	CanTarget = targetply,
	OnRun = function(Player, Trace)
		local ply = Trace.Entity
		local pos, ang = ply:GetPos(), ply:GetAngles()
		ply:KillSilent()
		ply:Spawn()
		ply:SetPos(pos)
		ply:SetAngles(ang)
		Stick_SendChat(Player, tostring(ply) .. " has been respawned")
		Stick_SendChat(ply, "You have been respawned")
	end
})

AddStickTool("[SA] Lock/Unlock Door", {
	Description = "Locks/Unlocks target door",
	Icon = "icon16/application_xp_terminal.png",
	CanTarget = function(ent)
		local class = ent:GetClass()
		if (class == "func_door") or (class == "prop_door_rotating") then
			return true
		end
		return false
	end,
	OnRun = function(Player, Trace)
		if (Trace.Entity:GetSaveTable().m_bLocked) then
			Trace.Entity:Fire("Unlock", "", 0)
			Trace.Entity:Fire("Open", "", 0.5)
			Stick_SendChat(Player, "Door unlocked")
		else
			Trace.Entity:Fire("Lock", "", 0)
			Trace.Entity:Fire("Close", "", 0.1)
			Stick_SendChat(Player, "Door locked")
		end
	end
})

AddStickTool("[EA] List Weapons", {
	Description = "Lists weapons currently equipped by target",
	Icon = "icon16/application_xp_terminal.png",
	CanTarget = targetply,
	OnRun = function(Player, Trace)
		local weaponString = ""
		local ply = Trace.Entity
		for k, v in pairs(ply:GetWeapons()) do
			if (table.HasValue(StickConfig.IgnoreWeapons, v:GetClass())) then continue end
			weaponString = weaponString .. " " .. v:GetClass()
		end
		Stick_SendChat(Player, tostring(ply) .. " has weapons:" .. weaponString)
	end
})



AddStickTool("[EA] Mute/Unmute Player", {
	Description = "Toggles voice mute on target",
	Icon = "icon16/application_xp_terminal.png",
	CanTarget = targetply,
	OnRun = function(Player, Trace)
		local ply = Trace.Entity
		if (ply:IsAdmin()) then
			Stick_SendChat(Player, "You can't mute an admin")
			return
		end
		if (ply:GetNetVar("IsAdminMuted", false)) then
			ply:SetNetVar("IsAdminMuted", false)
			Stick_SendChat(ply, "Your voice has been unmuted")
			Stick_SendChat(Player, tostring(ply) .. " has been unmuted")
		else
			Stick_SendChat(ply, "Your voice has been muted")
			ply:SetNetVar("IsAdminMuted", true)
			Stick_SendChat(Player, tostring(ply) .. " has been muted")
		end
	end	
})

AddStickTool("[SA] Remover", {
	Description = "Removes target entity",
	Icon = "icon16/application_xp_terminal.png",
	CanTarget = function(ent)
		local class = ent:GetClass()
		if (ent:IsPlayer()) and (StickConfig.KickPlayerOnRemove) then
			return true
		elseif (table.HasValue(StickConfig.RemoverBlacklist, class)) and (!StickConfig.RemoverBlacklistIsWhitelist) then
			return false
		elseif (table.HasValue(StickConfig.RemoverBlacklist, class)) and (StickConfig.RemoverBlacklistIsWhitelist) then
			return true
		else
			return true
		end
	end,
	OnRun = function(Player, Trace)
		local ent = Trace.Entity
		if (ent:IsPlayer()) then
			Stick_SendChat(Player, "Kicked " .. ent:Nick())
			ent:Kick("You have been kicked from the server by an administrator.")
			return
		end
		Stick_SendChat(Player, "Removed " .. tostring(ent))
		ent:Remove()
	end
})

AddStickTool("[M] Print Target Position", {
	Description = "Prints the hit pos of your eye trace",
	Icon = "icon16/application_xp_terminal.png",
	CanTarget = anything,
	OnRun = function(Player, Trace)
		local pos = Trace.HitPos
		local str = "Vector(" .. pos.x .. ", " .. pos.y .. ", " .. pos.z .. ")"
		Player:ChatPrint(str)
	end
})

AddStickTool("[M] Print Entity Position", {
	Description = "Prints the position of the target entity",
	Icon = "icon16/application_xp_terminal.png",
	CanTarget = anything,
	OnRun = function(Player, Trace)
		if (Trace.Entity == Entity(0)) then // Removing the world crashes the game. No need to do that.
			return
		end
		local pos = Trace.Entity:GetPos()
		local str = "Vector(" .. pos.x .. ", " .. pos.y .. ", " .. pos.z .. ")"
		Player:ChatPrint(str)
	end
})

AddStickTool("[A] Repair Vehicle", {
	Description = "Repairs any vehicle that is in front of you.",
	Icon = "icon16/application_xp_terminal.png",
	CanTarget = anything,
	OnRun = function(Player, Trace)
		if (Trace.Entity == Entity(0)) then // Removing the world crashes the game. No need to do that.
			return
		end
		
		if not IsValid( Trace.Entity ) or not Trace.Entity:IsVehicle() or not Trace.Entity.UID then return end

		GAMEMODE.Cars:SetCarHealth( tr.Entity, GAMEMODE.Cars:GetCarMaxHealth( tr.Entity ))
	end
})