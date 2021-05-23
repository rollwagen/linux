for MDFILE in $(ls [a-z]*.md);
do
        BASEFILENAME=$(basename "$MDFILE" ".md")
        pandoc --variable geometry:margin=1.2cm --variable fontsize=10.5pt "$MDFILE" -o "$BASEFILENAME".pdf
done

