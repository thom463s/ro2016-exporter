const Selection = game:GetService("Selection")
const Plugin = script.Parent.Parent
const React = require(Plugin.Packages.React)

const function read()
    const selected = Selection:Get()
    return {
        instance = selected[1],
        count = #selected,
    }
end

const function useSelection(): (Instance?, number)
    const state, setState = React.useState(read)

    React.useEffect(function()
        const connection = Selection.SelectionChanged:Connect(function()
            setState(read())
        end)
        return function()
            connection:Disconnect()
        end
    end, {})

    return state.instance, state.count
end

return useSelection
