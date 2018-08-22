pkgdown: 
	rm -rf docs ;\
	Rscript -e "Sys.setlocale('LC_ALL', 'C'); pkgdown::build_site(document = FALSE)" 

