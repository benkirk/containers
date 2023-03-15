FROM benjaminkirk/centos7-libmesh_build_support:latest

ARG APP_STAGE_PATH="/pv/path_for/bundle"
ARG build_variant="devel"

USER root
RUN echo "persistent volume & permissions" \
    && mkdir -p ${APP_STAGE_PATH}  && chown plainuser: ${APP_STAGE_PATH}
USER plainuser

RUN echo $(whoami)

RUN echo "populating build env: ${build_variant}" \
    && cd ${BUILD_STAGE_PATH} \
    && make -C centos7/${build_variant} all install\
    && docker-clean

ENV APP_STAGE_PATH=${APP_STAGE_PATH}


# Local Variables:
# mode: sh
# End:
