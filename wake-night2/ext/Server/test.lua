print('Initial load completed.')

function OnExtensionLoaded()
	print('Extension has loaded.')
	return true
end

Events:Subscribe('ExtensionLoaded', OnExtensionLoaded)
