FROM benjaminkirk/ubuntu-ml-base:latest

RUN pip install \
         numpy scipy matplotlib pandas \
         pydoe \
         'tensorflow==2.14.*' tensorrt \
         jaxlib 'jax[cuda12_local]' -f https://storage.googleapis.com/jax-releases/jax_cuda_releases.html \
    && docker-clean

COPY test_tf+jax_install.py /container/test_tf+jax_install.py

RUN echo "Testing..." \
    && python3 /container/test_tf+jax_install.py


#USER plainuser
#SHELL ["/bin/bash", "-lc"]

# Local Variables:
# mode: sh
# End:
