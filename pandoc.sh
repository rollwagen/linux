for MDFILE in $(ls [a-z]*.md);
do
        BASEFILENAME=$(basename "$MDFILE" ".md")
        pandoc \
		--variable geometry:margin=1.5cm \
		--variable fontsize=12pt \
 		--variable colorlinks=true \
 		--variable papersize=a4 \
		"$MDFILE" -o "$BASEFILENAME".pdf
done

pandoc \
	--variable geometry:margin=1.5cm \
	--variable fontsize=12pt \
 	--variable colorlinks=true \
 	--variable papersize=a4 \
	essential_concepts.md filesystem_hierarchy_standard.md process_management.md memory_management.md threading.md \
	-o linux.pdf

# gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -sOutputFile=linux.pdf essential_concepts.pdf filesystem_hierarchy_standard.pdf process_management.pdf memory_management.pdf threading.pdf
