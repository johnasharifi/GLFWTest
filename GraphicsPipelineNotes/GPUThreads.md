# Overview

Description of threading on GPU.

# GPU SIMD execution model

GPUs are 
- SIMD (single instruction multiple data type, sometimes SIMT - single instruction multiple thread) across warps, but 
- MIMD (multiple instructions, multiple data types) in general.

https://web.cs.ucdavis.edu/~amenta/f15/amenta-cuda.pdf

Simliar to a PRAM (Parallel Random Access Machine) but you need to use a strategy to resolve conflicting read/write issues:
- exclusive read, exclusive write (EREW): one processor can read, one processor can write
- concurrent read, exclusive write (CREW): every processor can read, one processor can write

or be very careful when using these techniques which pose a risk for mutating data in an undesired order:
- exclusive read, concurrent write (ERCW): one processor can read, all processors can write
- concurrent read, concurrent write (CRCW): every processor can read and write every memory cell

or use a technique like double buffering or having a read/write and a display chunk of memory.

# Threads

GPU vs CPU:

- GPU: threads are lightweight. CPU: higher overhead per thread
- GPU: threads must be occupied to be efficient. CPU: threads should be released when unused

Hierarchy of concurrent threads:

- kernels abstract away the mass of the problem to a series of steps per coordinate
- thread groups run in parallel
- threads execute per coordinate

Each thread may have its own register, but pull data from a shared "parallel data cache".

DRAM is dynamic random access mmeory. Accessing 1 byte of DRAM (at random location) is same cost as accessing 128 consecutive bytes.

# Waves

GCN - "graphics core next"
https://en.wikipedia.org/wiki/Graphics_Core_Next
https://gpuopen.com/learn/optimizing-gpu-occupancy-resource-usage-large-thread-groups/

Each Graphics Core Next (GCN) Compute Unit (CU) must run a thread-group of scheduled work, or wave, of 64 threads.
Each of the four SIMDs on the CU can schedule up to 10 concurrent waves.
The ComputeUnit may pause a wave and begin executing another concurrent wave, if one of the waves is waiting on memory operations.
There are buffers per ComputeUnit which we may wish to use, in which case we can gain efficiency by making sure our buffers are always full of useful data per each ComputeUnit.

# Registers, cache

https://www.ce.jhu.edu/dalrymple/classes/602/Class13.pdf

Each thread has a register which contains data specific to that thread.
Threads all have access to a shared
- texture cache and
- constant cache

Memory: 
- fast: shared memory which can be accessed by any thread
- fast: registers per thread
- fast: constant / compiled values
- slow: local memory, global memory. This is where compiler stores things which could not fit into registers, e.g. int[10]

Memory access occurs in chunks of 32 bytes. Every time that 32 bytes are retrieved, try to use full 32 bytes.
