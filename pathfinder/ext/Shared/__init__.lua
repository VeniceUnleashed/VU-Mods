class 'pathfinderShared'


function pathfinderShared:__init()
	print("Initializing pathfinderShared")
	self:RegisterVars()
	self:RegisterEvents()
end


function pathfinderShared:RegisterVars()
	--self.m_this = that
end


function pathfinderShared:RegisterEvents()
end


g_pathfinderShared = pathfinderShared()

