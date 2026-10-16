const Plugin = script.Parent.Parent
const React = require(Plugin.Packages.React)

const function read(): "Light" | "Dark"
	const success, name = pcall(function()
		return settings().Studio.Theme.Name
	end)
	return if success and name == "Dark" then "Dark" else "Light"
end

const function useStudioTheme(): "Light" | "Dark"
	const theme, setTheme = React.useState(read)

	React.useEffect(function()
		const success, connection = pcall(function()
			return settings().Studio.ThemeChanged:Connect(function()
				setTheme(read())
			end)
		end)
		return function()
			if success then
				connection:Disconnect()
			end
		end
	end, {})

	return theme
end

return useStudioTheme
