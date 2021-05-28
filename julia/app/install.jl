ENV["PYTHON"] = "/opt/conda/bin/python"

using Pkg

Pkg.activate()
Pkg.resolve()
Pkg.instantiate()
Pkg.precompile()

using IJulia
installkernel(
    "Julia",
    julia=`julia -t auto --project=@base -i --color=yes`,
)

# Force Gen to precompile
using Gen

