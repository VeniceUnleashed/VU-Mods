Events:Subscribe('UpdateManager:Update', function(p_Delta, p_Pass) 
	local s_Player = PlayerManager:GetLocalPlayer()
	if(s_Player == nil) then
		return
	end
	s_Player.ragdollComponent

end)