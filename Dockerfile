# Base image
FROM bgruening/galaxy-stable

# Put my hand up as maintainer
MAINTAINER Mika Yoshimura <myoshimura080822@gmail.com>

# Set environment variables
ENV R_BASE_VERSION=3.2.2 \
    LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/galaxy/Sailfish-0.6.3-Linux_x86-64/lib \
    #PATH=$PATH:/galaxy/Sailfish-0.6.3-Linux_x86-64/bin \
    PATH=$PATH:/galaxy/SailfishBeta-0.9.2_trusty/bin

# Include all needed scripts from the host
ADD vimrc.local /galaxy/
ADD install_rnaseqENV.R /galaxy/
COPY SailfishBeta-0.9.2_trusty.tar.gz /galaxy/

# Install OS tools we'll need
RUN \
    apt-get -y update && \
    apt-get -y upgrade && \
    apt-get -y install tree zsh imagemagick pandoc && \
    apt-get -y install libcurl4-gnutls-dev libglu1-mesa-dev freeglut3-dev mesa-common-dev && \
# Install OH-MY-ZSH
    git clone git://github.com/robbyrussell/oh-my-zsh.git /home/galaxy/.oh-my-zsh  && \
    #cp /etc/zsh/zshrc{,_bk} && \
    cp /home/galaxy/.oh-my-zsh/templates/zshrc.zsh-template /etc/zsh/zshrc && \
    sed -i -e "9i TERM=xterm" /etc/zsh/zshrc && \
    sed -i "s/robbyrussell/candy/" /etc/zsh/zshrc && \
# Setting vim
    cp /galaxy/vimrc.local /etc/vim/ && \
# Install R 
    apt-get install -y software-properties-common && \
    add-apt-repository 'deb http://cran.us.r-project.org/bin/linux/ubuntu trusty/' && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9 && \
    apt-get update && \
    apt-get install -y --force-yes r-base=${R_BASE_VERSION}* r-base-dev=${R_BASE_VERSION}* r-recommended=${R_BASE_VERSION}* \
    libcurl4-openssl-dev libxml2-dev libxt-dev libgtk2.0-dev libcairo2-dev xvfb xauth xfonts-base mesa-common-dev libx11-dev freeglut3-dev && \
# Setting Python
    python -m pip install --upgrade --force-reinstall pip && \
    sudo pip install -U pip && \
    sudo pip install python-dateutil && \
    sudo pip install bioblend && \
    sudo pip install pandas && \
    sudo pip install grequests && \
    sudo pip install GitPython && \
    sudo pip install pip-tools && \
# install R pkg
    R -e 'source("/galaxy/install_rnaseqENV.R")' && \
# Install Sailfish
    bash -c "tar zxf <(curl -L https://github.com/kingsfordgroup/sailfish/releases/download/v0.6.3/Sailfish-0.6.3-Linux_x86-64.tar.gz) -C /galaxy" && \
    mv /galaxy/Sailfish-0.6.3-Linux_x86-64/lib/libz.so.1 /galaxy/Sailfish-0.6.3-Linux_x86-64/lib/libz.so.1_bk && \
    tar -zxf /galaxy/SailfishBeta-0.9.2_trusty.tar.gz -C /galaxy/ && \

# Install ToolShed-tools
    (cd /galaxy-central &&\
    install-repository \
    "--url https://toolshed.g2.bx.psu.edu/ -o devteam --name bowtie2 -r a9d4f71dbfb0 --panel-section-name NGS-tools" \
    "--url https://toolshed.g2.bx.psu.edu/ -o devteam --name cuffcompare -r b77178f66fc3 --panel-section-name NGS-tools" \
    "--url https://toolshed.g2.bx.psu.edu/ -o devteam --name cuffdiff -r 0f32ad418df8 --panel-section-name NGS-tools" \
    "--url https://toolshed.g2.bx.psu.edu/ -o devteam --name cufflinks -r a1ea9af8d5f4 --panel-section-name NGS-tools" \
    "--url https://toolshed.g2.bx.psu.edu/ -o devteam --name cuffquant -r 986b63735a5e --panel-section-name NGS-tools" \
    "--url https://toolshed.g2.bx.psu.edu/ -o devteam --name cuffnorm -r 7d4c2097aac5 --panel-section-name NGS-tools" \
    "--url https://toolshed.g2.bx.psu.edu/ -o fcaramia --name edger -r 6324eefd9e91 --panel-section-name NGS-tools" \
    "--url https://toolshed.g2.bx.psu.edu/ -o devteam --name express -r 7b0708761d05 --panel-section-name NGS-tools" \
    "--url https://toolshed.g2.bx.psu.edu/ -o jjohnson --name fastq_mcf -r b61f1466ce8f --panel-section-name NGS-QCtools" \
    "--url https://toolshed.g2.bx.psu.edu/ -o devteam --name fastqc -r 28d39af2dd06 --panel-section-name NGS-QCtools" \
    "--url https://toolshed.g2.bx.psu.edu/ -o devteam --name gffread -r 48fe74f391ab --panel-section-name NGS-tools" \
    "--url https://toolshed.g2.bx.psu.edu/ -o iuc --name hisat2 -r b1e25f9b5eab --panel-section-name NGS-tools" \
    "--url https://toolshed.g2.bx.psu.edu/ -o devteam --name sam_merge -r 1977f1637890 --panel-section-name NGS-tools" \
    "--url https://toolshed.g2.bx.psu.edu/ -o devteam --name samtools_flagstat -r 0072bf593791 --panel-section-name NGS-QCtools" \
    "--url https://toolshed.g2.bx.psu.edu/ -o fubar --name toolfactory --panel-section-name Create-tools" \
    "--url https://toolshed.g2.bx.psu.edu/ -o fubar --name tool_factory_2 --panel-section-name Create-tools" \
    "--url https://toolshed.g2.bx.psu.edu/ -o devteam --name tophat2 -r 4eb3c3beb9c7 --panel-section-name NGS-tools" \ 
    "--url https://toolshed.g2.bx.psu.edu/ -o nilesh --name rseqc -r 6b33e31bda10 --panel-section-name NGS-QCtools" && \ 
# Clone Bug-fixed ToolFactory
    git clone https://github.com/myoshimura080822/galaxy-mytools_ToolFactory.git /galaxy/galaxy-mytools_ToolFactory/ && \
    mv /shed_tools/toolshed.g2.bx.psu.edu/repos/fubar/toolfactory/e9ebb410930d/toolfactory/rgToolFactory.py /shed_tools/toolshed.g2.bx.psu.edu/repos/fubar/toolfactory/e9ebb410930d/toolfactory/rgToolFactory.py_bk && \
    mv /shed_tools/toolshed.g2.bx.psu.edu/repos/fubar/toolfactory/e9ebb410930d/toolfactory/rgToolFactory.xml /shed_tools/toolshed.g2.bx.psu.edu/repos/fubar/toolfactory/e9ebb410930d/toolfactory/rgToolFactory.xml_bk && \ 
    cp /galaxy/galaxy-mytools_ToolFactory/rgToolFactory.py /shed_tools/toolshed.g2.bx.psu.edu/repos/fubar/toolfactory/e9ebb410930d/toolfactory/ && \
    cp /galaxy/galaxy-mytools_ToolFactory/rgToolFactory.xml /shed_tools/toolshed.g2.bx.psu.edu/repos/fubar/toolfactory/e9ebb410930d/toolfactory/)

# Define default command
CMD ["/usr/bin/startup"]
