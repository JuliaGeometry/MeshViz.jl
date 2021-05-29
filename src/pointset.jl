# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

Makie.plottype(::PointSet) = Viz{<:Tuple{PointSet}}

function Makie.plot!(plot::Viz{<:Tuple{PointSet}})
  # retrieve point set object
  pset = plot[:object][]

  # Meshes.jl attributes
  vertexcolor = plot[:vertexcolor][]

  # retrieve coordinates of points
  coords = coordinates.(pset)

  Makie.scatter!(plot, coords,
    color = vertexcolor,
  )
end
