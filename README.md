
<!-- README.md is generated from README.Rmd. Please edit that file -->

# categorizeQuantiles

<!-- badges: start -->
<!-- badges: end -->

## Description

The goal of categorizeQuantiles is to provide tools for categorizing
numeric variables in data frames or tibbles into quantile-based
categories. This is especially useful for grouping continuous data into
discrete categories based on quantiles, making it easier to analyze and
visualize patterns within categorical groups.

## Installation

You can install the development version of categorizeQuantiles from
[GitHub](https://github.com/) with:

``` r
# in R, make sure that the devtools package is installed then run 
# install.packages("devtools")
devtools::install_github("stat545ubc-2024/categorizeQuantiles")
```

## Example

In this part, let’s use a simple tibble and the *penguins* dataset from
the *palemerpenguins* package to show the correct usages.

Firstly, load the package and other library:

``` r
library(categorizeQuantiles)
```

#### 1. Using a Simple Tibble

This example divides the **score** column into two categories: “low”,
“high”.

``` r
# Define a simple tibble
simple_data <- tibble::tibble(
    id = c("1", "2", "3", "4", "5", "6", "7", "8", "9","10"),
    score = c(0, 10, 20, 30, 40, 50, 60, 70, 80, 90)
)

# Display the tibble
print(simple_data)
#> # A tibble: 10 × 2
#>    id    score
#>    <chr> <dbl>
#>  1 1         0
#>  2 2        10
#>  3 3        20
#>  4 4        30
#>  5 5        40
#>  6 6        50
#>  7 7        60
#>  8 8        70
#>  9 9        80
#> 10 10       90

# Apply categorize_by_quantiles to categorize "score" into two categories
data_categorized_1 <- categorize_by_quantiles(
    numerical_data = simple_data,
    numerical_var_name = "score",
    categorical_labels = c("low", "high"),
    num_categories = 2
)
# Display the result
print(data_categorized_1)
#> # A tibble: 10 × 3
#>    id    score score_category
#>    <chr> <dbl> <fct>         
#>  1 1         0 low           
#>  2 2        10 low           
#>  3 3        20 low           
#>  4 4        30 low           
#>  5 5        40 low           
#>  6 6        50 high          
#>  7 7        60 high          
#>  8 8        70 high          
#>  9 9        80 high          
#> 10 10       90 high
```

#### 2. Using a simple data frame

This example divides the **score** column into four categories: “low”,
“medium”, “high”, “very high”.

``` r
# Define a simple data frame
simple_data_2 <- data.frame( id = 1:10, score = c(55, 67, 22, 87, 45, 36, 91, 75, 59, 66) ) 

# Display the data frame
print(simple_data_2)
#>    id score
#> 1   1    55
#> 2   2    67
#> 3   3    22
#> 4   4    87
#> 5   5    45
#> 6   6    36
#> 7   7    91
#> 8   8    75
#> 9   9    59
#> 10 10    66

# Apply categorize_by_quantiles to categorize "score" into four categories
data_categorized_2 <- categorize_by_quantiles(
    numerical_data = simple_data_2,
    numerical_var_name = "score",
    categorical_labels = c("low", "medium", "high", "very high"),
    num_categories = 4
)

# Display the result
print(data_categorized_2)
#>    id score score_category
#> 1   1    55         medium
#> 2   2    67           high
#> 3   3    22            low
#> 4   4    87      very high
#> 5   5    45            low
#> 6   6    36            low
#> 7   7    91      very high
#> 8   8    75      very high
#> 9   9    59         medium
#> 10 10    66           high
```

#### 3. Using the penguins Dataset

This example uses **penguins** dataset and categorize **body_mass_g**
into three categories: “light”, “average”, “heavy”.

``` r
# Categorize body_mass_g into three quantile-based categories
penguins_categorized <- categorize_by_quantiles(
    numerical_data = palmerpenguins::penguins,
    numerical_var_name = "body_mass_g",
    categorical_labels = c("light", "average", "heavy"),
    num_categories = 3
)
# Move the new column body_mass_g_category to the front
penguins_categorized <- dplyr::select(penguins_categorized, body_mass_g_category, dplyr::everything())

# Display the result
head(penguins_categorized)
#> # A tibble: 6 × 9
#>   body_mass_g_category species island    bill_length_mm bill_depth_mm
#>   <fct>                <fct>   <fct>              <dbl>         <dbl>
#> 1 average              Adelie  Torgersen           39.1          18.7
#> 2 average              Adelie  Torgersen           39.5          17.4
#> 3 light                Adelie  Torgersen           40.3          18  
#> 4 <NA>                 Adelie  Torgersen           NA            NA  
#> 5 light                Adelie  Torgersen           36.7          19.3
#> 6 light                Adelie  Torgersen           39.3          20.6
#> # ℹ 4 more variables: flipper_length_mm <int>, body_mass_g <int>, sex <fct>,
#> #   year <int>
print(penguins_categorized)
#> # A tibble: 344 × 9
#>    body_mass_g_category species island    bill_length_mm bill_depth_mm
#>    <fct>                <fct>   <fct>              <dbl>         <dbl>
#>  1 average              Adelie  Torgersen           39.1          18.7
#>  2 average              Adelie  Torgersen           39.5          17.4
#>  3 light                Adelie  Torgersen           40.3          18  
#>  4 <NA>                 Adelie  Torgersen           NA            NA  
#>  5 light                Adelie  Torgersen           36.7          19.3
#>  6 light                Adelie  Torgersen           39.3          20.6
#>  7 light                Adelie  Torgersen           38.9          17.8
#>  8 heavy                Adelie  Torgersen           39.2          19.6
#>  9 light                Adelie  Torgersen           34.1          18.1
#> 10 average              Adelie  Torgersen           42            20.2
#> # ℹ 334 more rows
#> # ℹ 4 more variables: flipper_length_mm <int>, body_mass_g <int>, sex <fct>,
#> #   year <int>
```
