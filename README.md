# Write-Bangla-or-Bengali-in-Latex
<p align="justify">There is a simple <a href="https://github.com/Rajan-sust/Bangla-in-Latex-with-Overleaf">solution</a> to write Bengali or Bangla in Latex using <em>xelatex</em> compiler, 
but many journal, conference or preprint (i.e. arXiv) sites do not support <em>xelatex</em> compiler. 
Most of them uses <em>pdflatex</em> compiler. <em>Polyglossia</em> and <em>fontspec</em> packages (necessary to write Bangla in <em>xelatex</em> compiler) do not seem to work with <em>pdflatex</em>.</p>

<p align="justify"> To write bengali/Bangla in <em>pdflatex</em>, there is a package for typesetting documents in Bangla or Bengali using the Tex/Latex systems,
called <em><a href="https://www.saha.ac.in/theory/palashbaran.pal/bangtex/bangtex.html">[Bangtex]</a></em>. It is quite difficult 
to write rules based transliterattions manually to appear as Bengali or Bangla in <em>pdflatex</em>. However, there is a perl script that can
automatically transliterate unicode Bengali or Bangla to Bangtex supported transliteration. Once, we get the transliterations, we just need to paste them in the latex file!!</p> 

Please follow the below steps:

# Step 1: Write unicode in Bengali 
<p align="justify">Open a text file (say, <code>smpldoc.txt</code>), write unicode Bengali or unicode Bangla in the text file. For example, 
<em><code>রবীন্দ্রনাথের একটি কবিতার শুরু নিচে দেওয়া হল।</em></code></p>

# Step 2: Convert unicode Bengali to Bangtex 
+ Install Perl in your PC. Download file and installation procedure is available in this <a href="https://learn.perl.org/installing/windows.html">link</a>.
+ Download the <code>uni2bangtex.perl</code> script from this repository.
+ [Note: The command in the next point should be written in a single line not in separate lines]().
+ Open cmd (command prompt) and run the script as follows: <code>perl C:\Users\Shibli\Downloads\uni2bangtex.perl C:\Users\Shibli\Downloads\smpldoc.txt > C:\Users\Shibli\Downloads\smpldoc.tex</code><br/><b>clarification:</b> perl[space]C:\Users\Shibli\Downloads\uni2bangtex.perl[space]C:\Users\Shibli\Downloads\smpldoc.txt[space]>[space]C:\Users\Shibli\Downloads\smpldoc.tex
+ Considering <code>smpldoc.txt</code> file and <code>uni2bangtex.perl</code> script are on the same folder, in the above command <code>C:\Users\Shibli\Downloads</code> is the file path. Running this command will generate a (.tex) file in the same folder (as in the command <code>smpldoc.tex</code>). 
+ Open the (.tex) file using text editor (i.e. notepad or notepad++ etc). <code>smpldoc.tex</code> will contain <em><code>rbiin/dRnaethr EkiT kibtar shuru inec ed{O}ya Hl.</code></em> for the bangla example written in the text file.

# Step 3: Copy and paste into Latex file 
+ Download the <code>bangla_commands.tex</code> file from this repository and upload into your latex project.
+ In the <code>main.tex</code> (the tex file that loads when you run your project, may have different name), add <code>bangla_commands.tex</code> file like <code>\input{bangla_commands}</code> anywhere before <code>\begin{document}</code>
+ Copy the bangtex transliteration obtained in step 2 and paste like <code>{\bng rbiin/dRnaethr EkiT kibtar shuru inec ed{O}ya Hl.}</code> where you want to use Bengali. <em>(bangtex trasliteration should inside a <code>{\bng }</code> block.)</em>

# Fun fact
You can write English and Bangla in the input text file. The perl script will keep the English texts as it is. Only Bangla texts will be converted to Bangtex format. 

# N.B:
<p align="justify">I do not own/claim any of the files/materials mentioned/used in this repo. 
I found <a href="https://www.saha.ac.in/theory/palashbaran.pal/bangtex/bangtex.html">this</a> beautiful package and 
read their documentation and summarized into simpler steps. All credit goes to the 
authors/developers of <a href="https://www.saha.ac.in/theory/palashbaran.pal/bangtex/bangtex.html">Bangtex</a> 
and <a href="http://dasgupab.faculty.udmercy.edu/uni2bangtex/index.html">uni2bangtex</a>.</p>

 
