-- STReputation v.GitHub

util.AddNetworkString("strep_downdate")
util.AddNetworkString("strep_update")
util.AddNetworkString("strep_menu")

-- convenience functions
-- untested
-- report issues immediately
local meta = FindMetaTable( "Player" )
function meta:GetSTReputation()
	return self:GetNWInt( "st_rep" )
end

function meta:SetSTReputation( rep )
	rep = rep or 0
	self:SetPData( "st_reputation", rep )
	self:SetNWInt( "st_rep", rep )
end

hook.Add("PlayerDeath", "STReputationDeath", function(vic, inf, atk)
	
	-- tests
	if !IsValid(vic) or !IsValid(atk) or !atk:IsPlayer() then return end
	if vic == atk then return end
	-- if the victim is not the attacker's attacker,
	-- OR
	-- if the victim has a positive reputation
	-- remove reputation
	if vic != atk:GetNWEntity("rep_attacker") or vic:GetSTReputation() > 0 then
		atk:SetSTReputation( atk:GetSTReputation() - 1 )
		net.Start("strep_downdate")
		net.Send(atk)
	elseif vic:GetSTReputation() < 0 then
		atk:SetSTReputation( atk:GetSTReputation() + 1 )
		net.Start("strep_update")
		net.Send(atk)
	end
	
	-- when the player dies,
	-- reset their attacker
	vic:SetNWEntity("rep_attacker", nil)
	
end )

-- set a player as an attacker if they attack someone.
-- this will disallow someone from losing reputation if they
-- killed someone who attacked them first
hook.Add("PlayerHurt", "STReputationHurt", function(vic, atk, r, t)

	-- if the player isn't a player,
	-- or the attacker's attacker is the victim,
	-- stop everything
	if !atk:IsPlayer() then return end
	if atk:GetNWEntity("rep_attacker") == vic then return end

	-- set the attacker
	vic:SetNWEntity("rep_attacker", atk)
	
	-- remove the attacker after 15 seconds
	-- change 15 to whatever you want
	timer.Simple(15, function()
		vic:SetNWEntity("rep_attacker", nil)
	end)
	
end )

-- throws a nil error because when pdata is initialized,
-- it starts nil
-- realized later you can just do GetPData( key, 0 ) but eh
hook.Add("PlayerInitialSpawn", "SetUpSTReputation", function( ply ) 

	if ply:GetPData("st_reputation") == nil then
		ply:SetPData("st_reputation", 0)
	end
	
	ply:SetNWInt("st_rep", ply:GetPData("st_reputation"))

end )

hook.Add("PlayerSay", "GetReputation", function(ply, txt, t)

	if string.lower(txt) == "--rep" or string.lower(txt) == "--reputation" then
		net.Start("strep_menu")
			net.WriteEntity(ply)
		net.Send(ply)
	end

end)