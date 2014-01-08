PARTS=symbolic.tex admissible_computation.tex conjecture.tex discussion.tex experiments.tex generalization.tex introduction.tex partition_function.tex related_work.tex terminology.tex

symbolic.pdf: $(PARTS) bibliography.bib 
	pdflatex symbolic.tex
	bibtex symbolic
	pdflatex symbolic.tex
	pdflatex symbolic.tex
	pdflatex symbolic.tex


clean:
	rm -f symbolic.log symbolic.blg symbolic.aux symbolic.bbl symbolic.pdf symbolic.4tc symbolic.xref symbolic.tmp symbolic.dvi symbolic.bbl
	rm -rf ~*
	rm -rf *.tmp
	rm -rf *.4om
	rm -rf *~
