class 'KitSpawnUIClient'


function KitSpawnUIClient:__init()
	print("Initializing KitSpawnUIClient")
	self:RegisterEvents()
end



function KitSpawnUIClient:RegisterEvents()
    self.m_WeaponChangedEvent = Events:Subscribe('RealityModUI:SpawnWithKit', self, self.SpawnWithKit)
    self.m_OnUpdateInputEvent = Events:Subscribe('Client:UpdateInput', self, self.OnUpdateInput)
    self.m_OnLoadedEvent = Events:Subscribe('ExtensionLoaded', self, self.OnLoaded)
end
function KitSpawnUIClient:OnLoaded()
	print("Loading UI")
    WebUI:Init()
end

function KitSpawnUIClient:OnUpdateInput(p_Delta)
    
    if InputManager:WentKeyDown(InputDeviceKeys.IDK_F2) then
        WebUI:BringToFront()
        WebUI:EnableMouse()
        WebUI:Show()
    end

    if InputManager:WentKeyDown(InputDeviceKeys.IDK_F3) then
        --WebUI:BringToFront()
        WebUI:DisableMouse()
        WebUI:Hide()
    end
end

function KitSpawnUIClient:SpawnWithKit(p_SelectedKit)
	NetEvents:SendLocal('RealityModUI:SpawnSoldier', p_SelectedKit)
end

function KitSpawnUIClient:EnableSpawnForKit(p_KitID)
	WebUI:ExecuteJS("EnableSpawnForKit(p_KitID)")
end

function KitSpawnUIClient:DisableSpawnForKit(p_KitID)
	WebUI:ExecuteJS("DisableSpawnForKit(p_KitID)")
end

g_KitSpawnUIClient = KitSpawnUIClient()

