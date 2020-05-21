# Como buildear: estando en 'U:\repo\' ejecutar:
# oc new-app . --strategy=docker
# oc start-build jenkins --from-dir="." --follow

#FROM registry.redhat.io/openshift3/jenkins-2-rhel7
#FROM jenkins-2-custom
#FROM jenkins:2
FROM jenkins-rhel:latest

#RUN ls -la ./dimesions-lib/*.jar
RUN export DIMENSIONS_LIB_FOLDER=plugins/dimensionsscm/WEB-INF/lib

# Cargo las variables de entorno para git
ENV GIT_COMMITTER_NAME 1001
ENV GIT_COMMITTER_EMAIL 1001@mail.com

# COPIAR LOS .jar OBTENIDOS EN <DM_ROOT>/java_api/lib/ or <DM_ROOT>/AdminConsole/lib/ (Credicoop Dimemnsions Server) EN EL DIR dimesions-lib 
#COPY ./dimensions-libs/*.jar $JENKINS_HOME/plugins/dimensionsscm/WEB-INF/lib/
COPY ./openshift-pipelines/jenkins/configuration/*.xml $JENKINS_HOME/configuration/

USER root

# Copiar el dm-git-client y la configuracion de instalacion
ADD ./dimensions-libs/gitclient*.tar.gz /tmp
COPY ./conf/git-client-install.cfg /tmp

RUN /tmp/DimensionsCMGitClient-linux.bin -i silent -f /tmp/git-client-install.cfg

# Copiar el dm-java-cli y el rc-java-cli
RUN mkdir -p /opt/microdocus/native-clients
COPY ./dimensions-libs/*.jar /opt/serena/native-clients/

# Corregir los permisos del directorio /opt/microfocus
RUN chmod 777 -R /opt/microfocus \
    && chown 1001 -R /opt/microfocus

USER 1001


