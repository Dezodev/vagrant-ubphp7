#!/bin/bash

wget https://launchpad.net/imagemagick/main/6.9.10-5/+download/ImageMagick-6.9.10-5.tar.gz
tar -xvzf ImageMagick-6.9.10-5.tar.gz
cd ImageMagick-6.9.10-5
./configure
sudo make
sudo make install
