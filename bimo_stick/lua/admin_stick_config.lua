
StickConfig = {}

// Here are some configuration values for the admin stick. These do not normally need to be changed, but can be to suit your server.


// List of weapons not shown when getting a list of someones weapons. This does not need to be changed for DarkRP.
StickConfig.IgnoreWeapons = {
	"keys",
	"weapon_physcannon",
	"gmod_tool",
	"weapon_physgun",
	"adminstick",
	"arrest_stick",
	"door_ram",
	"pocket",
	"unarrest_stick",
	"stunstick"
}

// The prefix to the chat notifications given when using the admin stick. It is normally a blue [Administration]: tag and white text.
StickConfig.NotificationPrefix = {
	Color(0, 149, 255),
	"[Bimo Admin]: ",
	Color(255, 255, 255)
}


// Set this to true to use the remover blacklist as a whitelist
StickConfig.RemoverBlacklistIsWhitelist = false

// A list of entities that cannot be removed with the remover tool on the stick
StickConfig.RemoverBlacklist = {
	"prop_dynamic",
	"prop_door_rotating",
	"func_door",
	"func_lod",
	"func_rotating",
	"worldspawn",
	"func_door_rotating",
	"player"
}

// Set to true to kick players if an admin uses the remover tool on them (Not recommended, it can be done by accident very easily)
StickConfig.KickPlayerOnRemove = false

// A list of user groups that receive the stick when they spawn and can use the stick
StickConfig.GroupsCanUse = {
	"mod",
    "admin",
	"senioradmin",
	"headadmin",
	"staffmanager",
	"servermanager",
	"divisionmanager",
	"developer",
	"owner",
}

// Will regular admins spawn with the stick even if they are not on the above list?
StickConfig.GiveToAdmins = false



// This function is called to check if a player should be given the admin stick when they spawn. Default is to give according to the settings above.
StickConfig.ShouldGiveToPerson = function(Player)
	if (table.HasValue(StickConfig.GroupsCanUse, Player:GetUserGroup())) then return true end
	if (StickConfig.GiveToAdmins) and (Player:IsAdmin()) then return true end
	return false
end

// This function is called to check if a player should be able to use the admin stick. If a person is attempting to use the stick but cannot, it will be removed from them. Default is to give according to the settings above.
StickConfig.PersonCanUse = function(Player)
	if (table.HasValue(StickConfig.GroupsCanUse, Player:GetUserGroup())) then return true end
	if (StickConfig.GiveToAdmins) and (Player:IsAdmin()) then return true end
	return false
end



StickConfig.LimitedToGroups = {} // A list of tools and the user group it is limited to

StickConfig.LimitedToGroups["[A] Repair Vehicle"] = {"admin", "senioradmin", "headadmin", "staffmanager", "servermanager", "divisionmanager", "developer",  "owner"}
StickConfig.LimitedToGroups["[A] Restore Your Health"] = {"admin", "senioradmin", "headadmin", "staffmanager", "servermanager",  "owner"}
StickConfig.LimitedToGroups["[A] Restore Health"] = {"admin", "senioradmin", "headadmin", "staffmanager", "servermanager", "owner"}
StickConfig.LimitedToGroups["[M] Announce Server Restart"] = {"servermanager", "divisionmanager", "developer",  "owner"}
StickConfig.LimitedToGroups["[M] Reload Map"] = {"servermanager", "divisionmanager", "developer",  "owner"}
StickConfig.LimitedToGroups["[M] Print Target Position"] = {"servermanager", "divisionmanager", "developer", "owner"}
StickConfig.LimitedToGroups["[M] Print Entity Position"] = {"servermanager", "divisionmanager", "developer",  "owner"} 
StickConfig.LimitedToGroups["[SA] Remover"] = {"senioradmin", "headadmin", "staffmanager", "servermanager", "divisionmanager", "developer",  "owner"}
StickConfig.LimitedToGroups["[SA] God Mode"] = {"senioradmin", "headadmin", "staffmanager", "servermanager", "divisionmanager", "developer",  "owner"}
StickConfig.LimitedToGroups["[SA] Gimp Player"] = {"senioradmin", "headadmin", "staffmanager", "servermanager", "divisionmanager", "developer",  "owner"}
StickConfig.LimitedToGroups["[SA] Ungimp Player"] = {"senioradmin", "headadmin", "staffmanager", "servermanager", "divisionmanager", "developer",  "owner"}

// A list of disabled tools. Add the name of the tool here to prevent it from loading.
StickConfig.DisabledTools = {

}

// Set this to true to not load the default DarkRP tools when running DarkRP
StickConfig.DarkRPDisabled = true

// Set to true to show the stunstick view model
StickConfig.ShowViewModel = true