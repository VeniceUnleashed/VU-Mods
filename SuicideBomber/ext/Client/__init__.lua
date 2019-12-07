class 'SuicideBomberClient'


function SuicideBomberClient:__init()
	print("Initializing SuicideBomberClient")
	self:RegisterVars()
	self:RegisterEvents()
end


function SuicideBomberClient:RegisterVars()
	--local m_this = that
	self.explosion = nil
	self.effect = nil
	self.sizeMultiplier = 0.5
	self.blueprint = nil
	self.weaponPickup = nil
end


function SuicideBomberClient:RegisterEvents()
	self.m_ReadInstanceEvent = Events:Subscribe('Partition:ReadInstance', self, self.ReadInstance)
	self.m_ClientUpdateInputEvent = Events:Subscribe('Client:UpdateInput', self, self.OnUpdateInput)
	self.m_Whatever = Hooks:Install('ClientEntityFactory:Create', self, self.OnEntityCreate)
end




function SuicideBomberClient:OnEntityCreate(p_Hook, p_Data, p_Transform)
	--ChatManager:SendMessage(string.format('Creating entity type "%s"', p_Data.typeName))
	if p_Data.typeName == "KitPickupEntityData" then
		ChatManager:SendMessage("found a pickup")
		--local kit = KitPickupEntityData(p_Data)
		--local mesh = SkinnedMeshAsset(kit.mesh)
		--ChatManager:SendMessage(mesh.name)
	end
	return p_Hook:CallOriginal(p_Data, p_Transform)
end

function SuicideBomberClient:OnUpdateInput(p_Delta) 
	if InputManager:WentKeyDown(InputDeviceKeys.IDK_F1) then
		local s_Player = PlayerManager:GetLocalPlayer()
		if s_Player == nil then
			return
		end
		
		
		local s_Soldier = s_Player.soldier
		   if s_Soldier == nil then
			return
		end
		ChatManager:SendMessage("Allahuakbar")
		--EntityManager:CreateClientEntity(GrenadeEntityData(self.explosion), soldier.transform)
		--local effect = EntityManager:CreateClientEntity(EffectEntityData(self.effect), s_Soldier.transform)
		--if effect == nil then
		--	ChatManager:SendMessage("Could not activate effect")
		--	return
		--end
		--effect:Init(Realm.Realm_Client, true)
	end

end
function SuicideBomberClient:ReadInstance(p_Instance, p_PartitionGuid, p_Guid)
	if p_Instance == nil then
		return
	end
	
	if p_Guid == Guid("326152E6-0F84-430D-D2E3-19EBDA8266C4", 'D') then --nade
		--local s_Instance = PhysicsEntityData(p_Instance)
		self.explosion = p_Instance
	end

	if p_Guid == Guid('4D5AE774-5017-463E-8C05-6699374FD480', 'D') then
		print("Found smoke")
		self.effect = p_Instance
	end

	if p_Instance.typeName == "RegistryContainer" then
	
	end
end


g_SuicideBomberClient = SuicideBomberClient()

return SuicideBomberClient
