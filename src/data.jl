# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

Makie.plottype(::Data) = Viz{<:Tuple{Data}}

function Makie.plot!(plot::Viz{<:Tuple{Data}})
  # retrieve data object
  data = plot[:object][]

  # Meshes.jl attributes
  elementcolor = plot[:elementcolor][]
  vertexcolor  = plot[:vertexcolor][]
  facetcolor   = plot[:facetcolor][]
  showvertices = plot[:showvertices][]
  showfacets   = plot[:showfacets][]
  variable     = plot[:variable][]

  # retrieve domain and element table
  dom, tab = domain(data), values(data)

  # list of all variables
  variables = Tables.columnnames(tab)

  # select variable to visualize
  var = isnothing(variable) ? first(variables) : variable

  # element color from variable column
  elementcolor = Tables.getcolumn(tab, var)

  # call existing recipe for underlying domain
  viz!(plot, dom,
    colormap     = plot[:colormap],
    elementcolor = elementcolor,
    vertexcolor  = vertexcolor,
    facetcolor   = facetcolor,
    showvertices = showvertices,
    showfacets   = showfacets,
  )
end
