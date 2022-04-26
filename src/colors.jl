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

# --------------------------------
# PROCESS COLORS PROVIDED BY USER
# --------------------------------

# STEP 1: convert user input to colors
step1(numbers::AbstractVector{<:Number}, scheme) =
  get(ascolorscheme(scheme), numbers, :extrema)
step1(specs, scheme) = ascolor.(specs)

# STEP 2: add transparency to colors
step2(colors, alphas) = coloralpha.(colors, alphas)
step2(colors, alpha::Number) = coloralpha.(colors, Ref(alpha))

function process(values, scheme, alphas)
  colors = step1(values, scheme)
  step2(colors, alphas)
end