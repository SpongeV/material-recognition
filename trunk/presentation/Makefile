all: clean presentation.pdf

pdf: presentation.pdf

presentation.pdf: presentation.tex
#	pdflatex presentation.tex
#
	latex presentation.tex
	latex presentation.tex
	dvipdf presentation.dvi
	rm -f *.ps *.dvi *.aux *.toc *.nav *.snm *.idx *.ind *.ilg *.log *.out *.blg *.bbl
clean:
	rm -f *.ps *.dvi *.aux *.toc *.nav *.snm *.idx *.ind *.ilg *.log *.out *.blg *.bbl presentation.pdf
