# MeshViz.jl

Makie.jl recipes for visualization of Meshes.jl objects.

## Installation

Get the latest stable release with Julia's package manager:

```julia
] add MeshViz
```

## Usage

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

viz(mesh)
```
![beethoven](figs/beethoven.png)

```julia
mesh = readply("dragon.ply")

viz(mesh,
  showfacets=false,
  elementcolor=1:nelements(mesh),
  colormap=:Spectral
)
```
![dragon](figs/dragon.png)

```julia
grid = CartesianGrid(10,10)

viz(grid)
```
![grid2d](figs/grid2d.png)

```julia
viz(grid, elementcolor=1:nelements(grid))
```
![grid2d-color](figs/grid2d-color.png)

```julia
grid = CartesianGrid(10,10,10)

viz(grid)
```
![grid3d](figs/grid3d.png)

```julia
viz(grid, elementcolor=1:nelements(grid))
```
![grid3d-color](figs/grid3d-color.png)

```julia
using GeoTables

# Brazil states as Meshes.jl polygons
BRA = GeoTables.gadm("BRA", children=true, decimation=0.02)

viz(BRA.geometry)
```
![brazil](figs/brazil.png)

```julia
RIO = GeoTables.gadm("BRA", "Rio de Janeiro", children=true)

viz(RIO.geometry, decimation=0.001)
```
![rio](figs/rio.png)

```julia
viz(BRA.geometry, elementcolor=1:length(BRA.geometry))
```
![brazil-color](figs/brazil-color.png)

Please check the docstring `?viz` for available attributes.
