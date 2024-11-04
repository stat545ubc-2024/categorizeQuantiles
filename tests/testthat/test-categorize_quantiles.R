test_that("Testing categorize_by_quantiles function", {

  # Sample tibble for testing
  simple_test_data_1 <- tibble::tibble(
    id = c("1", "2", "3", "4", "5", "6"),
    score = c(0, 0, 1, 1, 2, 2)
  )

  simple_test_data_2 <- tibble::tibble(
    id = c("1", "2", "3", "4", "5", "6", "7", "8"),
    score = c(0, 0, 1, 1, 2, 2, NA, NA)
  )

  # Show these two test tibbles
  print(simple_test_data_1)
  print(simple_test_data_2)

  # Expected Results for tibbles
  expected_result_1 <- c("low", "low", "medium", "medium", "high", "high")
  expected_result_2 <- c("low", "low", "low", "low", "high", "high", NA, NA)

  # 1. Standard Case - 3 categories
  result_1 <- categorize_by_quantiles(simple_test_data_1, "score", c("low", "medium", "high"), 3)
  print(as.character(result_1$score_category))
  expect_true("score_category" %in% names(result_1))
  expect_equal(as.character(result_1$score_category), expected_result_1)

  # 2. Edge Case: With NA in numerical column Case
  result_2 <- categorize_by_quantiles(simple_test_data_2, "score", c("low", "high"), 2)
  print(as.character(result_2$score_category))
  expect_true("score_category" %in% names(result_1))
  expect_equal(as.character(result_2$score_category), expected_result_2)

  # 3. Error Handling - Non-Existent Column
  # set a non-existent column to the second input variable - numerical_var_name
  expect_error(
    categorize_by_quantiles(simple_test_data_1, "non-existent column", c("low", "medium", "high"), 3),
    "The specified column name does not exist in the data!"
  )

  # 4. Error Handling - Non-numeric Column
  # Set a non-numeric column as the input
  expect_error(
    categorize_by_quantiles(simple_test_data_1, "id", c("low", "medium", "high"), 3),
    "The specified column must be numeric!"
  )

  # 5. Error Handling - Mismatched labels and num_categories
  # Set an input with length of categorical_labels as 3 but num_categories as 2
  expect_error(
    categorize_by_quantiles(simple_test_data_1, "score", c("low", "medium", "high"), 2),
    "The length of labels should match num_categories!"
  )

  # 6. Error Handling - Invalid data
  # Set numerical_data as a single character, which is invalid
  expect_error(
    categorize_by_quantiles("simple_test_data_1", "score", c("low", "medium", "high"), 3),
    "Data must be a data frame or tibble!"
  )

  # 7. Error Handling - Invalid 'num_categories' (<= 1)
  # Set num_categories = 1, which is an invalid input
  expect_error(
    categorize_by_quantiles(simple_test_data_1, "score", c("low"), 1),
    "num_categories must be greater than 1 to create meaningful quantile categories!"
  )

})
