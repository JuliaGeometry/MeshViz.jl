module MeshViz

using Meshes

import Makie

@Makie.recipe(Viz, obj) do scene
  Makie.Attributes(;
    color        = :slategray3,
    markercolor  = :black,
    strokecolor  = :black,
  )
end

# -----------
# SimpleMesh
# -----------

Makie.plottype(::SimpleMesh) = Viz{<:Tuple{SimpleMesh}}

function Makie.plot!(plot::Viz{<:Tuple{SimpleMesh}})
  mesh = plot[:obj][]

  # retrieve geometry + topology
  verts = vertices(mesh)
  topo  = topology(mesh)
  elems = elements(topo)

  # retrieve coordinates of vertices
  coords = reduce(hcat, coordinates.(verts))'

  # decompose n-gons into simplices by
  # fan triangulation (assumes convexity)
  # https://en.wikipedia.org/wiki/Fan_triangulation
  triangles = Vector{Int}[]
  for elem in elems
    inds = indices(elem)
    for i in 2:length(inds)-1
      push!(triangles, [inds[1], inds[i], inds[i+1]])
    end
  end
  faces = reduce(hcat, triangles)'

  # enable shading in 3D
  shading = embeddim(mesh) == 3

  Makie.mesh!(plot, coords, faces,
    color = plot[:color], shading = shading,
  )
end

# ---------
# PointSet
# ---------

Makie.plottype(::PointSet) = Viz{<:Tuple{PointSet}}

function Makie.plot!(plot::Viz{<:Tuple{PointSet}})
  pset = plot[:obj][]

  # retrieve coordinates of points
  coords = coordinates.(pset)

  Makie.scatter!(plot, coords,
    color = plot[:markercolor],
  )
end

end
