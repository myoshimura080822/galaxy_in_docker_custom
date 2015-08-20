# Base image
FROM bgruening/galaxy-stable

# Put my hand up as maintainer
MAINTAINER Mika Yoshimura <myoshimura080822@gmail.com>

# Mark folders as imported from the host.
VOLUME ["/export/", "/data/", "/var/lib/docker"]

# Install OS tools we'll need
RUN \
    apt-get -y update && \
    apt-get -y install tree && \
    apt-get -y install zsh

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

# Install R 
RUN echo 'deb http://cran.rstudio.com/bin/linux/ubuntu trusty/' > /etc/apt/sources.list.d/r.list && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9 && \
    apt-get -y update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y r-base libcurl4-openssl-dev libxml2-dev libxt-dev libgtk2.0-dev libcairo2-dev xvfb xauth xfonts-base mesa-common-dev
ADD ./install_rnaseqENV.R /galaxy/install_rnaseqENV.R
ADD ./install_destiny.R /galaxy/install_destiny.R
RUN R -e 'source("/galaxy/install_rnaseqENV.R")'
RUN R -e 'source("/galaxy/install_destiny.R")'

# Setting Python
RUN pip install python-dateutil && \
    pip install bioblend && \
    pip install pandas && \
    pip install grequests && \
    pip install GitPython && \
    pip install pip-tools && \
    pip-review

# Install ToolShed-tools
WORKDIR /galaxy-central
RUN install-repository "--url https://toolshed.g2.bx.psu.edu/ -o devteam --name tophat2 -r da1f39fe14bc --panel-section-name NGS-tools" \
    "--url https://toolshed.g2.bx.psu.edu/ -o devteam --name express -r 7b0708761d05 --panel-section-name NGS-tools" \
    "--url https://toolshed.g2.bx.psu.edu/ -o fcaramia --name edger -r 6324eefd9e91 --panel-section-name NGS-tools" \
    "--url https://toolshed.g2.bx.psu.edu/ -o devteam --name bowtie2 -r c1ec08cb34f9 --panel-section-name NGS-tools" \
    "--url https://toolshed.g2.bx.psu.edu/ -o jjohnson --name fastq_mcf -r b61f1466ce8f --panel-section-name NGS-QCtools" \
    "--url https://toolshed.g2.bx.psu.edu/ -o devteam --name fastqc -r 0b201de108b9 --panel-section-name NGS-QCtools" \
    "--url https://toolshed.g2.bx.psu.edu/ -o fubar --name toolfactory --panel-section-name Create-tools" \
    "--url https://toolshed.g2.bx.psu.edu/ -o fubar --name tool_factory_2 --panel-section-name Create-tools"

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
