const Plugin = script.Parent.Parent
const React = require(Plugin.Packages.React)
const Label = require(script.Parent.Label)
const Theme = require(Plugin.Theme)

const e = React.createElement

const CHECKMARK_ID = "rbxassetid://87225501648406"
const BOX_SIZE = 16

type Props = {
	checked: boolean,
	onChange: (boolean) -> (),
	label: string,
	description: string?,
	disabled: boolean?,
	layoutOrder: number?,
}

const function Tick()
    const Color = Theme.useColor()
    return e("ImageLabel", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(BOX_SIZE, BOX_SIZE),
        BackgroundTransparency = 1,
        Image = CHECKMARK_ID,
        ImageColor3 = Color.White,
    })
end

const function Checkbox(props: Props)
	const Color = Theme.useColor()
	const hovered, setHovered = React.useState(false)
	const checked = props.checked
	const disabled = props.disabled == true
	const showHover = hovered and not disabled
	const borderColor = if checked or showHover then Color.Blue else Color.Border

	return e("TextButton", {
		LayoutOrder = props.layoutOrder,
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		AutoButtonColor = false,
		Text = "",

		[React.Event.MouseEnter] = function()
			setHovered(true)
		end,
		[React.Event.MouseLeave] = function()
			setHovered(false)
		end,
		[React.Event.Activated] = function()
			if not disabled then
				props.onChange(not checked)
			end
		end,
	}, {
		Box = e("Frame", {
			Position = UDim2.fromOffset(0, 2),
			Size = UDim2.fromOffset(BOX_SIZE, BOX_SIZE),
			BackgroundColor3 = if checked then Color.Blue else Color.Panel,
			BackgroundTransparency = if disabled then 0.5 else 0,
			BorderSizePixel = 0,
		}, {
			Corner = e("UICorner", {
				CornerRadius = UDim.new(0, 2),
			}),
			Stroke = e("UIStroke", {
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Color = borderColor,
			}),
			Tick = checked and e(Tick),
		}),
		Label = e(Label, {
			text = props.label,
			description = props.description,
			disabled = disabled,
			leftInset = BOX_SIZE + 10,
		}),
	})
end

return Checkbox
