MicroFract code
Copyright 2017 Sundararaghavan

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.



=====================================
2D MATLAB version of the MicroFract code and the examples in the paper (Ref. 1) are available here for download and provides a valuable image-based tool for identifying weak links in a microstructure. The only input to the code is an image of the cohesive energy distribution and the user should graphically input the macroscopic crack line.


To run the code: 

1. Download the Multi-label optimization/graph-cut library (gco-v3.0), from http://vision.csd.uwo.ca/code/gco-v3.0.zip, and add it to your MATLAB path (File->Set Path->add with subfolders). 

2. Run MicroFract.m, the code opens a image window with the cohesive energy map. Click the initial and final points of the macroscopic crack. The code will output the crack trajectory at the microscale.

3. The cohesive energy image can be changed in the MicroFract.m code in line 22, IMG = imread('polycrystal.bmp'); by default the image is read from "polycrystal.bmp" in the current folder.

4. The polycrystal example in the paper can be obtained directly by running microfract.m. The composite example can be obtained by changing line 22 of microfract.m to IMG = imread('cfiber2.bmp')









