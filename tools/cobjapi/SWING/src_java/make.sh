#!/bin/sh

echo " "
echo "--- Japi2 Kernel Build Script ---"
echo " "

echo "--> Creating tmp directory and copying files"
mkdir tmpdir
cd tmpdir/
cp -r ../src/ .
cp ../manifest.mf src/de/.

echo "--> Compiling Japi2 Kernel"
javac $(find . -name *.java)

echo "--> Cleanup of java resources"
find . -name "*.java" -type f -delete

echo "--> Packaging into JAR file"

cd src
jar -cvmf de/manifest.mf japi2.jar .

cd ../../
cp tmpdir/src/japi2.jar japi2.jar
rm -rf tmpdir/

echo " "
echo "Finished. File: $(pwd)/japi2.jar"
echo " "
