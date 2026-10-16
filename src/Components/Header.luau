const Plugin = script.Parent.Parent
const React = require(Plugin.Packages.React)
const Theme = require(Plugin.Theme)

const e = React.createElement

type Props = {
	title: string,
	height: number,
}

const function Header(props: Props)
	const Color = Theme.useColor()
	return e("Frame", {
		Size = UDim2.new(1, 0, 0, props.height),
		BackgroundColor3 = Color.Header,
		BorderSizePixel = 0,
	}, {
		Padding = e("UIPadding", {
			PaddingLeft = UDim.new(0, Theme.Padding),
			PaddingRight = UDim.new(0, Theme.Padding),
		}),
		Title = e("TextLabel", {
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			Font = Theme.Font.Bold,
			Text = props.title,
			TextSize = Theme.TextSize.Heading,
			TextColor3 = Color.White,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextTruncate = Enum.TextTruncate.AtEnd,
		}),
	})
end

return Header
