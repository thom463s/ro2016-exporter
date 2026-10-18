const SoundService = game:GetService("SoundService")

const Plugin = script.Parent
const React = require(Plugin.Packages.React)
const Exporter = require(Plugin.Exporter)
const Format = require(Plugin.Format)
const Theme = require(Plugin.Theme)

const Components = Plugin.Components
const Button = require(Components.Button)
const Checkbox = require(Components.Checkbox)
const Feedback = require(Components.Feedback)
const Header = require(Components.Header)
const LogList = require(Components.LogList)
const SectionModule = require(Components.Section)
const Segmented = require(Components.Segmented)
const SelectionCard = require(Components.SelectionCard)
const Tabs = require(Components.Tabs)

const Hooks = Plugin.Hooks
const useSelection = require(Hooks.useSelection)
const useStudioTheme = require(Hooks.useStudioTheme)

const Banner = Feedback.Banner
const DetailRow = SectionModule.DetailRow
const ProgressBar = Feedback.ProgressBar
const Section = SectionModule.Section

const e = React.createElement

const VERSION = "v1.0.0"
const CREATOR = "thom463s"

const SETTINGS_KEY = "RO2016Exporter.Options.v1"
const THEME_KEY = "RO2016Exporter.Theme.v1"
const DONE_SOUND = "rbxasset://sounds/electronicpingshort.wav"
const DONE_SOUND_LIFETIME = 3
const BANNER_DURATION = 4
const MAX_LOG_ENTRIES = 200

const HEADER_HEIGHT = 40
const TABS_HEIGHT = 40
const FOOTER_HEIGHT = 64
const BODY_TOP = HEADER_HEIGHT + TABS_HEIGHT

const NO_TARGET_TEXT = "No model set. Select one in the Explorer and press Get Selection."
const CLASS_CHECK_TEXT = "Creates every class in Data/Classes and reads each property. Anything this Studio doesn't recognise goes in the Log."

const TABS = {
	{ Id = "export", Label = "Export" },
	{ Id = "settings", Label = "Settings" },
	{ Id = "log", Label = "Log" },
}

const THEME_MODES = {
	{ Id = "Auto", Label = "Studio" },
	{ Id = "Light", Label = "Light" },
	{ Id = "Dark", Label = "Dark" },
}

type LogEntry = LogList.Entry

type ExportResult = {
	instances: number,
	chunks: number,
	strings: number,
	characters: number,
	seconds: number,
	path: string,
}

type BannerState = {
	Kind: "Success" | "Warning" | "Error",
	Text: string,
}

type ExportPageProps = {
	Target: Instance?,
	Selected: Instance?,
	LastResult: ExportResult?,
	PickSelection: () -> (),
}

type SettingsPageProps = {
	Options: { [string]: any },
	SetOption: (string, any) -> (),
	ThemeMode: Theme.Mode,
	SetThemeMode: (Theme.Mode) -> (),
	ResetOptions: () -> (),
	CheckClasses: () -> (),
}

type LogPageProps = {
	Log: { LogEntry },
	ClearLog: () -> (),
}

type Props = {
	Plugin: Plugin,
}

const function loadOptions(plugin: Plugin)
	const options = table.clone(Exporter.DEFAULT_OPTIONS)
	const success, saved = pcall(plugin.GetSetting, plugin, SETTINGS_KEY)

	if success and typeof(saved) == "table" then
		for key, value in saved do
			if options[key] ~= nil and typeof(value) == typeof(options[key]) then
				options[key] = value
			end
		end
	end

	return options
end

const function loadThemeMode(plugin: Plugin): Theme.Mode
	const success, saved = pcall(plugin.GetSetting, plugin, THEME_KEY)
	if success and (saved == "Auto" or saved == "Light" or saved == "Dark") then
		return saved
	end
	return "Auto"
end

const function playDoneSound()
	pcall(function()
		const sound = Instance.new("Sound")
		sound.SoundId = DONE_SOUND
		SoundService:PlayLocalSound(sound)

		task.delay(DONE_SOUND_LIFETIME, function()
			sound:Destroy()
		end)
	end)
end

type SmallTextProps = {
	Text: string,
	Color: Color3?,
	LayoutOrder: number,
}

const function SmallText(props: SmallTextProps)
	const Color = Theme.useColor()

	return e("TextLabel", {
		LayoutOrder = props.LayoutOrder,
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		Font = Theme.Font.Regular,
		Text = props.Text,
		TextSize = 14,
		TextColor3 = props.Color or Color.TextMuted,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextWrapped = true,
	})
end

const function ExportPage(props: ExportPageProps)
	const Color = Theme.useColor()
	const target = props.Target
	const selected = props.Selected
	const lastResult = props.LastResult
	const sameAsSelection = selected ~= nil and selected == target

	return e(React.Fragment, nil, {
		Target = e(Section, {
			Title = "Model",
			LayoutOrder = 1,
			Action = {
				Text = "Get Selection",
				Width = 100,
				Disabled = selected == nil or sameAsSelection,
				OnActivated = props.PickSelection,
			},
		}, {
			Card = e(SelectionCard, {
				LayoutOrder = 1,
				Instance = target,
				EmptyText = NO_TARGET_TEXT,
			}),
		}),

		Output = e(Section, {
			Title = "Output",
			LayoutOrder = 2,
			Gap = 6,
		}, {
			Where = if lastResult
				then e(SmallText, { LayoutOrder = 1, Text = `Saved to {lastResult.path}`, Color = Color.Text })
				else e(SmallText, { LayoutOrder = 1, Text = "Nothing exported yet." }),
			Paste = e(SmallText, { LayoutOrder = 2, Text = "Copy each value in order into the RO2016 Importer." }),
		}),

		Last = lastResult and e(Section, {
			Title = "Last Export",
			LayoutOrder = 3,
			Gap = 2,
		}, {
			Instances = e(DetailRow, {
				LayoutOrder = 1,
				Label = "Instances",
				Value = Format.number(lastResult.instances),
			}),
			Values = e(DetailRow, {
				LayoutOrder = 2,
				Label = "Values",
				Value = Format.number(lastResult.chunks),
			}),
			Strings = e(DetailRow, {
				LayoutOrder = 3,
				Label = "Strings",
				Value = Format.number(lastResult.strings),
			}),
			Characters = e(DetailRow, {
				LayoutOrder = 4,
				Label = "Characters",
				Value = Format.number(lastResult.characters),
			}),
			Time = e(DetailRow, {
				LayoutOrder = 5,
				Label = "Time",
				Value = string.format("%.2f seconds", lastResult.seconds),
			}),
		}),
	})
end

const function SettingsPage(props: SettingsPageProps)
	const options = props.Options
	const setOption = props.SetOption

	const function bindOption(key: string)
		return function(value: boolean)
			setOption(key, value)
		end
	end

	return e(React.Fragment, nil, {
		Export = e(Section, {
			Title = "Export Settings",
			LayoutOrder = 1,
		}, {
			Names = e(Checkbox, {
				LayoutOrder = 1,
				Label = "Import names",
				Description = "Keep every instance's Name. Makes the output a lot bigger.",
				Checked = options.processNames,
				OnChange = bindOption("processNames"),
			}),
			Strings = e(Checkbox, {
				LayoutOrder = 2,
				Label = "Import strings",
				Description = "Keep string properties like Text and StringValue.Value.",
				Checked = options.processStrings,
				OnChange = bindOption("processStrings"),
			}),
			Anchor = e(Checkbox, {
				LayoutOrder = 3,
				Label = "Anchor parts",
				Description = "Export every part as anchored. Your model isn't changed.",
				Checked = options.anchorParts,
				OnChange = bindOption("anchorParts"),
			}),
			Debug = e(Checkbox, {
				LayoutOrder = 4,
				Label = "Debug table",
				Description = "Label every value with its property name. The importer can't read this.",
				Checked = options.debugTable,
				OnChange = bindOption("debugTable"),
			}),
		}),

		Appearance = e(Section, {
			Title = "Theme",
			LayoutOrder = 2,
			Gap = 8,
		}, {
			Modes = e(Segmented, {
				LayoutOrder = 1,
				Options = THEME_MODES,
				Selected = props.ThemeMode,
				OnSelect = props.SetThemeMode,
			}),
			Text = e(SmallText, { LayoutOrder = 2, Text = "Studio follows the theme set in Studio's settings." }),
		}),

		Classes = e(Section, {
			Title = "Class Table",
			LayoutOrder = 3,
			Action = {
				Text = "Check",
				Width = 70,
				OnActivated = props.CheckClasses,
			},
		}, {
			Text = e(SmallText, { LayoutOrder = 1, Text = CLASS_CHECK_TEXT }),
		}),

		Reset = e(Button, {
			LayoutOrder = 4,
			Text = "Reset Settings",
			Variant = "Control",
			Size = "Small",
			Width = UDim.new(0, 130),
			OnActivated = props.ResetOptions,
		}),

		About = e(Section, {
			Title = "About",
			LayoutOrder = 5,
			Gap = 2,
		}, {
			Creator = e(DetailRow, {
				LayoutOrder = 1,
				Label = "Created by",
				Value = CREATOR,
			}),
			Version = e(DetailRow, {
				LayoutOrder = 2,
				Label = "Version",
				Value = VERSION,
			}),
		}),
	})
end

const function LogPage(props: LogPageProps)
	return e(Section, {
		Title = "Log",
		LayoutOrder = 1,
		Gap = 0,
		Action = if #props.Log > 0
			then {
				Text = "Clear",
				Width = 60,
				OnActivated = props.ClearLog,
			}
			else nil,
	}, {
		List = e(LogList, {
			Entries = props.Log,
			LayoutOrder = 1,
		}),
	})
end

const function App(props: Props)
	const plugin = props.Plugin
	const selected = useSelection()

	const options, setOptions = React.useState(function()
		return loadOptions(plugin)
	end)

	const studioTheme = useStudioTheme()
	const themeMode, setThemeMode = React.useState(function()
		return loadThemeMode(plugin)
	end)
	const Color = Theme.Palettes[if themeMode == "Auto" then studioTheme else themeMode]

	const tab, setTab = React.useState("export")
	const target, setTarget = React.useState(nil :: Instance?)
	const busy, setBusy = React.useState(false)
	const progress, setProgress = React.useState(0)
	const banner, setBanner = React.useState(nil :: BannerState?)
	const log, setLog = React.useState({} :: { LogEntry })
	const lastResult, setLastResult = React.useState(nil :: ExportResult?)

	const setOption = React.useCallback(function(key: string, value: any)
		setOptions(function(previous)
			const nextOptions = table.clone(previous)
			nextOptions[key] = value
			return nextOptions
		end)
	end, {})

	React.useEffect(function()
		pcall(plugin.SetSetting, plugin, SETTINGS_KEY, options)
	end, { options })

	React.useEffect(function()
		pcall(plugin.SetSetting, plugin, THEME_KEY, themeMode)
	end, { themeMode })

	React.useEffect(function()
		if banner == nil then
			return nil
		end

		const thread = task.delay(BANNER_DURATION, function()
			setBanner(nil)
		end)

		return function()
			pcall(task.cancel, thread)
		end
	end, { banner })

	React.useEffect(function()
		if target == nil then
			return nil
		end

		const connection = target.Destroying:Connect(function()
			setTarget(nil)
		end)

		return function()
			connection:Disconnect()
		end
	end, { target })

	const addLog = React.useCallback(function(level: string, text: string)
		setLog(function(previous)
			const nextLog = table.clone(previous)
			table.insert(nextLog, {
				Level = level,
				Text = text,
				Time = os.date("%H:%M:%S"),
			})

			while #nextLog > MAX_LOG_ENTRIES do
				table.remove(nextLog, 1)
			end

			return nextLog
		end)
	end, {})

	const function runExport()
		if busy or target == nil then
			return
		end

		const model = target
		const exportOptions = table.clone(options)
		setBusy(true)
		setProgress(0)
		addLog("info", `Collecting model data for {model:GetFullName()}...`)

		task.spawn(function()
			const success, result = pcall(Exporter.export, model, exportOptions, {
				onProgress = setProgress,
				onWarning = function(message)
					addLog("warning", message)
				end,
			})
			setBusy(false)

			if success then
				const path = result.folder:GetFullName()
				setLastResult({
					instances = result.instances,
					chunks = result.chunks,
					strings = result.strings,
					characters = result.characters,
					seconds = result.seconds,
					path = path,
				})

				const summary = string.format(
					"Saved data to %s! %s instances, %d value(s), %s characters in %.2fs.",
					path,
					Format.number(result.instances),
					result.chunks,
					Format.number(result.characters),
					result.seconds
				)
				addLog("success", summary)

				if exportOptions.debugTable then
					addLog(
						"warning",
						"Debug table was on: this output is for reading only, the importer can't load it."
					)
				end

				setBanner({ Kind = "Success", Text = `Saved data to {path}!` })
				playDoneSound()
			else
				addLog("error", tostring(result))
				setBanner({ Kind = "Error", Text = "Export failed. See the Log tab." })
			end
		end)
	end

	local page
	if tab == "export" then
		page = e(ExportPage, {
			Target = target,
			Selected = selected,
			LastResult = lastResult,
			
			PickSelection = function()
				setTarget(selected)
			end,
		})
	elseif tab == "settings" then
		page = e(SettingsPage, {
			Options = options,
			SetOption = setOption,
			ThemeMode = themeMode,
			SetThemeMode = setThemeMode,
			ResetOptions = function()
				setOptions(table.clone(Exporter.DEFAULT_OPTIONS))
				setThemeMode("Auto")
			end,
			CheckClasses = function()
				const problems = Exporter.checkClasses()
				if #problems == 0 then
					addLog("success", "Class table OK: every class and property was found.")
					setBanner({ Kind = "Success", Text = "Class table OK" })
				else
					for _, problem in problems do
						addLog("warning", problem)
					end
					setBanner({
						Kind = "Warning",
						Text = `{#problems} class table issue(s). See the Log.`,
					})
				end
			end,
		})
	else
		page = e(LogPage, {
			Log = log,
			ClearLog = function()
				setLog({})
			end,
		})
	end

	const buttonText = if busy
		then string.format("Exporting... %d%%", math.floor(progress * 100))
		elseif target == nil then "Get a selection first"
		else "Export"

	return e(Theme.Context.Provider, { value = Color }, {
		Root = e("Frame", {
			Size = UDim2.fromScale(1, 1),
			BackgroundColor3 = Color.Page,
			BorderSizePixel = 0,
		}, {
			Header = e(Header, {
				Title = "RO2016 Exporter",
				Height = HEADER_HEIGHT,
			}),

			Tabs = e(Tabs, {
				Tabs = TABS,
				Current = tab,
				OnSelect = setTab,
				Position = UDim2.fromOffset(0, HEADER_HEIGHT),
				Height = TABS_HEIGHT,
			}),

			Banner = banner and e(Banner, {
				Kind = banner.Kind,
				Text = banner.Text,
				Position = UDim2.fromOffset(0, BODY_TOP),

				OnDismiss = function()
					setBanner(nil)
				end,
			}),

			Body = e("ScrollingFrame", {
				Position = UDim2.fromOffset(0, BODY_TOP),
				Size = UDim2.new(1, 0, 1, -(BODY_TOP + FOOTER_HEIGHT)),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				CanvasSize = UDim2.new(),
				BottomImage = "rbxassetid://1195495135",
				MidImage = "rbxassetid://1195495135",
				TopImage = "rbxassetid://1195495135",
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				ScrollingDirection = Enum.ScrollingDirection.Y,
				ScrollBarThickness = 6,
				ScrollBarImageColor3 = Color.Border,
				VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar,
			}, {
				Padding = e("UIPadding", {
					PaddingTop = UDim.new(0, Theme.Padding),
					PaddingBottom = UDim.new(0, Theme.Padding),
					PaddingLeft = UDim.new(0, Theme.Padding),
					PaddingRight = UDim.new(0, Theme.Padding),
				}),
				Layout = e("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, 16),
				}),
				[tab] = page,
			}),

			Footer = e("Frame", {
				AnchorPoint = Vector2.new(0, 1),
				Position = UDim2.fromScale(0, 1),
				Size = UDim2.new(1, 0, 0, FOOTER_HEIGHT),
				BackgroundColor3 = Color.Panel,
				BorderSizePixel = 0,
				ZIndex = 2,
			}, {
				Shadow = e("UIShadow", {
					Color = Color.Shadow,
					Transparency = 0.8,
					Offset = UDim2.fromOffset(0, -1),
					BlurRadius = UDim.new(0, 4),
				}),
				Progress = busy and e("Frame", {
					Position = UDim2.fromOffset(Theme.Padding, 5),
					Size = UDim2.new(1, -Theme.Padding * 2, 0, 6),
					BackgroundTransparency = 1,
				}, {
					Bar = e(ProgressBar, {
						Progress = progress
					}),
				}),
				Action = e("Frame", {
					AnchorPoint = Vector2.new(0, 1),
					Position = UDim2.new(0, Theme.Padding, 1, -Theme.Padding),
					Size = UDim2.new(1, -Theme.Padding * 2, 0, 40),
					BackgroundTransparency = 1,
				}, {
					Button = e(Button, {
						Text = buttonText,
						Variant = "Primary",
						Size = "Large",
						Disabled = busy or target == nil,
						OnActivated = runExport,
					}),
				}),
			}),
		}),
	})
end

return App
