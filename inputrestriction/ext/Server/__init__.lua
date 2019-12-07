class 'inputrestrictionServer'


function inputrestrictionServer:__init()
	print("Initializing inputrestrictionServer")
	self:RegisterVars()
	self:RegisterEvents()
end


function inputrestrictionServer:RegisterVars()
	self.m_InputRestriction = nil
end


function inputrestrictionServer:RegisterEvents()
	self.m_PartitionLoadedEvent = Events:Subscribe('Partition:Loaded', self, self.OnPartitionLoaded)
	self.m_ChatEvent = Events:Subscribe("Player:Chat", self, self.OnChat)
end
function inputrestrictionServer:OnChat(p_Player, p_Mask, p_Message)
	local instance = InputRestrictionEntityData()
		instance.enabled = true
		instance.overridePreviousInputRestriction = true
		instance.applyRestrictionsToSpecificPlayer = false
		instance.throttle = true
		instance.strafe = true
		instance.brake = true
		instance.handBrake = true
		instance.clutch = true
		instance.yaw = true
		instance.pitch = true
		instance.roll = true
		instance.fire = true
		instance.fireCountermeasure = true
		instance.altFire = true
		instance.cycleRadioChannel = true
		instance.selectMeleeWeapon = true
		instance.zoom = true
		instance.jump = true
		instance.changeVehicle = true
		instance.changeEntry = true
		instance.changePose = true
		instance.toggleParachute = true
		instance.changeWeapon = true
		instance.reload = true
		instance.toggleCamera = true
		instance.sprint = true
		instance.scoreboardMenu = true
		instance.mapZoom = true
		instance.gearUp = true
		instance.gearDown = true
		instance.threeDimensionalMap = true
		instance.giveOrder = true
		instance.prone = true
		instance.switchPrimaryInventory = true
		instance.switchPrimaryWeapon = true
		instance.grenadeLauncher = true
		instance.staticGadget = true
		instance.dynamicGadget1 = true
		instance.dynamicGadget2 = true
		instance.meleeAttack = true
		instance.throwGrenade = true
		instance.selectWeapon1 = true
		instance.selectWeapon2 = true
		instance.selectWeapon3 = true
		instance.selectWeapon4 = true
		instance.selectWeapon5 = true
		instance.selectWeapon6 = true
		instance.selectWeapon7 = true
		instance.selectWeapon8 = true
		instance.selectWeapon9 = true

		self.m_InputRestriction = EntityManager:CreateServerEntity( instance, LinearTransform() )

		print("so far so good")

		if ( self.m_InputRestriction == nil ) then
			print("Could not spawn decal")
			return
		end
		
		self.m_InputRestriction:Init(Realm.Realm_Server, true)

		self.m_InputRestriction:FireEvent("Activate")
end
function inputrestrictionServer:OnUpdateInput(p_Delta)

	if InputManager:WentKeyDown(InputDeviceKeys.IDK_F) then
		local instance = InputRestrictionEntityData()
		instance.enabled = true

		self.m_InputRestriction = EntityManager:CreateServerEntity( instance, LinearTransform() )

		print("so far so good")

		if ( self.m_InputRestriction == nil ) then
			print("Could not spawn decal")
			return
		end
		
		self.m_InputRestriction:Init(Realm.Realm_Server, true)

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


g_inputrestrictionServer = inputrestrictionServer()

