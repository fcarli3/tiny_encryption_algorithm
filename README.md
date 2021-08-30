# tiny_encryption_algorithm
This repository contains the final project of Hardware and Embedded Security course (Master's Degree in Cybersecurity at [University of Pisa](https://cysec.unipi.it/)). The project has been developed for educational purposes and it is the implementation of the encryption module of [Tiny Encryption Algorithm](https://en.wikipedia.org/wiki/Tiny_Encryption_Algorithm).

## Prerequisites
The program has been developed on Windows 10. It has been used [Notepad++](https://notepad-plus-plus.org/downloads/) as text editor, and the following tools have been downloaded on Windows 10.

 - **Modelsim**: Intel FPGA edition for RTL simulation.
 - **Quartus**: tool used for the steps of Circuit Design and Physical Design inside the VLSI Design Flow. 

At this [link](https://fpgasoftware.intel.com/20.1.1/?edition=lite&platform=windows), insert edition **Lite**, release **20.1.1** and the OS basing on your own requirements. Then, select **Individual Files** tab and download **Quartus Lite Edition** and **Modelsim-Intel FPGA Edition**. After that, from **Device** section download **Cyclone V device support**. At the end, you can run the installation of Quartus Prime software: if all the previous files are in the same folder, Quartus Prime installation routine automatically detects also Modelsim software and Cyclone V device technology library. 

## Folder Organization
For simplicity, it has been used the following folder organization:

- **db**: HDL desing files (.sv).
- **Modelsim**: Modelsim project directory.
- **Quartus**: Quartus project directory.
- **tb**: testbench HDL files (.sv).


## Authors
 - [Francesco Carli](https://github.com/fcarli3)
 - [Gianluca Boschi](https://github.com/gianluca2414)
 - [Paola Petri](https://github.com/paolapetri)
