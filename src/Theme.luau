const React = require(script.Parent.Packages.React)
const Theme = {}

const Light = {
	Header = Color3.fromHex("0074BD"),
	HeaderDark = Color3.fromHex("0852B7"),
	Blue = Color3.fromHex("00A2FF"),
	BlueHover = Color3.fromHex("32B5FF"),
	Green = Color3.fromHex("02B757"),
	GreenHover = Color3.fromHex("3FC679"),
	Red = Color3.fromHex("E2231A"),
	RedHover = Color3.fromHex("E8504A"),
	Orange = Color3.fromHex("F68802"),
	BlueText = Color3.fromHex("00A2FF"),
	GreenText = Color3.fromHex("02B757"),
	RedText = Color3.fromHex("E2231A"),
	OrangeText = Color3.fromHex("F68802"),
	Page = Color3.fromHex("E3E3E3"),
	Panel = Color3.fromHex("FFFFFF"),
	Control = Color3.fromHex("F2F2F2"),
	Border = Color3.fromHex("B8B8B8"),
	BorderDark = Color3.fromHex("757575"),
	Divider = Color3.fromHex("E3E3E3"),
	Text = Color3.fromHex("191919"),
	TextMuted = Color3.fromHex("757575"),
	Placeholder = Color3.fromHex("B8B8B8"),
	Shadow = Color3.fromHex("191919"),
	White = Color3.new(1, 1, 1),
	Black = Color3.new(0, 0, 0),
}

export type Palette = typeof(Light)
export type Mode = "Auto" | "Light" | "Dark"

const Dark: Palette = {
	Header = Color3.fromHex("191B1D"),
	HeaderDark = Color3.fromHex("191B1D"),
	Blue = Color3.fromHex("00A2FF"),
	BlueHover = Color3.fromHex("32B5FF"),
	Green = Color3.fromHex("02B757"),
	GreenHover = Color3.fromHex("3FC679"),
	Red = Color3.fromHex("E2231A"),
	RedHover = Color3.fromHex("E8504A"),
	Orange = Color3.fromHex("F68802"),
	BlueText = Color3.fromHex("00A2FF"),
	GreenText = Color3.fromHex("02B757"),
	RedText = Color3.fromHex("E2231A"),
	OrangeText = Color3.fromHex("F68802"),
	Page = Color3.fromHex("232527"),
	Panel = Color3.fromHex("393B3D"),
	Control = Color3.fromHex("494B4D"),
	Border = Color3.fromHex("656668"),
	BorderDark = Color3.fromHex("989898"),
	Divider = Color3.fromHex("232527"),
	Text = Color3.fromHex("FFFFFF"),
	TextMuted = Color3.fromHex("BDBEBE"),
	Placeholder = Color3.fromHex("989898"),
	Shadow = Color3.new(0, 0, 0),
	White = Color3.new(1, 1, 1),
	Black = Color3.new(0, 0, 0),
}

Theme.Palettes = {
	Light = Light,
	Dark = Dark,
}

Theme.Context = React.createContext(Light)

function Theme.useColor(): Palette
	return React.useContext(Theme.Context)
end

Theme.Font = {
	Light = Enum.Font.SourceSansLight,
	Regular = Enum.Font.SourceSans,
	Semibold = Enum.Font.SourceSansSemibold,
	Bold = Enum.Font.SourceSansBold,
}

Theme.TextSize = {
	Small = 14,
	Body = 16,
	Title = 18,
	Heading = 20,
	Section = 24,
	Logo = 26,
}

Theme.Radius = UDim.new(0, 3)
Theme.Padding = 12

return Theme
