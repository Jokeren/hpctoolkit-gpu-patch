# Modified from https://github.com/Jokeren/compute-sanitizer-samples/tree/master/MemoryTracker
# Location of the CUDA Toolkit
CUDA_PATH ?= /usr/local/cuda
SANITIZER_PATH ?= $(CUDA_PATH)/extras/Sanitizer
CUPTI_PATH ?= $(CUDA_PATH)/extras/CUPTI

NVCC := $(CUDA_PATH)/bin/nvcc

INCLUDE_DIRS := -I$(CUDA_PATH)/include -I$(SANITIZER_PATH)/include -I$(CUPTI_PATH)/include
CXXFLAGS := $(INCLUDE_DIRS) --fatbin --keep-device-functions -Xptxas --compile-as-tools-patch

ARCHS := 50 60 70 75

# Generate SASS code for each SM architectures
$(foreach sm,$(ARCHS),$(eval GENCODE_FLAGS += -gencode arch=compute_$(sm),code=sm_$(sm)))

# Generate PTX code from the highest SM architecture in $(SMS) to guarantee forward-compatibility
HIGHEST_SM := $(lastword $(sort $(ARCHS)))
GENCODE_FLAGS += -gencode arch=compute_$(HIGHEST_SM),code=compute_$(HIGHEST_SM)

all: memory.fatbin

memory.fatbin: memory.cu
	$(NVCC) $(CXXFLAGS) $(GENCODE_FLAGS) -o $@ -c $<

clean:
	rm -f memory.fatbin
