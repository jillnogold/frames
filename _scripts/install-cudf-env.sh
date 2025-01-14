# Copyright 2018 Iguazio
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
#!/bin/bash
# Install minconda + cudf 0.5 + go SDK on Linux machine
# On AWS we use NVIDIA Volta Deep Learning AMI 18.11 AMI
# All that needed to run frames tests

set -x
set -e

miniconda_sh=Miniconda3-latest-Linux-x86_64.sh
miniconda_url="https://repo.anaconda.com/miniconda/${miniconda_sh}"
go_tar=go1.11.5.linux-amd64.tar.gz
go_url="https://dl.google.com/go/${go_tar}"

# Install miniconda
curl -LO ${miniconda_url}
bash ${miniconda_sh} -b
echo 'export PATH=${HOME}/miniconda3/bin:${PATH}' >> ~/.bashrc

# Install Go SDK
curl -LO ${go_url}
tar xzf ${go_tar}
mv go goroot
echo 'export GOROOT=${HOME}/goroot' >> ~/.bashrc
echo 'export PATH=${GOROOT}/bin:${PATH}' >> ~/.bashrc

CONDA_INSTALL="${HOME}/miniconda3/bin/conda install -y"

# Install cudf
${CONDA_INSTALL} \
    -c nvidia -c rapidsai -c pytorch -c numba \
    -c conda-forge -c defaults \
    cudf=0.5 cuml=0.5 python=3.6
${CONDA_INSTALL} cudatoolkit=9.2

# Install testing
${CONDA_INSTALL} pytest pyyaml ipython

# Get frames code
git clone https://github.com/v3io/frames.git

# Install frames dependencies
${CONDA_INSTALL} grpcio-tools=1.16.1 protobuf=3.6.1 requests=2.21.0
