module MeshViz

using Meshes

import Makie
import Makie: convert_arguments
import Makie: plottype

# ---------
# PointSet
# ---------

plottype(::PointSet) = Makie.Scatter

convert_arguments(P::Type{<:Makie.Scatter}, pset::PointSet) =
  convert_arguments(P, coordinates.(pset))

# -----------
# SimpleMesh
# -----------

plottype(::SimpleMesh) = Makie.Mesh

function convert_arguments(P::Type{<:Makie.Mesh}, mesh::SimpleMesh)
  # retrieve geometry + topology
  verts = vertices(mesh)
  topo  = topology(mesh)
  elems = elements(topo)

  # convert to Julia arrays
  coords = reduce(hcat, coordinates(v) for v in verts)'
  connec = reduce(hcat, collect(indices(e)) for e in elems)'

  convert_arguments(P, coords, connec)
end

end
