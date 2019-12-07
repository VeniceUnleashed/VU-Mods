class 'inputrestrictionClient'


function inputrestrictionClient:__init()
	print("Initializing inputrestrictionClient")
	self:RegisterVars()
	self:RegisterEvents()
end


function inputrestrictionClient:RegisterVars()
	self.m_InputRestriction = nil
end


function inputrestrictionClient:RegisterEvents()
	self.m_PartitionLoadedEvent = Events:Subscribe('Partition:Loaded', self, self.OnPartitionLoaded)
	self.m_OnUpdateInputEvent = Events:Subscribe('Client:UpdateInput', self, self.OnUpdateInput)
end

function inputrestrictionClient:OnUpdateInput(p_Delta)

	if InputManager:WentKeyDown(InputDeviceKeys.IDK_F) then
		local instance = InputRestrictionEntityData()
		instance.enabled = true

		self.m_InputRestriction = EntityManager:CreateClientEntity( instance, LinearTransform() )

		print("so far so good")

		if ( self.m_InputRestriction == nil ) then
			print("Could not spawn decal")
			return
		end
		
		self.m_InputRestriction:Init(Realm.Realm_Client, true)

		self.m_InputRestriction:FireEvent("Activate")
	end

	if InputManager:WentKeyDown(InputDeviceKeys.IDK_C) then
		--WebUI:BringToFront()
		WebUI:DisableMouse()
		-- WebUI:Hide()
		Freecam:Disable();
		self.isFreecam = false;
	end

	if InputManager:WentKeyDown(InputDeviceKeys.IDK_F3) then

	end

	-- We let go of right mouse button. Activate the UI again.
	if(self.isFreecam and InputManager:WentMouseButtonUp(InputDeviceMouseButtons.IDB_Button_1)) then
		WebUI:EnableMouse()
		WebUI:EnableKeyboard()
	end
end


g_inputrestrictionClient = inputrestrictionClient()

