export GPU_FORCE_64BIT_PTR 0
export GPU_MAX_HEAP_SIZE 100
export GPU_USE_SYNC_OBJECTS 1
export GPU_MAX_ALLOC_PERCENT 100
export GPU_SINGLE_ALLOC_PERCENT 100

./ethdcrminer64 -epool eth-eu1.nanopool.org:9999 -ewal YOUR_ETH_ADDRESS/YOUR_WORKER_NAME/YOUR_EMAIL -epsw x -dpool stratum+tcp://pasc-eu1.nanopool.org:15555 -dwal YOUR_PASC_ADDRESS.YOUR_PAYMENTID.YOUR_WORKER_NAME/YOUR_EMAIL -dpsw x -dcoin pasc -ftime 10