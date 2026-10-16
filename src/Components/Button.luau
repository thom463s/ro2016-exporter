const Plugin = script.Parent.Parent
const React = require(Plugin.Packages.React)
const Theme = require(Plugin.Theme)

const e = React.createElement

const VARIANTS = {
	Primary = {
		base = "Green",
		hover = "GreenHover",
		text = "White",
	},
	Secondary = {
		base = "Blue",
		hover = "BlueHover",
		text = "White",
	},
	Alert = {
		base = "Red",
		hover = "RedHover",
		text = "White",
	},
	Control = {
		base = "Panel",
		hover = "Panel",
		text = "Text",
		stroke = "Border",
		strokeHover = "Blue",
	},
	ToggleOn = {
		base = "Blue",
		hover = "Blue",
		text = "White",
		stroke = "Blue",
		strokeHover = "Blue",
	},
}

const SIZES = {
	XSmall = { height = 24, text = 14 },
	Small = { height = 26, text = 14 },
	Medium = { height = 32, text = 16 },
	Large = { height = 40, text = 20 },
}

type Props = {
	text: string,
	variant: ("Primary" | "Secondary" | "Alert" | "Control" | "ToggleOn")?,
	size: ("XSmall" | "Small" | "Medium" | "Large")?,
	width: UDim?,
	disabled: boolean?,
	layoutOrder: number?,
	onActivated: (() -> ())?,
}

const function Button(props: Props)
	const Color = Theme.useColor()
	const hovered, setHovered = React.useState(false)
	const variant = VARIANTS[props.variant or "Primary"]
	const size = SIZES[props.size or "Medium"]
	const disabled = props.disabled == true
	const showHover = hovered and not disabled
	const width = props.width or UDim.new(1, 0)

	return e("TextButton", {
		LayoutOrder = props.layoutOrder,
		Size = UDim2.new(width.Scale, width.Offset, 0, size.height),
		BackgroundColor3 = Color[if showHover then variant.hover else variant.base],
		BackgroundTransparency = if disabled then 0.45 else 0,
		BorderSizePixel = 0,
		AutoButtonColor = false,
		Font = Enum.Font.SourceSansSemibold,
		Text = props.text,
		TextSize = size.text,
		TextColor3 = Color[variant.text],
		TextTransparency = if disabled then 0.25 else 0,

		[React.Event.MouseEnter] = function()
			setHovered(true)
		end,
		[React.Event.MouseLeave] = function()
			setHovered(false)
		end,
		[React.Event.Activated] = function()
			if not disabled and props.onActivated then
				props.onActivated()
			end
		end,
	}, {
		Corner = e("UICorner", {
			CornerRadius = Theme.Radius,
		}),
		Padding = e("UIPadding", {
			PaddingLeft = UDim.new(0, 10),
			PaddingRight = UDim.new(0, 10),
		}),
		Stroke = variant.stroke and e("UIStroke", {
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
            Color = Color[if showHover then variant.strokeHover else variant.stroke],
        }),
	})
end

return Button
