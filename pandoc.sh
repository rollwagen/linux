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
