const ChangeHistoryService = game:GetService("ChangeHistoryService")
const HttpService = game:GetService("HttpService")

const Plugin = script.Parent

const Data = Plugin.Data
const Classes = require(Data.Classes)
const ClassSchema = require(Data.ClassSchema)
const SpecialStrings = require(Data.SpecialStrings)

const PLACEHOLDER = "instance placeholder"
const YIELD_INTERVAL = 500
const SERIALIZE_PROGRESS = 0.85
const STRINGIFY_PROGRESS = 0.9

const URL_PATTERNS = {
	"rbxassetid://",
	"rbxassetid:/",
	"http://roblox%.com/asset/%?id=",
	"https://roblox%.com/asset/%?id=",
	"http://roblox%.com/asset%?id=",
	"https://roblox%.com/asset%?id=",
	"http://www%.roblox%.com/asset/%?id=",
	"https://www%.roblox%.com/asset/%?id=",
	"http://www%.roblox%.com/asset%?id=",
	"https://www%.roblox%.com/asset%?id=",
}

export type Options = {
	processNames: boolean,
	processStrings: boolean,
	debugTable: boolean,
	anchorParts: boolean,
}

export type Hooks = {
	onWarning: ((string) -> ())?,
	onProgress: ((number) -> ())?,
}

export type Result = {
	folder: Folder,
	chunks: number,
	characters: number,
	instances: number,
	strings: number,
	seconds: number,
}

type Stats = {
	instances: number,
	strings: number,
}

type PendingReference = {
	record: {any},
	index: number,
	instance: Instance,
}

type Session = {
	target: Instance,
	options: Options,
	modelData: {{any}},
	ids: {[Instance]: number},
	pending: {PendingReference},
	strings: {[any]: number},
	pointer: number,
	special: number,
	defaultNames: {[string]: string | false},
	warned: {[string]: boolean},
	warn: (string) -> (),
	processed: number,
	onStep: () -> (),
}

const Exporter = {}

Exporter.HEADER_SIZE = 2
Exporter.CHUNK_LIMIT = 100_000
Exporter.FOLDER_NAME = "ExportFolder"

Exporter.DEFAULT_OPTIONS = {
	processNames = true,
	processStrings = true,
	debugTable = false,
	anchorParts = false,
}

const function noop(_: any)
end

const function jsonify(value: any): any
	const kind = typeof(value)

	if kind == "number" then
		const rounded = string.format("%.3f", math.round(value * 1000) / 1000)
		return tonumber(string.match(rounded, "(.-)%.?0*$"))
	elseif kind == "string" then
		const characters = table.create(#value)
		for index = 1, #value do
			const byte = string.byte(value, index)
			if byte <= 127 then
				table.insert(characters, string.char(byte))
			end
		end
		return (string.gsub(table.concat(characters), "%c", ""))
	elseif kind == "boolean" then
		return if value then 1 else 0
	end

	return value
end
Exporter.jsonify = jsonify

const function warnOnce(session: Session, key: string, message: string)
	if not session.warned[key] then
		session.warned[key] = true
		session.warn(message)
	end
end

const function intern(session: Session, key: any): number
	const existing = session.strings[key]
	if existing then
		return existing
	end

	const index = session.pointer
	session.strings[key] = index
	session.pointer += 1
	return index
end

const function defaultName(session: Session, className: string): string?
	local cached = session.defaultNames[className]
	if cached == nil then
		const success, instance = pcall(Instance.new, className)
		if success then
			cached = instance.Name
			instance:Destroy()
		else
			cached = false
		end
		session.defaultNames[className] = cached
	end

	return if cached then cached else nil
end

const function addProperty(session: Session, record: {any}, value: any)
	const kind = typeof(value)

	if kind == "string" then
		const lowered = string.lower(value)
		if #lowered == 0 then
			table.insert(record, -1)
			return
		end

		local assetId
		for _, pattern in URL_PATTERNS do
			assetId = string.match(lowered, pattern .. "(%d+)")
			if assetId then
				break
			end
		end

		if assetId then
			table.insert(record, assetId)
		elseif session.options.processStrings then
			table.insert(record, intern(session, tonumber(value) or jsonify(value)))
		else
			table.insert(record, session.strings[lowered] or 0)
		end
	elseif kind == "number" or kind == "boolean" then
		table.insert(record, jsonify(value))
	elseif kind == "EnumItem" then
		table.insert(record, jsonify(value.Value))
	elseif kind == "Vector2" then
		table.insert(record, jsonify(value.X))
		table.insert(record, jsonify(value.Y))
	elseif kind == "NumberRange" then
		table.insert(record, jsonify(value.Min))
		table.insert(record, jsonify(value.Max))
	elseif kind == "Vector3" then
		table.insert(record, jsonify(value.X))
		table.insert(record, jsonify(value.Y))
		table.insert(record, jsonify(value.Z))
	elseif kind == "BrickColor" then
		addProperty(session, record, value.Color)
	elseif kind == "Color3" then
		table.insert(record, jsonify(math.round(value.R * 255)))
		table.insert(record, jsonify(math.round(value.G * 255)))
		table.insert(record, jsonify(math.round(value.B * 255)))
	elseif kind == "ColorSequence" then
		table.insert(record, #value.Keypoints)
		for _, keypoint in value.Keypoints do
			table.insert(record, jsonify(keypoint.Time))
			addProperty(session, record, keypoint.Value)
		end
	elseif kind == "NumberSequence" then
		table.insert(record, #value.Keypoints)
		for _, keypoint in value.Keypoints do
			table.insert(record, jsonify(keypoint.Time))
			table.insert(record, jsonify(keypoint.Value))
			table.insert(record, jsonify(keypoint.Envelope))
		end
	elseif kind == "UDim2" then
		table.insert(record, jsonify(value.X.Scale))
		table.insert(record, jsonify(value.X.Offset))
		table.insert(record, jsonify(value.Y.Scale))
		table.insert(record, jsonify(value.Y.Offset))
	elseif kind == "Instance" then
		const id = session.ids[value]
		if id then
			table.insert(record, id)
		elseif value:IsDescendantOf(session.target) and Classes:get(value.ClassName) then
			table.insert(record, PLACEHOLDER)
			table.insert(session.pending, {
				record = record,
				index = #record,
				instance = value,
			})
		else
			table.insert(record, -1)
		end
	elseif kind == "CFrame" then
		const x, y, z = value:ToOrientation()
		addProperty(session, record, value.Position)
		addProperty(session, record, Vector3.new(math.deg(x), math.deg(y), math.deg(z)))
	elseif kind == "nil" then
		table.insert(record, -1)
	else
		warnOnce(
			session,
			`type: {kind}`,
			`Values of type {kind} can't be exported and were excluded.`
		)
	end
end

const function label(session: Session, record: {any}, text: string)
	if session.options.debugTable and #record > 0 then
		record[#record] = `{record[#record]} {text}`
	end
end

const function writeProp(
	session: Session,
	instance: Instance,
	className: string,
	prop: ClassSchema.Prop,
	record: {any}
)
	if typeof(prop) == "table" then
		if prop.kind == "literal" then
			table.insert(record, prop.value)
		else
			local success, value = pcall(prop.get, instance)
			if not success then
				const name = `{className}.{prop.label}`
				warnOnce(session, name, `{name} failed: {value}`)
				value = nil
			end
			addProperty(session, record, value)
		end
		return
	end

	const success, value = pcall(function()
		return (instance :: any)[prop]
	end)

	if not success then
		const name = `{className}.{prop}`
		warnOnce(session, name, `{name} doesn't exist in this Studio; wrote -1.`)
		table.insert(record, -1)
	elseif value == nil then
		table.insert(record, -1)
	elseif prop == "Anchored" and session.options.anchorParts then
		addProperty(session, record, 1)
	else
		addProperty(session, record, value)
	end
end

local addInstance

const function makeOut(session: Session, instance: Instance, record: {any}): ClassSchema.Out
	return {
		value = function(value)
			addProperty(session, record, value)
		end,
		literal = function(value)
			table.insert(record, value)
		end,
		child = function(child: Instance)
			addInstance(session, child, session.ids[instance])
		end,
		options = session.options,
	}
end

function addInstance(session: Session, instance: Instance, parentId: number?): boolean
	const className, def = Classes:resolve(instance)
	if def == nil then
		warnOnce(
			session,
			`class: {className}`,
			`Unable to process class {className} (it and its children were skipped).`
		)
		return false
	end

	const record = {}
	session.ids[instance] = #session.modelData
	table.insert(session.modelData, record)

	table.insert(record, def.id)
	label(session, record, "Class")
	table.insert(record, parentId or session.ids[instance.Parent :: Instance])
	label(session, record, "Parent")

	if session.options.processNames then
		const name = tonumber(instance.Name) or jsonify(instance.Name)

		if session.strings[name] then
			table.insert(record, session.strings[name])
		elseif instance.Name == defaultName(session, instance.ClassName) then
			table.insert(record, 0)
		else
			table.insert(record, intern(session, name))
		end
		label(session, record, "Name")
	end

	for _, prop in Classes:propsFor(className) do
		writeProp(session, instance, className, prop, record)
		label(session, record, ClassSchema.describe(prop))
	end

	if def.after then
		const success, message = pcall(def.after, instance, makeOut(session, instance, record))
		if not success then
			warnOnce(session, `after: {className}`, `{className} extra data failed: {message}`)
		end
	end

	if not session.options.processNames and session.strings[instance.Name] then
		table.insert(record, -1)
		table.insert(record, session.strings[instance.Name])
		label(session, record, "default name")
	end

	session.processed += 1
	session.onStep()
	return true
end

const function addChildren(session: Session, parent: Instance)
	for _, child in parent:GetChildren() do
		if addInstance(session, child, nil) then
			addChildren(session, child)
		end
	end
end

function Exporter.serialize(target: Instance, options: Options, hooks: Hooks?): ({{any}}, Stats)
	const onWarning = if hooks and hooks.onWarning then hooks.onWarning else noop
	const onProgress = if hooks and hooks.onProgress then hooks.onProgress else noop
	const total = #target:GetDescendants() + 1
	const strings = table.clone(SpecialStrings)

	local pointer = 1
	for _, index in strings do
		pointer = math.max(pointer, index)
	end
	pointer += 1

	local session: Session
	session = {
		target = target,
		options = options,
		modelData = {},
		ids = {},
		pending = {},
		strings = strings,
		pointer = pointer,
		special = pointer,
		defaultNames = {},
		warned = {},
		warn = onWarning,
		processed = 0,

		onStep = function()
			if session.processed % YIELD_INTERVAL == 0 then
				onProgress(math.min(session.processed / total, 1) * SERIALIZE_PROGRESS)
				task.wait()
			end
		end,
	}

	const headerSize = Exporter.HEADER_SIZE
	const header = { headerSize }

	table.insert(session.modelData, header)
	addProperty(session, header, options.processNames)
	addProperty(session, header, options.processStrings)

	if addInstance(session, target, 0) then
		addChildren(session, target)
	end

	local stringCount = 0
	if options.processStrings or options.processNames then
		header[headerSize + 2] = "error!!!"
		for value, index in session.strings do
			if index >= session.special then
				header[headerSize + index + 3 - session.special] = value
			end
		end
		stringCount = #header - headerSize - 2
		header[headerSize + 2] = stringCount
	end

	for _, reference in session.pending do
		reference.record[reference.index] = session.ids[reference.instance] or -1
	end

	return session.modelData, {
		instances = #session.modelData - 1,
		strings = stringCount,
	}
end

const function addTokens(tokens: {string}, value: any)
	if typeof(value) == "table" then
		for _, item in ipairs(value) do
			addTokens(tokens, item)
		end
	elseif typeof(value) == "string" then
		table.insert(tokens, value)
	else
		table.insert(tokens, string.sub(HttpService:JSONEncode({value}), 2, -2))
	end
end

function Exporter.stringify(modelData: {{any}}): {string}
	const chunks = {}
	local tokens = {}
	local length = 2

	const function flush()
		if #tokens > 0 then
			table.insert(chunks, HttpService:JSONEncode(tokens))
			tokens = {}
			length = 2
		end
	end

	for _, record in modelData do
		const recordTokens = {}
		addTokens(recordTokens, record)
		const size = #HttpService:JSONEncode(recordTokens) - 2

		if #tokens > 0 and length + 1 + size >= Exporter.CHUNK_LIMIT then
			flush()
		end
		if #tokens > 0 then
			length += 1
		end

		length += size
		table.move(recordTokens, 1, #recordTokens, #tokens + 1, tokens)
	end

	flush()
	return chunks
end

function Exporter.export(target: Instance, options: Options, hooks: Hooks?): Result
	const onProgress = if hooks and hooks.onProgress then hooks.onProgress else noop
	const started = os.clock()

	if target.Parent == nil then
		error("The target was deleted. Select it again.", 0)
	end

	const className, def = Classes:resolve(target)
	if def == nil then
		error(`{className} isn't in the class table, so it can't be exported. Add it to Data/Classes.`, 0)
	end

	const modelData, stats = Exporter.serialize(target, options, hooks)
	onProgress(STRINGIFY_PROGRESS)
	const chunks = Exporter.stringify(modelData)

	local characters = 0
	for _, chunk in chunks do
		characters += #chunk
	end

	const recordingStarted, recording = pcall(
		ChangeHistoryService.TryBeginRecording,
		ChangeHistoryService,
		`Export {target.Name}`
	)

	const success, folder = pcall(function()
		local root = workspace:FindFirstChild(Exporter.FOLDER_NAME)
		if not root then
			root = Instance.new("Folder")
			root.Name = Exporter.FOLDER_NAME
			root.Parent = workspace
		end

		const existing = root:FindFirstChild(target.Name)
		if existing then
			existing:Destroy()
		end

		const exportFolder = Instance.new("Folder")
		exportFolder.Name = target.Name

		for index, chunk in chunks do
			const stringValue = Instance.new("StringValue")
			stringValue.Name = tostring(index)
			stringValue.Value = chunk
			stringValue.Parent = exportFolder
		end

		exportFolder.Parent = root
		return exportFolder
	end)

	if recordingStarted and recording then
		const operation = if success
			then Enum.FinishRecordingOperation.Commit
			else Enum.FinishRecordingOperation.Cancel

		ChangeHistoryService:FinishRecording(recording, operation)
	end

	if not success then
		error(folder, 0)
	end
	onProgress(1)

	return {
		folder = folder,
		chunks = #chunks,
		characters = characters,
		instances = stats.instances,
		strings = stats.strings,
		seconds = os.clock() - started,
	}
end

function Exporter.checkClasses(): {string}
	const problems = table.clone(Classes.problems)
	const names = {}

	for name, def in Classes.defs do
		if def.id ~= nil then
			table.insert(names, name)
		end
	end
	table.sort(names)

	for _, name in names do
		const success, instance = pcall(Instance.new, name)
		if not success then
			table.insert(
				problems,
				`{name}: can't be created in this Studio (deprecated or not creatable)`
			)
			continue
		end

		const missing = {}
		for _, prop in Classes:propsFor(name) do
			if typeof(prop) == "string" then
				const readable = pcall(function()
					return (instance :: any)[prop]
				end)
				if not readable then
					table.insert(missing, prop)
				end
			end
		end
		instance:Destroy()

		if #missing > 0 then
			table.insert(problems, `{name}: unknown properties {table.concat(missing, ", ")}`)
		end
	end

	return problems
end

return Exporter
