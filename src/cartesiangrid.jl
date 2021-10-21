# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

Makie.plottype(::CartesianGrid) = Viz{<:Tuple{CartesianGrid}}

function Makie.plot!(plot::Viz{<:Tuple{CartesianGrid}})
  # retrieve point set object
  grid = plot[:object][]
  nd = embeddim(grid)
  or = coordinates(minimum(grid))
  sp = spacing(grid)
  sz = size(grid)

  # Meshes.jl attributes
  color        = plot[:color][]
  elementcolor = plot[:elementcolor][]
  facetcolor   = plot[:facetcolor][]
  showfacets   = plot[:showfacets][]

  # choose attribute with element color
  ecolor = isnothing(color) ? elementcolor : color

  if ecolor isa AbstractVector
    # create a full heatmap or volume
    xyz = cartesiancenters(or, sp, sz, nd)
    if nd == 2
      xs, ys = xyz
      xs′ = xs .- sp[1] / 2
      ys′ = ys .- sp[2] / 2
      C   = reshape(ecolor, sz)
      Makie.heatmap!(plot, xs′, ys′, C,
        colormap = plot[:colormap],
      )
    elseif nd == 3
      xs, ys, zs = xyz
      coords = [(x,y,z) for x in xs for y in ys for z in zs]
      Makie.meshscatter!(plot, coords,
        colormap = plot[:colormap],
        marker = Makie.Rect3(-sp, sp),
        markersize = 1,
        color = ecolor,
      )
    end
  else
    # create the smallest mesh of simplices
    mesh = cartesianmesh(or, sp, sz, nd)
    viz!(plot, mesh,
      elementcolor = ecolor,
      showvertices = false,
      showfacets = false
    )

    if showfacets
      # create a minimum number of segments
      xyz  = cartesiansegments(or, sp, sz, nd)
      Makie.lines!(plot, xyz...,
        color = facetcolor
      )
    end
  end
end

# helper function to create the smallest mesh
# of simplices covering the Cartesian grid
function cartesianmesh(or, sp, sz, nd)
  if nd == 2
    A = Point2(or) + Vec2(0, 0)
    B = Point2(or) + Vec2(sp[1]*sz[1], 0)
    C = Point2(or) + Vec2(sp[1]*sz[1], sp[2]*sz[2])
    D = Point2(or) + Vec2(0, sp[2]*sz[2])
    points = [A, B, C, D]
    connec = connect.([(1,2,3),(3,4,1)])
    SimpleMesh(points, connec)
  elseif nd == 3
    A = Point3(or) + Vec3(0, 0, 0)
    B = Point3(or) + Vec3(sp[1]*sz[1], 0, 0)
    C = Point3(or) + Vec3(sp[1]*sz[1], sp[2]*sz[2], 0)
    D = Point3(or) + Vec3(0, sp[2]*sz[2], 0)
    E = Point3(or) + Vec3(0, 0, sp[3]*sz[3])
    F = Point3(or) + Vec3(sp[1]*sz[1], 0, sp[3]*sz[3])
    G = Point3(or) + Vec3(sp[1]*sz[1], sp[2]*sz[2], sp[3]*sz[3])
    H = Point3(or) + Vec3(0, sp[2]*sz[2], sp[3]*sz[3])
    points = [A, B, C, D, E, F, G, H]
    connec = connect.([(1,2,3,4),(8,7,6,5),(2,1,5,6),
                       (2,6,7,3),(3,7,8,4),(4,8,5,1)])
    SimpleMesh(points, connec)
  else
    throw(ErrorException("not implemented"))
  end
end

# helper function to create a minimum number
# of line segments within Cartesian grid
function cartesiansegments(or, sp, sz, nd)
  if nd == 2
    xs = range(or[1], step=sp[1], length=sz[1]+1)
    ys = range(or[2], step=sp[2], length=sz[2]+1)
    coords = []
    for x in xs
      push!(coords, (x, first(ys)))
      push!(coords, (x, last(ys)))
      push!(coords, (NaN, NaN))
    end
    for y in ys
      push!(coords, (first(xs), y))
      push!(coords, (last(xs), y))
      push!(coords, (NaN, NaN))
    end
    x = getindex.(coords, 1)
    y = getindex.(coords, 2)
    x, y
  elseif nd == 3
    xs = range(or[1], step=sp[1], length=sz[1]+1)
    ys = range(or[2], step=sp[2], length=sz[2]+1)
    zs = range(or[3], step=sp[3], length=sz[3]+1)
    coords = []
    for y in ys, z in zs
      push!(coords, (first(xs), y, z))
      push!(coords, (last(xs), y, z))
      push!(coords, (NaN, NaN, NaN))
    end
    for x in xs, z in zs
      push!(coords, (x, first(ys), z))
      push!(coords, (x, last(ys), z))
      push!(coords, (NaN, NaN, NaN))
    end
    for x in xs, y in ys
      push!(coords, (x, y, first(zs)))
      push!(coords, (x, y, last(zs)))
      push!(coords, (NaN, NaN, NaN))
    end
    x = getindex.(coords, 1)
    y = getindex.(coords, 2)
    z = getindex.(coords, 3)
    x, y, z
  else
    throw(ErrorException("not implemented"))
  end
end

# helper function to create the center of
# the elements of the Cartesian grid
function cartesiancenters(or, sp, sz, nd)
  if nd == 2
    xs = range(or[1]+sp[1], step=sp[1], length=sz[1])
    ys = range(or[2]+sp[2], step=sp[2], length=sz[2])
    xs, ys
  elseif nd == 3
    xs = range(or[1]+sp[1], step=sp[1], length=sz[1])
    ys = range(or[2]+sp[2], step=sp[2], length=sz[2])
    zs = range(or[3]+sp[3], step=sp[3], length=sz[3])
    xs, ys, zs
  else
    throw(ErrorException("not implemented"))
  end
end
