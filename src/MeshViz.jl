module MeshViz

using Meshes
using AbstractPlotting

import AbstractPlotting: convert_arguments

convert_arguments(P::AbstractPlotting.PointBased, pset::PointSet) =
  convert_arguments(P, [coordinates(pset[i]) for i in 1:nelements(pset)])

end
