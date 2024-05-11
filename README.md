Task: using a functional programming language, implement the transformation of a numerical series to a linguistic chain according to a certain probability distribution of values falling into intervals with and then construct the precedence matrix.

Input: a numerical series, the type of probability distribution, the power of the alphabet. Output: a linguistic series and a precedence matrix. Programming language: chosen by the student (Racket) Distribution: exponential distribution

Steps:

The numerical series is sorted from the smallest value to the largest. Thus, we get the range (domain) of valid values.
We divide the OPP into intervals (the number depends on the power of the selected alphabet) in according to the probability distribution, taking into account that the probability of falling to the interval P[a,b]=F(b)-F(a).
Each numerical value is assigned an alphabetical character that has the same index as the interval.
After replacement, the resulting string of letters is output.
Based on the linguistic series, the following matrix is constructed
![image](https://github.com/kiereshka/racket-exponential-distribution/assets/106348326/691ba45e-c066-4d4a-8981-f0c8f43faeba)
