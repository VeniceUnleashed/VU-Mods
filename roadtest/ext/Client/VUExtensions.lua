class "VUExtensions"

-- Todo 3ti: Eventually replace print / error with the logger stuff, but only if this thingy isnt wildly shared anymore

function VUExtensions:PrepareInstanceForEdit(p_Instance,p_Partition,replace)
	if p_Instance == nil then
		error('[VUExtensions] parameter p_Instance was nil.')
		return
	end

	if p_Instance.isReadOnly == nil then
		-- If .isReadOnly is nil it means that its not a DataContainer, it's a Structure. We return it casted
		print('[VUExtensions] The instance '..p_Instance.typeInfo.name.." is not a DataContainer, it's a Structure")
		return _G[p_Instance.typeInfo.name](p_Instance)
	end

	if not p_Instance.isReadOnly then
		return _G[p_Instance.typeInfo.name](p_Instance)
	end

	if p_Instance.isLazyLoading then
		error('[VUExtensions] The instance is being lazy loaded, thus it cant be prepared for editing. Instance type: "' .. p_Instance.typeInfo.name)-- maybe add callstack
		return _G[p_Instance.typeInfo.name](p_Instance)
	end

	if p_Instance.instanceGuid == nil then
		error('[VUExtensions] .instanceGuid is nil. Instance type: ' .. p_Instance.typeInfo.name)

		return nil
	end

	local clone = p_Instance:Clone(p_Instance.instanceGuid)

	if replace and p_Partition == nil then
		error('[VUExtensions] parameter p_Partition was nil. Instance type: ' .. p_Instance.typeInfo.name)
		return
	end
	if replace and p_Partition ~= nil then
		p_Partition:ReplaceInstance(p_Instance, clone, true)
	end
	
	local castedClone = _G[clone.typeInfo.name](clone)

	if castedClone ~= nil and castedClone.typeInfo.name ~= clone.typeInfo.name then
		error('[VUExtensions] VUExtensions:PrepareInstanceForEdit() - Failed to prepare instance of type ' .. clone.typeInfo.name)
		return nil
	end

	return castedClone
end

return VUExtensions