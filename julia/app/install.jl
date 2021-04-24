using Pkg

Pkg.activate()
Pkg.resolve()
Pkg.instantiate()
Pkg.precompile()

using IJulia
installkernel(
    "Julia",
    julia=`julia -p auto -t auto --project=@base -i --color=yes`,
)
