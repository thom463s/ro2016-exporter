const Plugin = script.Parent.Parent
const React = require(Plugin.Packages.React)
const Label = require(script.Parent.Label)
const Theme = require(Plugin.Theme)

const e = React.createElement

const CHECKMARK_ID = "rbxassetid://87225501648406"
const BOX_SIZE = 16

type Props = {
	Checked: boolean,
	OnChange: (boolean) -> (),
	Label: string,
	Description: string?,
	Disabled: boolean?,
	LayoutOrder: number?,
}

const function Tick()
    const color = Theme.useColor()
    return e("ImageLabel", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(BOX_SIZE, BOX_SIZE),
        BackgroundTransparency = 1,
        Image = CHECKMARK_ID,
        ImageColor3 = color.White,
    })
end

const function Checkbox(props: Props)
	const color = Theme.useColor()
	const hovered, setHovered = React.useState(false)
	const checked = props.Checked
	const disabled = props.Disabled == true
	const showHover = hovered and not disabled
	const borderColor = if checked or showHover then color.Blue else color.Border

	return e("TextButton", {
		LayoutOrder = props.LayoutOrder,
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
				props.OnChange(not checked)
			end
		end,
	}, {
		Box = e("Frame", {
			Position = UDim2.fromOffset(0, 2),
			Size = UDim2.fromOffset(BOX_SIZE, BOX_SIZE),
			BackgroundColor3 = if checked then color.Blue else color.Panel,
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
			Text = props.Label,
			Description = props.Description,
			Disabled = disabled,
			LeftInset = BOX_SIZE + 10,
		}),
	})
end

return Checkbox
