const Plugin = script.Parent.Parent
const React = require(Plugin.Packages.React)
const Format = require(Plugin.Format)
const Icons = require(Plugin.Icons)
const Section = require(script.Parent.Section)
const Theme = require(Plugin.Theme)

const DetailRow = Section.DetailRow

const e = React.createElement

const ICON_SIZE = 16
const SHEET_WIDTH = 1024
const ICONS_PER_ROW = SHEET_WIDTH // Icons.Size
const DEFAULT_EMPTY_TEXT = "Nothing selected. Pick a Model, Part or Folder in the Explorer."

type Props = {
	instance: Instance?,
	count: number?,
	emptyText: string?,
	layoutOrder: number?,
}

const function classIcon(className: string)
	const entry = Icons.Data[className]
	const index = if entry and entry.index then entry.index else 0
	const column = index % ICONS_PER_ROW
	const row = index // ICONS_PER_ROW

	return {
		Image = Icons.ImageId,
		ImageRectOffset = Vector2.new(column * Icons.Size, row * Icons.Size),
		ImageRectSize = Vector2.new(Icons.Size, Icons.Size),
	}
end

const function SelectionCard(props: Props)
	const Color = Theme.useColor()
	const instance = props.instance
	const count = props.count or 1

	const descendantCount = React.useMemo(function()
		if instance == nil then
			return 0
		end

		const success, descendants = pcall(instance.GetDescendants, instance)
		return if success then #descendants else 0
	end, { instance })

	if instance == nil then
		return e("TextLabel", {
			LayoutOrder = props.layoutOrder,
			Size = UDim2.fromScale(1, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			Font = Theme.Font.Regular,
			Text = props.emptyText or DEFAULT_EMPTY_TEXT,
			TextSize = Theme.TextSize.Body,
			TextColor3 = Color.TextMuted,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextWrapped = true,
		})
	end

	const icon = classIcon(instance.ClassName)
	const nameInset = ICON_SIZE + 6

	return e("Frame", {
		LayoutOrder = props.layoutOrder,
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
	}, {
		Layout = e("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 2),
		}),
		
		Title = e("Frame", {
			LayoutOrder = 1,
			Size = UDim2.new(1, 0, 0, 26),
			BackgroundTransparency = 1,
		}, {
			Icon = e("ImageLabel", {
				AnchorPoint = Vector2.new(0, 0.5),
				Position = UDim2.fromScale(0, 0.5),
				Size = UDim2.fromOffset(ICON_SIZE, ICON_SIZE),
				BackgroundTransparency = 1,
				Image = icon.Image,
				ImageRectOffset = icon.ImageRectOffset,
				ImageRectSize = icon.ImageRectSize,
				ResampleMode = Enum.ResamplerMode.Pixelated,
			}),
			Name = e("TextLabel", {
				Position = UDim2.fromOffset(nameInset, 0),
				Size = UDim2.new(1, -nameInset, 1, 0),
				BackgroundTransparency = 1,
				Font = Theme.Font.Semibold,
				Text = instance.Name,
				TextSize = Theme.TextSize.Title,
				TextColor3 = Color.Text,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextTruncate = Enum.TextTruncate.AtEnd,
			}),
		}),

		Class = e(DetailRow, {
			layoutOrder = 2,
			label = "Class",
			value = instance.ClassName,
		}),
		Descendants = e(DetailRow, {
			layoutOrder = 3,
			label = "Descendants",
			value = Format.number(descendantCount),
		}),
		Path = e(DetailRow, {
			layoutOrder = 4,
			label = "Path",
			value = instance:GetFullName(),
			valueColor = Color.BlueText,
		}),

		Multi = count > 1 and e("TextLabel", {
			LayoutOrder = 5,
			Size = UDim2.fromScale(1, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			Font = Theme.Font.Semibold,
			Text = `Only the first of {count} selected instances is exported.`,
			TextSize = 13,
			TextColor3 = Color.OrangeText,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextWrapped = true,
		}),
	})
end

return SelectionCard
