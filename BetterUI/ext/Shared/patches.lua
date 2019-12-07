class 'patches'


function patches:__init()
	self:RegisterEvents()
end

function patches:RegisterEvents()
	self.m_ReadInstanceEvent = Events:Subscribe('Partition:ReadInstance', self, self.ReadInstance)
end

function patches:ReadInstance(p_Instance, p_Guid)

	if p_Instance == nil then
		return
	end
	if p_Guid == Guid('9CDAC6C3-9D3E-48F1-B8D9-737DB28AE936','D') then -- menu
		local s_Instance = ColorCorrectionComponentData(p_Instance)
		s_Instance.enable = false
		s_Instance.brightness = Vec3(1, 1, 1)
		s_Instance.contrast = Vec3(1.2, 1.2, 1.2)
		s_Instance.saturation = Vec3(1, 1, 1)
	end
	if p_Guid == Guid('46FE1C37-5B7E-490C-8239-2EB2D6045D7B','D') then -- oob
		local s_Instance = ColorCorrectionComponentData(p_Instance)
		s_Instance.enable = false
		s_Instance.brightness = Vec3(0.8, 0.8, 0.8)
		s_Instance.contrast = Vec3(1, 1, 1)
		s_Instance.saturation = Vec3(1, 1, 1)
	end

	if p_Instance.typeName == "FilmGrainComponentData" then
		local s_Instance = FilmGrainComponentData(p_Instance)
		s_Instance.enable = false
	end
end

g_patches = patches()

return patches