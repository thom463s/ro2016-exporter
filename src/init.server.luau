const Plugin = script
const React = require(Plugin.Packages.React)
const ReactRoblox = require(Plugin.Packages.ReactRoblox)
const App = require(Plugin.App)

const TITLE = "RO2016 Exporter"
const WIDGET_ID = "RO2016Exporter"
const ICON = "rbxassetid://103468893915862"

const toolbar = plugin:CreateToolbar(TITLE)
const button = toolbar:CreateButton(TITLE, "Open or close the object exporter", ICON)
button.ClickableWhenViewportHidden = true

const widgetInfo = DockWidgetPluginGuiInfo.new(
	Enum.InitialDockState.Left,
	false,
	false,
	340,
	560,
	280,
	420
)

const widget = plugin:CreateDockWidgetPluginGuiAsync(WIDGET_ID, widgetInfo)
widget.Name = WIDGET_ID
widget.Title = TITLE
widget.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

button:SetActive(widget.Enabled)
button.Click:Connect(function()
    widget.Enabled = not widget.Enabled
end)

widget:GetPropertyChangedSignal("Enabled"):Connect(function()
    button:SetActive(widget.Enabled)
end)

const app = React.createElement(App, { plugin = plugin })
const root = ReactRoblox.createRoot(Instance.new("Folder"))
root:render(ReactRoblox.createPortal(app, widget))

plugin.Unloading:Connect(function()
    root:unmount()
end)
