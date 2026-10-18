const Plugin = script.Parent.Parent
const React = require(Plugin.Packages.React)
const Button = require(script.Parent.Button)
const Theme = require(Plugin.Theme)

const e = React.createElement

const ACTION_WIDTH = 80
const ACTION_GAP = 8
const DETAIL_LABEL_WIDTH = 90

type Action = {
	Text: string,
	Width: number?,
	Disabled: boolean?,
	OnActivated: () -> (),
}

type SectionProps = {
	Title: string,
	Action: Action?,
	LayoutOrder: number?,
	Gap: number?,
	children: any,
}

type DividerProps = {
	LayoutOrder: number?,
}

type DetailRowProps = {
	Label: string,
	Value: string,
	ValueColor: Color3?,
	LayoutOrder: number?,
}

const function Section(props: SectionProps)
	const color = Theme.useColor()
	const action = props.Action
	const actionWidth = if action then action.Width or ACTION_WIDTH else 0
	const titleInset = if action then actionWidth + ACTION_GAP else 0

	return e("Frame", {
		LayoutOrder = props.LayoutOrder,
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
	}, {
		Layout = e("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 6),
		}),
		Header = e("Frame", {
			LayoutOrder = 1,
			Size = UDim2.new(1, 0, 0, 30),
			BackgroundTransparency = 1,
		}, {
			Title = e("TextLabel", {
				Size = UDim2.new(1, -titleInset, 1, 0),
				BackgroundTransparency = 1,
				Font = Theme.Font.Light,
				Text = props.Title,
				TextSize = Theme.TextSize.Section,
				TextColor3 = color.Text,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextTruncate = Enum.TextTruncate.AtEnd,
			}),
			Action = action and e("Frame", {
				AnchorPoint = Vector2.new(1, 0.5),
				Position = UDim2.fromScale(1, 0.5),
				Size = UDim2.fromOffset(actionWidth, 24),
				BackgroundTransparency = 1,
			}, {
				Button = e(Button, {
					Text = action.Text,
					Variant = "Secondary",
					Size = "XSmall",
					Disabled = action.Disabled,
					OnActivated = action.OnActivated,
				}),
			}),
		}),
		Content = e("Frame", {
			LayoutOrder = 2,
			Size = UDim2.fromScale(1, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundColor3 = color.Panel,
			BorderSizePixel = 0,
		}, {
			Shadow = e("UIShadow", {
				Color = color.Shadow,
				Transparency = 0.8,
				Offset = UDim2.fromOffset(0, 1),
				BlurRadius = UDim.new(0, 4),
			}),
			Padding = e("UIPadding", {
				PaddingTop = UDim.new(0, Theme.Padding),
				PaddingBottom = UDim.new(0, Theme.Padding),
				PaddingLeft = UDim.new(0, Theme.Padding),
				PaddingRight = UDim.new(0, Theme.Padding),
			}),
			Layout = e("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, props.Gap or 12),
			}),
			Children = e(React.Fragment, nil, props.children),
		}),
	})
end

const function Divider(props: DividerProps)
	const color = Theme.useColor()
	return e("Frame", {
		LayoutOrder = props.LayoutOrder,
		Size = UDim2.new(1, 0, 0, 1),
		BackgroundColor3 = color.Divider,
		BorderSizePixel = 0,
	})
end

const function DetailRow(props: DetailRowProps)
	const color = Theme.useColor()
	return e("Frame", {
		LayoutOrder = props.LayoutOrder,
		Size = UDim2.new(1, 0, 0, 20),
		BackgroundTransparency = 1,
	}, {
		Label = e("TextLabel", {
			Size = UDim2.new(0, DETAIL_LABEL_WIDTH, 1, 0),
			BackgroundTransparency = 1,
			Font = Theme.Font.Regular,
			Text = props.Label,
			TextSize = Theme.TextSize.Body,
			TextColor3 = color.TextMuted,
			TextXAlignment = Enum.TextXAlignment.Left,
		}),
		Value = e("TextLabel", {
			Position = UDim2.fromOffset(DETAIL_LABEL_WIDTH, 0),
			Size = UDim2.new(1, -DETAIL_LABEL_WIDTH, 1, 0),
			BackgroundTransparency = 1,
			Font = Theme.Font.Regular,
			Text = props.Value,
			TextSize = Theme.TextSize.Body,
			TextColor3 = props.ValueColor or color.Text,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextTruncate = Enum.TextTruncate.AtEnd,
		}),
	})
end

return {
	Section = Section,
	Divider = Divider,
	DetailRow = DetailRow,
}
