#!/bin/sh
# Auto Gate/Geant4 Installation 
# Simplify the Installation of the Gate/Geant4 monte-carlo simulation toolkit
# Version 1.0
# Created on: Nov 23, 2022
# Updated on: 
# Author: BUI Tien Hung (hungbuitien19081997@gmail.com)
# NB : Use this script at your own Risk
echo "        Auto Gate/Geant4 Installation        "
echo " "
echo " ******************************************* "
echo "  Installation :                             "
echo "    - Package Requirements                   "
echo "    - HDF5 1.10.5                            "
echo "    - Geant4 10.6.p03                        "
echo "    - ROOT 6.20/02                           "
echo "  Author :   BUI Tien Hung                   "
echo "             Vietnam Atomic Energy Institute "
echo "             hungbuitien19081997@gmail.com   "						
echo " ******************************************* "
echo " "
## Check internet connection
wget -q --spider http://google.com
if [ $? -eq 0 ]; then
    echo "Your internet has been successfully conected"
else
    echo "Please check your internet connection & restart the script"
    return
fi
#
# Install pre-package
sudo apt-get update && sudo apt-get upgrade
sudo apt-get install build-essential apt-file gcc g++ autoconf automake automake1.11 tcl8.6-dev tk8.6-dev libglu1-mesa-dev libgl1-mesa-dev libxt-dev libxmu-dev libglew-dev libglw1-mesa-dev gfortran inventor-dev libxaw7-dev freeglut3-dev libxerces-c-dev libxmltok1-dev qt5-default libxi-dev libclutter-gtk-1.0-0 cmake libxmlrpc-core-c3-dev tclxml tclxml-dev libexpat1-dev libgtk2.0-dev libxpm-dev x11proto-gl-dev x11proto-input-dev -y
sudo apt-get install dpkg-dev cmake g++ gcc binutils libx11-dev libxpm-dev libxft-dev libxext-dev python libssl-dev gfortran libpcre3-dev xlibmesa-glu-dev libglew1.5-dev libftgl-dev libmysqlclient-dev libfftw3-dev libcfitsio-dev graphviz-dev libavahi-compat-libdnssd-dev libldap2-dev python-dev libxml2-dev libkrb5-dev libgsl0-dev qtwebengine5-dev
#
number_of_cores=$(nproc)
mkdir Softwares
cd Softwares
GPTH=$(pwd)
#
# HDF5 library config
echo " => Installing HDF5 library "
wget https://support.hdfgroup.org/ftp/HDF5/current/src/hdf5-1.10.5.tar.gz
tar -xvf hdf5-1.10.5.tar.gz
rm hdf5-1.10.5.tar.gz
cd hdf5-1.10.5
./configure --enable-cxx --enable-threadsafe --enable-unsupported --prefix=/opt/hdf5 
make -j$number_of_cores
sudo make install
cd ..
#
# Geant4.10.06
echo " => Installing Geant4 "
mkdir Geant4.10.06
cd Geant4.10.06
wget -nc https://geant4-data.web.cern.ch/releases/geant4.10.06.p03.tar.gz
tar -xvf geant4.10.06.p03.tar.gz
rm geant4.10.06.p03.tar.gz
mkdir data
cd data
wget -nc https://geant4-data.web.cern.ch/datasets/G4NDL.4.6.tar.gz
wget -nc https://geant4-data.web.cern.ch/datasets/G4EMLOW.7.9.1.tar.gz
wget -nc https://geant4-data.web.cern.ch/datasets/G4PhotonEvaporation.5.5.tar.gz
wget -nc https://geant4-data.web.cern.ch/datasets/G4RadioactiveDecay.5.4.tar.gz
wget -nc https://geant4-data.web.cern.ch/datasets/G4SAIDDATA.2.0.tar.gz
wget -nc https://geant4-data.web.cern.ch/datasets/G4PARTICLEXS.2.1.tar.gz
wget -nc https://geant4-data.web.cern.ch/datasets/G4ABLA.3.1.tar.gz
wget -nc https://geant4-data.web.cern.ch/datasets/G4INCL.1.0.tar.gz
wget -nc https://geant4-data.web.cern.ch/datasets/G4PII.1.3.tar.gz
wget -nc https://geant4-data.web.cern.ch/datasets/G4ENSDFSTATE.2.2.tar.gz
wget -nc https://geant4-data.web.cern.ch/datasets/G4RealSurface.2.1.1.tar.gz
wget -nc https://geant4-data.web.cern.ch/datasets/G4TENDL.1.3.2.tar.gz
tar -xvf G4NDL.4.6.tar.gz
tar -vxf G4EMLOW.7.9.1.tar.gz
tar -vxf G4PhotonEvaporation.5.5.tar.gz
tar -vxf G4RadioactiveDecay.5.4.tar.gz
tar -vxf G4SAIDDATA.2.0.tar.gz
tar -vxf G4PARTICLEXS.2.1.tar.gz
tar -vxf G4ABLA.3.1.tar.gz
tar -vxf G4INCL.1.0.tar.gz
tar -vxf G4PII.1.3.tar.gz
tar -vxf G4ENSDFSTATE.2.2.tar.gz
tar -vxf G4RealSurface.2.1.1.tar.gz
tar -vxf G4TENDL.1.3.2.tar.gz
cd ..
mkdir build
mkdir install
cd install
geant4_install_dir=$(pwd)
cd ..
cd build
cmake -DGEANT4_INSTALL_DATADIR=../data -DGEANT4_USE_GDML=ON -DGEANT4_USE_HDF5=OFF -DGEANT4_USE_OPENGL_X11=ON -DGEANT4_USE_QT=ON -DGEANT4_BUILD_MULTITHREADED=ON -DCMAKE_INSTALL_PREFIX=../install ../geant4.10.06.p03
make -j$number_of_cores
make install
cd ..
cd ..
#
# Root 6.20.02
echo " => Installing Root "
mkdir Root
cd Root
wget -nc https://root.cern/download/root_v6.20.02.source.tar.gz
tar -xvf root_v6.20.02.source.tar.gz
sudo apt-get install git
mkdir build
mkdir install
cd install
root_install_dir=$(pwd)
cd ..
cd build
cmake -DCMAKE_INSTALL_PREFIX=$root_install_dir ../root-6.20.02
cmake --build . -- -j$number_of_cores
sudo make install
cd ..
cd ..
touch geant4.sh
echo 'source' $geant4_install_dir'/bin/geant4.sh' >> geant4.sh
echo 'source' $geant4_install_dir'/share/Geant4-10.6.3/geant4make/geant4make.sh' >> geant4.sh
echo 'source' $root_install_dir'/bin/thisroot.sh' >> geant4.sh
echo -e "\n" >> ~/.bashrc
echo '# export path variable for Geant4 and Root' >> ~/.bashrc
echo 'source' $GPTH'/geant4.sh' >> ~/.bashrc
echo "           ******************************************************************************"
echo "                                 The installation has been finished                      "
echo "           ******************************************************************************"
echo " "
printf "Have a good day. Bye bye (^ ^) !                                                       "