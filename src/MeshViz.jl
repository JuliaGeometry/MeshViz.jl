module MeshViz

using Meshes
using Makie

import Makie: convert_arguments, plottype

# ---------
# PointSet
# ---------

plottype(::PointSet) = Makie.Scatter

convert_arguments(P::Type{<:Makie.Scatter}, pset::PointSet) =
  convert_arguments(P, map(coordinates, pset))

# -----------
# SimpleMesh
# -----------

plottype(::SimpleMesh) = Makie.Mesh

function convert_arguments(P::Type{<:Makie.Mesh}, mesh::SimpleMesh)
  topo  = topology(mesh)
  verts = vertices(mesh)
  elems = elements(topo)
  coord = reduce(hcat, coordinates.(verts))'
  faces = reduce(hcat, collect.(indices.(elems)))'
  convert_arguments(P, coord, faces)
end

end
