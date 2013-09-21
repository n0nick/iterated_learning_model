# Iterated Learning Model

Implementation of the Iterated Learner presented in the Kirby 2000 paper [1].

The software simulates a population attempting to articulate possible meanings
to each other.  Starting with an initial non-linguistic population, the
simulation shows how quickly the learners are educated and the language adjusts
to be fully expressive. It is then possible to analyse the resulting language as
a function of the initial arguments, and formulate conclusions on the
characteristics of various linguistic features.

This work is a part of my seminar paper for the course [0627-3777 Learning
Seminar: Computation and Cognition](http://www2.tau.ac.il/yedion/syllabus.asp?year=2012&course=0627377701).

## Assumptions

1. All full meanings (sentences) are comprised of three parts: Agent,
   Patient and Predicate. They are all mandatory.
2. Meaning units (whether full or partial) cannot have more than one word
   assigned to them.
3. Generalizations are done on the maximal possible level; a learner would
   always prefer the most generic rule (a take on Occam's Razor). This
   specifically means that word learning is done using a Longest Common
   Substring algorithm.
4. Generalizations are done naively. Specifically, the said Longest Common
   Substring algorithm requires exact matches only (no word difference
   calculation) and requires that they are totally common (no probability
   used).

## References

[1] Kirby, S. (2000) *Syntax without Natural Selection: How compositionality
emerges from vocabulary in a population of learners*. In C. Knight, editor, The
Evolutionary Emergence of Language: Social Function and the Origins of
Linguistic Form, pages 303-323. Cambridge University Press.
[(PDF)](http://www.lel.ed.ac.uk/~simon/Papers/Kirby/Syntax%20without%20Natural%20Selection%20How%20compositionality.pdf)
