# MeshViz.jl

Makie.jl recipes for visualization of [Meshes.jl](https://github.com/JuliaGeometry/Meshes.jl).

## Installation

Get the latest stable release with Julia's package manager:

```julia
] add MeshViz
```

## Usage

```julia
using Meshes, MeshViz

# choose a Makie backend
import GLMakie as Mke

using PlyIO: load_ply

function loadply(fname)
  ply = load_ply(fname)
  x = ply["vertex"]["x"]
  y = ply["vertex"]["y"]
  z = ply["vertex"]["z"]
  I = ply["face"]["vertex_indices"]
  points = Point.(x, y, z)
  connec = [connect(Tuple(i.+1)) for i in I]
  SimpleMesh(points, connec)
end

mesh = loadply("beethoven.ply")

viz(mesh, showfacets = true)
```
![beethoven](figs/beethoven.png)

```julia
mesh = loadply("dragon.ply")

# for vertex coloring pass a vector of colors
# with the same length of the number of vertices
viz(mesh, color = 1:nvertices(mesh), colorscheme = :Spectral)
```
![dragon](figs/dragon.png)

```julia
grid = CartesianGrid(10,10)

viz(grid, showfacets = true)
```
![grid2d](figs/grid2d.png)

```julia
# for element coloring pass a vector of colors
# with the same length of the number of elements
viz(grid, color = 1:nelements(grid))
```
![grid2d-color](figs/grid2d-color.png)

```julia
grid = CartesianGrid(10,10,10)

viz(grid, showfacets = true)
```
![grid3d](figs/grid3d.png)

```julia
viz(grid, color = 1:nelements(grid))
```
![grid3d-color](figs/grid3d-color.png)

```julia
using GeoTables

# Brazil states as Meshes.jl polygons
BRA = GeoTables.gadm("BRA", depth = 1)

viz(BRA.geometry)
```
![brazil](figs/brazil.png)

```julia
RIO = GeoTables.gadm("BRA", "Rio de Janeiro", depth = 1)

viz(RIO.geometry)
```
![rio](figs/rio.png)

```julia
viz(BRA.geometry, color = 1:length(BRA.geometry))
```
![brazil-color](figs/brazil-color.png)

Please check the docstring `?viz` for available attributes.
