# Base image
FROM bgruening/galaxy-stable

# Put my hand up as maintainer
MAINTAINER Mika Yoshimura <myoshimura080822@gmail.com>

# Mark folders as imported from the host.
VOLUME ["/export/", "/data/", "/var/lib/docker"]

# Install OS tools we'll need
RUN \
    apt-get -y update && \
    apt-get -y upgrade && \
    apt-get -y install tree zsh imagemagick pandoc && \
    apt-get -y install libcurl4-gnutls-dev libglu1-mesa-dev freeglut3-dev mesa-common-dev

# Install OH-MY-ZSH
RUN cd /usr/local/src   && \
    git clone git://github.com/robbyrussell/oh-my-zsh.git /home/galaxy/.oh-my-zsh  && \
    cp /etc/zsh/zshrc /etc/zsh/zshrc_bk && \
    cp /home/galaxy/.oh-my-zsh/templates/zshrc.zsh-template /etc/zsh/zshrc && \
    sed -i -e "9i TERM=xterm" /etc/zsh/zshrc && \
    sed -i "s/robbyrussell/candy/" /etc/zsh/zshrc

# Setting vim
ADD ./vimrc.local /galaxy/vimrc.local
RUN cp /galaxy/vimrc.local /etc/vim/vimrc.local

# Install R and require Pkg 
ENV R_BASE_VERSION 3.2.2
RUN apt-get install -y software-properties-common && \
    add-apt-repository 'deb http://cran.us.r-project.org/bin/linux/ubuntu trusty/' && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9 && \
    apt-get update && \
    apt-get install -y --force-yes r-base=${R_BASE_VERSION}* r-base-dev=${R_BASE_VERSION}* r-recommended=${R_BASE_VERSION}* && \
    apt-get install -y --force-yes libcurl4-openssl-dev libxml2-dev libxt-dev libgtk2.0-dev libcairo2-dev xvfb xauth xfonts-base mesa-common-dev libx11-dev freeglut3-dev
ADD ./install_rnaseqENV.R /galaxy/install_rnaseqENV.R
RUN R -e 'source("/galaxy/install_rnaseqENV.R")'

# Setting Python
RUN python -m pip install --upgrade --force-reinstall pip && \
    sudo pip install -U pip && \
    sudo pip install python-dateutil && \
    sudo pip install bioblend && \
    sudo pip install pandas && \
    sudo pip install grequests && \
    sudo pip install GitPython && \
    sudo pip install pip-tools

# Install ToolShed-tools
WORKDIR /galaxy-central
RUN install-repository "--url https://toolshed.g2.bx.psu.edu/ -o devteam --name tophat2 -r da1f39fe14bc --panel-section-name NGS-tools" \
    "--url https://toolshed.g2.bx.psu.edu/ -o devteam --name express -r 7b0708761d05 --panel-section-name NGS-tools" \
    "--url https://toolshed.g2.bx.psu.edu/ -o fcaramia --name edger -r 6324eefd9e91 --panel-section-name NGS-tools" \
    "--url https://toolshed.g2.bx.psu.edu/ -o devteam --name bowtie2 -r c1ec08cb34f9 --panel-section-name NGS-tools" \
    "--url https://toolshed.g2.bx.psu.edu/ -o jjohnson --name fastq_mcf -r b61f1466ce8f --panel-section-name NGS-QCtools" \
    "--url https://toolshed.g2.bx.psu.edu/ -o devteam --name fastqc -r 0b201de108b9 --panel-section-name NGS-QCtools" \
    "--url https://toolshed.g2.bx.psu.edu/ -o fubar --name toolfactory --panel-section-name Create-tools" \
    "--url https://toolshed.g2.bx.psu.edu/ -o fubar --name tool_factory_2 --panel-section-name Create-tools" \
    "--url https://toolshed.g2.bx.psu.edu/ -o devteam --name samtools_flagstat -r 0072bf593791 --panel-section-name NGS-QCtools"

# Clone Bug-fixed ToolFactory
WORKDIR /galaxy
RUN git clone https://github.com/myoshimura080822/galaxy-mytools_ToolFactory.git && \
    mv /shed_tools/toolshed.g2.bx.psu.edu/repos/fubar/toolfactory/e9ebb410930d/toolfactory/rgToolFactory.py /shed_tools/toolshed.g2.bx.psu.edu/repos/fubar/toolfactory/e9ebb410930d/toolfactory/rgToolFactory_BK.py && \
    cp /galaxy/galaxy-mytools_ToolFactory/rgToolFactory.py /shed_tools/toolshed.g2.bx.psu.edu/repos/fubar/toolfactory/e9ebb410930d/toolfactory/ && \
    mv /shed_tools/toolshed.g2.bx.psu.edu/repos/fubar/toolfactory/e9ebb410930d/toolfactory/rgToolFactory.xml /shed_tools/toolshed.g2.bx.psu.edu/repos/fubar/toolfactory/e9ebb410930d/toolfactory/rgToolFactory_BK.xml && \
    cp /galaxy/galaxy-mytools_ToolFactory/rgToolFactory.xml /shed_tools/toolshed.g2.bx.psu.edu/repos/fubar/toolfactory/e9ebb410930d/toolfactory/

# Install Sailfish
WORKDIR /galaxy
RUN wget https://github.com/kingsfordgroup/sailfish/releases/download/v0.6.3/Sailfish-0.6.3-Linux_x86-64.tar.gz && \
    tar -zxvf Sailfish-0.6.3-Linux_x86-64.tar.gz && \
    rm Sailfish-0.6.3-Linux_x86-64.tar.gz && \
    mv /galaxy/Sailfish-0.6.3-Linux_x86-64/lib/libz.so.1 /galaxy/Sailfish-0.6.3-Linux_x86-64/lib/libz.so.1_bk
#ENV PATH $PATH:/galaxy/Sailfish-0.6.3-Linux_x86-64/bin
ENV LD_LIBRARY_PATH $LD_LIBRARY_PATH:/galaxy/Sailfish-0.6.3-Linux_x86-64/lib

WORKDIR /galaxy
RUN wget https://github.com/kingsfordgroup/sailfish/releases/download/v0.9.2/SailfishBeta-0.9.2_CentOS5.tar.gz && \
    tar -zxvf SailfishBeta-0.9.2_CentOS5.tar.gz && \
    rm SailfishBeta-0.9.2_CentOS5.tar.gz
ENV PATH $PATH:/galaxy/SailfishBeta-0.9.2_CentOS5/bin

# Mark folders as imported from the host.
VOLUME ["/export/", "/data/", "/var/lib/docker"]

# Expose port 80 (webserver), 21 (FTP server), 8800 (Proxy)
EXPOSE :80
EXPOSE :21
EXPOSE :8800

# Define working directory
WORKDIR /galaxy-central

# Define default command
CMD ["/usr/bin/startup"]
