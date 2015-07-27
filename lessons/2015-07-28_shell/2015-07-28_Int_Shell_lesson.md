# Cool and Fast Data Wrangling in the Unix Shell by Tiffany Timbers

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


> ## Wildcards 
>
> `grep`'s real power doesn't come from its options, though; it comes from
> the fact that patterns can include wildcards. (The technical name for
> these is **regular expressions**, which
> is what the "re" in "grep" stands for.) Regular expressions are both complex
> and powerful; if you want to do complex searches, please look at the lesson
> on [our website](http://software-carpentry.org/v4/regexp/index.html). As a taster, we can
> find lines that have an 'o' in the second position like this:
>
>     $ grep -E '^.o' haiku.txt
>     You bring fresh toner.
>     Today it is not working
>     Software is like that.
>
> We use the `-E` flag and put the pattern in quotes to prevent the shell
> from trying to interpret it. (If the pattern contained a '\*', for
> example, the shell would try to expand it before running `grep`.) The
> '\^' in the pattern anchors the match to the start of the line. The '.'
> matches a single character (just like '?' in the shell), while the 'o'
> matches an actual 'o'.

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
grep -E '^III' MMP.vcf > ChrIII.vcf
head -5 ChrIII.vcf
~~~

Now you might notice that the header is no longer there. This is because it didn't start
with `III`. To add the header to our output file we first need to extract the header, and 
then extract the Chr III variants and append them to the same file:

~~~
grep -E '^#' MMP.vcf > ChrIII.vcf
grep -E '^III' MMP.vcf >> ChrIII.vcf
head -5 ChrIII.vcf
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
grep -E -v '^##' MMP.vcf > MMP_minheader.txt
~~~

Now we have a simple, rectangular file we can use easily with `awk`. Now, to extract the 
variant column, which is the 3rd column, we can type:

~~~
awk '{print $3}' MMP_minheader.txt > MMPvariants.txt
head -10 MMPvariants.txt
~~~

You can see that we also get the header for that column. What if you don't want that? You
can use:

~~~
awk '{if (NR > 1) print $3}' MMP_minheader.txt > MMPvariants.txt
head -10 MMPvariants.txt
~~~

To select multiple columns, you can simply list them, separating them with commas:

~~~
awk '{print $1, $2, $3}' MMP_minheader.txt > MMP_chrNvarsNpos.txt
head -10 MMP_chrNvarsNpos.txt
~~~

> ## Challenge 
>
> Create a file that contains 

We can specify a range of columns, but it starts to look a bit complicated:

~~~
awk '{for (x=1; x<=3; x++) printf("%s ", $x); printf("\n"); }' MMP_minheader.txt > MMP_chrNvarsNpos.txt
head -10 MMP_chrNvarsNpos.txt
~~~

> ## Challenge 
>
> Create a file that has the columns #CHROM, ID, REF and the first 3 of the VC columns 
> (e.g. VC10118, VC10129 & VC10130) 


