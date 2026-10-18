const Plugin = script.Parent.Parent
const React = require(Plugin.Packages.React)
const Theme = require(Plugin.Theme)

const e = React.createElement

const BANNER_COLORS = {
	Success = "Green",
	Error = "Red",
	Info = "Blue",
	Warning = "Orange",
}

type BannerProps = {
	Kind: "Success" | "Error" | "Info" | "Warning",
	Text: string,
	Position: UDim2,
	OnDismiss: () -> (),
}

type ProgressBarProps = {
	Progress: number,
	LayoutOrder: number?,
}

const function Banner(props: BannerProps)
	const color = Theme.useColor()
	return e("TextButton", {
		Position = props.Position,
		Size = UDim2.new(1, 0, 0, 34),
		BackgroundColor3 = color[BANNER_COLORS[props.Kind] or "Blue"],
		BorderSizePixel = 0,
		AutoButtonColor = false,
		Font = Theme.Font.Semibold,
		Text = props.Text,
		TextSize = Theme.TextSize.Body,
		TextColor3 = color.White,
		TextTruncate = Enum.TextTruncate.AtEnd,
		ZIndex = 10,

		[React.Event.Activated] = props.OnDismiss,
	}, {
		Padding = e("UIPadding", {
			PaddingLeft = UDim.new(0, Theme.Padding),
			PaddingRight = UDim.new(0, Theme.Padding),
		}),
	})
end

const function ProgressBar(props: ProgressBarProps)
	const color = Theme.useColor()
	return e("Frame", {
		LayoutOrder = props.LayoutOrder,
		Size = UDim2.new(1, 0, 0, 6),
		BackgroundColor3 = color.Divider,
		BorderSizePixel = 0,
		ClipsDescendants = true,
	}, {
		Corner = e("UICorner", {
			CornerRadius = UDim.new(1, 0)
		}),
		Fill = e("Frame", {
			Size = UDim2.fromScale(math.clamp(props.Progress, 0, 1), 1),
			BackgroundColor3 = color.Blue,
			BorderSizePixel = 0,
		}, {
			Corner = e("UICorner", {
				CornerRadius = UDim.new(1, 0)
			}),
		}),
	})
end

return {
	Banner = Banner,
	ProgressBar = ProgressBar,
}
