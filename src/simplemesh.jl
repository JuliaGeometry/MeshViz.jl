# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

Makie.plottype(::SimpleMesh) = Viz{<:Tuple{SimpleMesh}}

function Makie.plot!(plot::Viz{<:Tuple{SimpleMesh}})
  # retrieve mesh object
  mesh = plot[:object]
  rank = paramdim(mesh[])

  # different recipes for meshes with
  # 1D, 2D, 3D, ... ND simplices
  if rank == 1
    # visualize segments
    viz1D!(plot, mesh)
  elseif rank == 2
    # visualize polygons
    viz2D!(plot, mesh)
  elseif rank == 3
    # visualize polyhedra
    viz3D!(plot, mesh)
  end
end

function viz1D!(plot, mesh)
  color       = plot[:color][]
  alpha       = plot[:alpha][]
  colorscheme = plot[:colorscheme][]
  facetcolor  = plot[:facetcolor][]
  showfacets  = plot[:showfacets][]

  # process color spec into colorant
  colorant = process(color, colorscheme, alpha)

  # retrieve vertices and topology
  vert = vertices(mesh)
  topo = topology(mesh)

  # visualize segments
  coords = segmentsof(topo, vert)
  Makie.lines!(plot, coords,
    color = colorant,
  )

  if showfacets
    # TODO
  end
end

function viz2D!(plot, mesh)
  color       = plot[:color][]
  alpha       = plot[:alpha][]
  colorscheme = plot[:colorscheme][]
  facetcolor  = plot[:facetcolor][]
  showfacets  = plot[:showfacets][]

  # process color spec into colorant
  colorant = process(color, colorscheme, alpha)

  # relevant settings
  makie_mesh = map(mesh) do mesh
    dim   = embeddim(mesh)
    nvert = nvertices(mesh)
    nelem = nelements(mesh)
    verts = vertices(mesh)
    topo  = topology(mesh)
    elems = elements(topo)

    # coordinates of vertices
    coords = coordinates.(verts)

    # fan triangulation (assume convexity)
    tris4elem = map(elems) do elem
      I = indices(elem)
      [[I[1], I[i], I[i+1]] for i in 2:length(I)-1]
    end

    # flatten vector of triangles
    tris = [tri for tris in tris4elem for tri in tris]

    # element vs. vertex coloring
    if colorant isa AbstractVector
      ncolor = length(colorant)
      if ncolor == nelem # element coloring
        # duplicate vertices and adjust
        # connectivities to avoid linear
        # interpolation of colors
        nt = 0
        elem4tri = Dict{Int,Int}()
        for e in 1:nelem
          Δs = tris4elem[e]
          for _ in 1:length(Δs)
            nt += 1
            elem4tri[nt] = e
          end
        end
        nv = 3nt
        tcoords = [coords[i] for tri in tris for i in tri]
        tconnec = [collect(I) for I in Iterators.partition(1:nv, 3)]
        tcolors = map(1:nv) do i
          t = ceil(Int, i/3)
          e = elem4tri[t]
          colorant[e]
        end
      elseif ncolor == nvert # vertex coloring
        # nothing needs to be done because
        # this is the default in Makie and
        # because the triangulation above
        # does not change the vertices in
        # the original polygonal mesh
        tcoords = coords
        tconnec = tris
        tcolors = colorant
      else
        throw(ArgumentError("Provided $ncolor colors but the mesh has
                             $nvert vertices and $nelem elements"))
      end
    else # single color
      # nothing needs to be done
      tcoords  = coords
      tconnec  = tris
      tcolors  = colorant
    end

    # convert connectivities to matrix format
    tmatrix = reduce(hcat, tconnec) |> transpose

    # enable shading in 3D
    shading = dim == 3

    return Makie.convert_arguments(Makie.Mesh, tcoords, tmatrix)[1]
  end

  Makie.mesh!(plot, makie_mesh, color=:brown, shading=true)

  if showfacets
    # use a sophisticated data structure
    # to extract the edges from the n-gons
    t = convert(HalfEdgeTopology, topo)
    ∂ = Boundary{1,0}(t)

    # append indices of incident vertices
    # interleaved with a sentinel index
    inds = Int[]
    for i in 1:nfacets(t)
      append!(inds, ∂(i))
      push!(inds, nvert+1)
    end

    # fill sentinel index with NaN coordinates
    push!(coords, Vec(ntuple(i->NaN, dim)))

    # extract incident vertices
    coords = coords[inds]

    # split coordinates to match signature
    xyz = [getindex.(coords, j) for j in 1:dim]

    Makie.lines!(plot, xyz...,
      color = facetcolor,
    )
  end
end

function viz3D!(plot, mesh)
  geoms  = elements(mesh)
  bounds = boundary.(geoms)
  meshes = discretize.(bounds)
  vizmany!(plot, meshes)
end

function segmentsof(topo, vert)
  dim = embeddim(first(vert))
  nan = Vec(ntuple(i->NaN, dim))
  xs  = coordinates.(vert)

  coords = map(elements(topo)) do e
    inds = indices(e)
    xs[collect(inds)]
  end

  reduce((x,y) -> [x; [nan]; y], coords)
end

function segmentsof(topo::GridTopology, vert)
  xs = coordinates.(vert)
  ip = first(isperiodic(topo))
  ip ? [xs; [first(xs)]] : xs
end