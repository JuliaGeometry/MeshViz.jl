# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

# convert value to colorant, optionally using color scheme object
ascolor(value::Symbol, scheme) = ascolor(string(value), scheme)
ascolor(value::AbstractString, scheme) = parse(Colorant, value)
ascolor(value::CategoricalValue, scheme) = scheme[levelcode(value)]
ascolor(value::Missing, scheme) = parse(Colorant, "rgba(0,0,0,0)")
ascolor(value, scheme) = convert(Colorant, value)

# convert color scheme name to color scheme object
ascolorscheme(name::Symbol) = colorschemes[name]
ascolorscheme(name::AbstractString) = ascolorscheme(Symbol(name))
ascolorscheme(scheme) = scheme

# default color scheme for values
defaultscheme(values) = defaultscheme(elscitype(values))
defaultscheme(::Type{Unknown}) = colorschemes[:viridis]
defaultscheme(::Type{Continuous}) = colorschemes[:viridis]
defaultscheme(::Type{Count}) = colorschemes[:viridis]
defaultscheme(::Type{Multiclass{N}}) where {N} =
  distinguishable_colors(N, transform=protanopic)
defaultscheme(::Type{OrderedFactor{N}}) where {N} =
  distinguishable_colors(N, transform=protanopic)

# --------------------------------
# PROCESS COLORS PROVIDED BY USER
# --------------------------------

# STEP 0: find adequate color scheme for values
step0(values::AbstractVector, scheme) =
  isnothing(scheme) ? defaultscheme(values) : scheme
step0(value, scheme) = scheme

# STEP 1: convert user input to colors
step1(values, scheme) = ascolor.(values, Ref(scheme))
function step1(numbers::AbstractVector{V}, scheme) where {V<:Union{Number,Missing}}
  # find indices with invalid and valid numbers
  isinvalid(v) = ismissing(v) || isnan(v)
  iinds = findall(isinvalid, numbers)
  vinds = setdiff(1:length(numbers), iinds)

  # invalid numbers are assigned full transparency
  icolors = parse(Colorant, "rgba(0,0,0,0)")

  # valid numbers are assigned colors from scheme
  vnumbers = Number.(numbers[vinds])
  vcolors  = get(scheme, vnumbers, :extrema)

  # build final vector of colors
  colors = Vector{Colorant}(undef, length(numbers))
  colors[iinds] .= icolors
  colors[vinds] .= vcolors

  colors
end

# STEP 2: add transparency to colors
step2(colors, alphas) = coloralpha.(colors, alphas)
step2(colors, alpha::Number) = coloralpha.(colors, Ref(alpha))

function process(values, scheme, alphas)
  scheme = step0(values, scheme)
  colors = step1(values, ascolorscheme(scheme))
  step2(colors, alphas)
end