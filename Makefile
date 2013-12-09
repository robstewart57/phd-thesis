RELEASE_DIR  = .

    # 'make all' builds plots, images, exports LaTeX from thesis.org, and builds PDF with pdflatex
    all:
	@$(MAKE) images
	@$(MAKE) plots
	@$(MAKE) latex
	@$(MAKE) pdf

    # target: help - Display callable targets.
    help:
	@echo "run 'make all' to compile PDF"
	@echo "The 'make all' command depends on two software dependencies."
	@echo ""
	@echo "1. org-mode in emacs, and the org-mode version must be using the new >0.8 exporter."
	@echo ""
	@echo "2. The following commands:"
	@echo "xfig, pdflatex, xelatex, RScript, dia, fig2mpdf, convert, gnuplot, spin, gcc, sed, dot, gvpr"

    # all images in the thesis
    images:
	./mkImages.sh

    # all result plots in the thesis
    plots:
	./mkPlots.sh

    # generate LaTeX from org-mode
    latex:
	emacs -batch --visit=thesis.org -u $(LOGNAME) -funcall org-latex-export-to-latex

    # compiles the LaTeX generated from org-mode
    pdf:
	latexmk -pdf -pdflatex="pdflatex" thesis.tex

    # 'make dist' is same as 'make all'
    dist:
	@$(MAKE) all

    # 'make' is same as 'make all'
    .PHONY:
	@$(MAKE) all

    clean:
	find results/ -name "*.pdf" -delete
	find results/ -name "*.csv" -delete
	find img/ -name "*.pdf" -delete
	find spin_model/ -name "pan.b" -delete
	find spin_model/ -name "pan.c" -delete
	find spin_model/ -name "pan.h" -delete
	find spin_model/ -name "pan.m" -delete
	find spin_model/ -name "pan.p" -delete
	find spin_model/ -name "pan.t" -delete
	find spin_model/ -name "pan" -delete
	find spin_model/ -name "*.pdf" -delete
	find spin_model/ -name "*.dot" -delete
	rm -f *.log *.aux *.dvi *.bbl *.blg *.ilg *.toc *.lof *.lot *.idx *.ind *.ps *.out
	rm -f thesis.pdf

    sty:
	wget -N http://anorien.csc.warwick.ac.uk/mirrors/CTAN/graphics/psfig/psfig.sty
	wget -N http://anorien.csc.warwick.ac.uk/mirrors/CTAN/macros/latex/contrib/wrapfig/wrapfig.sty
	wget -N http://anorien.csc.warwick.ac.uk/mirrors/CTAN/macros/latex/contrib/algorithmicx/algpseudocode.sty
	wget -N http://anorien.csc.warwick.ac.uk/mirrors/CTAN/macros/latex/contrib/algorithmicx/algorithmicx.sty
	wget -N http://mirrors.ctan.org/macros/latex/contrib/appendix/appendix.ins
	wget -N http://mirrors.ctan.org/macros/latex/contrib/appendix/appendix.dtx
	latex appendix.ins
