const Plugin = script.Parent.Parent
const React = require(Plugin.Packages.React)
const Button = require(script.Parent.Button)

const e = React.createElement
const GAP = 6

type Option = {
	id: string,
	label: string,
}

type Props = {
	options: { Option },
	selected: string,
	onSelect: (string) -> (),
	layoutOrder: number?,
}

const function Segmented(props: Props)
	const count = #props.options
	const width = UDim.new(1 / count, -GAP * (count - 1) / count)

	const children = {
		Layout = e("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, GAP),
		}),
	}

	for index, option in props.options do
		children[option.id] = e(Button, {
			layoutOrder = index,
			text = option.label,
			variant = if option.id == props.selected then "ToggleOn" else "Control",
			size = "Small",
			width = width,
			
			onActivated = function()
				props.onSelect(option.id)
			end,
		})
	end

	return e("Frame", {
		LayoutOrder = props.layoutOrder,
		Size = UDim2.new(1, 0, 0, 26),
		BackgroundTransparency = 1,
	}, children)
end

return Segmented
