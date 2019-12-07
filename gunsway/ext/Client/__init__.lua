class 'gunswayClient'


function gunswayClient:__init()
	print("Initializing gunswayClient")
	self:RegisterVars()
	self:RegisterEvents()
end


function gunswayClient:RegisterVars()
	local s_OldRecoilDeviation = {pitch = 0, yaw = 0}
end


function gunswayClient:RegisterEvents()
	Events:Subscribe('GunSway:UpdateRecoil', self, self.OnGunSwayUpdateRecoil)
end


function gunswayClient:OnGunSwayUpdateRecoil(p_GunSway, p_DeltaTime)

	local s_LocalPlayer = PlayerManager:GetLocalPlayer()

	if s_LocalPlayer == nil or s_LocalPlayer.soldier == nil or p_GunSway == nil then
		return
	end
		local s_RecoilDeviation = p_GunSway.currentRecoilDeviation

		if s_RecoilDeviation.pitch == 0 and s_RecoilDeviation.yaw == 0 then
			return
		end
		print(tostring(p_DeltaTime) .. " | " .. tostring(p_GunSway ))

		local s_RecoilDeviation = p_GunSway.currentRecoilDeviation
		print("yaw: " .. tostring(s_RecoilDeviation.yaw))
		print("pitch" .. tostring(s_RecoilDeviation.pitch))

	

end


g_gunswayClient = gunswayClient()

