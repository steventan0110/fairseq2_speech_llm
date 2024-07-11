#!/usr/bin/env bash

# Copyright (c) Meta Platforms, Inc. and affiliates.
# All rights reserved.
#
# This source code is licensed under the BSD-style license found in the
# LICENSE file in the root directory of this source tree.

set -eo pipefail

env_name=fs2_speechllm
env_date=240613

env_path=$HOME/fairseq2/$env_name


cuda_version=12.1
torch_version=2.2.0
ofi_nccl_version=1.9.1

echo "Creating '$env_name' Conda environment with PyTorch $torch_version and CUDA $cuda_version..."

# conda create\
#     --prefix "$env_path/conda"\
#     --yes\
#     --strict-channel-priority\
#     --override-channels\
#     --channel https://aws-ml-conda.s3.us-west-2.amazonaws.com\
#     --channel pytorch\
#     --channel nvidia\
#     --channel conda-forge\
#     python==3.10.14\
#     pytorch==$torch_version\
#     pytorch-cuda==$cuda_version\
#     aws-ofi-nccl==$ofi_nccl_version\
#     libsndfile==1.0.31


# conda env config vars set --prefix "$env_path/conda"\
#     CUDA_HOME=/usr/local/cuda-$cuda_version\
#     FI_EFA_USE_DEVICE_RDMA=1\
#     FI_EFA_SET_CUDA_SYNC_MEMOPS=0\
#     FAIRSEQ2_ENV_DATE=$env_date


# echo "Installing Seamless-Communication"

# cd "$env_path"
# cd seamless_communication

# conda run --prefix "$env_path/conda" --no-capture-output --live-stream\
#     pip install --editable .





echo "Installing fairseq2n nightly..."

conda run --prefix "$env_path/conda" --no-capture-output --live-stream\
    pip install fairseq2n --pre --upgrade\
        --extra-index-url https://fair.pkg.atmeta.com/fairseq2/whl/nightly/pt$torch_version/cu${cuda_version//.}

cd "$env_path"

echo "Installing fairseq2..."

# git clone https://github.com/facebookresearch/fairseq2.git

cd fairseq2

conda run --prefix "$env_path/conda" --no-capture-output --live-stream\
    pip install --editable .

conda run --prefix "$env_path/conda" --no-capture-output --live-stream\
    pip install --requirement requirements-devel.txt

cd -

echo "Installing fairseq2-ext (internal extensions)..."

# git clone https://github.com/fairinternal/fairseq2-ext.git

cd fairseq2-ext

conda run --prefix "$env_path/conda" --no-capture-output --live-stream\
    pip install --editable .

cd -

# echo "Installing APEX... This can take a while!"

# export CUDA_HOME=/usr/local/cuda-$cuda_version

# # git clone https://github.com/NVIDIA/apex.git

# cd apex

# git checkout 23.08

# conda run --prefix "$env_path/conda" --no-capture-output --live-stream\
#     pip install\
#         --verbose\
#         --disable-pip-version-check\
#         --no-cache-dir\
#         --no-build-isolation\
#         --config-settings "--build-option=--cpp_ext" --config-settings "--build-option=--cuda_ext"\
#         .

# cd -

cat << EOF

Done!
To activate the environment, run 'conda activate ~/fairseq2/$env_name/conda'.
EOF
