# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

# convert color spec to color object
ascolor(spec::AbstractString) = parse(Colorant, spec)
ascolor(spec::Symbol) = ascolor(string(spec))
ascolor(color) = color

# convert color scheme name to color scheme object
ascolorscheme(name::Symbol) = colorschemes[name]
ascolorscheme(name::AbstractString) = ascolorscheme(Symbol(name))
ascolorscheme(scheme) = scheme

# process colors provided by user into final format
process(numbers::AbstractVector{<:Number}, scheme) =
  get(ascolorscheme(scheme), numbers, :extrema)
process(specs, scheme) = ascolor.(specs)