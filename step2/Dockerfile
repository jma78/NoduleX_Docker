FROM ubuntu:14.04

MAINTAINER Jing Ma <jingma365@gmail.com>

RUN apt-get update && apt-get install -y \
        wget \
        unzip \
        zip \
        curl \
        libfreetype6-dev \
        libpng12-dev \
        libzmq3-dev \
        pkg-config \
        python-numpy \
        python-pip \
        python-scipy \
        python-matplotlib \
        python-pandas \
        git \
        libhdf5-dev \
        && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN curl -O https://bootstrap.pypa.io/get-pip.py && \
    python get-pip.py && \
    rm get-pip.py

RUN pip --no-cache-dir install h5py 

RUN pip install --upgrade html5lib==1.0b8

# WORKDIR "/root"

RUN mkdir /root/medpy
WORKDIR /root/medpy
RUN git clone https://github.com/loli/medpy.git .
RUN python setup.py develop

RUN mkdir -p /root/src

COPY LIDC-IDRI-0011.zip /root/src/

ADD requirements.txt requirements.txt
RUN pip install -r requirements.txt

EXPOSE 8000

COPY keras.json /root/.keras/keras.json

COPY . /root

CMD ["/bin/bash"]