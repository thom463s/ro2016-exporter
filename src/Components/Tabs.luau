const Plugin = script.Parent.Parent
const React = require(Plugin.Packages.React)
const Theme = require(Plugin.Theme)

const e = React.createElement

type TabSpec = {
	id: string,
	label: string,
}

type TabProps = {
	label: string,
	active: boolean,
	count: number,
	layoutOrder: number,
	onActivated: () -> (),
}

type Props = {
	tabs: { TabSpec },
	current: string,
	onSelect: (string) -> (),
	position: UDim2,
	height: number,
}

const function Tab(props: TabProps)
	const Color = Theme.useColor()
	const hovered, setHovered = React.useState(false)
	const active = props.active
	const highlighted = active or hovered

	return e("TextButton", {
		LayoutOrder = props.layoutOrder,
		Size = UDim2.fromScale(1 / props.count, 1),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		AutoButtonColor = false,
		Font = Theme.Font.Semibold,
		Text = props.label,
		TextSize = Theme.TextSize.Title,
		TextColor3 = if highlighted then Color.Text else Color.TextMuted,

		[React.Event.MouseEnter] = function()
			setHovered(true)
		end,
		[React.Event.MouseLeave] = function()
			setHovered(false)
		end,
		[React.Event.Activated] = props.onActivated,
	}, {
		Underline = highlighted and e("Frame", {
			AnchorPoint = Vector2.new(0, 1),
			Position = UDim2.fromScale(0, 1),
			Size = UDim2.new(1, 0, 0, 4),
			BackgroundColor3 = if active then Color.Blue else Color.Divider,
			BorderSizePixel = 0,
		}),
	})
end

const function Tabs(props: Props)
	const Color = Theme.useColor()
	const tabCount = #props.tabs

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

	for index, tab in props.tabs do
		children[tab.id] = e(Tab, {
			layoutOrder = index,
			count = tabCount,
			label = tab.label,
			active = tab.id == props.current,
			onActivated = function()
				props.onSelect(tab.id)
			end,
		})
	end

	return e("Frame", {
		Position = props.position,
		Size = UDim2.new(1, 0, 0, props.height),
		BackgroundColor3 = Color.Panel,
		BorderSizePixel = 0,
		ZIndex = 2,
	}, children)
end

return Tabs
