class "kAdminServer"

function kAdminServer:__init()
	self.m_ChatEvent = Events:Subscribe("Player:Chat", self, self.OnChat)
	self.m_UpdateEvent = Events:Subscribe("Engine:Update", self, self.OnUpdate)
	
	self.m_Commands = {
		["!voteban"] = self.OnVoteBan,
		["!votekick"] = self.OnVoteKick,
		["!y"] = self.OnYes,
		["!n"] = self.OnNo,
		["!yes"] = self.OnYes,
		["!no"] = self.OnNo,
		["!cancel"] = self.OnCancel,
		["!tp"] = self.OnTp,
	}
	
	self.m_MaxTime = 30.0 -- max call a vote for for 30s
	self.m_CurrentTime = 0.0
	self.m_IsVoteCalled = false
	
	self.m_VoteType = "none" -- "kick" "ban"
	self.m_CalledByPlayer = nil
	self.m_PlayerCalledOn = nil
	
	self.m_PlayersYes = {}
	self.m_PlayersNo = {}
	-- Forget about the players who don't vote
end

function kAdminServer:OnChat(p_Player, p_Mask, p_Message)
	--print("[kBot] " .. p_Player.name .. ": " .. p_Message)
	if p_Player == nil then
		return
	end


	
	local s_Commands = split(p_Message, " ")
	
	local s_Command = s_Commands[1]
	if s_Command == nil then
		return
	end
	
	s_Function = self.m_Commands[s_Command]
	if s_Function == nil then
		return
	end
	self.m_CalledByPlayer = p_Player
	s_Function(self, p_Player, p_Mask, p_Message, s_Commands)
end

function kAdminServer:OnUpdate(p_Delta, p_SimulationDelta)
	if self.m_IsVoteCalled == false then
		self.m_CurrentTime = 0.0
		return
	end
	
	-- Check to see if we reached our max time
	if self.m_CurrentTime >= self.m_MaxTime then
		
		self:OnFinalResults()
		
		self.m_IsVoteCalled = false
		self.m_CurrentTime = 0.0
		
		ServerChatManager:SendMessage("[kAdmin] Vote Expired")
		print("Vote Expired")
		return
	end
	
	-- Increment our delta
	self.m_CurrentTime = self.m_CurrentTime + p_Delta
	
	
end

function kAdminServer:OnFinalResults()
	local s_YesCount = table.getn(self.m_PlayersYes)
	local s_NoCount = table.getn(self.m_PlayersNo)
	local s_PlayerCount = PlayerManager:GetPlayerCount()
	
	-- If our player count is zero, how in the heck did this get called?
	if s_PlayerCount == 0 then
		return
	end
	
	local s_Percentage = s_YesCount / s_PlayerCount
	if s_Percentage >= 0.5 then
		print("[kAdmin] Vote passed.")
		if self.m_VoteType == "kick" then
			self.m_PlayerCalledOn:kick()
		end
		
		if self.m_VoteType == "ban" then
			self.m_PlayerCalledOn:ban()
		end
		
		ServerChatManager:SendMessage("[kAdmin] Vote Passed!")
	else
		print("[kAdmin] Vote failed.")
		ServerChatManager:SendMessage("[kAdmin] Vote Failed!")
	end
	
	self.m_CalledByPlayer = nil
	self.m_PlayerCalledOn = nil
	self.m_IsVoteCalled = false
	self.m_VoteType = "none"
	self.m_PlayersYes = {}
	self.m_PlayersNo = {}
	print("[kAdmin] Vote reset.")
end

-- !voteban <partial player name>
function kAdminServer:OnVoteBan(p_Player, p_Mask, p_Message, p_Commands)
	print("OnVoteBan called")
	
	-- If a vote is already in progress don't do anything
	if self.m_IsVoteCalled == true then
		return
	end
	
	-- Set that there is a vote in progress
	self.m_IsVoteCalled = true
	
	if table.getn(p_Commands) < 2 then
		return
	end
	
	local s_PlayerSearchString = p_Commands[2]
	print("PlayerSearch:" .. s_PlayerSearchString)
	
	local s_Players = PlayerManager:GetPlayers()
	for s_Index, s_Player in pairs(s_Players) do
		print("Searching:" .. s_Player.name)
		
		if string.match(s_Player.name, s_PlayerSearchString) then
			self.m_CalledByPlayer = p_Player
			self.m_PlayerCalledOn = s_Player
			break
		end
	end
	
	if self.m_PlayerCalledOn == nil then
		self.m_IsVoteCalled = false
		print("PlayerCalledOn is invalid.")
		return
	end
	
	if self.m_CalledByPlayer == nil then
		self.m_IsVoteCalled = false
		print("CalledByPlayer is invalid.")
		return
	end
	
	if self.m_PlayerCalledOn.name == self.m_CalledByPlayer.name then
		print("Dumbass " .. self.m_PlayerCalledOn.name .. " tried to call a vote on him/her/itself.")
		self.m_CalledByPlayer = nil
		self.m_PlayerCalledOn = nil
		self.m_IsVoteCalled = false
		-- TODO: Send message back to player saying they are a dumbass
		return
	end
	
	self.m_VoteType = "ban"
	
	self:EchoVote()
end

function kAdminServer:OnVoteKick(p_Player, p_Mask, p_Message, p_Commands)
	print("OnVoteKick called")
	
	-- If a vote is already in progress don't do anything
	if self.m_IsVoteCalled == true then
		return
	end
	
	-- Set that there is a vote in progress
	self.m_IsVoteCalled = true
	
	local s_PlayerSearchString = p_Commands[2]
	print("PlayerSearch:" .. s_PlayerSearchString)
	
	local s_Players = PlayerManager:GetPlayers()
	for s_Index, s_Player in pairs(s_Players) do
		print("Searching:" .. s_Player.name)
		
		if string.match(s_Player.name, s_PlayerSearchString) then
			self.m_CalledByPlayer = p_Player
			self.m_PlayerCalledOn = s_Player
			break
		end
	end
	
	if self.m_PlayerCalledOn == nil then
		self.m_IsVoteCalled = false
		print("PlayerCalledOn is invalid.")
		return
	end
	
	if self.m_CalledByPlayer == nil then
		self.m_IsVoteCalled = false
		print("CalledByPlayer is invalid.")
		return
	end
	
	
	
	self.m_VoteType = "kick"
	
	self:EchoVote()
end


function kAdminServer:FindPlayer(p_Player) 
	local s_Players = PlayerManager:GetPlayers()
	local ret = nil
	for s_Index, s_Player in pairs(s_Players) do
		print(tostring(s_Player.name))
		if string.match(string.lower(s_Player.name), string.lower(p_Player)) then
			ret = s_Player
			print(s_Player.name)
			return ret
		end
	end
end

function kAdminServer:OnTp(p_Player, p_Mask, p_Message, p_Commands)
	print("Tp called")

	local s_Target = nil
	local s_Destination = nil
	local s_T = nil
	local s_D = nil
	local s_Transform = nil
	local pos = nil
	local rot = nil

	local s_t_s = false
	local s_d_s = false

	local s_Players = PlayerManager:GetPlayers()

	if p_Commands[3] ~= nil then
		s_Destination = p_Commands[3]
	else 
		s_Destination = self.m_CalledByPlayer
	end
	print("Tp called2")
	if p_Commands[2] ~= nil then
		s_Target = p_Commands[2]
	else 
		s_Target = self.m_CalledByPlayer
	end


print("Tp called3")

	if s_Destination == "@me" then
		s_D = self.m_CalledByPlayer
	elseif s_Destination == nil then
		return
	else
		s_D = kAdminServer:FindPlayer(s_Destination)
	end
	if(s_D == nil) then
		return
	end
	print("Tp called4")
	if s_D.hasSoldier then 
		local s_Transform = s_D.soldier.transform
		pos = Vec3(s_Transform.trans.x, s_Transform.trans.y, s_Transform.trans.z)
		print(pos.x .. " |" .. pos.y .. " | " .. pos.z)
	else 
		return
	end

	if s_Target == "@me" then
		s_T = self.m_CalledByPlayer
	elseif s_Target == "@all" then
		for s_Index, s_Player in pairs(s_Players) do

			if s_Player.hasSoldier then
				print("kok")
				s_Player.soldier:SetPosition(pos)
			end

		end
	else 
		s_T = kAdminServer:FindPlayer(s_Target)
		if s_T.hasSoldier then
			print("kik")
			local soldier = s_T.soldier
			soldier:SetPosition(pos)
		end
	end
end

function kAdminServer:EchoVote()
	if self.m_CalledByPlayer == nil then
		return
	end
	
	if self.m_PlayerCalledOn == nil then
		return
	end
	
	print("[kAdmin] Player " .. self.m_CalledByPlayer.name .. " called a vote to kick on " .. self.m_PlayerCalledOn.name)
	ServerChatManager:SendMessage("[kAdmin] Vote to " .. self.m_VoteType .. " " .. self.m_PlayerCalledOn.name .. " has started! Vote Yes with !y or !yes and No with !n or !no or cancel with !cancel.")
end

function kAdminServer:OnYes(p_Player, p_Mask, p_Message, p_Commands)
	local s_PlayerName = p_Player.name
	
	-- Don't allow a player to vote more than once
	for i, v in ipairs(self.m_PlayersYes) do
		if string.match(v.name, s_PlayerName) then
			return
		end
	end
	
	-- If players want to switch their vote remove them from the Yes Vote
	for i, v in ipairs(self.m_PlayersNo) do
		if string:match(v.name, s_PlayerName) then
			self.m_PlayersNo:remove(i)
			break
		end
	end
	
	table.insert(self.m_PlayersYes, p_Player)
end

function kAdminServer:OnNo(p_Player, p_Mask, p_Message, p_Commands)
	local s_PlayerName = p_Player.name
	
	-- Don't allow a player to vote more than once
	for i, v in ipairs(self.m_PlayersNo) do
		if string.match(v.name, s_PlayerName) then
			return
		end
	end
	
	-- If players want to switch their vote remove them from the Yes Vote
	for i, v in ipairs(self.m_PlayersYes) do
		if string.match(v.name, s_PlayerName) then
			self.m_PlayersYes:remove(i)
			break
		end
	end
	
	table.insert(self.m_PlayersNo, p_Player)
end

function kAdminServer:OnCancel(p_Player, p_Mask, p_Message, p_Commands)
	if p_Player == nil then
		return
	end
	
	if self.m_CalledByPlayer == nil then
		return
	end
	
	if self.m_IsVoteCalled == false then
		return
	end
	
	if string.match(p_Player.name, self.m_CalledByPlayer.name) then
		self.m_CalledByPlayer = nil
		self.m_PlayerCalledOn = nil
		self.m_IsVoteCalled = false
		self.m_VoteType = "none"
		ServerChatManager:SendMessage("[kAdmin] Vote cancelled!")
	end
end
-- Copy pasta'd from http://www.computercraft.info/forums2/index.php?/topic/930-lua-string-split/page__p__93664#entry93664
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

local g_AdminServer = kAdminServer()