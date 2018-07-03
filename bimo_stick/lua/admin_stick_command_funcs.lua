
// Ignore this function. It is needed for the command adding to work.
local function AddCommand(cmd, name, desc, icon)
	desc = desc or "A command-based tool. This runs the command: " .. cmd
	name = name or cmd
	icon = icon or "icon16/application_xp_terminal.png"
	AddStickTool(name, {
		Description = desc,
		Icon = icon,
		CanTarget = anything,
		OnRun = function(Player, Trace)
			Player:ConCommand(cmd)
		end
	})
end


////////////
// Use this file to add command-based tools.
////////////

//
// Example: 	Use ULX kick command to kick the person you are looking at with reason 'Kicked by Admin'.
// 				It will have a description of "Kicks the target player.", has the cancel icon and the name 'Kick Player' in the menu.
//				Remove the // from the start of the line to enable it.


AddCommand("ulx rcon say Server Restart incoming!", "[M] Announce Server Restart", "Announces that the server is going to restart.")
AddCommand("ulx decals", "[EA] Clear Decals", "Clears Decals.")
AddCommand("ulx stopsounds", "[EA] Stop Sounds", "Stops Sounds.")
AddCommand("ulx slap 0", "[EA] Slap Player", "Slaps a player for being goofy.")
AddCommand("ulx jail @ 0", "[EA] Jail Player", "Jails a player..")
AddCommand("ulx unjail @ 0", "[EA] Unjail Player", "Release a player from jail..")
AddCommand("ulx rcon changelevel rp_paralake_city_v3", "[M] Reload Map", "STOPS THE SERVER and reloads the map.")
AddCommand("ulx hp ^ 100", "[A] Restore Your Health", "Restores YOUR health.")
AddCommand("ulx gimp @", "[SA] Gimp Player", "Gimps a player's text chat.")
AddCommand("ulx ungimp @", "[SA] Ungimp Player", "Ungimps a player.")
AddCommand("ulx strip @", "[EA] Strip Weapons", "Strips a player's weapons")