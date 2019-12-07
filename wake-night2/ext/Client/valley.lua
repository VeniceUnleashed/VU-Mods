function FixEnvironmentState(p_State)
	print(p_State.entityName)

	local s_ColorCorrection = p_State.colorCorrection

	if s_ColorCorrection ~= nil then
		s_ColorCorrection.brightness = Vec3(0.9, 0.9, 0.9)
		s_ColorCorrection.contrast = Vec3(1.15, 1.15, 1.15)
		s_ColorCorrection.saturation = Vec3(0.6, 0.6, 0.64)
		s_ColorCorrection.colorGradingEnable = false
		s_ColorCorrection.enable = false
	end

	local s_Sky = p_State.sky

	if s_Sky ~= nil then
		s_Sky.sunSize = 0
		s_Sky.brightnessScale = 0.04
		s_Sky.sunScale = 0
	end

	local s_OutdoorLight = p_State.outdoorLight

	if s_OutdoorLight ~= nil then
		s_OutdoorLight.skyLightAngleFactor = 0.000000
		s_OutdoorLight.sunSpecularScale = 0.100000
		s_OutdoorLight.skyEnvmapShadowScale = 0.600000
		s_OutdoorLight.cloudShadowCoverage = 0.092000
		s_OutdoorLight.translucencyDistortion = 0.100000
		s_OutdoorLight.cloudShadowSize = 1000.000000
		s_OutdoorLight.translucencyAmbient = 0.200000
		s_OutdoorLight.translucencyScale = 1.000000
		s_OutdoorLight.translucencyPower = 8.000000
		s_OutdoorLight.sunShadowHeightScale = 0.4

		s_OutdoorLight.sunColor = Vec3(0.09, 0.09, 0.09)
		s_OutdoorLight.skyColor = Vec3(0.07, 0.07, 0.07)
		s_OutdoorLight.groundColor = Vec3(0, 0, 0)

		s_OutdoorLight.enable = true
		s_OutdoorLight.cloudShadowEnable = false
	end

	local s_Enlighten = p_State.enlighten

	if s_Enlighten ~= nil then
		s_Enlighten.enable = false
	end

	local s_Fog = p_State.fog

	if s_Fog ~= nil then
		s_Fog.start = 20
		s_Fog['end'] = 350

		s_Fog.enable = false
		s_Fog.fogColorEnable = false
	end

	local s_SunFlare = p_State.sunFlare

	if s_SunFlare ~= nil then
		s_SunFlare.enable = true
		s_SunFlare.element1Enable = false
		s_SunFlare.element2Enable = false
		s_SunFlare.element3Enable = false
		s_SunFlare.element4Enable = false
		s_SunFlare.element5Enable = false
	end
end

function OnLoaded()
	local s_States = VisualEnvironmentManager:GetStates()

	for s_State in s_States do
		if s_State.entityName ~= 'EffectEntity' then
			FixEnvironmentState(s_State)			
		end
	end

	VisualEnvironmentManager.dirty = true

	return true
end

function OnStateAdded(p_State)
	if p_State.entityName ~= 'EffectEntity' then
		FixEnvironmentState(p_State)
		VisualEnvironmentManager.dirty = true
	end

	return true
end

function OnStateRemoved(p_State)
	return true
end

function OnStatesCleared()
	return true
end

Events:Subscribe('ExtensionLoaded', OnLoaded)
Events:Subscribe('VisualEnvironment:StateAdded', OnStateAdded)
Events:Subscribe('VisualEnvironment:StateRemoved', OnStateRemoved)
Events:Subscribe('VisualEnvironment:StatesCleared', OnStatesCleared)
