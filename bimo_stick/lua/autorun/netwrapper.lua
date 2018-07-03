if (netwrapper) then return end

print( "[NetWrapper] Initializing netwrapper library" )

--[[--------------------------------------------------------------------------
--		Namespace Tables 
--------------------------------------------------------------------------]]--

netwrapper      = netwrapper      or {}
netwrapper.ents = netwrapper.ents or {}

--[[--------------------------------------------------------------------------
--		Localized Variables 
--------------------------------------------------------------------------]]--

local ENTITY = FindMetaTable( "Entity" )

--[[--------------------------------------------------------------------------
--		Localized Functions 
--------------------------------------------------------------------------]]--

local net      = net
local hook     = hook
local util     = util
local pairs    = pairs
local IsEntity = IsEntity

--[[--------------------------------------------------------------------------
--		Namespace Functions
--------------------------------------------------------------------------]]--

if ( SERVER ) then 

	util.AddNetworkString( "NetWrapper" )
	util.AddNetworkString( "NetWrapperRemove" )

	--\\----------------------------------------------------------------------\\--
	net.Receive( "NetWrapper", function( len, ply )
		netwrapper.SyncClient( ply )
	end )
	--\\----------------------------------------------------------------------\\--
	hook.Add( "EntityRemoved", "NetWrapperRemove", function( ent )
		netwrapper.RemoveNetVars( ent:EntIndex() )
	end )
	--\\----------------------------------------------------------------------\\--
	function netwrapper.SyncClient( ply )
		for id, values in pairs( netwrapper.ents ) do			
			for key, value in pairs( values ) do
				if ( IsEntity( value ) and !value:IsValid() ) then 
					netwrapper.ents[ id ][ key ] = nil 
					continue; 
				end
				
				netwrapper.SendNetVar( ply, id, key, value )
			end			
		end
	end
	--\\----------------------------------------------------------------------\\--
	function netwrapper.BroadcastNetVar( id, key, value )
		net.Start( "NetWrapper" )
			net.WriteUInt( id, 16 )
			net.WriteString( key )
			net.WriteType( value )
		net.Broadcast()
	end
	--\\----------------------------------------------------------------------\\--
	function netwrapper.SendNetVar( ply, id, key, value )
		net.Start( "NetWrapper" )
			net.WriteUInt( id, 16 )
			net.WriteString( key )
			net.WriteType( value )
		net.Send( ply )
	end
	
elseif ( CLIENT ) then

	net.Receive( "NetWrapper", function( len )
		local entid  = net.ReadUInt( 16 )
		local key    = net.ReadString()
		local typeid = net.ReadUInt( 8 )
		local value  = net.ReadType( typeid )

		netwrapper.StoreNetVar( entid, key, value )
	end )
	--\\----------------------------------------------------------------------\\--
	net.Receive( "NetWrapperRemove", function( len )
		local entid = net.ReadUInt( 16 )
		netwrapper.RemoveNetVars( entid )
	end )
	--\\----------------------------------------------------------------------\\--
	hook.Add( "InitPostEntity", "NetWrapperSync", function()
		net.Start( "NetWrapper" )
		net.SendToServer()
	end )
	--\\----------------------------------------------------------------------\\--
	hook.Add( "OnEntityCreated", "NetWrapperSync", function( ent )
		local id = ent:EntIndex()
		local values = netwrapper.GetNetVars( id )
		
		for key, value in pairs( values ) do
			ent:SetNetVar( key, value )
		end
	end )
	
end


--\\----------------------------------------------------------------------\\--
function ENTITY:SetNetVar( key, value )
	netwrapper.StoreNetVar( self:EntIndex(), key, value )
	
	if ( SERVER ) then 
		netwrapper.BroadcastNetVar( self:EntIndex(), key, value )
	end
end
--\\----------------------------------------------------------------------\\--
function ENTITY:GetNetVar( key, default )
	local values = netwrapper.GetNetVars( self:EntIndex() )
	return (values and values[ key ]) or default
end
--\\----------------------------------------------------------------------\\--
function netwrapper.StoreNetVar( id, key, value )
	netwrapper.ents = netwrapper.ents or {}
	netwrapper.ents[ id ] = netwrapper.ents[ id ] or {}
	netwrapper.ents[ id ][ key ] = value
end
--\\----------------------------------------------------------------------\\--
function netwrapper.GetNetVars( id )
	return netwrapper.ents[ id ] or {}
end
--\\----------------------------------------------------------------------\\--
function netwrapper.RemoveNetVars( id )
	netwrapper.ents[ id ] = nil

	if ( SERVER ) then
		net.Start( "NetWrapperRemove" )
			net.WriteUInt( id, 16 )
		net.Broadcast()
	end
end