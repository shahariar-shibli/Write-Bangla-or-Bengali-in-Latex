# Write-Bangla-or-Bengali-in-Latex
<p align="justify">There is a simple solution to write Bengali or Bangla in Latex using xelatex compiler, 
but many journal, conference or preprint (i.e. arXiv) sites doesnot support xelatex compiler. 
Most of them uses pdflatex compiler. Polyglossia and fontspec package seems not to work with pdflatex.</p>

<p align="justify"> To write bengali/Bangla in pdflatex, there is a package for typesetting documents in Bangla or Bengali using the Tex/Latex systems,
called <em><a href="https://www.saha.ac.in/theory/palashbaran.pal/bangtex/bangtex.html">[Bangtex]</a></em>. It is quite difficult 
to write rules based transliterattions manually to appear as Bengali or Bangla in pdflatex. However, there is a perl script that can
automatically transliterate unicode Bengali or Bangla. Once, we get the transliterations, we just need to paste them in the pdflatex!!</p> 

# Overview
+ Step 1. Write unicode Bengali or unicode Bangla in a (.txt) file. <em>[Example: রবীন্দ্রনাথের একটি কবিতার শুরু নিচে দেওয়া হল। ]</em>
+ Step 2. Convert the txt file containing unicode Bangla into a (.tex) file with the corresponding Bangtex supported transliteration. <em>[Example: rbiin/dRnaethr EkiT kibtar shuru inec ed{O}ya Hl. ]</em> 


# N.B:
I do not own/claim any of the matrials mentioned/used here.

 
