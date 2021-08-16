# docker build -t solve solve
# docker login -u gregclinton sf
# docker images
# docker tag effc482e9bf1 gregclinton/solve
# docker push gregclinton/solve

FROM ubuntu:18.04

RUN apt-get -y update && \
    apt-get -y install g++ make cmake git wget liblapacke-dev libsuitesparse-dev

RUN wget http://bitbucket.org/eigen/eigen/get/3.3.4.tar.bz2 && \
    tar xvjf 3.3.4.tar.bz2 && \
    rm *.tar.bz2 && \
    mv eigen-eigen-5a0156e40feb/Eigen /usr/local/include/. && \
    rm -rf eigen-eigen-5a0156e40feb

RUN git clone --recursive https://github.com/cvxgrp/scs && \
    cd scs && \
    make && \
    mkdir /usr/local/include/scs && \
    mv include/* /usr/local/include/scs/. && \
    mv linsys/* /usr/local/include/scs/. && \
    mv out/lib* /usr/lib/x86_64-linux-gnu/. && \
    cd ..  && \
    rm -rf scs

RUN echo "deb [trusted=yes] http://old-releases.ubuntu.com/ubuntu/ hardy universe" >> /etc/apt/sources.list && \
    echo "deb [trusted=yes] http://old-releases.ubuntu.com/ubuntu/ hardy-updates universe" >> /etc/apt/sources.list && \
    apt-get update -y && \
    apt-get install -y g77

RUN wget https://www.mcs.anl.gov/hs/software/DSDP/DSDP5.8.tar.gz && \
    gunzip DSDP5.8.tar.gz && \
    tar -xvf DSDP5.8.tar && \
    rm *.tar && \
    cd DSDP5.8 && \
    export DSDPROOT=/DSDP5.8 && \
    make dsdpapi && \
    mkdir /usr/local/include/dsdp && \
    cp include/* /usr/local/include/dsdp/. && \
    cp lib/* /usr/lib/x86_64-linux-gnu/. && \
    cd ..  && \
    rm -rf DSDP5.8

RUN wget https://download.mosek.com/stable/9.2.14/mosektoolslinux64x86.tar.bz2 && \
    tar xvjf mosektoolslinux64x86.tar.bz2 && \
    rm *.tar.bz2 && \
    mkdir /usr/local/include/mosek && \
    cp mosek/9.2/tools/platform/linux64x86/h/* /usr/local/include/mosek/. && \
    cp mosek/9.2/tools/platform/linux64x86/bin/lib* /usr/lib/x86_64-linux-gnu/. && \
    rm -rf mosek

RUN apt-get install -y unzip && \
    wget https://download.pytorch.org/libtorch/cu102/libtorch-cxx11-abi-shared-with-deps-1.7.1.zip && \
    unzip libtorch-cxx11-abi-shared-with-deps-1.7.1.zip && \
    rm libtorch-cxx11-abi-shared-with-deps-1.7.1.zip && \
    cp -r libtorch/include /usr/local/. && \
    cp -r libtorch/include/torch/csrc/api/include/torch /usr/local/include/. && \
    cp libtorch/lib/*.so* /usr/lib/x86_64-linux-gnu/. && \
    rm -rf libtorch