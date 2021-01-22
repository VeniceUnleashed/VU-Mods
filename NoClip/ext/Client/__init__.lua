class 'NoClipClient'


function NoClipClient:__init()
	print("Initializing NoClipClient")
	self:RegisterVars()
	self:RegisterEvents()
end


function NoClipClient:RegisterVars()

	self.m_Enabled = false
	self.m_LastUpdated = 0
end


function NoClipClient:RegisterEvents()
	Events:Subscribe('Client:UpdateInput', self, self.OnUpdate)


	--self.m_EntityCreateEvent = Hooks:Install('ClientEntityFactory:Create', 500, self, self.OnEntityCreate)

end


function NoClipClient:Toggle()
	if self.m_Enabled == false then
		self.m_Enabled = true
		print("Noclip: " .. tostring(self.m_Enabled))
		NetEvents:SendLocal('NoClip:Enable')
	else
		self.m_Enabled = false
		print("Noclip: " .. tostring(self.m_Enabled))
		NetEvents:SendLocal('NoClip:Disable')
	end

end

function NoClipClient:OnUpdate(p_Delta, p_SimulationDelta)
	
	self.m_LastUpdated = self.m_LastUpdated + p_Delta

	local s_NoclipKey = InputManager:WentKeyDown(InputDeviceKeys.IDK_V)


	if s_NoclipKey then
		print("Toggled noclip")
		self:Toggle()
	end


	if self.m_Enabled == false then
		return
	end


	local s_FBMove = 0.0
	local s_LRMove = 0.0

	if InputManager:IsKeyDown(InputDeviceKeys.IDK_W) then
		s_FBMove = 1.0
	elseif InputManager:IsKeyDown(InputDeviceKeys.IDK_S) then
		s_FBMove = -1.0
	end
		
	if InputManager:IsKeyDown(InputDeviceKeys.IDK_A) then
		s_LRMove = 1.0
	elseif InputManager:IsKeyDown(InputDeviceKeys.IDK_D) then
		s_LRMove = -1.0
	end

	self:UpdateVelocity(s_FBMove, s_LRMove)

end



function NoClipClient:UpdateVelocity(p_FBMove, p_LRMove)
	if(self.m_LastUpdated < 0.1) then 
		return
	end
	if p_FBMove == 0 and p_LRMove == 0 then
		return
	end

	local s_Player = PlayerManager:GetLocalPlayer()
	if s_Player == nil then
		return
	end

	local s_Soldier = s_Player.soldier
	if s_Soldier == nil then
		return
	end

	local s_SoldierPhysics = s_Soldier.physicsEntityBase
	if s_SoldierPhysics == nil then
		return
	end

	print("Calcing velocity")

	local s_CameraTransform = ClientUtils:GetCameraTransform()
	
	print("Got camera " .. tostring(s_CameraTransform.forward.x))
	print("p_FBMove" .. tostring(p_FBMove))
	print("p_LRMove" .. tostring(p_LRMove))
	local s_Velocity = s_CameraTransform.forward*p_FBMove

	print("after camera " .. tostring(s_Velocity.x))
	-- calc velocity

	print("Velocity X: " .. tostring(s_Velocity.x) .. " Velocity Y: " .. tostring(s_Velocity.y) .. " Velocity Z: " .. tostring(s_Velocity.z))

	-- client prediction
	--s_SoldierPhysics.linearVelocity = s_Velocity


	NetEvents:SendLocal('NoClip:SetVelocity', s_Velocity)

	self.m_LastUpdated = 0
end


g_NoClipClient = NoClipClient()