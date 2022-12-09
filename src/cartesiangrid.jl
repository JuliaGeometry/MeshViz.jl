# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

Makie.plottype(::CartesianGrid) = Viz{<:Tuple{CartesianGrid}}

function Makie.plot!(plot::Viz{<:Tuple{CartesianGrid}})
  # retrieve grid object
  grid = plot[:object][]

  color        = plot[:color]
  alpha        = plot[:alpha][]
  colorscheme  = plot[:colorscheme][]
  facetcolor   = plot[:facetcolor][]
  showfacets   = plot[:showfacets][]

  # process color spec into colorant
  colorant = Makie.@lift process($color, colorscheme, alpha)

  # relevant settings
  nd = embeddim(grid)
  or = coordinates(minimum(grid))
  sp = spacing(grid)
  sz = size(grid)

  if colorant[] isa AbstractVector
    # create a full heatmap or volume
    xyz = cartesiancenters(or, sp, sz, nd)
    if nd == 1
      # rely on recipe for simplices
      xs, ys = xyz
      xs⁻ = [(xs .- sp[1] / 2); (last(xs) + sp[1] / 2)]
      ys⁻ = [ys; last(ys)]
      vert = [Point(x, y) for (x,y) in zip(xs⁻, ys⁻)]
      topo = topology(grid)
      mesh = SimpleMesh(collect(vert), topo)
      viz!(plot, mesh,
        color = color,
        alpha = alpha,
        colorscheme = colorscheme,
        showfacets = showfacets,
        facetcolor = facetcolor,
      )
    elseif nd == 2
      xs, ys = xyz
      C = Makie.@lift reshape($colorant, sz)
      Makie.heatmap!(plot, xs, ys, C)
    elseif nd == 3
      xs, ys, zs = xyz
      xs⁺ = xs .+ sp[1]/2
      ys⁺ = ys .+ sp[2]/2
      zs⁺ = zs .+ sp[3]/2
      coords = [(x,y,z) for x in xs⁺ for y in ys⁺ for z in zs⁺]
      Makie.meshscatter!(plot, coords,
        marker = Makie.Rect3(-1 .* sp, sp),
        markersize = 1,
        color = colorant,
      )
    end
  else
    # create the smallest mesh of simplices
    mesh = cartesianmesh(or, sp, sz, nd)
    viz!(plot, mesh,
      color = color,
      alpha = alpha,
      showfacets = false
    )
  end

  if showfacets
    # create a minimum number of segments
    xyz = cartesiansegments(or, sp, sz, nd)
    Makie.lines!(plot, xyz...,
      color = facetcolor
    )
  end
end

# helper function to create the smallest mesh
# of simplices covering the Cartesian grid
function cartesianmesh(or, sp, sz, nd)
  if nd == 1
    A = Point2(or[1], 0) + Vec2(0, 0)
    B = Point2(or[1], 0) + Vec2(sp[1]*sz[1], 0)
    points = [A, B]
    topo   = GridTopology(1)
    SimpleMesh(points, topo)
  elseif nd == 2
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
    connec = connect.([(4,3,2,1),(5,6,7,8),(6,5,1,2),
                       (3,7,6,2),(4,8,7,3),(1,5,8,4)])
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
  if nd == 1
    xs = range(or[1]+sp[1]/2, step=sp[1], length=sz[1])
    ys = fill(0.0, sz[1])
    xs, ys
  elseif nd == 2
    xs = range(or[1]+sp[1]/2, step=sp[1], length=sz[1])
    ys = range(or[2]+sp[2]/2, step=sp[2], length=sz[2])
    xs, ys
  elseif nd == 3
    xs = range(or[1]+sp[1]/2, step=sp[1], length=sz[1])
    ys = range(or[2]+sp[2]/2, step=sp[2], length=sz[2])
    zs = range(or[3]+sp[3]/2, step=sp[3], length=sz[3])
    xs, ys, zs
  else
    throw(ErrorException("not implemented"))
  end
end
