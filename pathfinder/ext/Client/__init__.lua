class 'pathfinderClient'
local pgps = require('__shared/pgps')


function pathfinderClient:__init()
	print("Initializing pathfinderClient")
	self:RegisterVars()
	self:RegisterEvents()
end


function pathfinderClient:RegisterVars()
	self.castDistance = 200
	self.m_path = nil
	self.m_worldPath = {}
	self.m_From = nil
	self.m_Cleared = {}
end


function pathfinderClient:RegisterEvents()
	Events:Subscribe('Partition:Loaded', self, self.OnPartitionLoaded)
	Events:Subscribe("UI:DrawHud", self, self.OnDrawHud)
    Events:Subscribe('UpdateManager:Update', self, self.OnUpdatePass)
end
function floor(vec)
    return Vec3(math.floor(vec.x), math.floor(vec.y), math.floor(vec.z))
end
function pathfinderClient:OnDrawHud(a,b,c)
	local s_Player = PlayerManager:GetLocalPlayer()
	if s_Player == nil then
		return
	end

	local s_Soldier = s_Player.soldier
	if s_Soldier == nil then
		return
	end

	if(self.m_worldPath ~= nil and #self.m_worldPath > 0) then
		for k, v in pairs(self.m_worldPath) do
			local lastPos = self.m_worldPath[k - 1]
			if(lastPos == nil) then
				lastPos = self.m_worldPath[1]
			end
			DebugRenderer:DrawLine(lastPos, v, Vec4(1,0,0,1), Vec4(0,1,0,1))
			lastPos = v
		end
	end
end

function pathfinderClient:OnUpdatePass(p_Delta, p_Pass)
    if(p_Pass ~= UpdatePass.UpdatePass_PreSim) then
        return
    end
	local s_Player = PlayerManager:GetLocalPlayer()
	if(s_Player == nil) then
		return
	end
	if(s_Player.soldier == nil) then
		return
	end
	if InputManager:WentKeyDown(InputDeviceKeys.IDK_F1) then
		print("akka")
		local s_Transform = ClientUtils:GetCameraTransform()

		local s_CameraForward = Vec3(s_Transform.forward.x * -1, s_Transform.forward.y * -1, s_Transform.forward.z * -1)

		local s_CastPosition = Vec3(s_Transform.trans.x + (s_CameraForward.x*self.castDistance),
									s_Transform.trans.y + (s_CameraForward.y*self.castDistance),
									s_Transform.trans.z + (s_CameraForward.z*self.castDistance))

		local s_Raycast = RaycastManager:Raycast(s_Transform.trans, s_CastPosition, 2)
		if(s_Raycast == nil) then
			print("Raycast failed")
			return
		end
		local transform = LinearTransform()
		transform.trans = s_Raycast.position
		transform.trans.y = transform.trans.y + 1
		self.m_From = transform.trans

		NetEvents:SendLocal('SpawnPlayer', transform)
	end

	if InputManager:WentKeyDown(InputDeviceKeys.IDK_F2) then
		local s_Player = PlayerManager:GetLocalPlayer()
		if(s_Player == nil) then
			print("No player")
			return
		end
		NetEvents:SendLocal('SetTransform', s_Player.soldier.transform)
	end

	if InputManager:WentKeyDown(InputDeviceKeys.IDK_F3) then
		local s_Transform = ClientUtils:GetCameraTransform()

		local s_CameraForward = Vec3(s_Transform.forward.x * -1, s_Transform.forward.y * -1, s_Transform.forward.z * -1)

		local s_CastPosition = Vec3(s_Transform.trans.x + (s_CameraForward.x*self.castDistance),
									s_Transform.trans.y + (s_CameraForward.y*self.castDistance),
									s_Transform.trans.z + (s_CameraForward.z*self.castDistance))

		local s_Raycast = RaycastManager:Raycast(s_Transform.trans, s_CastPosition, 2)
		if(s_Raycast == nil) then
			print("Raycast failed")
			return
		end
		--NetEvents:SendLocal('GoToTransform', transform)
		local transform = LinearTransform()
		transform.trans = s_Raycast.position
		transform.trans.y = transform.trans.y + 1 
		local s_WorldPath = self:CalculatePath(self.m_From, floor(transform.trans))
		if(s_WorldPath ~= nil) then
			NetEvents:SendLocal('FollowPath', s_WorldPath)
		end
		if(s_WorldPath[1] ~= nil) then
			self.m_worldPath = s_WorldPath
		end
	end
end


function round(num, numDecimalPlaces)
  local mult = 10^(numDecimalPlaces or 0)
  return math.floor(num * mult + 0.5) / mult
end

function roundVec(vec, dec)
    return Vec3(round(vec.x, dec), round(vec.y, dec), round(vec.z, dec))
end
function pathfinderClient:CalculatePosition(p_Trans, p_Direction)
	local out = Vec3(p_Trans.x, p_Trans.y, p_Trans.z)
    if(p_Direction == 0) then -- North
        out.z = out.z - 1
        return out
    end
    if(p_Direction == 1) then -- West
        out.x = out.x - 1
        return out
    end
    if(p_Direction == 2) then -- South
        out.z = out.z + 1
        return out
    end
    if(p_Direction == 3) then -- East
        out.x = out.x + 1
        return out
    end
    if(p_Direction == 4) then -- Up
        out.y = out.y + 1
        return out
    end
    if(p_Direction == 5) then -- Down
        out.y = out.y - 1
        return out
    end
end
function pathfinderClient:CanSeeLocation(p_Trans, p_Destination)
	local block, blocktype = pgps:getBlock(roundVec(p_Destination))
	--if(block == nil) then
	local s_Raycast = RaycastManager:Raycast(p_Trans, p_Destination, 4)
	if (s_Raycast ~= nil and (s_Raycast.rigidBody.typeInfo.name ~= "CharacterPhysicsEntity")) then
		print("Failed at: " .. tostring(s_Raycast.position) .. "")
		pgps:setBlock(floor(s_Raycast.position), 1, s_Raycast.rigidBody.typeInfo.name)
	end
	print(p_Destination)
	return s_Raycast == nil
end
function pathfinderClient:ParseAndCombinePath(p_Path)
	local s_LastDirection = -1
	local s_CurrentValue = Vec3()
	local out = {}
	local i = 1
	for _,v in pairs(p_Path) do
		if(v ~= s_LastDirection) then
			i = i + 1
		end
		if(out[i] == nil) then
			out[i] = Vec3()
		end
		out[i] = self:CalculatePosition(out[i], v)
		table.insert(out, s_CurrentValue)
		s_LastDirection = v
	end

	return out
end
function pathfinderClient:CalculatePath(p_Transform, p_Destination, p_CurrentPath, p_WorldMap, p_Try)
	local s_WorldMap = {}
	if(p_WorldMap ~= nil) then
		s_WorldMap = {}
	end
	if(p_Try == nil) then
		p_Try = 0
	end
	if(p_Try > 100) then
		print("Failed to get a path")
		return p_CurrentPath
	end
	if(p_CurrentPath == nil) then
		p_CurrentPath = p_Transform
	end
	print("Calculating path to " .. tostring(p_Destination) .. " | from: " .. tostring(p_CurrentPath))
	local s_Path = self:ParseAndCombinePath(pgps:a_star(roundVec(p_CurrentPath), roundVec(p_Destination)), 0)
	local lastPos = roundVec(p_CurrentPath)
	if(s_Path == false) then 
		return self:CalculatePath(p_Transform, p_Destination, nil, nil, p_Try + 1)
	end

	for k, v in pairs(s_Path) do
		local nextPos = vecplus(lastPos, v)
		if (self:CanSeeLocation(lastPos, nextPos)) then
			table.insert(s_WorldMap, nextPos)
			lastPos = nextPos
		elseif(nextPos:Distance(p_Destination) < 1) then
			print("final?")
		else
			print("Target position: " .. tostring(nextPos))
			return self:CalculatePath(p_Transform, p_Destination, roundVec(lastPos), s_WorldMap, p_Try + 1)
		end
	end
	if(s_WorldMap[#s_WorldMap]:Distance(p_Destination) > 1) then
		print("Final result: " .. tostring(s_WorldMap[#s_WorldMap]))
		print("Retrying...")
		return self:CalculatePath(p_Transform, p_Destination, p_CurrentPath, s_WorldMap, p_Try + 1)
	end
	print("Path calculated")
	self.m_From = p_Destination
	return s_WorldMap
end
function vecplus(a,b)
	return Vec3(a.x + b.x, a.y + b.y, a.z + b.z)
end
function pathfinderClient:OnPartitionLoaded(p_Partition)
	if p_Partition == nil then
		return
	end
end
g_pathfinderClient = pathfinderClient()