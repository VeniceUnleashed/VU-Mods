class 'MetroModShared'


function MetroModShared:__init()
	print("Initializing MetroModShared")
	self:RegisterVars()
	self:RegisterEvents()
end


function MetroModShared:RegisterVars()
	self.m_RegistryGUID = Guid('F98F36A2-3A59-A7E0-ABC5-240CB4C88307', 'D')
	
	self.m_MeshDatabaseGUID1 = Guid('370966A0-317F-3890-507A-1DD504BCDFF8', 'D')
	self.m_MVD1 = nil
	self.m_MeshDatabaseGUID2 = Guid('3A7617AB-5D31-1CD1-5C0C-1ADBB565B81F')
	self.m_MVD2 = nil

	self.m_WorldPartDataGUID = Guid('7C59DE20-3ADA-4F52-95B1-9CC0D8214984', 'D')
	
	self.m_LevelDataGUID = Guid('56A884A6-0451-F6B3-D1F1-40BBB4E2CD92', 'D')

	self.m_Enable = false
	
	self.lav25g0 = Guid('0AA2C0B7-6B2C-76F5-B7CE-50276A615E3A', 'D')
	self.lav25i0 = nil
	self.lav25g1 = Guid('2108D7BF-0820-4F57-967F-B952D4AC8BCB', 'D')
	self.lav25i1 = nil
	self.lav25g2 = Guid('ADF563C9-28B1-C42B-993E-B2FD40F36078', 'D')
	self.lav25i2 = nil
	self.lav25g3 = Guid('5C58DA9D-F492-40A6-B7C4-B513D90E4733', 'D')
	self.lav25i3 = nil
	self.lav25g4 = Guid('7FBD2EE5-7E3F-4CA0-0263-A258A0924834', 'D')
	self.lav25i4 = nil
	self.lav25g5 = Guid('A4EA9BD4-D228-11DF-B6A2-F818A1A10C85', 'D')
	self.lav25i5 = nil
	
	self.lav25g6 = Guid('0AA2C0B7-6B2C-76F5-B7CE-50276A615E3A', 'D')
	self.lav25i6 = nil
	
	
	self.dirtbike0 = Guid('33960E31-BB2A-4CAD-80B9-FBDA32E36745', 'D')
	self.dirtbikei0 = nil
	self.dirtbike1 = Guid('7CAE2DB9-FE40-4F7A-937D-4617CD9CC0E8', 'D')
	self.dirtbikei1 = nil
	self.dirtbike2 = Guid('399323F8-87EB-11E1-AF32-BE54FEE25012', 'D')
	self.dirtbikei2 = nil
	self.dirtbike3 = Guid('CE069226-E864-2B46-F269-97F0486ADFF5', 'D')
	self.dirtbikei3 = nil
	self.dirtbike4 = Guid('A401FE88-C8AE-43D1-BD60-13F9464060B6', 'D')
	self.dirtbikei4 = nil

	self.replaced = false
end


function MetroModShared:RegisterEvents()
	self.m_PartitionLoadedEvent = Events:Subscribe('Partition:Loaded', self, self.OnPartitionLoaded)
	Events:Subscribe('Level:LoadResources', self, self.OnLoadResources)
	--Hooks:Install('ResourceManager:LoadBundles', 100, self, self.OnLoadBundles)
end

function MetroModShared:OnLoadResources( dedicated )
	ResourceManager:MountSuperBundle('Xp5Chunks')
	ResourceManager:MountSuperBundle('Levels/XP5_004/XP5_004')

end

function MetroModShared:OnLoadBundles( hook, bundles, compartment )
    if #bundles == 1 and IsPrimaryLevel(bundles[1]) then
        bundles = {
            'levels/xp5_004/xp5_004',
            'levels/xp5_004/rush',
            "levels/xp5_004/xp5_004_uiendofround",
			"levels/xp5_004/xp5_004_uiloadingmp",
			"levels/xp5_004/xp5_004_uiloadingsp",
			"levels/xp5_004/xp5_004_uiplaying",
            bundles[1]
        }
        print(bundles)
        hook:Pass(bundles, compartment)
    end
end

function MetroModShared:OnPartitionLoaded(p_Partition)
	if p_Partition == nil then
		return
	end
	
	local s_Instances = p_Partition.instances


	for _, p_Instance in ipairs(s_Instances) do
		local p_GUID = p_Instance.instanceGuid

		
		--[[ if p_GUID == self.m_LevelDataGUID then
			local s_Instance = LevelData(p_Instance)
			s_Instance.maxVehicleHeight = 1337.0
		end ]]
		if p_GUID == Guid('B3824BD6-C797-8EA5-D33D-A366C05CACA5') then
			print("MVD")
		end
		if p_GUID == self.lav25g0 then print('a0') self.lav25i0 = p_Instance end
		if p_GUID == self.lav25g1 then print('a1') self.lav25i1 = p_Instance end
		if p_GUID == self.lav25g2 then print('a2') self.lav25i2 = p_Instance end
		if p_GUID == self.lav25g3 then print('a3') self.lav25i3 = p_Instance end
		if p_GUID == self.lav25g4 then print('a4') self.lav25i4 = p_Instance end
		if p_GUID == self.lav25g5 then print('a5') self.lav25i5 = p_Instance end
		
		if p_GUID == self.dirtbike0 then print('0') self.dirtbikei0 = p_Instance end
		if p_GUID == self.dirtbike1 then print('1') self.dirtbikei1 = p_Instance end
		if p_GUID == self.dirtbike2 then print('2') self.dirtbikei2 = p_Instance end
		if p_GUID == self.dirtbike3 then print('3') self.dirtbikei3 = p_Instance end
		if p_GUID == self.dirtbike4 then print('4') self.dirtbikei4 = p_Instance end

		--[[
		if p_GUID == self.m_MeshDatabaseGUID2 then
			print('MVD2')
			self.m_MVD2 = p_Instance 
		end
		if p_GUID == self.m_MeshDatabaseGUID1 then
			print('MVD1')
			local s_MVD = MeshVariationDatabase(p_Instance:Clone(p_Instance.instanceGuid))
			local s_xpMVD = MeshVariationDatabase(p_Instance)
			for k,v in ipairs(s_xpMVD.entries)  do
				s_MVD.entries:add(MeshVariationDatabaseEntry(v))
			end

			p_Partition:ReplaceInstance(p_Instance, s_MVD, true)
		end
]]
		if p_GUID == self.m_RegistryGUID then
			print("cloning")
			if(self.replaced == false) then
				self.replaced = true

				local s_Instance = RegistryContainer(p_Instance:Clone(p_Instance.instanceGuid))

				print('Adding instances to registry!')
				
				s_Instance.entityRegistry:add(self.lav25i0)
				s_Instance.entityRegistry:add(self.lav25i3)
				s_Instance.entityRegistry:add(self.lav25i5)

				s_Instance.blueprintRegistry:add(self.lav25i2)
				s_Instance.blueprintRegistry:add(self.lav25i4)

				s_Instance.referenceObjectRegistry:add(self.lav25i1)

				s_Instance.entityRegistry:add(self.dirtbikei0)
				s_Instance.entityRegistry:add(self.dirtbikei1)
				s_Instance.entityRegistry:add(self.dirtbikei2)

				s_Instance.blueprintRegistry:add(self.dirtbikei3)
				s_Instance.blueprintRegistry:add(self.dirtbikei4) --[[ ]]
				
				p_Partition:ReplaceInstance(p_Instance, s_Instance, true)
			end
		end

	end
end
function IsPrimaryLevel( p_Bundle )
	local s_Path = split(p_Bundle, "/")
	if s_Path[2] == s_Path[3] then
		return true
	end

	return false
end

function split(pString, pPattern)
   local Table = {}  -- NOTE: use {n = 0} in Lua-5.0
   local fpat = "(.-)" .. pPattern
   local last_end = 1
   local s, e, cap = pString:find(fpat, 1)
   while s do
	  if s ~= 1 or cap ~= "" then
	 table.insert(Table,cap)
	  end
	  last_end = e+1
	  s, e, cap = pString:find(fpat, last_end)
   end
   if last_end <= #pString then
	  cap = pString:sub(last_end)
	  table.insert(Table, cap)
   end
   return Table
end
function dump(o)
	if(o == nil) then
		print("tried to load jack shit")
	end
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. dump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end


g_MetroModShared = MetroModShared()

