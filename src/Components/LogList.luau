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
	Level: string,
	Text: string,
	Time: string,
}

type RowProps = {
	Entry: Entry,
	LayoutOrder: number,
	First: boolean,
}

type Props = {
	Entries: { Entry },
	LayoutOrder: number?,
}

const function Row(props: RowProps)
	const color = Theme.useColor()
	const entry = props.Entry

	return e("Frame", {
		LayoutOrder = props.LayoutOrder,
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
	}, {
		Divider = not props.First and e("Frame", {
			Position = UDim2.fromOffset(0, -ROW_PADDING),
			Size = UDim2.new(1, 0, 0, 1),
			BackgroundColor3 = color.Divider,
			BorderSizePixel = 0,
		}),
		Padding = e("UIPadding", {
			PaddingTop = UDim.new(0, if props.First then 0 else ROW_PADDING),
			PaddingBottom = UDim.new(0, ROW_PADDING),
		}),
		Time = e("TextLabel", {
			Size = UDim2.fromOffset(TEXT_OFFSET - 4, 18),
			BackgroundTransparency = 1,
			Font = Theme.Font.Regular,
			Text = entry.Time,
			TextSize = Theme.TextSize.Small,
			TextColor3 = color.TextMuted,
			TextXAlignment = Enum.TextXAlignment.Left,
		}),
		Text = e("TextLabel", {
			Position = UDim2.fromOffset(TEXT_OFFSET, 0),
			Size = UDim2.new(1, -TEXT_OFFSET, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			Font = Theme.Font.Regular,
			Text = entry.Text,
			TextSize = Theme.TextSize.Small,
			TextColor3 = color[LEVEL_COLORS[entry.Level] or "Text"],
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
	if #props.Entries == 0 then
		return e("TextLabel", {
			LayoutOrder = props.LayoutOrder,
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
	
	const count = #props.Entries
	for index, entry in props.Entries do
		rows[`Entry{index}`] = e(Row, {
			Entry = entry,
			LayoutOrder = count - index,
			First = index == count,
		})
	end

	return e("Frame", {
		LayoutOrder = props.LayoutOrder,
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
	}, rows)
end

return LogList
