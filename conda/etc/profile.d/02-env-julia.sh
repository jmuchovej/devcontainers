[ echo ${CONTAINER} | grep -c "julia" ] && exit 0

# enable multi-threading
export JULIA_NUM_THREADS="$(nproc)"

# Allow for Probmods to be run as a kernel
export IJULIA_KERNEL="$(find ${JULIA_DEPOT_PATH}/packages/IJulia -name "kernel.jl" | head -1)"