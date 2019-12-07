class 'NoRecoilspringClient'


function NoRecoilspringClient:__init()
	print("Initializing NoRecoilspringClient")
	self:RegisterVars()
	self:RegisterEvents()
end


function NoRecoilspringClient:RegisterVars()
	--self.m_this = that
end


function NoRecoilspringClient:RegisterEvents()


	Events:Subscribe('Engine:Update', self, self.OnGunsway)


end



function NoRecoilspringClient:OnGunsway(p_GunSwaya, p_DeltaTime)
    local s_LocalPlayer = PlayerManager:GetLocalPlayer()

	-- We can't send a message if we don't have an active player.
	if s_LocalPlayer == nil then
		return
	end
	local s_Soldier = s_LocalPlayer.soldier
	if(s_Soldier == nil) then
		return
	end

	local s_CurrentWeapon = s_Soldier.weaponsComponent:GetWeapon(s_Soldier.weaponsComponent.currentWeaponIndex)
	if(s_CurrentWeapon.aimingSimulation == nil) then
		print("nil")
	end
	local s_AimingSimulation = s_CurrentWeapon.aimingSimulation
	local s_AimAssist = AimAssist(s_CurrentWeapon.aimingSimulation.aimAssist)
	print("not nil")

	if(s_AimAssist.acceleration) then

	print("not nil1")

		print(s_AimAssist.acceleration)
	end
	print("not nil2")


	-- Crashes
	--print(s_AimAssist.yaw)
	

	-- Does not exist?
	--print("fireShot: " .. p_GunSway.fireShot)
	--print("isFiring: " .. p_GunSway.isFiring)
	--print("isJumping: " .. p_GunSway.isJumping)
	--print("isMoving: " .. p_GunSway.isMoving)
end


g_NoRecoilspringClient = NoRecoilspringClient()

