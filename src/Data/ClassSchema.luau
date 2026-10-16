export type Literal = {
	kind: "literal",
	value: any,
}

export type Computed = {
	kind: "computed",
	label: string,
	get: (Instance) -> any,
}

export type Prop = string | Literal | Computed

export type Out = {
	value: (any) -> (),
	literal: (any) -> (),
	child: (Instance) -> (),
	options: { [string]: any },
}

export type ClassDef = {
	id: number?,
	extends: string?,
	props: { Prop }?,
	remap: ((Instance) -> string?)?,
	after: ((Instance, Out) -> ())?,
}

export type Registry = {
	defs: { [string]: ClassDef },
	problems: { string },
	_flat: { [string]: { Prop } },
	get: (self: Registry, className: string) -> ClassDef?,
	resolve: (self: Registry, instance: Instance) -> (string, ClassDef?),
	propsFor: (self: Registry, className: string) -> { Prop },
}

const Registry = {}
Registry.__index = Registry

function Registry.get(self: Registry, className: string): ClassDef?
	return self.defs[className]
end

function Registry.resolve(self: Registry, instance: Instance): (string, ClassDef?)
	local className = instance.ClassName
	local def = self.defs[className]

	if def and def.remap then
		const remapped = def.remap(instance)
		if remapped then
			className = remapped
			def = self.defs[remapped]
		end
	end

	return className, def
end

function Registry.propsFor(self: Registry, className: string): { Prop }
	const cached = self._flat[className]
	if cached then
		return cached
	end

	const flat: { Prop } = {}
	const chain: { ClassDef } = {}
	local current: string? = className

	while current do
		const def = self.defs[current]
		if def == nil then
			break
		end

		table.insert(chain, 1, def)
		current = def.extends
	end

	for _, def in chain do
		for _, prop in def.props or {} do
			table.insert(flat, prop)
		end
	end

	self._flat[className] = flat
	return flat
end

const function isValidProp(prop: any): boolean
	if typeof(prop) == "string" then
		return true
	end

	return typeof(prop) == "table" and (prop.kind == "literal" or prop.kind == "computed")
end

const Schema = {}

function Schema.literal(value: any): Literal
	return {
		kind = "literal",
		value = value,
	}
end

function Schema.computed(label: string, get: (Instance) -> any): Computed
	return {
		kind = "computed",
		label = label,
		get = get,
	}
end

function Schema.describe(prop: Prop): string
	if typeof(prop) == "string" then
		return prop
	elseif prop.kind == "literal" then
		return tostring(prop.value)
	end

	return prop.label
end

function Schema.build(defs: { [string]: ClassDef }): Registry
	const problems = {}

	const function addProblem(message: string)
		table.insert(problems, message)
		warn(message)
	end

	for name, def in defs do
		if typeof(def) ~= "table" then
			addProblem(`{name} should be a table`)
			continue
		end

		if def.extends and defs[def.extends] == nil then
			addProblem(`{name} extends {def.extends}, which isn't in the table`)
		end
		if def.id ~= nil and typeof(def.id) ~= "number" then
			addProblem(`{name}.id should be a number`)
		end

		for index, prop in def.props or {} do
			if not isValidProp(prop) then
				addProblem(`{name}.props[{index}] should be a property name, literal(...) or computed(...)`)
			end
		end
        
		const seen = {}
		local current = name
		while current and defs[current] do
			if seen[current] then
				addProblem(`{name} has an extends loop`)
				def.extends = nil
				break
			end

			seen[current] = true
			current = defs[current].extends
		end
	end

	return setmetatable({
		defs = defs,
		problems = problems,
		_flat = {},
	}, Registry) :: any
end

return Schema
