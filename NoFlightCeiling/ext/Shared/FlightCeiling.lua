class 'FlightCeiling'

function FlightCeiling:__init()
	self.m_FXGuid = Guid('AC4C1198-CB9A-4F84-A74F-F3EB724A5DBB', 'D')
	self.m_VERainGuid = Guid('5E4510C1-94BE-4D47-9825-6EB768C60C1B', 'D')
	self.m_WindGuid = Guid('20C10935-801E-45F2-865F-8A17CA96986C', 'D')
	self.m_CollisionRoof = Guid('6F4359EB-7749-4FD1-B827-C5457E5DE0C6', 'D')
end

function FlightCeiling:OnLoaded()
	
end

function FlightCeiling:OnReadInstance(p_Instance, p_Guid)
	print("fack")
	if p_Instance == nil then
		return 
	end

	if p_Instance.entityName ~= 'LevelData' then
		local s_LevelData = p_Instance;
		print("Found leveldata entityName")

		print(s_LevelData.levelreference)
		print(s_LevelData.maxvehicleheight)
	end

	if p_Instance.typeName ~= 'LevelData' then
		local s_LevelDatatypeName = p_Instance;
		print("Found typeName entityName")
		print(s_LevelDatatypeName.maxVehicleHeight)
	end
end

return FlightCeiling