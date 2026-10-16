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
	kind: "Success" | "Error" | "Info" | "Warning",
	text: string,
	position: UDim2,
	onDismiss: () -> (),
}

type ProgressBarProps = {
	progress: number,
	layoutOrder: number?,
}

const function Banner(props: BannerProps)
	const Color = Theme.useColor()
	return e("TextButton", {
		Position = props.position,
		Size = UDim2.new(1, 0, 0, 34),
		BackgroundColor3 = Color[BANNER_COLORS[props.kind] or "Blue"],
		BorderSizePixel = 0,
		AutoButtonColor = false,
		Font = Theme.Font.Semibold,
		Text = props.text,
		TextSize = Theme.TextSize.Body,
		TextColor3 = Color.White,
		TextTruncate = Enum.TextTruncate.AtEnd,
		ZIndex = 10,

		[React.Event.Activated] = props.onDismiss,
	}, {
		Padding = e("UIPadding", {
			PaddingLeft = UDim.new(0, Theme.Padding),
			PaddingRight = UDim.new(0, Theme.Padding),
		}),
	})
end

const function ProgressBar(props: ProgressBarProps)
	const Color = Theme.useColor()
	return e("Frame", {
		LayoutOrder = props.layoutOrder,
		Size = UDim2.new(1, 0, 0, 6),
		BackgroundColor3 = Color.Divider,
		BorderSizePixel = 0,
		ClipsDescendants = true,
	}, {
		Corner = e("UICorner", {
			CornerRadius = UDim.new(1, 0)
		}),
		Fill = e("Frame", {
			Size = UDim2.fromScale(math.clamp(props.progress, 0, 1), 1),
			BackgroundColor3 = Color.Blue,
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
