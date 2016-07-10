#!/bin/bash

export CUDA_HOME=${CUDA_HOME:-/usr/local/cuda-7.5}

if [ ! -d ${CUDA_HOME}/lib64 ]; then
  echo "Failed to locate CUDA libs at ${CUDA_HOME}/lib64."
  exit 1
fi

#export CUDA_SO=$(\ls /usr/lib/x86_64-linux-gnu/libcuda.* | xargs -I{} echo '--volume={}:{}')
export DEVICES=$(\ls /dev/nvidia* | xargs -I{} echo '--device={}:{}')

if [[ "${DEVICES}" = "" ]]; then
  echo "Failed to locate NVidia device(s). Did you want the non-GPU container?"
  exit 1
fi

docker run \
    --rm=true \
    --interactive=true \
    --net=host \
    --tty=true \
    --workdir=$HOME \
    --env="DISPLAY" \
    --volume="/etc/group:/etc/group:ro" \
    --volume="/etc/passwd:/etc/passwd:ro" \
    --volume="/etc/shadow:/etc/shadow:ro" \
    --volume="/etc/sudoers.d:/etc/sudoers.d:ro" \
    --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
    --volume="/home3/aambasth/.Xauthority:/root/.Xauthority:rw" \
    --volume="/home:/home" \
    --volume="/home2:/home2" \
    --volume="/home3:/home3" \
    --volume="/home4:/home4" \
    $CUDA_SO \
    $DEVICES \
    abhishek/cudnnv3 /bin/bash -i