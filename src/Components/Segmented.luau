const Plugin = script.Parent.Parent
const React = require(Plugin.Packages.React)
const Button = require(script.Parent.Button)

const e = React.createElement
const GAP = 6

type Option = {
	Id: string,
	Label: string,
}

type Props = {
	Options: { Option },
	Selected: string,
	OnSelect: (string) -> (),
	LayoutOrder: number?,
}

const function Segmented(props: Props)
	const count = #props.Options
	const width = UDim.new(1 / count, -GAP * (count - 1) / count)

	const children = {
		Layout = e("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, GAP),
		}),
	}

	for index, option in props.Options do
		children[option.Id] = e(Button, {
			LayoutOrder = index,
			Text = option.Label,
			Variant = if option.Id == props.Selected then "ToggleOn" else "Control",
			Size = "Small",
			Width = width,
			
			OnActivated = function()
				props.OnSelect(option.Id)
			end,
		})
	end

	return e("Frame", {
		LayoutOrder = props.LayoutOrder,
		Size = UDim2.new(1, 0, 0, 26),
		BackgroundTransparency = 1,
	}, children)
end

return Segmented
