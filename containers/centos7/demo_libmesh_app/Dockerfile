FROM benjaminkirk/centos7-libmesh_build_support

# build arguments with defaults, can be overridden from Makefile
ARG APP_STAGE_PATH="/pv/path_for/bundle"
ARG build_variant="devel"

USER root
RUN echo "yum addons: required for libMesh+Tecplot API support" \
    && yum install -y \
           libXt-devel \
    && docker-clean

RUN echo "persistent volume & permissions" \
    && mkdir -p ${APP_STAGE_PATH} && chown plainuser: ${APP_STAGE_PATH}
USER plainuser

RUN echo $(whoami)

RUN echo "populating build env: ${build_variant}" \
    && cd ${BUILD_STAGE_PATH} \
    && make -C centos7/${build_variant} all install \
    && docker-clean

ADD more_extras/build_app.sh ${APP_STAGE_PATH}/build_app.sh

ENV APP_STAGE_PATH=${APP_STAGE_PATH}
ENV STACK_CONFIG=${BUILD_STAGE_PATH}/centos7/${build_variant}/use_stack.sh

# Local Variables:
# mode: sh
# End:
