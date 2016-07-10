FROM ubuntu:14.04
MAINTAINER Abhishek Ambastha <aambasth@cisco.com>


ENV DEBIAN_FRONTEND noninteractive


RUN apt-get update && apt-get install -y build-essential wget git curl

# Install CUDA
RUN cd /tmp && \
  wget http://developer.download.nvidia.com/compute/cuda/7.5/Prod/local_installers/cuda_7.5.18_linux.run && \
  chmod +x cuda_*_linux.run && ./cuda_*_linux.run -extract=`pwd` && \
  ./NVIDIA-Linux-x86_64-*.run -s --no-kernel-module && \
  ./cuda-linux64-rel-*.run -noprompt && \
  rm -rf *

ENV PATH=/usr/local/cuda/bin:$PATH \
  LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH

ENV CUDA_REPO_PKG=cuda-repo-ubuntu1404_6.5-14_amd64.deb
RUN wget http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1404/x86_64/$CUDA_REPO_PKG && \
  dpkg -i $CUDA_REPO_PKG

# Install cuDNN v3
RUN wget http://developer.download.nvidia.com/compute/redist/cudnn/v3/cudnn-7.0-linux-x64-v3.0-prod.tgz  && \
    tar -xzf cudnn-7.0-linux-x64-v3.0-prod.tgz -C /usr/local && \
    rm cudnn-7.0-linux-x64-v3.0-prod.tgz && \
    ldconfig

RUN apt-get install -y \
  bc \
  htop \
  vim \
  cmake \
  libatlas-base-dev \
  libatlas-dev \
  libboost-all-dev \
  libopencv-dev \
  libprotobuf-dev \
  libgoogle-glog-dev \
  libgflags-dev \
  protobuf-compiler \
  libhdf5-dev \
  libleveldb-dev \
  liblmdb-dev \
  libsnappy-dev \
  python-dev \
  python-pip \
  python-numpy \
  gfortran > /dev/null

#Install Caffe
RUN cd /root && git clone https://github.com/BVLC/caffe.git && cd caffe && \
  cat python/requirements.txt | xargs -n1 pip install

#RUN cd /root/caffe && \
#  mkdir build && cd build && \
#  cmake .. && \
#  make -j"$(nproc)" all && \
#  make install

# Add to Python path
#ENV PYTHONPATH=/root/caffe/python:$PYTHONPATH

RUN cd ~ && \
	mkdir opencv && cd opencv && \
	git clone -b oldCV https://github.com/abhishekambastha/opencv.git && \
	cd opencv && \
	mkdir build && cd build && cmake -DWITH_1394=OFF -DWITH_OPENGL=ON -DFORCE_VTK=ON -DWITH_TBB=ON -DWITH_GDAL=ON -DWITH_XINE=ON -DWITH_CUBLAS=1 .. && \
	make install -j && \
	make clean 

# Set ~/caffe as working directory

RUN pip install easydict
RUN pip install jupyter
ENV LD_LIBRARY_PATH /usr/local/cuda/lib64
WORKDIR /root