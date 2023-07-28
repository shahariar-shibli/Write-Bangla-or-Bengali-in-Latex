# Write-Bangla-or-Bengali-in-Latex
<p align="justify">There is a simple solution to write Bengali or Bangla in Latex using xelatex compiler, 
but many journal, conference or preprint (i.e. arXiv) sites doesnot support xelatex compiler. 
Most of them uses pdflatex compiler. Polyglossia and fontspec package seems not to work with pdflatex.</p>

<p align="justify"> To write bengali/Bangla in pdflatex, there is a package for typesetting documents in Bangla or Bengali using the Tex/Latex systems,
called <em><a href="https://www.saha.ac.in/theory/palashbaran.pal/bangtex/bangtex.html">[Bangtex]</a></em>. It is quite difficult 
to write rules based transliterattions manually to appear as Bengali or Bangla in pdflatex. However, there is a perl script that can
automatically transliterate unicode Bengali or Bangla. Once, we get the transliterations, we just need to paste them in the pdflatex!!</p> 

# Overview
+ <b>Step 1.</b> 
+ <b>Step 2.</b> Convert the txt file containing unicode Bangla into a (.tex) file with the corresponding Bangtex supported transliteration. <em>[Example: rbiin/dRnaethr EkiT kibtar shuru inec ed{O}ya Hl. ]</em> 
+ <b>Step 3.</b> Copy the bangtex supported transliteration and paste into the pdflatex inside a <code>{\bng ... }</code> block where you want to use Bengali. <em>(... should be replaced by the copied transliteration)</em>

# Step 1: Write unicode in Bengali 
<p align="justify">Open a text file (say, <code>smpldoc.txt</code>), write unicode Bengali or unicode Bangla in the text file. 
<em>[Example: রবীন্দ্রনাথের একটি কবিতার শুরু নিচে দেওয়া হল। ]</em> </p>

# Step 2: Convert unicode Bengali to Bangtex 
+ Install Perl in your PC. Download file and installation procedure is available in this <a href="https://learn.perl.org/installing/windows.html">link</a>.
+ Download the *uni2bangtex.perl* script from this repository.
+ Open cmd (command prompt) and run the script as follows:
<code>perl C:\Users\Shibli\Downloads\uni2bangtex.perl C:\Users\Shibli\Downloads\smpldoc.txt > C:\Users\Shibli\Downloads\smpldoc.tex</code>

<p align="justify">[Considering smpldoc.txt file and uni2bangtex.perl script are on the same folder, in the above command "C:\Users\Shibli\Downloads" is the file paths.
Running this command will produce a (.tex) file like smpldoc.tex here. Open this using text editor (i.e. notepad or notepad++ etc)]</p>

# N.B:
I do not own/claim any of the matrials mentioned/used here.

 
