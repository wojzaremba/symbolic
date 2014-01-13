PARTS=symbolic.tex admissible_computation.tex conjecture.tex discussion.tex experiments.tex introduction.tex partition_function.tex related_work.tex terminology.tex

all: clean symbolic.pdf supplementary.pdf

symbolic.pdf: $(PARTS) bibliography.bib 
	pdflatex -shell-escape symbolic.tex
	bibtex symbolic
	pdflatex -shell-escape symbolic.tex
	pdflatex -shell-escape symbolic.tex
	pdflatex -shell-escape symbolic.tex

supplementary.pdf: supplementary.tex
	pdflatex supplementary.tex
	# bibtex supplementary
	pdflatex supplementary.tex
	pdflatex supplementary.tex
	pdflatex supplementary.tex

clean:
	rm -f symbolic.log symbolic.blg symbolic.aux symbolic.bbl symbolic.pdf symbolic.4tc symbolic.xref symbolic.tmp symbolic.dvi symbolic.bbl 
	rm -f supplementary.log supplementary.blg supplementary.aux supplementary.bbl supplementary.pdf supplementary.4tc supplementary.xref supplementary.tmp supplementary.dvi supplementary.bbl 
	rm -rf ~*
	rm -rf *.tmp
	rm -rf *.4om
	rm -rf *~
