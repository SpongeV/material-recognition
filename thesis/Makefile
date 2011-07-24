all: clean thesis.pdf

pdf: thesis.pdf

thesis.pdf: thesis.tex
#	pdflatex thesis.tex
	latex thesis.tex
	latex thesis.tex
	dvipdfm thesis.dvi
	makeindex thesis.idx

	bibtex thesis

#	pdflatex thesis.tex
	latex thesis.tex
	latex thesis.tex
	dvipdfm thesis.dvi

	latex_count=5 ; \
	while egrep -s 'Rerun (LaTeX|to get cross-references right)' thesis.log && [ $$latex_count -gt 0 ] ;\
	    do \
	      echo "Rerunning latex...." ;\
	      latex thesis.tex ;\
	      latex_count=`expr $$latex_count - 1` ;\
	    done
	rm -f *.ps *.dvi *.aux *.toc *.idx *.ind *.ilg *.log *.out *.blg *.bbl
clean:
	rm -f *.ps *.dvi *.aux *.toc *.idx *.ind *.ilg *.log *.out *.blg *.bbl thesis.pdf
