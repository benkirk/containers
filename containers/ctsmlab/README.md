# CTSM Training Containers
This is a proof-of-concept implementation of a layerized CTSM training container, used mostly to stress bulding containers using various runtimes.
For an actual containerizeg training application, see for example 
https://www.cesm.ucar.edu/models/cam/tutorial

## Quickstart
### Build each image, in sequence:
```pre
git clone https://github.com/benkirk/containers.git
cd containers/containers/ctsmlab
make images
```

### Run the final container:
```pre
cd ./postproc
make run
```
### or any intermediate layer:
```pre
cd ./cesm
make run
```

## Approach
The approach we take is to subdivide the final container behemoth into a number of separate layers, each depending on the previous:
1. `mpich-base`: Basic operating system with mpich MPI (from source),
2. `deps`: Scientific I/O library dependencies (HDF5, NetCDF, PnetCDF),
3. `esmf`: Earth System Modeling Framework (ESMF) layer,
4. `cesm`: CTSM from git [source](https://github.com/ESCOMP/CTSM.git), 
5. `postproc`: **incomplete**, Installs Pangeo and JupyterHub postprocessing analysis software.
