Events:Subscribe('Partition:Loaded', function(partition)
	if partition == nil then
		return
	end

	local instances = partition.instances
	for _, instance in pairs(instances) do
		if instance ~= nil then
			if instance:Is("EmitterTemplateData") then
				local emitterTemplate = EmitterTemplateData(instance)


				-- Tweak smoke and dust to last longer
				if(string.find(emitterTemplate.name:lower(), "smoke") or string.find(emitterTemplate.name:lower(), "dust")) then
					emitterTemplate:MakeWritable()
					if (emitterTemplate.emissive or emitterTemplate.actAsPointLight or emitterTemplate.repeatParticleSpawning or emitterTemplate.opaque) == false then
						if(emitterTemplate.rootProcessor:Is("UpdateAgeData")) then
							local rootProcessor = UpdateAgeData(emitterTemplate.rootProcessor)
							rootProcessor:MakeWritable()
							rootProcessor.lifetime = rootProcessor.lifetime * 3

							emitterTemplate.lifetime = emitterTemplate.lifetime * 3
							emitterTemplate.maxCount = emitterTemplate.maxCount * 3
							emitterTemplate.timeScale = emitterTemplate.timeScale / 2
						end
					end

				-- Make muzzleflashes light up
				elseif(string.find(emitterTemplate.name:lower(), "muzz")) then
					emitterTemplate:MakeWritable()
					emitterTemplate.actAsPointLight = true
					if(emitterTemplate.pointLightColor == Vec3(1,1,1)) then
						emitterTemplate.pointLightColor = Vec3(1,0.25,0)
					end

				-- Make bullets light up
				elseif(string.find(emitterTemplate.name:lower(), "tracer")) then
					emitterTemplate:MakeWritable()
					emitterTemplate.actAsPointLight = true
					if(emitterTemplate.pointLightColor == Vec3(1,1,1)) then
						emitterTemplate.pointLightColor = Vec3(1,0.25,0) -- Change this to something suitable?
					end

				-- Make sparks light up
				elseif(string.find(emitterTemplate.name:lower(), "spark")) then
					emitterTemplate:MakeWritable()
					emitterTemplate.actAsPointLight = true--emitterTemplate.lifetime * 3
					if(emitterTemplate.pointLightColor == Vec3(1,1,1)) then
						emitterTemplate.pointLightColor = Vec3(1,0.25,0) -- Change this to something suitable?
					end
				end
			end
		end
	end
end)

