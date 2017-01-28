#!/bin/bash

echo "==>dependencies setup for deep_q_rl"

echo "==>updating current package..."
sudo apt-get update

echo "==>installing OpenCV..."
sudo apt-get install python-opencv

echo "==>installing Matplotlib..."
sudo apt-get install python-matplotlib python-tk

mkdir build
cd build
echo "==>installing Theano ..."
# some dependencies ...
sudo apt-get install python-numpy python-scipy python-dev python-pip python-nose g++ libopenblas-dev git
# new version of Theano has incompatibility issues, therefore install from older branch
#pip install --user --upgrade --no-deps git+git://github.com/Theano/Theano.git
git clone --branch rel-0.8.2 https://github.com/Theano/Theano.git
cd Theano
pip install .
cd ..

echo "==>installing Lasagne ..."
pip install --user --upgrade https://github.com/Lasagne/Lasagne/archive/master.zip

# Packages below this point require downloads.
mkdir cores

if [ ! -d "./pylearn2" ]
then
echo "==>installing Pylearn2 ..."
# dependencies...
sudo apt-get install libyaml-0-2 python-six
git clone git://github.com/lisa-lab/pylearn2
fi
cd ./pylearn2
python setup.py develop --user
cd ..

if [ ! -d "./RLE" ]
then
echo "==>installing RLE ..."

# dependencies ...
sudo apt-get install libsdl1.2-dev libsdl-gfx1.2-dev libsdl-image1.2-dev cmake

git clone --branch 1.0.2 https://github.com/nadavbh12/Retro-Learning-Environment.git RLE
mkdir cores
cd ./RLE
cmake -DUSE_SDL=ON -DBUILD_EXAMPLES=OFF .
make -j 4
pip install --user .
cp stella-libretro/stella_libretro.so ../../cores/
cp snes9x2010/snes9x2010_libretro.so ../../cores/
cd ..
fi

echo "==>All done!"
