class 'carrierClient'


function carrierClient:__init()
	print("Initializing carrierClient")
	self:RegisterVars()
	self:RegisterEvents()
end


function carrierClient:RegisterVars()
	self.m_Carrier = nil
	self.m_SpawnedCarrier = nil
end


function carrierClient:RegisterEvents()
    Events:Subscribe('Client:UpdateInput', self, self.OnUpdateInput)
end

function carrierClient:OnUpdateInput(p_Delta, p_SimulationDelta)

	if InputManager:WentKeyDown(InputDeviceKeys.IDK_F1) then
		self:SpawnCarrier()
	end

end


function carrierClient:SpawnCarrier()
	local s_LocalPlayer = PlayerManager:GetLocalPlayer()
	if(s_LocalPlayer.soldier == nil ) then
		return
	end

	if(self.m_Carrier == nil) then
		self.m_Carrier = SpatialPrefabBlueprint( ResourceManager:FindInstanceByGUID(Guid('23D6044F-C7E9-11E0-8EED-DBDC27CFCAAA'), Guid('7AF2BC91-94C6-39C2-E135-5AE14A677F30')):Clone())
		self.m_Carrier.propertyConnections:clear()
		self.m_Carrier.linkConnections:clear()

	end

	local params = EntityCreationParams()
	params.transform = s_LocalPlayer.soldier.transform
	params.variationNameHash = 0

	self.m_SpawnedCarrier = EntityManager:CreateEntitiesFromBlueprint(self.m_Carrier, params)
	for i, entity in pairs(self.m_SpawnedCarrier) do
		entity:Init(Realm.Realm_Client, true)
		entity:FireEvent("Start")
	end

end
g_carrierClient = carrierClient()

