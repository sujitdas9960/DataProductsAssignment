---
title       : Linear Regression Analysis - mtcars data set
subtitle    : 
author      : Sujit Purkayastha Das
job         : Data Analyst
logo        : coursera.png
framework   : io2012        # {io2012, html5slides, shower, dzslides, ...}
highlighter : highlight.js  # {highlight.js, prettify, highlight}
hitheme     : tomorrow      # 
widgets     : []            # {mathjax, quiz, bootstrap}
mode        : selfcontained # {standalone, draft}
knit        : slidify::knit2slides
---
</br>
### Overview

1. User selects number of top predictors (default value is 5) and chooses whether to display resultant fitted linear regression formula and the root mean square error
2. Once user clicks submit button, top predictors are choosen from the mtcars data set by running univariate regression for each predictor
3. Predictors with least significance level (p-value) are chosen
4. mtcars data set is partitioned (60% training set and 40% test set)
 + linear model is fitted using the training data set. The linear model formula is printed if user chooses to see it
 + prediction is run against the test data set. Prediction model's root mean square error is printed if user chooses to see it

--- .class #id 
</br>
### Snapshot of Shiny app when user selects 10 predictors
</br>
<div style='text-align: center;'>
    <img height='475' src='./assets/img/snapshot.png' />
</div>

--- .class #id
</br>
#### Snapshot of Shiny app when user selects 5 predictors and unchecks options
</br>
<div style='text-align: center;'>
    <img height='475' src='./assets/img/snapshot_noOptions.png' />
</div>

--- .class #id

</br>
</br>

<div style='text-align: center;'>
    <img height='475' src='./assets/img/thank-you.png' />
</div>
