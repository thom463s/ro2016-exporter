const Plugin = script.Parent.Parent
const React = require(Plugin.Packages.React)
const Theme = require(Plugin.Theme)

const e = React.createElement

type Props = {
	text: string,
	label: string?,
	hint: string?,
	placeholder: string?,
	onChange: ((string) -> ())?,
	onCommit: ((string) -> string?)?,
	layoutOrder: number?,
}

const function TextInput(props: Props)
	const Color = Theme.useColor()
	const focused, setFocused = React.useState(false)
	const hovered, setHovered = React.useState(false)

	const strokeColor = if focused
		then Color.Blue
		elseif hovered then Color.BorderDark
		else Color.Border

	return e("Frame", {
		LayoutOrder = props.layoutOrder,
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
	}, {
		Layout = e("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 4),
		}),
		Label = props.label and e("TextLabel", {
			LayoutOrder = 1,
			Size = UDim2.new(1, 0, 0, 18),
			BackgroundTransparency = 1,
			Font = Theme.Font.Semibold,
			Text = props.label,
			TextSize = Theme.TextSize.Body,
			TextColor3 = Color.Text,
			TextXAlignment = Enum.TextXAlignment.Left,
		}),
		Field = e("Frame", {
			LayoutOrder = 2,
			Size = UDim2.new(1, 0, 0, 32),
			BackgroundColor3 = Color.Panel,
			BorderSizePixel = 0,

			[React.Event.MouseEnter] = function()
				setHovered(true)
			end,
			[React.Event.MouseLeave] = function()
				setHovered(false)
			end,
		}, {
			Corner = e("UICorner", {
				CornerRadius = UDim.new(0, 2)
			}),
			Stroke = e("UIStroke", {
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Color = strokeColor,
			}),
			Box = e("TextBox", {
				Position = UDim2.fromOffset(8, 0),
				Size = UDim2.new(1, -16, 1, 0),
				BackgroundTransparency = 1,
				ClearTextOnFocus = false,
				ClipsDescendants = true,
				Font = Theme.Font.Regular,
				Text = props.text,
				PlaceholderText = props.placeholder or "",
				PlaceholderColor3 = Color.Placeholder,
				TextSize = Theme.TextSize.Body,
				TextColor3 = Color.Text,
				TextXAlignment = Enum.TextXAlignment.Left,

				[React.Event.Focused] = function()
					setFocused(true)
				end,
				[React.Event.FocusLost] = function(textBox: TextBox)
					setFocused(false)
					if props.onCommit then
						const replacement = props.onCommit(textBox.Text)
						if replacement ~= nil and replacement ~= textBox.Text then
							textBox.Text = replacement
						end
					end
				end,
				[React.Change.Text] = function(textBox: TextBox)
					if props.onChange then
						props.onChange(textBox.Text)
					end
				end,
			}),
		}),
		Hint = props.hint and e("TextLabel", {
			LayoutOrder = 3,
			Size = UDim2.fromScale(1, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			Font = Theme.Font.Regular,
			Text = props.hint,
			TextSize = 13,
			TextColor3 = Color.TextMuted,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextWrapped = true,
		}),
	})
end

return TextInput
