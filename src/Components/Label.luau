const Plugin = script.Parent.Parent
const React = require(Plugin.Packages.React)
const Theme = require(Plugin.Theme)

const e = React.createElement

type Props = {
	text: string?,
	description: string?,
	bold: boolean?,
	disabled: boolean?,
	textSize: number?,
	leftInset: number?,
	rightInset: number?,
	layoutOrder: number?,
}

const function Label(props: Props)
	const Color = Theme.useColor()
	const leftInset = props.leftInset or 0
	const rightInset = props.rightInset or 0

	return e("Frame", {
		LayoutOrder = props.layoutOrder,
		Position = UDim2.fromOffset(leftInset, 0),
		Size = UDim2.new(1, -(leftInset + rightInset), 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
	}, {
		Layout = e("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 1),
		}),
		Title = e("TextLabel", {
			LayoutOrder = 1,
			Size = UDim2.fromScale(1, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			Font = if props.bold then Theme.Font.Semibold else Theme.Font.Regular,
			Text = props.text or "",
			TextSize = props.textSize or Theme.TextSize.Body,
			TextColor3 = if props.disabled then Color.Placeholder else Color.Text,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextWrapped = true,
		}),
		Description = props.description and e("TextLabel", {
			LayoutOrder = 2,
			Size = UDim2.fromScale(1, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			Font = Theme.Font.Regular,
			Text = props.description,
			TextSize = Theme.TextSize.Small,
			TextColor3 = Color.TextMuted,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextWrapped = true,
		}),
	})
end

return Label
