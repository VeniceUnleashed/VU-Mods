class 'neteventstestClient'


function neteventstestClient:__init()
	print("Initializing neteventstestClient")
	self:RegisterVars()
	self:RegisterEvents()
end


function neteventstestClient:RegisterVars()
	self.m_Id = 0
	self.m_start = false
end


function neteventstestClient:RegisterEvents()
 	Events:Subscribe("Engine:Update", self, self.OnUpdate)

	NetEvents:Subscribe('netevents:start', self, self.OnSetStarted)
	NetEvents:Subscribe('netevents:server', self, self.OnReceive)
end

function neteventstestClient:OnSetStarted(started)
	self.m_start = started
	if(started == false) then
		self.m_Id = 0
	end
end

function neteventstestClient:OnUpdate(p_Delta, p_SimulationDelta)
	if(self.m_start == true) then
		NetEvents:SendLocal('netevents:client', self.m_Id)
		self.m_Id = self.m_Id + 1
	end
end

function neteventstestClient:OnReceive( id )
	if((self.m_Id) ~= id) then 
		print("!!!!!!!!!!!!!!!!!!!! TEST FAILED!")
		print(self.m_Id)
		print(id)
		print("^^^^^^^^^^^^^^^^^^^^")
		self.m_start = false

		NetEvents:SendLocal('netevents:start', false)
		self.m_Id = 0
	end

	self.m_Id = self.m_Id + 1
	print("ok: " .. self.m_Id)
end

g_neteventstestClient = neteventstestClient()