all: 
	rm -f symbolic.pdf
	pdflatex symbolic.tex
	bibtex symbolic
	pdflatex symbolic.tex
	pdflatex symbolic.tex


clean:
	rm -f symbolic.log symbolic.blg symbolic.aux symbolic.bbl symbolic.pdf symbolic.4tc symbolic.xref symbolic.tmp symbolic.dvi symbolic.bbl
	rm -rf ~*
	rm -rf *.tmp
	rm -rf *.4om
	rm -rf *~

