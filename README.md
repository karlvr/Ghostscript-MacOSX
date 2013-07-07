Ghostscript for Mac OS X
========================

Build scripts for creating a package for Ghostscript on Mac OS X.

Download and install Packages, which is the application that builds the installer packages:  
http://s.sudre.free.fr/Software/Packages/about.html

You must have Home Brew installed, as it is used to install dependencies on your system:  
http://mxcl.github.io/homebrew/

You must have XQuartz installed:  
http://xquartz.macosforge.org/landing/

You should have a Developer ID Installer identity from Apple in your Keychain. This is used to sign the package.
If you don't have this identity the script will skip the signing stage.

Download the latest Ghostscript source:  
http://www.ghostscript.com/download/gsdnld.html

Extract the Ghostscript source into this repository, to create a folder such as ``ghostscript-9.07``.

Open Terminal.app to that Ghostscript source directory, then run the build script:  
``../build-package.sh``

The build script will download dependencies, configure and compile then and then compile Ghostscript.
It also checks that the package does not have any depdendencies that won't work on other systems.

The output files will be in the ``build`` directory.
