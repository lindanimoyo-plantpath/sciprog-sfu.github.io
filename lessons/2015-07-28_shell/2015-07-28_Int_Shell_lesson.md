# Cool and Fast Data Wrangling in the Unix Shell by Tiffany Timbers
Much of this material has been taken and remixed from Software-Carpentry's Unix Shell 
lesson (http://software-carpentry.org/lessons.html).

## Use `grep` to select lines from text files that match simple patterns

`grep` is a unix-based command line tool which finds and prints lines in files that match 
a pattern. 

### A simple introduction to `grep`

Copy the following text (from three haikus taken from a 1998 competition in Salon 
magazine) and save it as a plain text file, called `haiku.txt`, on your Desktop.

~~~
The Tao that is seen
Is not the true Tao, until
You bring fresh toner.

With searching comes loss
and the presence of absence:
"My Thesis" not found.

Yesterday it worked
Today it is not working
Software is like that.
~~~

Let’s find lines that contain the word “not”:
~~~
$ grep not haiku.txt
~~~
~~~
Is not the true Tao, until
"My Thesis" not found
Today it is not working
~~~

Here, not is the pattern we're searching for. It's pretty simple: every alphanumeric 
character matches against itself. After the pattern comes the name or names of the files 
we're searching in. The output is the three lines in the file that contain the letters 
"not".

Let's try a different pattern: "day".

~~~ {.bash}
$ grep day haiku.txt
~~~
~~~ {.output}
Yesterday it worked
Today it is not working
~~~

This time,
two lines that include the letters "day" are outputted.
However, these letters are contained within larger words.
To restrict matches to lines containing the word "day" on its own,
we can give `grep` with the `-w` flag.
This will limit matches to word boundaries.

~~~ {.bash}
$ grep -w day haiku.txt
~~~

In this case, there aren't any, so `grep`'s output is empty. Sometimes we don't
want to search for a single word, but a phrase. This is also easy to do with
`grep` by putting the phrase in quotes.

~~~ {.bash}
$ grep -w "is not" haiku.txt
~~~
~~~ {.output}
Today it is not working
~~~

We've now seen that you don't have to have quotes around single words, but it is useful to use quotes when searching for multiple words. It also helps to make it easier to distinguish between the search term or phrase and the file being searched. We will use quotes in the remaining examples.

Another useful option is `-n`, which numbers the lines that match:

~~~ {.bash}
$ grep -n "it" haiku.txt
~~~
~~~ {.output}
5:With searching comes loss
9:Yesterday it worked
10:Today it is not working
~~~

Here, we can see that lines 5, 9, and 10 contain the letters "it".

We can combine options (i.e. flags) as we do with other Unix commands.
For example, let's find the lines that contain the word "the". We can combine
the option `-w` to find the lines that contain the word "the" and `-n` to number the lines that match:

~~~ {.bash}
$ grep -n -w "the" haiku.txt
~~~
~~~ {.output}
2:Is not the true Tao, until
6:and the presence of absence:
~~~

Now we want to use the option `-i` to make our search case-insensitive:

~~~ {.bash}
$ grep -n -w -i "the" haiku.txt
~~~
~~~ {.output}
1:The Tao that is seen
2:Is not the true Tao, until
6:and the presence of absence:
~~~

Now, we want to use the option `-v` to invert our search, i.e., we want to output
the lines that do not contain the word "the".

~~~ {.bash}
$ grep -n -w -v "the" haiku.txt
~~~
~~~ {.output}
1:The Tao that is seen
3:You bring fresh toner.
4:
5:With searching comes loss
7:"My Thesis" not found.
8:
9:Yesterday it worked
10:Today it is not working
11:Software is like that.
~~~

`grep` has lots of other options.
To find out what they are, we can type `man grep`.
`man` is the Unix "manual" command:
it prints a description of a command and its options,
and (if you're lucky) provides a few examples of how to use it.

To navigate through the `man` pages,
you may use the up and down arrow keys to move line-by-line,
or try the "b" and spacebar keys to skip up and down by full page.
Quit the `man` pages by typing "q".


> ## Challenge 
>
> The Tao that is seen
> Is not the true Tao, until
> You bring fresh toner.
> With searching comes loss
> and the presence of absence:
> "My Thesis" not found.
> Yesterday it worked
> Today it is not working
> Software is like that.
>
> From the above text, contained in the file haiku.txt, which command would result in the following output:
> 
> `and the presence of absence`
>
> a. `grep of haiku.txt`
> b. `grep -E of haiku.txt`
> c. `grep -w of haiku.txt`


## Wildcards 

 `grep`'s real power doesn't come from its options, though; it comes from
 the fact that patterns can include wildcards. (The technical name for
 these is **regular expressions**, which
 is what the "re" in "grep" stands for.) Regular expressions are both complex
 and powerful; if you want to do complex searches, please look at the lesson
 on [our website](http://software-carpentry.org/v4/regexp/index.html). As a taster, we can
 find lines that have an 'o' in the second position like this:

     $ grep -E '^.o' haiku.txt
     You bring fresh toner.
     Today it is not working
     Software is like that.

 We use the `-E` flag and put the pattern in quotes to prevent the shell
 from trying to interpret it. (If the pattern contained a '\*', for
 example, the shell would try to expand it before running `grep`.) The
 '\^' in the pattern anchors the match to the start of the line. The '.'
 matches a single character (just like '?' in the shell), while the 'o'
 matches an actual 'o'.

### Using `grep` to select lines from a variant call file

Variant call files (`.vcf`) a text file used in bioinformatics for storing gene sequence 
variations. The format has been developed with the advent of large-scale genotyping and 
DNA sequencing projects, such as the 1000 Genomes Project.


These files can be very large, and often you might want to filter the data within these 
files. There have been tools developed to do this (e.g. vcftools), but it is also 
possible to do this quickly and easily with the command line.


We will be working with an example `.vcf` file from the Million Mutation Project 
(Thompson et al., 2013) that contains the genotype information for 500 variants for 20
individuals. This file is called `MMP.vcf` and can be found in the `genomic` directory
in the `data` directory provided with this lesson.


One thing we might want to do is extract all the rows that contain mutations on Chr III. 
We can use grep to do this:

~~~
$ grep -E '^III' MMP.vcf > ChrIII.vcf
$ head -5 ChrIII.vcf
~~~

Now you might notice that the header is no longer there. This is because it didn't start
with `III`. To add the header to our output file we first need to extract the header, and 
then extract the Chr III variants and append them to the same file:

~~~
$ grep -E '^#' MMP.vcf > ChrIII.vcf
$ grep -E '^III' MMP.vcf >> ChrIII.vcf
$ head -5 ChrIII.vcf
~~~

> ## Challenge 
>
> Create a `.vcf` file for Chromosomes I

## Selecting columns using `awk`

`Awk` is an interpreted programming language designed for text processing and typically used 
as a data extraction and reporting tool. It is a standard feature of most Unix-like 
operating systems.


Where `grep` can be very useful to grab rows of data, we can use `awk` to select certain
columns of data that we are interested in.
 

If, for example, in the `.vcf` we have been working with we want to grab the names of all
of the variants, we can easily combine awk and grep to do this. First, we will use grep to
make a version of the `.vcf` file with a less complex header:

~~~
$ grep -E -v '^##' MMP.vcf > MMP_minheader.txt
~~~

Now we have a simple, rectangular file we can use easily with `awk`. Now, to extract the 
variant column, which is the 3rd column, we can type:

~~~
$ awk '{print $3}' MMP_minheader.txt > MMPvariants.txt
$ head -10 MMPvariants.txt
~~~

We can also "peak" at what we are doing with large files before saving things by combining
`awk` and `head` with a pipe, `|` (the vertical bar on your keyboard).

~~~
$ awk '{print $3}' MMP_minheader.txt | head -10
~~~

> ## Challenge 
>
> Extract the INFO column


You can see that we also get the header for that column. What if you don't want that? You
can use:

~~~
$ awk '{if (NR > 1) print $3}' MMP_minheader.txt | head -10
~~~

Wait! so can we use that on the original .vcf file? Yes we can!

~~~
$ awk '{if (NR > 51) print $3}' MMP.vcf | head -10
~~~

To select multiple columns, you can simply list them, separating them with commas:

~~~
$ awk '{if (NR > 51) print $1, $2, $3}' MMP.vcf | head -10
~~~

We can specify a range of columns, but it starts to look a bit complicated, and it is
"simplest" on rectangular datasets:

~~~
awk '{for (x=1; x<=7; x++) printf("%s ", $x); printf("\n"); }' MMP_minheader.txt | head -10
~~~

> ## Challenge 
>
> Create a file that has the columns 20-29.

## Finding files and folders using `find`

Sometimes, files we want to work with are distributed across different folders. If for 
example, we wanted to concatenate everything from a similar file-type to make one big file
for analysis, how might we do this? We can use the `find` tool in the Unix Shell.


In the `behaviour` directory inside the `data` directory associated with this lesson we 
can see 3 date-time-stamped folders which contain many files, including those that end in
`.dat`, `.set` and `.summary`. Each `.dat` file represents the behavioural analysis of a  
single worm from a worm tracking experiment and each date-time-stamped folder contains
all the worms that were on a plate together during a single tracking experiment. We want 
to combine all the `.dat` files into one big file so that we can work with it our 
favourite programming language (e.g. R, Python, Matlab, etc). The `find` command will let
us do this very easily. Before we jump into this, let's learn a little more about the find 
command.


With `find` we can grab the file or directory names within our current directory or any 
sub-directories. We can do this by asking what are the names of all the directories and 
sub-directories in our current directory. To demonstrate this, let's navigate to the data 
directory:

~~~
$ cd ..
$ pwd
$ find . -type d
~~~

We can specify that we only want to know about the directories in our current directory, 
and not their subdirectories using the `-maxdepth` option.

~~~
$ find . -maxdepth 1 -type d
~~~

We can use the `f` option for type to get all the files in the directory and 
subdirectories:

~~~
$ find . -type f
~~~

OK, this is great, but back to our current problem, how can we access only certain files
or directories? We can use the `-name` option instead of `-type` and match names. To 
get all the names of the files ending in `.summary` in the behaviour directory we can:

~~~
$ cd behaviour
$ find . -name *.summary
~~~

> ## Challenge 
>
> Grab the file names of all the `.dat` files in the behaviour directory

Now, we want to concatenate all these files - how could we do that? Could we use a pipe as
we did previously and send the output of find to `cat`, `grep` or `awk`?

~~~
$ find . -name *.summary | cat
~~~

That doesn't seem to work... All we get are the filenames... So we need to use another 
method for combining tools, the `$()`. For example:

~~~
$ wc -l $(find . -name '*.summary')
~~~

When the shell executes this command, the first thing it does is run whatever is inside 
the $(). It then replaces the $() expression with that command's output. Since the output 
of find is the three filenames ending in `.summary` the shell 
constructs the command:

~~~
$ wc -l ./20141118_141834/n2_4DayOld_locomo600s_a.summary ./20141118_145455/n2_4DayOld_locomo600s_b.summary ./20141118_152854/n2_4DayOld_locomo600s_c.summary
~~~

> ## Challenge 1
> Using `cat`, concatenate all the text in all the `.summary` files into one file called
> `all_summaries.summary`

> ## Challenge 2
> How do you know if you got the right answer?

> ## Challenge 3
> Using `cat`, concatenate all the text in all the `.dat` files into one file called
> `all_dats.dat`. This works in our case with only 3 experiments, but with more we would 
> get the error `-bash: /bin/cat: Argument list too long`. How could we get around this
> still using the Shell?



