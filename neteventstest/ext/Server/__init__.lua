class 'neteventstestServer'


function neteventstestServer:__init()
	print("Initializing neteventstestServer")
	self:RegisterVars()
	self:RegisterEvents()
end


function neteventstestServer:RegisterVars()
	self.m_Id = 0
	self.m_start = false
end


function neteventstestServer:RegisterEvents()
 	Events:Subscribe('Player:Chat', self, self.OnChat)
	NetEvents:Subscribe('netevents:client', self, self.OnReceive)
	self.m_EngineUpdateEvent = Events:Subscribe('UpdateManager:Update', self, self.OnUpdatePass)
	NetEvents:Subscribe('netevents:start', self, self.OnSetStarted)
end


function neteventstestServer:OnSetStarted(started)
	self.m_start = started
	if(started == false) then
		self.m_Id = 0
	end
end

function neteventstestServer:OnChat(  )
	self.m_start = true
	--NetEvents:BroadcastLocal('netevents:start', true)
end

function neteventstestServer:OnReceive( p_Player, id )
	if((self.m_Id) ~= id) then 
		print("!!!!!!!!!!!!!!!!!!!! TEST FAILED!")
		print(self.m_Id)
		print(id)
		print("^^^^^^^^^^^^^^^^^^^^")
		self.m_start = false

		NetEvents:BroadcastLocal('netevents:start', false)
		self.m_Id = 0
	end

	self.m_Id = self.m_Id + 1
	print("ok: " .. self.m_Id)
end

function neteventstestServer:OnUpdatePass(p_Delta, p_Pass)

	if(self.m_start == true) then
		NetEvents:BroadcastLocal('netevents:server', self.m_Id)
		self.m_Id = self.m_Id + 1
	end
end
g_neteventstestServer = neteventstestServer()

