# Overview

Objective: discuss latency, bandwidth, throughput on GPU.

https://www.eecg.utoronto.ca/~moshovos/CUDA08/arx/microbenchmark_report.pdf

# Latency

Latency is the delay between a request, and the return of a request. GPU latency can manifest as 

- the GPU taking too much time to render a frame, causing CPU to have to pause
- the GPU having to move data from memory into registers

# Bandwidth

Bandwidth is speed at which the device retrieves useful bytes. Poor bandwidth can be due to having to retrieve data from many different chunks of memory, reducing our effective byte retrieval rate.

Bandwidth is measured in bytes / clock cycle.

# Throughput

Throughput is the rate at which data is processed, or query values are returned. Throughput can be reduced due to 

- a lack of optimized hardware for a query
- pausing a process to retrieve data to fulfill a query

Generally, as throughput goes up, latency will go down.
