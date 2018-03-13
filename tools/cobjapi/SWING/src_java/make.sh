#!/bin/sh

echo " "
echo "--- Japi2 Kernel Build Script ---"
echo " "

echo "--> Creating tmp directory and copying files"
mkdir tmpdir
cd tmpdir/
cp -r ../src/ .

echo "--> Compiling Japi2 Kernel"
javac $(find . -name *.java)

echo "--> Cleanup of java resources"
find . -name "*.java" -type f -delete

echo "--> Packaging into JAR file"
mkdir META-INF
jar -cf japi2.jar .

echo "--> Generating manifest"
echo "Manifest-Version: 1.0\nMain-Class: de.japi.Japi2\n" > META-INF/MANIFEST.MF
(7z a japi2.jar META-INF/) > log.txt

echo "--> Compressing JAR file"
pack200 --repack --effort=9 --segment-limit=-1 --modification-time=latest --strip-debug japi2-compressed.jar japi2.jar 

echo "     Original size....: $(wc -c < japi2.jar) bytes"
echo "     Compressed size..: $(wc -c < japi2-compressed.jar) bytes"

cd ../
cp tmpdir/japi2-compressed.jar japi2.jar
rm -rf tmpdir/

echo " "
echo "Finished. File: $(pwd)/japi2.jar"
echo " "