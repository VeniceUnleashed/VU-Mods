class 'pathfinderServer'
local pgps = require('__shared/pgps')
local SoldierBlueprintPartitionGuid = Guid("f256e142-c9d8-4bfe-985b-3960b9e9d189","D")
local SoldierBlueprintInstanceGuid = Guid("261e43bf-259b-41d2-bf3b-9ae4dda96ad2","D")
local RUReconPartitionGuid = Guid("ce67cb9d-5f04-4428-b8e4-b10c5b7f4e6c","D")
local RUReconInstanceGuid = Guid("84a4be20-b110-42e5-9588-365643624525","D")
local RUReconDrPepperCamoPartitionGuid = Guid("b06e6037-4797-47a5-8917-2772ec79b3c5","D")
local RUReconDrPepperCamoInstanceGuid = Guid("2c86f862-3fee-4231-804d-bbb769e7a78b","D")

local AEKPartitonGuid = Guid("44549092-2956-11E0-9658-B1395B1E88C3", "D")
local AEKInstanceGuid = Guid("5E2D49D1-D1BB-F553-78A5-8D537C43E624", "D")


local North, West, South, East, Up, Down = 0, 1, 2, 3, 4, 5


function pathfinderServer:__init()
    print("Initializing pathfinderServer")
    self:RegisterVars()
    self:RegisterEvents()
end


function pathfinderServer:RegisterVars()
    self.m_LatestSoldier = nil
    self.m_path = nil
    self.m_step = 1

    self.m_caller = nil

    self.m_timer = 0
end


function pathfinderServer:RegisterEvents()
    NetEvents:Subscribe('SpawnPlayer', self, self.SpawnPlayer)
    NetEvents:Subscribe('SetTransform', self, self.SetTransform)
    NetEvents:Subscribe('FollowPath', self, self.FollowPath)
    Events:Subscribe('UpdateManager:Update', self, self.OnUpdatePass)
end

function pathfinderServer:CalculatePosition(p_Trans, p_Direction)
    if(p_Direction == 0) then -- North
        p_Trans.z = p_Trans.z - 1
        return p_Trans
    end
    if(p_Direction == 1) then -- West
        p_Trans.x = p_Trans.x - 1
        return p_Trans
    end
    if(p_Direction == 2) then -- South
        p_Trans.z = p_Trans.z + 1
        return p_Trans
    end
    if(p_Direction == 3) then -- East
        p_Trans.x = p_Trans.x + 1
        return p_Trans
    end
    if(p_Direction == 4) then -- Up
        p_Trans.y = p_Trans.y + 1
        return p_Trans
    end
    if(p_Direction == 5) then -- Down
        p_Trans.y = p_Trans.y - 1
        return p_Trans
    end
    print("trans: " .. tostring(p_Transform))
    print("dir: " .. p_Direction)

end


function pathfinderServer:RecalculatePath()
    self.m_path = pgps:a_star(0,0,0,10,10,10,0)
    self.m_step = 1
end
function floor(vec)
    return Vec3(math.floor(vec.x), math.floor(vec.y), math.floor(vec.z))
end
function round(num, numDecimalPlaces)
  local mult = 10^(numDecimalPlaces or 0)
  return math.floor(num * mult + 0.5) / mult
end

function roundVec(vec, dec)
    return Vec3(round(vec.x, dec), round(vec.y, dec), round(vec.z, dec))
end
function pathfinderServer:CalculateAndMove(p_Delta)
    if ( self.m_step > #self.m_path ) then
        self.m_path = nil
        self.m_step = 1
        print("Arrived at destination?")
        return
    end
    local s_TargetPosition = self.m_path[self.m_step]
    if(s_TargetPosition == nil) then
        print("Failed to generate position for some reason?")
        print(self.m_step)
        return
    end


    self.m_LatestSoldier:SetPosition(lerpVec3(self.m_LastPosition, s_TargetPosition, self.m_timer))

    if(roundVec(self.m_LatestSoldier.transform.trans, 0) == floor(s_TargetPosition)) then
        self.m_step = self.m_step + 1
        self.m_LastPosition = floor(s_TargetPosition)
        self.m_timer = 0
    end
    self.m_timer = self.m_timer + p_Delta
end
function lerpVec3(a, b, t)
    local from = a
    local to = b
    from.x = lerp(from.x, to.x, t)
    from.y = lerp(from.y, to.y, t)
    from.z = lerp(from.z, to.z, t)
    return from
end 

function lerp(a, b, t)
    return a + (b - a) * t
end

function pathfinderServer:OnUpdatePass(p_Delta, p_Pass)
    if(p_Pass ~= UpdatePass.UpdatePass_PreSim) then
        return
    end
    if(self.m_LatestSoldier == nil) then
        return
    end
    if(self.m_path ~= nil) then
        if(self.m_LatestSoldier == nil) then
            return
        end
        self:CalculateAndMove(p_Delta)
    end
end
function pathfinderServer:CheckPath(path)
    
end
-- Commands
function pathfinderServer:FollowPath(p_Player, p_Path, p_Destination)
    print("Calculating path:" .. tostring(p_Path))
    if(p_Path.x ~= nil) then
        return
    end
    self.m_path = p_Path
    self.m_LastPosition = p_Path[1]
    print(self.m_path)
    self.m_step = 1
end

function pathfinderServer:SetTransform(p_Player, p_Transform)
    if(self.m_LatestSoldier == nil) then
        print("No soldier")
        return
    end
    if(self.m_LatestSoldier:Is("PhysicsEntityBase")) then
        print("Physics!")
    end
    self.m_LatestSoldier:SetPosition(p_Transform.trans)
    print("Set transform")
end

function pathfinderServer:SpawnPlayer(p_Player, p_Transform)
    local team = 2
    local player = PlayerManager:CreatePlayer("Bot", team, SquadId.SquadNone)
    if(player == nil) then
        print("Failed to create player")
    end
    local soldierBlueprint = ResourceManager:FindInstanceByGUID(SoldierBlueprintPartitionGuid, SoldierBlueprintInstanceGuid)

    if soldierBlueprint == nil then
        print('Couldnt find soldierBlueprint')
        return
    end
    local weaponInstance = ResourceManager:FindInstanceByGUID(AEKPartitonGuid, AEKInstanceGuid)
    if(weaponInstance == nil) then
        print('Failed to find weapon instance')
        return
    end
    local kitInstance = ResourceManager:FindInstanceByGUID(RUReconPartitionGuid, RUReconInstanceGuid)
    if(kitInstance == nil) then
        print('Failed to find kit instance')
        return
    end
    local camoInstance = ResourceManager:FindInstanceByGUID(RUReconDrPepperCamoPartitionGuid, RUReconDrPepperCamoInstanceGuid)
    if(camoInstance == nil) then
        print('Failed to find kit instance')
        return
    end
    player:SelectWeapon( WeaponSlot.WeaponSlot_0, weaponInstance, {weaponInstance})
    player:SelectUnlockAssets( kitInstance, {camoInstance})
    local soldier = player:CreateSoldier( soldierBlueprint, p_Transform)
    if(soldier == nil) then
        print('Failed to create soldier')
    end
    print("Spawning Soldier")
    player:SpawnSoldierAt( soldier, p_Transform, CharacterPoseType.CharacterPoseType_Stand)
    print(soldier)
    self.m_LatestSoldier = soldier
end


g_pathfinderServer = pathfinderServer()