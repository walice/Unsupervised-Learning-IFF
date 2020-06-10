FROM jupyter/scipy-notebook:dc57157d6316

# start binder compatibility
# from https://mybinder.readthedocs.io/en/latest/tutorials/dockerfile.html

ARG NB_USER
ARG NB_UID
ENV USER ${NB_USER}
ENV NB_UID ${NB_UID}
ENV HOME /home/${NB_USER}

COPY . ${HOME}/work
USER root
RUN chown -R ${NB_UID} ${HOME}

# end binder compatibility code

# add modification code here

USER ${NB_USER}
RUN pip install altair pyreadr jupyter-server-proxy altair_data_server joypy

# Jupyter Notebook extensions
RUN pip install jupyter_contrib_nbextensions && \
    jupyter contrib nbextension install --sys-prefix && \
    jupyter nbextension enable toc2/main --sys-prefix && \
    jupyter nbextension enable export_embedded/main --sys-prefix

RUN jupyter nbextensions_configurator enable --sys-prefix && \
    \
    pip install --pre rise && \
    jupyter nbextension install rise --py --sys-prefix && \
    jupyter nbextension enable rise --py --sys-prefix

# Jupyter Lab extensions
RUN jupyter labextension install @jupyterlab/toc --clean
RUN jupyter labextension install @jupyterlab/server-proxy

# Network analysis and visualization
RUN conda install -c conda-forge cartopy
RUN pip install --force-reinstall networkx==2.3
