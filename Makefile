pkgdown: 
	rm -rf docs ;\
	Rscript -e "Sys.setlocale('LC_ALL', 'C'); pkgdown::build_site(devel = FALSE)" 

rdmd:
	Rscript -e "Rd2md::Rd2markdown(rdfile = 'man/ncar-package.Rd', outfile = 'README.md')"
