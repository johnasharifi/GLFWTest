# Overview

Objective: discuss latency, bandwidth, throughput on GPU.

https://www.eecg.utoronto.ca/~moshovos/CUDA08/arx/microbenchmark_report.pdf

http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.726.9999&rep=rep1&type=pdf

> Due to the use of specialized caching strategies that were originally
developed for texture access, it has been shown to be compute rather than bandwidth limited. Especially with
recents developments however, not only the raw bandwidth, but also the latency for both memory access and read
after write register dependencies can become a limiting factor.

> In this paper we will analyze the memory and instruction dependency latencies of depth first ray tracing. We will
show that ray tracing is in fact latency limited on current GPUs...

# Latency

Latency is the delay between a request, and the return of a request. GPU latency can manifest as 

- the GPU taking too much time to render a frame, causing CPU to have to pause
- the GPU having to move data from memory into registers

# Bandwidth

Bandwidth is speed at which the device retrieves useful bytes. Poor bandwidth can be due to having to retrieve data from many different chunks of memory, reducing our effective byte retrieval rate.

Bandwidth is measured in bytes / clock cycle.

In GPUs, when performing ray-tracing, we may not be limited by retrieval-time limitations (bandwidth) but rather by compute power or compute speed.

# Throughput

Throughput is the rate at which data is processed, or query values are returned. Throughput can be reduced due to 

- a lack of optimized hardware for a query
- pausing a process to retrieve data to fulfill a query

Generally, as throughput goes up, latency will go down.

Compute power is proportional to throughput. IE as max compute power increases, max throughput increases.
