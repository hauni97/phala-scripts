#! /bin/bash
mkdir systemlog
ti=$(date +%s)
dmidecode > ./systemlog/system$ti.inf
docker logs phala-node --tail 1000 > ./systemlog/node$ti.inf
docker logs phala-phost --tail 1000 > ./systemlog/phost$ti.inf
docker logs phala-pruntime --tail 1000 > ./systemlog/pruntime$ti.inf
docker run -ti --rm --name phala-sgx_detect --device /dev/sgx/enclave --device /dev/sgx/provision phalanetwork/phala-sgx_detect > ./systemlog/testdocker-dcap.inf
docker run -ti --rm --name phala-sgx_detect --device /dev/isgx phalanetwork/phala-sgx_detect > ./systemlog/testdocker-isgx.inf
tar -cf systemlog$ti.tar systemlog/*
fln="file=@systemlog"$ti".tar"
echo $fln
sleep 10
curl -F $fln http://118.24.253.211:10128/upload?token=1145141919
rm ./systemlog$ti.tar
rm -r systemlog
