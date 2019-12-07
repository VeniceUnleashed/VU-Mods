function FixEnvironmentState(p_State)

	print('Creating dynamic envmap.')

	local s_DynamicEnvmap = DynamicEnvmapData()
	s_DynamicEnvmap.enable = true
	s_DynamicEnvmap.keyColorEnvmap = Vec3(1.0, 1.0, 1.0)
	s_DynamicEnvmap.groundColorEnvmap = Vec3(1.0, 1.0, 1.0)
	s_DynamicEnvmap.skyColorEnvmap = Vec3(1.0, 1.0, 1.0)

	print('Setting dynamic envmap')

	p_State.dynamicEnvmap = s_DynamicEnvmap

	print('Creating planar reflection')

	local s_PlanarReflection = PlanarReflectionData()
	s_PlanarReflection.enable = true
	s_PlanarReflection.skyRenderEnable = true
	s_PlanarReflection.horizontalDeviation = 1.0
	s_PlanarReflection.groundHeight = 1.0
	s_PlanarReflection.verticalDeviation = 1.0
	s_PlanarReflection.verticalBlurFilter = 1
	s_PlanarReflection.horizontalBlurFilter = 1

	print('Setting planar reflection')

	p_State.planarReflection = s_PlanarReflection

	print('Swag')

	if p_State.entityName == 'Levels/MP_001/Lighting/VE_MP_001_Bazaar' then
		local s_ColorCorrection = p_State.colorCorrection

		if s_ColorCorrection ~= nil then
			s_ColorCorrection.brightness = Vec3(0.9, 0.9, 0.9)
			s_ColorCorrection.contrast = Vec3(1.15, 1.15, 1.15)
			s_ColorCorrection.saturation = Vec3(0.8, 0.8, 0.84)
			s_ColorCorrection.colorGradingEnable = false
			s_ColorCorrection.enable = false
		end

		local s_Sky = p_State.sky

		if s_Sky ~= nil then
			s_Sky.enable = true
			s_Sky.sunSize = 0
			s_Sky.brightnessScale = 0.05
			s_Sky.sunScale = 0
			s_Sky.skyVisibilityExponent = 10
			s_Sky.cloudLayer1SunLightIntensity = 0
			s_Sky.cloudLayer2SunLightIntensity = 0
		end

		local s_OutdoorLight = p_State.outdoorLight

		if s_OutdoorLight ~= nil then
			s_OutdoorLight.translucencyPower = 0.000000

			s_OutdoorLight.sunColor = Vec3(0, 0, 0)
			s_OutdoorLight.skyColor = Vec3(0, 0, 0)
			s_OutdoorLight.groundColor = Vec3(0.1, 0.1, 0.1)

			s_OutdoorLight.enable = true
			s_OutdoorLight.cloudShadowEnable = false
		end

		local s_TonemapData = p_State.tonemap

		if s_TonemapData ~= nil then
			s_TonemapData.bloomScale = Vec3(0, 0, 0)
			s_TonemapData.minExposure = 0.2
			s_TonemapData.middleGray = 0.05
			s_TonemapData.maxExposure = 0.6
		end

		return true
	end


	if p_State.entityName == 'Levels/MP_001/CollisionRoof' then
		local s_ColorCorrection = p_State.colorCorrection

		if s_ColorCorrection ~= nil then
			s_ColorCorrection.brightness = Vec3(0.9, 0.9, 0.9)
			s_ColorCorrection.contrast = Vec3(1.15, 1.15, 1.15)
			s_ColorCorrection.saturation = Vec3(0.8, 0.8, 0.84)
			s_ColorCorrection.colorGradingEnable = false
			s_ColorCorrection.enable = false
		end

		local s_Sky = p_State.sky

		if s_Sky ~= nil then
			s_Sky.enable = true
			s_Sky.sunSize = 0
			s_Sky.brightnessScale = 0.05
			s_Sky.sunScale = 0
			s_Sky.skyVisibilityExponent = 10
			s_Sky.cloudLayer1SunLightIntensity = 0
			s_Sky.cloudLayer2SunLightIntensity = 0
		end

		local s_OutdoorLight = p_State.outdoorLight

		if s_OutdoorLight ~= nil then
			s_OutdoorLight.translucencyPower = 0.000000

			s_OutdoorLight.sunColor = Vec3(0, 0, 0)
			s_OutdoorLight.skyColor = Vec3(0, 0, 0)
			s_OutdoorLight.groundColor = Vec3(0.1, 0.1, 0.1)

			s_OutdoorLight.enable = true
			s_OutdoorLight.cloudShadowEnable = false
		end

		local s_TonemapData = p_State.tonemap

		if s_TonemapData ~= nil then
			s_TonemapData.bloomScale = Vec3(0, 0, 0)
			s_TonemapData.minExposure = 0.2
			s_TonemapData.middleGray = 0.05
			s_TonemapData.maxExposure = 0.6
		end

		return true
	end


	if p_State.entityName == 'Levels/MP_001/Lighting/VE_MP_001_LensRain_01' then
		local s_ScreenEffect = p_State.screenEffect

		if s_ScreenEffect ~= nil then
			s_ScreenEffect.outerFrameOpacity = 0.2
			s_ScreenEffect.innerFrameOpacity = 0.2
		end
	end
end

function OnLoaded()
	local s_States = VisualEnvironmentManager:GetStates()

	for i, s_State in ipairs(s_States) do
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
