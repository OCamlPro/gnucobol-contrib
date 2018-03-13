# ![Japi2 kernel program icon](/japi-logo.png?raw=true "Japi2 kernel program icon") Japi2 Kernel

[![Collage of Japi2 kernel](/screenshot_small.jpg?raw=true "Collage of Japi2 kernel")](japi_collage_big.png?raw=true).

> *Japi is an open source free software GUI toolkit, which makes it easy to develop platform independent applications. Written in JAVA and C, Japi provides the JAVA AWT Toolkit to non object oriented Languages like C, Fortran, Pascal and even Basic.* - [The official project page](https://userpages.uni-koblenz.de/~evol/japi/japi.html)

Japi uses a Java application called *Japi kernel* which acts like the X server and displays the controls requested by the Japi C library. Therefore C programs can easily be extended by a (simple) GUI.

The original Japi kernel uses the AWT GUI toolkit provided by Java. Since this toolkit is very old this project aims to port the Japi kernel to the SWING GUI toolkit providing more modern GUI elements and features.

This repository provides the following project resources:

 - Complete source code of Japi 2 kernel. The project has been developed using NetBeans IDE 8.1. Therefore this repo can directly be opened as a project.
 - [An extensive project documentation (only in German)](/documentation.pdf?raw=true) which describes the structure of the Japi 2 kernel, design thoughts and gives a tutorial on how to implement new custom components.
 - [The main architectural model of the Japi 2 kernel (only in German)](/japi4-model.pdf?raw=true).
 - The Java Doc of this project in the subfolder `dist/javadoc/`.
 - The executable Japi 2 kernel as JAR file in [`dist/japi2.jar`](/dist/japi2.jar?raw=true).

**Tip:** you'll find screenshots of some Japi 2 kernel GUI components on my project archive [here](http://maxstrauch.github.io/projects/japi2-kernel/index.html). *Check it out!*

# Usage

This project only aims on porting the Japi kernel. To get runnable examples please take a look at the Japi project page [here](https://userpages.uni-koblenz.de/~evol/japi/japi.html) and download the complete source tree. Place all files and folders of this repository in the `java` subfolder of the Japi source tree and compile it. Then the Japi 2 kernel will be compiled into the Japi library and ready to use.

# License

 - Japi by [Dr. Merten Joost](https://userpages.uni-koblenz.de/~evol/Merten.html)
 - Japi 2 kernel (2015) by Vera Christ, Daniel Vivas Estevao and [Maximilian Strauch](http://maxstrauch.github.io/)

Japi and Japi 2 kernel (this repo and all resources) free software and licensed under the terms and conditions of the [GNU Lesser General Public License](/LICENSE.txt?raw=true).

In short this means that you can use it free of charge and you can also embed it into proprietary, non-free software.

`This program is distributed WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.`