#! /bin/bash
now=$(date)
echo "$now"
if [ -d "/sys/fs/cgroup/memory/cache-test-arghya" ]
then
cgdelete memory:cache-test-arghya
fi
cgcreate -g memory:cache-test-arghya
bash -c "echo 1 > /sys/fs/cgroup/memory/cache-test-arghya/memory.oom_control"
bash -c "echo 4194304 > /sys/fs/cgroup/memory/cache-test-arghya/memory.limit_in_bytes"

declare -a ip_size=( "1048576" "2097152" "4194304" "8388608" )
#( "8192" "16384" "32768" "65536" "131072" "262144" "524288" "1048576" "2097152" "4194304" "8388608" )
numruns=1

for (( j=0; j<=${#ip_size[@]}-1; j++ ));
do
gcc lcs-classic.c
#cgexec -g memory:cache-test-arghya ./a.out ${ip_size[$j]} $numruns < data/data-${ip_size[$j]}.in 
g++ lcs-hirschberg-opt-uneq.c 
cgexec -g memory:cache-test-arghya ./a.out ${ip_size[$j]} $numruns < data/data-${ip_size[$j]}.in
g++ -std=c++11 lcs-our-alg-opt-uneq.c
cgexec -g memory:cache-test-arghya ./a.out ${ip_size[$j]} $numruns < data/data-${ip_size[$j]}.in
done


