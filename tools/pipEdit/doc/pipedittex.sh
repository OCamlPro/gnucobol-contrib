rm pipEdit_UserGuide.pdf
rm pipEdit_UserGuide.dvi
echo "Running LaTeX 3 times...."
latex pipEdit_User_Guide.tex
latex pipEdit_User_Guide.tex
latex pipEdit_User_Guide.tex
###echo "Displaying the *.dvi file...."
###xdvi pipedit.dvi
echo "Converting the *.dvi to a *.pdf..."
dvipdf pipEdit_User_Guide.dvi
echo "Displaying the *.pdf file...."
evince pipEdit_User_Guide.pdf
###echo "Converting the *.dvi to a *.pcl..."
###dvihp pipedit.dvi -o pipedit.pcl
