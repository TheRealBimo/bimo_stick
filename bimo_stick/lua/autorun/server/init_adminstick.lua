

hook.Add("PlayerLoadout", "AdminStick_GiveTheStick", function(ply)
	if (StickConfig.ShouldGiveToPerson(ply)) and (!ply:HasWeapon("cs_adminstick")) then
		ply:Give("cs_adminstick")
	end
end)

hook.Add("PlayerSpawn", "AdminStick_GiveTheStick_Backup", function(ply) // Backup in case the PlayerLoadout hook is overwritten in a custom gamemode
	if (StickConfig.ShouldGiveToPerson(ply)) and (!ply:HasWeapon("cs_adminstick")) then
		ply:Give("cs_adminstick")
	end
end)