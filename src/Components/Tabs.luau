const Plugin = script.Parent.Parent
const React = require(Plugin.Packages.React)
const Theme = require(Plugin.Theme)

const e = React.createElement

type TabSpec = {
	Id: string,
	Label: string,
}

type TabProps = {
	Label: string,
	Active: boolean,
	Count: number,
	LayoutOrder: number,
	OnActivated: () -> (),
}

type Props = {
	Tabs: { TabSpec },
	Current: string,
	OnSelect: (string) -> (),
	Position: UDim2,
	Height: number,
}

const function Tab(props: TabProps)
	const color = Theme.useColor()
	const hovered, setHovered = React.useState(false)
	const active = props.Active
	const highlighted = active or hovered

	return e("TextButton", {
		LayoutOrder = props.LayoutOrder,
		Size = UDim2.fromScale(1 / props.Count, 1),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		AutoButtonColor = false,
		Font = Theme.Font.Semibold,
		Text = props.Label,
		TextSize = Theme.TextSize.Title,
		TextColor3 = if highlighted then color.Text else color.TextMuted,

		[React.Event.MouseEnter] = function()
			setHovered(true)
		end,
		[React.Event.MouseLeave] = function()
			setHovered(false)
		end,
		[React.Event.Activated] = props.OnActivated,
	}, {
		Underline = highlighted and e("Frame", {
			AnchorPoint = Vector2.new(0, 1),
			Position = UDim2.fromScale(0, 1),
			Size = UDim2.new(1, 0, 0, 4),
			BackgroundColor3 = if active then color.Blue else color.Divider,
			BorderSizePixel = 0,
		}),
	})
end

const function Tabs(props: Props)
	const Color = Theme.useColor()
	const tabCount = #props.Tabs

	const children = {
		Layout = e("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			SortOrder = Enum.SortOrder.LayoutOrder,
		}),
		Shadow = e("UIShadow", {
			Color = Color.Shadow,
			Transparency = 0.8,
			Offset = UDim2.fromOffset(0, 1),
			BlurRadius = UDim.new(0, 4),
		}),
	}

	for index, tab in props.Tabs do
		children[tab.Id] = e(Tab, {
			LayoutOrder = index,
			Count = tabCount,
			Label = tab.Label,
			Active = tab.Id == props.Current,
			OnActivated = function()
				props.OnSelect(tab.Id)
			end,
		})
	end

	return e("Frame", {
		Position = props.Position,
		Size = UDim2.new(1, 0, 0, props.Height),
		BackgroundColor3 = Color.Panel,
		BorderSizePixel = 0,
		ZIndex = 2,
	}, children)
end

return Tabs
