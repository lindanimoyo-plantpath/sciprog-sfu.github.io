# Introduction to Regular Expressions

 - **Authors**: Bruno Grande
 - **Research field**: Computational biology / Cancer genomics
 - **Lesson Topic**: This lesson introduces the basics of regular expressions. 

## Setup

For today's lesson, our "data" will be the following text. To introduce the basics of regular expressions (regex), we will be using the website http://regexpal.com/. This will allow us to focus on the regex syntax. If we have time, we can start using other tools, such as grep, sed and python. For now though, copy the text below into the bottom text box on regexpal. 

Additionally, you can use any number of regex cheat sheets available online. Here's [one example](http://www.cheatography.com/davechild/cheat-sheets/regular-expressions/). 

```
=== Parts 1 and 2 ===

TACTAGATGACTGCAGAATTCCCGACGTTAAGTACATTACCCCGTCCAGG
GCGCCGTTCAGGATCACGTTACCGCCATAAGATGGGAGGGATCCTTCTTC
TCCGCTGCGCCCACGCCAGTAGTGATTATATATACTCCTATAACCCTTCT
CCGGAGGCGGAAATCCGCCACGAATGAATTCGAGAATGTATTTCCCCGAC
AATCATTATATAGGGGCGCTCCTAAGCTTTTCCACTCGGTTGAGCCTGGT
```

## Lesson

### Part 1: Basic Patterns

A common technique in molecular biology is to digest or cut DNA with restriction enzymes. You can think of restriction enzymes as DNA scissors that only cut at specific places, depending on their recognition site. There are a great number of commercially available restriction enzymes, each with its own recognition site. I have included a few real and theoretical ones below. 

| Restriction Enzyme | Recognition Sequence |
| ------------------ | -------------------- |
| *Eco*RI            | `GAATTC`             |
| *Bam*HI            | `GGATCC`             |
| *Eco*RII           | `CCWGG`              |
| *Boom*HI           | `CTGCNNNN`           |

**Notes** 

* W = A or T 

* N = A, T, G or C

To search for *Eco*RI cutting sites, you can simply search using the recognition sequencing as the pattern. 

```text
GAATTC
```

This should unveil two *Eco*RI cutting sites. You can do the same for finding *Bam*HI cutting sites. 

```text
GGATCC
```

In this case, you should find one *Bam*HI cutting site. 

What if you're interested in doing a double digestion, using both *Eco*RI and *Bam*HI. In this case, you want to match either `GAATTC` or `GGATCC`. The "OR" operator in regex is the vertical bar (or pipe), `|`. Hence, here's how you can match all *Eco*RI and *Bam*HI cutting sites. 

```text
GAATTC|GGATCC
```

**Warning:** Spacing in regex matters. Hence, do not add spaces that are not specifically needed. For instance, the following pattern would fail to detect cutting sites: `GAATTC | GGATCC`. This pattern would search for `GAATTC` followed by a space or `GGATCC` preceded by a space. Neither of these appear in our example text. 

**Tip:** If the pattern isn't matching, make sure there aren't any hidden newlines. 

Now that we've found all *Eco*RI and *Bam*HI cutting sites, let's do the same for *Eco*RII. In this case, the recognition sequence is `CCWGG`, where W = A or T. If you were to search for `CCWGG`, you will notice that no matches are made. This is because regex isn't aware of the W convention. Instead, it's searching for the actual letter W. 

There is a way however to specify a range of possible characters to match. For this, you can use the square braquets notation, `[]`. In this case, you want to match `CC`, followed by either an A or a T, followed by `GG`. In regex, you can express this pattern as follows. 

```text
CC[AT]GG
```

This pattern should detect two *Eco*RII cutting sites, one being CCAGG and the other, CCTGG. 

If you wanted to detect *all* possible cutting sites, you can add *Eco*RII's recognition sequence to our list from before, namely:

```text
GAATTC|GGATCC|CC[AT]GG
```

----

#### Challenge Question 1

Refer back to the table of restriction enzymes above. Create a pattern to match *Boom*HI cutting sites. 

**Hint:** If you notice repetition in your pattern, you should consider using quantifiers. See cheat sheet or jump ahead a little to learn how to use quantifiers. 

*Answers to challenge questions are located at the bottom of this lesson.*

----

### Part 2: Quantifiers

A common feature of DNA sequences are repeats, in which a stretch of sequence is repeated a variable number of times. The repeated sequence is usually relatively well defined, but the number of repeats can vary. 

The simplest kind of repeat is a stretch of the same nucleotide. For instance, to search for stretches of one or more T's, you may use the plus quantifier, `+`. This quantifier means that the preceding subpattern can be present one or more times. Similar quantifier are the asterisk, `*`, which signifies zero or more times, and the question mark, `?`, which signifies zero or one time.

In this case, matching stretches of one or more T's can be done as follows. 

```text
T+
```

You should see a number of matches in the DNA sequence, One wouldn't consider a single T to be a repeat. Let's say we want to search for two or more T's in a row. We may use the general quantifier notation using curly braces, `{}`. 

There are various ways of using the curly braces notation. 

* **An exact count:** `{3}` would match exactly three occurrences of the preceding subpattern.
* **A bounded range:** `{3,5}` would match three, four or five occurrences. 
* **An unbounded range:** `{3,}` would match three or more occurrences.

Hence, in our case, if we wish to match stretches of two or more T's in the DNA sequence, we can achieve this with the following pattern. 

```text
T{2,}
```

Now, let's match repeats of the dinucleotide TA. Unfortunately, the pattern `TA{2,}` doesn't work, because the quantifier only applies to the subpattern directly preceding it, namely `A` in this case. This pattern would match ant T following by two or more A's. 

To match TA repeats, we need to group the T and A together and apply the quantifier to that group. The parentheses notation, `()`, can be used to this effect. Accordinfly, our pattern becomes:

```text
(TA){2,}
```

As you can see, there are three instances of TA repeats in our example DNA sequence. 

----

#### Challenge Question 2

Match all of the phone number formats listed below. 

```text
415-555-1234
650-555-2345
(416)555-3456
202 555 4567
4035555678
1 416 555 9292
```

**Hint:** The question mark quantifier, `?`, mentioned earlier could be useful here. 

*Answers to challenge questions are located at the bottom of this lesson.*

----

### Part 3: Character Classes

To-do list:

* Ranges using square braquets
* Character classes (_e.g._ ., \w, \d, \s)
* Special characters (\n, \t)
* Word boundary (\b)

----

#### Challenge Question 3

Create a regex pattern that matches all of the number formats listed below. 

```text
3.14529
-255.34
128
1.9e10
123,340.00
```

*Answers to challenge questions are located at the bottom of this lesson.*

----

### Part 4: Applications of Regular Expressions

To-do list:

* Using `grep` or `sed`
* Using `python`

## Answers to Challenge Questions

#### Challenge Question 1

Based on what we learned so far, a correct pattern to match *Boom*HI cutting sites would be the following. 

```text
CTGC[ATGC][ATGC][ATGC][ATGC]
```

However, we have the same subpattern (`[ATGC]`) being repeated multiple times. In regex, we can use quantifiers to allow subpatterns to be repeated a given number of times using the curly braces notation, `{}`. In this case, we want the `[ATGC]` subpattern to be matched exactly four times. 

```text
CTGC[ATGC]{4}
```

#### Challenge Question 2

There are many approaches to solving this challenge. Here's my attempt:

```text
1? ?\(?\d{3}\)?[- ]?\d{3}[- ]?\d{4}
```

#### Challenge Question 3

Again, there are multiple ways of solving this challenge. Here's one example solution. 

```text
-?(\d+,?)+(\.\d+)?(e\d+)?
```
