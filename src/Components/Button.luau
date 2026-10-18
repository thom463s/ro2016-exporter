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
	Text: string,
	Variant: ("Primary" | "Secondary" | "Alert" | "Control" | "ToggleOn")?,
	Size: ("XSmall" | "Small" | "Medium" | "Large")?,
	Width: UDim?,
	Disabled: boolean?,
	LayoutOrder: number?,
	OnActivated: (() -> ())?,
}

const function Button(props: Props)
	const color = Theme.useColor()
	const hovered, setHovered = React.useState(false)
	const variant = VARIANTS[props.Variant or "Primary"]
	const size = SIZES[props.Size or "Medium"]
	const disabled = props.Disabled == true
	const showHover = hovered and not disabled
	const width = props.Width or UDim.new(1, 0)

	return e("TextButton", {
		LayoutOrder = props.LayoutOrder,
		Size = UDim2.new(width.Scale, width.Offset, 0, size.height),
		BackgroundColor3 = color[if showHover then variant.hover else variant.base],
		BackgroundTransparency = if disabled then 0.45 else 0,
		BorderSizePixel = 0,
		AutoButtonColor = false,
		Font = Enum.Font.SourceSansSemibold,
		Text = props.Text,
		TextSize = size.text,
		TextColor3 = color[variant.text],
		TextTransparency = if disabled then 0.25 else 0,

		[React.Event.MouseEnter] = function()
			setHovered(true)
		end,
		[React.Event.MouseLeave] = function()
			setHovered(false)
		end,
		[React.Event.Activated] = function()
			if not disabled and props.OnActivated then
				props.OnActivated()
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
            Color = color[if showHover then variant.strokeHover else variant.stroke],
        }),
	})
end

return Button
