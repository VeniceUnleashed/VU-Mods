class 'patches'


function patches:__init()
	self:RegisterEvents()
	self.mm = nil
end

function patches:RegisterEvents()
	self.m_ReadInstanceEvent = Events:Subscribe('Partition:ReadInstance', self, self.ReadInstance)
end

function patches:ReadInstance(p_Instance, p_Guid)
	if p_Instance == nil then
		return
	end

	if p_Instance.typeName == "ObjectBlueprint" then
		local s_Instance = ObjectBlueprint(p_Instance)
		if string.match(s_Instance.name:lower(), "invisible") then
			print("[NoCollision] Removed ObjectBlueprint: " .. s_Instance.name)
			s_Instance.object = nil
		end
	end

	if p_Instance.typeName == "StaticModelEntityData" then
		if p_Guid == Guid('8B71D173-8518-11E0-BB7A-DDA550615CAF', 'D') or
			p_Guid == Guid('C2E7889C-9CB2-11E0-A4B6-91A00ABC2528', 'D') or
			p_Guid == Guid('E05D532C-9CB2-11E0-A4B6-91A00ABC2528', 'D') or
			p_Guid == Guid('A75DADEA-BDC6-11E0-A4AD-D5BD8D209D9C', 'D') or
			p_Guid == Guid('743B1FF7-FCBE-41BD-B343-491C9A66BBA5', 'D') or
			p_Guid == Guid('1023699D-F571-4D7B-8CDF-2290541F8BBC', 'D') or
			p_Guid == Guid('D4650FCF-C9A5-11E0-928D-951B45190C6C', 'D') or
			p_Guid == Guid('1034FDAE-C9A4-11E0-928D-951B45190C6C', 'D') or
			p_Guid == Guid('21F3012F-C9A6-11E0-928D-951B45190C6C', 'D') or
			p_Guid == Guid('4B03F97E-C9A6-11E0-928D-951B45190C6C', 'D') or
			p_Guid == Guid('1034FDAE-C9A4-11E0-928D-951B45190C6C', 'D') or
			p_Guid == Guid('5658121F-C9A7-11E0-928D-951B45190C6C', 'D') or
			p_Guid == Guid('3F0FE56F-C9A7-11E0-928D-951B45190C6C', 'D') or
			p_Guid == Guid('25D585AF-C9A7-11E0-928D-951B45190C6C', 'D') then
				local s_Instance = StaticModelEntityData(p_Instance)
				s_Instance.enabled = false
				print("[NoCollision] Disabled StaticModelEntityData invisible wall")
		end
	end
	if p_Instance.typeName == "ObjectBlueprint" then
		if p_Guid == Guid('3677DB58-00FC-49E9-5603-7467A89F63E1', 'D') or
		p_Guid == Guid('91873AB1-6236-1C53-2B58-F03F29E2BC1E', 'D') or
		p_Guid == Guid('C01686D6-3B31-DD1B-ECB6-0CE6C0942972', 'D') or
		p_Guid == Guid('671FB365-43B1-48FD-CB4A-08718A249877', 'D') or
		p_Guid == Guid('557B2795-07D2-43C8-9384-6C89E4B1FE12', 'D') or
		p_Guid == Guid('BDFF4073-CB2F-4284-BA77-F1B494D69912', 'D') or
		p_Guid == Guid('FF4821AE-9684-8E14-F04D-7035F6C9C886', 'D') or
		p_Guid == Guid('3E357E33-A44D-D000-E7B4-D260505B2085', 'D') or
		p_Guid == Guid('E6DD0715-65E7-3B2B-D343-7320BACDAC89', 'D') or
		p_Guid == Guid('AF1D0413-822A-DE3C-7738-EB9D560DA065', 'D') or
		p_Guid == Guid('B2CF3036-7BD3-FEB3-FE40-3416AE7403A4', 'D') or
		p_Guid == Guid('396EABEC-A71A-E52A-0AAE-6341A83EC557', 'D') or
		p_Guid == Guid('3F9B1441-755B-F70E-CB5A-01D5A6A24F8D', 'D') then
			local s_Instance = ObjectBlueprint(p_Instance)
			s_Instance.object = nil
		end
	end

	if p_Guid == Guid('6B89F5E3-EEF5-4CB8-8B2A-740229ECCE84', 'D') then
		local s_Instance = WorldPartData(p_Instance)
		s_Instance:ClearObjects()
	end

	if p_Instance.typeName == "WorldPartData" then
		local s_Instance = WorldPartData(p_Instance)
		if string.match(string.lower(s_Instance.name), "collision") then
			print(tostring("[NoCollision] Removed WorldPartData: " .. s_Instance.name))
			s_Instance:ClearObjects()
		end
		if string.match(string.lower(s_Instance.name), "invisible") then
			print(tostring("[NoCollision] Removed WorldPartData: " .. s_Instance.name))
			s_Instance:ClearObjects()
		end
	end

	if p_Guid == Guid('2870D49F-764A-11E0-9B59-A2F97EE2E494', 'D') then
		local s_Instance = StaticModelEntityData(p_Instance)
		s_Instance.enabled = false
	end

end

g_patches = patches()

return patches