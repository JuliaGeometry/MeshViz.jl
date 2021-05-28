# MeshViz.jl

Recipes for visualization of Meshes.jl objects with Makie.jl.

```julia
using Meshes, MeshViz
import GLMakie

using PlyIO

function readply(fname)
  ply = load_ply(fname)
  x = ply["vertex"]["x"]
  y = ply["vertex"]["y"]
  z = ply["vertex"]["z"]
  points = Meshes.Point.(x, y, z)
  connec = [connect(Tuple(c.+1)) for c in ply["face"]["vertex_indices"]]
  SimpleMesh(points, connec)
end

mesh = readply("beethoven.ply")

viz(mesh, showfacets=true)
```
![beethoven](beethoven.png)
