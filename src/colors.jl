# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

# convert color scheme name to color scheme object
ascolorscheme(name::Symbol) = colorschemes[name]
ascolorscheme(name::AbstractString) = ascolorscheme(Symbol(name))
ascolorscheme(scheme) = scheme

# convert value to colorant, optinally using color scheme object
ascolor(value::Symbol, scheme) = ascolor(string(value), scheme)
ascolor(value::AbstractString, scheme) = parse(Colorant, value)
ascolor(value::CategoricalValue, scheme) = scheme[levelcode(value)]
ascolor(value, scheme) = convert(Colorant, value)

# --------------------------------
# PROCESS COLORS PROVIDED BY USER
# --------------------------------

# STEP 1: convert user input to colors
step1(values, scheme) = ascolor.(values, Ref(scheme))
step1(numbers::AbstractVector{<:Number}, scheme) =
  get(scheme, numbers, :extrema)

# STEP 2: add transparency to colors
step2(colors, alphas) = coloralpha.(colors, alphas)
step2(colors, alpha::Number) = coloralpha.(colors, Ref(alpha))

function process(values, scheme, alphas)
  colors = step1(values, ascolorscheme(scheme))
  step2(colors, alphas)
end