ARG CUDA=11.7
FROM nvidia/cuda:${CUDA}.1-cudnn8-runtime-ubuntu20.04 AS base

ARG PYTHON_VERSION=3.8

ENV DEBIAN_FRONTEND=noninteractive
ENV LANG C.UTF-8

SHELL ["/bin/bash", "-c"]

#
# install OS packages
#
RUN apt-get update && \
    apt-get upgrade --yes && \
    apt-get install --yes --no-install-recommends \
    ack \
    fonts-liberation \
    graphviz \
    less \
    locales \
    pandoc \
    sudo \
    texlive-xetex \
    texlive-fonts-recommended \
    texlive-plain-generic \
    tree \
    tzdata \
    vim && \
    echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen && \
    rm -f /etc/localtime && ln -s /usr/share/zoneinfo/America/Toronto /etc/localtime

#
# install python3.8
#
RUN apt-get install --yes --no-install-recommends \
    python${PYTHON_VERSION} \
    python3-pip && \
    ln -s $(which python3) /usr/local/bin/python && \
    python3 -m pip install --no-cache-dir --upgrade \
    "pip<20.3" \
    setuptools \
    wheel && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

#
# setup user account
#
ARG USER_ID=1000
ARG USER_NAME=dev
ARG GROUP_ID=100
ARG GROUP_NAME=users

RUN sed -i 's/^#force_color_prompt=yes/force_color_prompt=yes/' /etc/skel/.bashrc && \
    groupadd --force --gid ${GROUP_ID} --non-unique ${GROUP_NAME} && \
    useradd -l -m -s /bin/bash -u ${USER_ID} -g ${GROUP_NAME} -G sudo ${USER_NAME} && \
    echo "${USER_NAME}    ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

#
# switch to ${USER_NAME}
#
USER ${USER_NAME}

WORKDIR /home/${USER_NAME}

ENV PATH=/home/${USER_NAME}/.local/bin:${PATH}

#
# install Jupyter notebook and other python packages
#
RUN python3 -m pip install --no-cache-dir \
    jupyter \
    jupyterlab \
    jupyterlab-drawio \
    matplotlib \
    pandas \
    pydot \
    scikit-learn \
    seaborn

#
# configure jupyter lab
#
ARG DISABLE_JUPYTER_AUTH=no

# override jupyter lab default theme
COPY overrides.json .local/share/jupyter/lab/settings/

RUN jupyter-lab --generate-config && \
# configure notebook terminal to use bash instead of sh
echo "c.ServerApp.terminado_settings = {'shell_command': ['/bin/bash']}" >> .jupyter/jupyter_lab_config.py && \
# disable jupyter auth if required, which is convenient for local development
if [[ ${DISABLE_JUPYTER_AUTH} = "yes" ]]; \
then echo "c.ServerApp.token = ''" >> .jupyter/jupyter_lab_config.py; \
fi

EXPOSE 8888

#
# dev env for TensorFlow 2.7
#
FROM base AS devenv_tf

ARG TF_PACKAGE=tensorflow-gpu
ARG TF_VERSION=2.7

# install TensorFlow
RUN python3 -m pip install --no-cache-dir \
    protobuf==3.19.4 \
    ${TF_PACKAGE}${TF_VERSION:+==${TF_VERSION}}

# start jupyter lab
CMD ["bash", "-c", "jupyter-lab --ip 0.0.0.0 --no-browser --notebook-dir ${NOTEBOOK_FOLDER}"]

#
# dev env for PyTorch 2.0
#
FROM base AS devenv_torch

# install PyTorch 2.0
RUN python3 -m pip install --no-cache-dir \
    torch \
    torchaudio \
    torchtext \
    torchvision

# start jupyter lab
CMD ["bash", "-c", "jupyter-lab --ip 0.0.0.0 --no-browser --notebook-dir ${NOTEBOOK_FOLDER}"]
