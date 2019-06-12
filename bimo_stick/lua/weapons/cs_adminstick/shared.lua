
if (SERVER) then
	AddCSLuaFile( "shared.lua" )
else
    SWEP.PrintName = "Bimo's Administration Tool"
    SWEP.Slot = 0
    SWEP.SlotPos = 5
    SWEP.DrawAmmo = false
    SWEP.DrawCrosshair = true
end
 
SWEP.Author = "Bimo"
SWEP.Instructions = "Right click to open menu, Left click to fire."
SWEP.Contact        = "therealbimo@gmail.com"
SWEP.Purpose        = "Administrative Stick"
SWEP.FirstPersonGlowSprite = Material("sprites/light_glow02_add_noz");
SWEP.ThirdPersonGlowSprite = Material("sprites/light_glow02_add");
 
SWEP.ViewModelFOV       = 62
SWEP.ViewModelFlip      = false
SWEP.AnimPrefix  = "stunstick"
SWEP.WorldModel = "models/weapons/w_stunbaton.mdl"
SWEP.ViewModel = "models/weapons/v_stunstick.mdl"

SWEP.Spawnable = false
SWEP.AdminSpawnable = false

SWEP.Sound1 = Sound("npc/metropolice/vo/moveit.wav")
SWEP.Sound2 = Sound("npc/metropolice/vo/movealong.wav")

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ""
SWEP.HoldType = "melee" 
SWEP.ShowWorldModel = true
 
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = ""

function SWEP:Deploy()
	if (SERVER) then
		self.Owner:DrawViewModel(StickConfig.ShowViewModel)
		self.Owner:DrawWorldModel(true)
		self:SetHoldType(self.HoldType)
		self:DrawShadow(true)
	end
end

function SWEP:Think ( )

	if self.Floater and IsValid(self.Floater) then

			local trace = {}

			trace.start = self.Floater:GetPos()

			trace.endpos = trace.start - Vector(0, 0, 100000);

			trace.filter = { self.Floater }

			local tr = util.TraceLine( trace )



		local altitude = tr.HitPos:Distance(trace.start);



		local ent = self.Spazzer;

		local vec;



		if self.FloatSmart then

			local trace = {}

			trace.start = self.Owner:GetShootPos()

			trace.endpos = trace.start + (self.Owner:GetAimVector() * 400)

			trace.filter = { self.Owner, self.Weapon }

			local tr = util.TraceLine( trace )



			vec = trace.endpos - self.Floater:GetPos();

		else

			vec = Vector(0, 0, 0);

		end



		if altitude < 150 then

			if vec == Vector(0, 0, 0) then

				vec = Vector(0, 0, 25);

			else

				vec = vec + Vector(0, 0, 100);

			end

		end



		vec:Normalize()



		if self.Floater:IsPlayer() then

			local speed = self.Floater:GetVelocity()

			self.Floater:SetVelocity( (vec * 1) + speed)

		else

			local speed = self.Floater:GetPhysicsObject():GetVelocity()

			self.Floater:GetPhysicsObject():SetVelocity( (vec * math.Clamp((self.Floater:GetPhysicsObject():GetMass() / 20), 10, 20)) + speed)

		end



	end

end



function SWEP:DrawWorldModel()

    self:DrawModel();



    local attachment = self:GetAttachment(1);

    local curTime = CurTime();

    local scale = math.abs(math.sin(curTime) * 4);

    local alpha = math.abs(math.sin(curTime) / 4);



    self.ThirdPersonGlowSprite:SetFloat("$alpha", 0.7 + alpha);



    if (self.Owner:IsUserGroup("superadmin")) then

    	rankcolor = Color(255,0,0);	

    elseif (self.Owner:IsUserGroup("developer")) then

    	rankcolor = Color(255,200,0,255);	  

    elseif (self.Owner:IsUserGroup("manager")) then

    	rankcolor = Color(255,115,0,255);

    elseif (self.Owner:IsUserGroup("senior_admin")) then

    	rankcolor = Color(0,149,255,255);

    elseif (self.Owner:IsUserGroup("admin")) then

        rankcolor = Color(0,255,0,255);

    elseif (self.Owner:IsUserGroup("entry_admin")) then

        rankcolor = Color(255,0,255,255);

    end



    if (attachment and attachment.Pos) then

        cam.Start3D( EyePos(), EyeAngles() )
            render.SetMaterial(self.ThirdPersonGlowSprite);
            render.DrawSprite( attachment.Pos, 45 + scale, 45 + scale, rankcolor );
        cam.End3D()

        cam.Start3D( EyePos(), EyeAngles() )
            render.SetMaterial(self.ThirdPersonGlowSprite);
            render.DrawSprite( attachment.Pos, 45 + scale, 45 + scale, rankcolor );
        cam.End3D()

        cam.Start3D( EyePos(), EyeAngles() )
            render.SetMaterial(self.ThirdPersonGlowSprite);
            render.DrawSprite( attachment.Pos, 45 + scale, 45 + scale, rankcolor );
        cam.End3D()
    end

end



function SWEP:ViewModelDrawn()

        if (self:IsCarriedByLocalPlayer()) then

            local viewModel = self.Owner:GetViewModel();



            if (IsValid(viewModel)) then

                local attachment = viewModel:GetAttachment( viewModel:LookupAttachment("sparkrear") );

                local curTime = CurTime();

                local scale = math.abs(math.sin(curTime) * 4);

                local alpha = math.abs(math.sin(curTime) / 4);



                self.FirstPersonGlowSprite:SetFloat("$alpha", 0.7 + alpha);

                self.ThirdPersonGlowSprite:SetFloat("$alpha", 0.5 + alpha);



            	if (self.Owner:IsUserGroup("superadmin")) then

                local frequency = 0.3
                local red = math.sin(frequency*CurTime() + 0) * 127 + 128
                local green = math.sin(frequency*CurTime() + 2) * 127 + 128
                local blue = math.sin(frequency*CurTime() + 4) * 127 + 128
                rankcolor = Color(255,0,0,255)

				elseif (self.Owner:IsUserGroup("developer")) then

				rankcolor = Color(255,200,0,255);	  
	 
				elseif (self.Owner:IsUserGroup("manager")) then

				rankcolor = Color(255,100,0,255);

				elseif (self.Owner:IsUserGroup("senior_admin")) then

				rankcolor = Color(0,149,255,255);

				elseif (self.Owner:IsUserGroup("admin")) then

				rankcolor = Color(0,255,0,255);

				elseif (self.Owner:IsUserGroup("entry_admin")) then
	
				rankcolor = Color(255,0,255,255);
				
           	 	end



                if (attachment and attachment.Pos) then

                    cam.Start3D( EyePos(), EyeAngles() );

                        render.SetMaterial(self.ThirdPersonGlowSprite);

                        render.DrawSprite( attachment.Pos, 45 + scale, 45 + scale, rankcolor );
                        render.DrawSprite( attachment.Pos, 45 + scale, 45 + scale, rankcolor );
                        render.DrawSprite( attachment.Pos, 45 + scale, 45 + scale, rankcolor );
                        render.DrawSprite( attachment.Pos, 45 + scale, 45 + scale, rankcolor );
                        render.DrawSprite( attachment.Pos, 45 + scale, 45 + scale, rankcolor );
                        render.DrawSprite( attachment.Pos, 45 + scale, 45 + scale, rankcolor );

                        self.FirstPersonGlowSprite:SetFloat("$alpha", 0.5 + alpha);



                            for i = 1, 9 do

                                local attachment = viewModel:GetAttachment( viewModel:LookupAttachment("spark"..i.."a") );

                                	if (attachment.Pos) then

                                    	if (i == 1 or i == 2 or i == 9) then

                                        	render.SetMaterial(self.ThirdPersonGlowSprite);

                                    	else

                                        	render.SetMaterial(self.FirstPersonGlowSprite);

                                    	end

                                        render.DrawSprite( attachment.Pos, 1, 1, rankcolor );
                                        render.DrawSprite( attachment.Pos, 1, 1, rankcolor );
                                        render.DrawSprite( attachment.Pos, 1, 1, rankcolor );
                                        render.DrawSprite( attachment.Pos, 1, 1, rankcolor );
                                        render.DrawSprite( attachment.Pos, 1, 1, rankcolor );
                                        render.DrawSprite( attachment.Pos, 1, 1, rankcolor );
                                    end

                                end



                                for i = 1, 9 do

                                    local attachment = viewModel:GetAttachment( viewModel:LookupAttachment("spark"..i.."b") );

                                    if (attachment.Pos) then

                                        if (i == 1 or i == 2 or i == 9) then

                                            render.SetMaterial(self.ThirdPersonGlowSprite);

                                        else

                                            render.SetMaterial(self.FirstPersonGlowSprite);

                                        end

                                            render.DrawSprite( attachment.Pos, 1, 1, rankcolor );
                                            render.DrawSprite( attachment.Pos, 1, 1, rankcolor );
                                            render.DrawSprite( attachment.Pos, 1, 1, rankcolor );
                                            render.DrawSprite( attachment.Pos, 1, 1, rankcolor );
                                            render.DrawSprite( attachment.Pos, 1, 1, rankcolor );
                                            render.DrawSprite( attachment.Pos, 1, 1, rankcolor );
                                        end

                                	end

                    		cam.End3D()

                    	end

                end

        end

end

function SWEP:Initialize()
    if (SERVER) then
		self:SetNetVar("SelectedTool", "[EA] Freeze Player")
    end
	
	self:SetWeaponHoldType("melee")
end

if (SERVER) then
	util.AddNetworkString("AS_DoAttack")
	local function doToolStuff(len, ply)
		local infoTab = net.ReadTable()
		local weapEnt = Entity(infoTab.Weapon)
		local target = Entity(infoTab.Target)
		if !StickConfig.PersonCanUse(ply) then
	   		ply:ChatPrint("You shouldn't have the administrator tool. It has been taken from you.")
	   		weapEnt:Remove()
	   		return false
	   	end
	    ply:SetAnimation( PLAYER_ATTACK1 )	
	    weapEnt.Weapon:SendWeaponAnim( ACT_VM_HITCENTER )
	    local toolName = weapEnt:GetNetVar("SelectedTool", "[EA] Freeze Player")
	    if (StickConfig.LimitedToGroups[toolName]) and (!table.HasValue(StickConfig.LimitedToGroups[toolName], ply:GetUserGroup())) then
	    	Stick_SendChat(ply, "This tool is limited.")
	    	return
	    end
	    local tool = StickTools[toolName]
	    if (tool) then
	    	if (tool.CanTarget) and (!tool.CanTarget(target)) then return end
	    	if (tool.CanUse) and (!tool.CanUse(ply)) then return end
	    	local trace = ply:GetEyeTraceNoCursor()
	    	trace.Entity = target
	    	tool.OnRun(ply, trace)
	    end
	end
	net.Receive("AS_DoAttack", doToolStuff)
end

function SWEP:PrimaryAttack()
	if (SERVER) then return end
	self.nextAt = self.nextAt or 0
	if (self.nextAt > CurTime()) then return end
	self.nextAt = CurTime() + 0.5
   	local trace = LocalPlayer():GetEyeTraceNoCursor()
   	net.Start("AS_DoAttack")
   	net.WriteTable({
   		Target = trace.Entity:EntIndex(),
   		Weapon = LocalPlayer():GetActiveWeapon():EntIndex()
    })
   	net.SendToServer()
end

if (SERVER) then
	util.AddNetworkString("AdminStick_Select")

	net.Receive("AdminStick_Select", function(len, ply)
		if (!StickConfig.PersonCanUse(ply)) then return end
		local tool = net.ReadString()
		net.ReadEntity():SetNetVar("SelectedTool", tool)
	end)

	hook.Add("PlayerCanHearPlayersVoice", "AS_MakeMutedMuted", function(listener, talker)
		if (talker:GetNetVar("IsAdminMuted", false)) then
			return false, false
		end
	end)
end

if (CLIENT) then
	surface.CreateFont("AS_Details", {
		font = "Arial",
		size = 20,
		weight = 500,
		outline = false
	})

	function SWEP:DrawHUD()
		surface.SetFont("AS_Details")
		local trEnt = LocalPlayer():GetEyeTraceNoCursor().Entity
		local tolTxt = "Current Tool: " .. self:GetNetVar("SelectedTool", "[EA] Freeze Player")
		local descTxt = StickTools[self:GetNetVar("SelectedTool", "[EA] Freeze Player")].Description or "This tool has no description."
		local targTxt = "Target: " .. tostring(trEnt)
		local wid = 0
		if (select(1, surface.GetTextSize(tolTxt)) > wid) then wid = select(1, surface.GetTextSize(tolTxt)) end
		if (select(1, surface.GetTextSize(descTxt)) > wid) then wid = select(1, surface.GetTextSize(descTxt)) end
		if (select(1, surface.GetTextSize(targTxt)) > wid) then wid = select(1, surface.GetTextSize(targTxt)) end
		surface.SetDrawColor(Color(0, 149, 255, 10))
		surface.DrawRect(8, 57, wid + 2, 41)
		surface.SetTextColor(Color(255, 255, 255, 255))
		surface.SetTextPos(10, 56)
		surface.DrawText(tolTxt)
		surface.SetTextPos(10, 74)
		surface.DrawText(descTxt)
	end

	function SWEP:SecondaryAttack()
		if SERVER then return false end
			
		local menu = DermaMenu()

		local lUsrGrp = LocalPlayer():GetUserGroup()
		
		for k, v in SortedPairs(StickTools) do

			if (StickConfig.LimitedToGroups[k]) and (!table.HasValue(StickConfig.LimitedToGroups[k], lUsrGrp)) then
				continue
			end

			local function onRun()
				net.Start("AdminStick_Select")
				net.WriteString(k)
				net.WriteEntity(self)
				net.SendToServer()
			end
			
			local opt = menu:AddOption(k, onRun)
			if (v.Icon) then
				opt:SetIcon(v.Icon)
			end
		end
	
		menu:Open(100, 140)

		timer.Simple(0, function()
			gui.SetMousePos(100, 140)
		end)
	end
end