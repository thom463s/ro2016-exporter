const Format = {}

function Format.number(n: number): string
    const s = tostring(math.floor(n))
    const sign, digits = string.match(s, "^(-?)(%d+)$")
    if not digits then
        return s
    end
    local grouped = string.reverse((string.gsub(string.reverse(digits), "(%d%d%d)", "%1,")))
	grouped = string.gsub(grouped, "^,", "")
	return sign .. grouped
end

return Format
