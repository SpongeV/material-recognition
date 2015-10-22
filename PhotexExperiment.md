State-of-the-art classification results for the Photex database

# Results #

Explanation:
  * Accuracy1 - results from the paper Texture Classification With Minimal Training Images _(Targhi, 2009)_
  * Accuracy2 - current accuracy in replicated experiment

| Trainset   | Accuracy1 | Accuracy2 |
|:-----------|:----------|:----------|
| T1         | 96.00%    | 90.38%    |
| T4         | 82.75%    |           |
| G1         | 72.00%    |           |
| G4         | 68.25%    |           |

NOTES:
  * Accuracy1 is based on the average of 5 repetitions. Accuracy2 is based on the average of a 100 repetitions.
  * During supervision meetings, I've been told the accuracies of the original paper are not entirely correct. T1 was measured around 90%. Since I obtained a similar accuracy on a 100-fold cross-validation, the experimental setup looks correct.