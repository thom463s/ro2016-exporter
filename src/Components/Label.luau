const Plugin = script.Parent.Parent
const React = require(Plugin.Packages.React)
const Theme = require(Plugin.Theme)

const e = React.createElement

type Props = {
	Text: string?,
	Description: string?,
	Bold: boolean?,
	Disabled: boolean?,
	TextSize: number?,
	LeftInset: number?,
	RightInset: number?,
	LayoutOrder: number?,
}

const function Label(props: Props)
	const color = Theme.useColor()
	const leftInset = props.LeftInset or 0
	const rightInset = props.RightInset or 0

	return e("Frame", {
		LayoutOrder = props.LayoutOrder,
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
			Font = if props.Bold then Theme.Font.Semibold else Theme.Font.Regular,
			Text = props.Text or "",
			TextSize = props.TextSize or Theme.TextSize.Body,
			TextColor3 = if props.Disabled then color.Placeholder else color.Text,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextWrapped = true,
		}),
		Description = props.Description and e("TextLabel", {
			LayoutOrder = 2,
			Size = UDim2.fromScale(1, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			Font = Theme.Font.Regular,
			Text = props.Description,
			TextSize = Theme.TextSize.Small,
			TextColor3 = color.TextMuted,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextWrapped = true,
		}),
	})
end

return Label
