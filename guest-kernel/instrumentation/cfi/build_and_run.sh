echo "[*] Starting CFI instrumentation"
cp ${1}.bc ${SHARD_PATH}/guest-kernel/callgraph/.
cd ${SHARD_PATH}/guest-kernel/callgraph/.
./create_call_graphs.sh ${1}.bc
cp ${1}.bc ${SHARD_PATH}/guest-kernel/instrumentation/cfi/.
cd ${SHARD_PATH}/guest-kernel/instrumentation/cfi

python write_cfi_lib_vars.py callsites_info
make
llvm-link ${1}.bc cfi_lib.bc -o ${1}.bc
opt -load ${SHARD_PATH}/guest-kernel/instrumentation/cfi/lib/CFIInst.so -CFIInst ${1}.bc -o ${1}-instrumented.bc
llvm-dis ${1}-instrumented.bc