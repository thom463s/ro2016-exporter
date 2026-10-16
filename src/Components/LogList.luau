const Plugin = script.Parent.Parent
const React = require(Plugin.Packages.React)
const Theme = require(Plugin.Theme)

const e = React.createElement

const ROW_PADDING = 6
const TEXT_OFFSET = 60

const LEVEL_COLORS = {
	success = "GreenText",
	warning = "OrangeText",
	error = "RedText",
}

export type Entry = {
	level: string,
	text: string,
	time: string,
}

type RowProps = {
	entry: Entry,
	layoutOrder: number,
	first: boolean,
}

type Props = {
	entries: { Entry },
	layoutOrder: number?,
}

const function Row(props: RowProps)
	const Color = Theme.useColor()
	const entry = props.entry

	return e("Frame", {
		LayoutOrder = props.layoutOrder,
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
	}, {
		Divider = not props.first and e("Frame", {
			Position = UDim2.fromOffset(0, -ROW_PADDING),
			Size = UDim2.new(1, 0, 0, 1),
			BackgroundColor3 = Color.Divider,
			BorderSizePixel = 0,
		}),
		Padding = e("UIPadding", {
			PaddingTop = UDim.new(0, if props.first then 0 else ROW_PADDING),
			PaddingBottom = UDim.new(0, ROW_PADDING),
		}),
		Time = e("TextLabel", {
			Size = UDim2.fromOffset(TEXT_OFFSET - 4, 18),
			BackgroundTransparency = 1,
			Font = Theme.Font.Regular,
			Text = entry.time,
			TextSize = Theme.TextSize.Small,
			TextColor3 = Color.TextMuted,
			TextXAlignment = Enum.TextXAlignment.Left,
		}),
		Text = e("TextLabel", {
			Position = UDim2.fromOffset(TEXT_OFFSET, 0),
			Size = UDim2.new(1, -TEXT_OFFSET, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			Font = Theme.Font.Regular,
			Text = entry.text,
			TextSize = Theme.TextSize.Small,
			TextColor3 = Color[LEVEL_COLORS[entry.level] or "Text"],
			TextXAlignment = Enum.TextXAlignment.Left,
			TextWrapped = true,
		}, {
			Padding = e("UIPadding", {
				PaddingTop = UDim.new(0, 1),
			}),
		}),
	})
end

const function LogList(props: Props)
	const Color = Theme.useColor()
	if #props.entries == 0 then
		return e("TextLabel", {
			LayoutOrder = props.layoutOrder,
			Size = UDim2.new(1, 0, 0, 20),
			BackgroundTransparency = 1,
			Font = Theme.Font.Regular,
			Text = "No exports yet.",
			TextSize = Theme.TextSize.Body,
			TextColor3 = Color.TextMuted,
			TextXAlignment = Enum.TextXAlignment.Left,
		})
	end

	const rows = {
		Layout = e("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
		}),
	}
	
	const count = #props.entries
	for index, entry in props.entries do
		rows[`Entry{index}`] = e(Row, {
			entry = entry,
			layoutOrder = count - index,
			first = index == count,
		})
	end

	return e("Frame", {
		LayoutOrder = props.layoutOrder,
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
	}, rows)
end

return LogList
