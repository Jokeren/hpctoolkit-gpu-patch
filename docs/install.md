# Install

The documentation includes detailed instructions for every package required by gvprof. One can use `./bin/install` to install all these packages at once.

The install script accepts three arguments in order:

```bash
./bin/install <install-prefix> <path/to/cuda> <path/to/compute-sanitizer>
# default values
# <install-prefix>=`pwd`/gvprof
# <path/to/cuda>=/usr/local/cuda
# <path/to/compute-sanitizer>=<path/to/cuda>/compute-sanitizer
```

Before you install, make sure all the CUDA related paths (e.g., `LD_LIBRARY_PATH`) are setup.

## GPU Patch

If you install cuda toolkit in somewhere else, you need to change the value of `SANITIZER_PATH`.

```bash
git clone --recursive git@github.com:Jokeren/GVProf.git
cd GVProf
make PREFIX=/path/to/gpu-patch/installation SANITIZER_PATH=/usr/local/cuda/compute-sanitizer/ install
```
## Dependencies

- spack

```bash
git clone https://github.com/spack/spack.git
export SPACK_ROOT=/path/to/spack
source ${SPACK_ROOT}/share/spack/setup-env.sh
```
- required packages

```bash
spack spec hpctoolkit
spack install --only dependencies hpctoolkit ^dyninst@master
# XXX(Keren): Temporary workaround until new hpctoolkit is merged
spack install libmonitor@master +dlopen +hpctoolkit
```

## Redshow

```bash
cd redshow
# Tip: get boost libarary path 'spack find --path' and append include to that path
make install -j8 PREFIX=/path/to/redshow/installation BOOST_DIR=/path/to/boost/installation GPU_PATH_DIR=/path/to/gpu-patch/installation
# Useful options:
# make DEBUG=1
# make OPENMP=1
```

## HPCToolkit

- profiling substrates

```bash
cd /path/to/hpctoolkit
mkdir build && cd build
# Tip: check spack libraries' root->spack find --path.  
# For example: --with-spack=/home/username/spack/opt/spack/linux-ubuntu18.04-zen/gcc-7.4.0/
../configure --prefix=/path/to/hpctoolkit/installation --with-cuda=/usr/local/cuda-11.0 --with-sanitizer=/path/to/sanitizer --with-gpu-patch=/path/to/gpu-patch/installation --with-redshow=/path/to/redshow/installation --with-spack=/path/to/spack/libraries/root --with
make install -j8
```

- hpcviewer (optional)

[http://hpctoolkit.org/download/hpcviewer/](http://hpctoolkit.org/download/hpcviewer/)

## Setup and Test

Add following lines into your `.bashrc` file and source it.

```bash
export PATH=/path/to/hpctoolkit/install/bin/:$PATH
export PATH=/path/to/GVProf/install/bin/:$PATH
export PATH=/path/to/redshow/install/bin/:$PATH
```

Test if gvprof works.

```bash
cd ./samples/vectorAdd.f32
make
gvprof -e redundancy ./vectorAdd
hpcviewer gvprof-database
```