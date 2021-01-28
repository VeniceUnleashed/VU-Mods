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

local s_Multiplier = 1.0

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
	local s_UDMove = 0.0

	local s_MouseWheel = InputManager:GetLevel(InputConceptIdentifiers.ConceptFreeCameraSwitchSpeed)
	if s_MouseWheel == nil then
		print("s_MouseWheel is nil")
		return
	else
		s_Multiplier = math.max(0, s_Multiplier + (s_MouseWheel * 0.1))
	end

	if InputManager:IsKeyDown(InputDeviceKeys.IDK_Q) then
		s_UDMove = 1.0 * s_Multiplier
	elseif InputManager:IsKeyDown(InputDeviceKeys.IDK_E) then
		s_UDMove = -1.0 * s_Multiplier
	end

	if InputManager:IsKeyDown(InputDeviceKeys.IDK_W) then
		s_FBMove = 1.0 * s_Multiplier
	elseif InputManager:IsKeyDown(InputDeviceKeys.IDK_S) then
		s_FBMove = -1.0 * s_Multiplier
	end

	if InputManager:IsKeyDown(InputDeviceKeys.IDK_A) then
		s_LRMove = 1.0 * s_Multiplier
	elseif InputManager:IsKeyDown(InputDeviceKeys.IDK_D) then
		s_LRMove = -1.0 * s_Multiplier
	end
	self:UpdateVelocity(s_FBMove, s_LRMove, s_UDMove)
end

function NoClipClient:UpdateVelocity(p_FBMove, p_LRMove, p_UDMove)
	if(self.m_LastUpdated < 0.01) then
		return
	end
	if p_FBMove == 0 and p_LRMove == 0 and p_UDMove == 0 then
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

	local s_CameraTransform = ClientUtils:GetCameraTransform()
	local s_Velocity = s_CameraTransform.forward*p_FBMove + s_CameraTransform.left*p_LRMove + s_CameraTransform.up*p_UDMove

	s_Player.soldier:SetPosition( s_Player.soldier.physicsEntityBase.position - s_Velocity )
	NetEvents:SendLocal('NoClip:SetVelocity', s_Velocity)
	self.m_LastUpdated = 0
end

g_NoClipClient = NoClipClient()