class 'NoClipServer'

function NoClipServer:__init()
	NetEvents:Subscribe('NoClip:SetVelocity', self, self.UpdateVelocity)
	NetEvents:Subscribe('NoClip:Disable', self, self.TurnOff)
	NetEvents:Subscribe('NoClip:Enable', self, self.TurnOn)


	Events:Subscribe('Player:Respawn', self, self.OnPlayer)
	Events:Subscribe('Player:SpawnOnPlayer', self, self.OnPlayer)
	Events:Subscribe('Player:SpawnAtVehicle', self, self.OnPlayer)

	Events:Subscribe('Player:Deleted', self, self.OnPlayerDeleted)
	Events:Subscribe('Player:Destroyed', self, self.OnPlayerDeleted)

	self.m_EnabledPlayers = {}

end

function NoClipServer:HasSoldier(p_Player)
	if p_Player == nil then
		return false
	end

	if p_Player.soldier == nil then
		return false
	end

	return true
end

function NoClipServer:TurnOff(p_Player)
	
	if p_Player == nil then
		return
	end

	self.m_EnabledPlayers[p_Player.onlineId] = false

	if self:HasSoldier(p_Player) then
		p_Player.soldier:FireEvent("EnableCollision")
	end

end	

function NoClipServer:TurnOn(p_Player)

	if p_Player == nil then
		return
	end

	self.m_EnabledPlayers[p_Player.onlineId] = true

	if self:HasSoldier(p_Player) then
		p_Player.soldier:FireEvent("DisableCollision")
	end
end	


function NoClipServer:UpdateVelocity(p_Player, p_Velocity)
	if self:HasSoldier(p_Player) then


		local s_SoldierPhysics = p_Player.soldier.physicsEntityBase

		if s_SoldierPhysics == nil then
			return
		end


		s_SoldierPhysics.linearVelocty = p_Velocity
		--p_Player.soldier:SetPosition(p_Transform)
	else 
		print("Tried to teleport a player that\'s not alive: " .. p_Player)
	end
end

function NoClipServer:OnPlayerDeleted(p_Player)

	print("OnlineId: " .. tostring(p_Player.onlineId))
	self.m_EnabledPlayers[p_Player.onlineId] = false
end

function NoClipServer:OnPlayer(p_Player)
	print("OnlineId: " .. tostring(p_Player.onlineId))
	self.m_EnabledPlayers[p_Player.onlineId] = false
end

g_NoClipServer = NoClipServer()