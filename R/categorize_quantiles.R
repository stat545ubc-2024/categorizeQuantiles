#' @title Categorize a Numeric Variable into Quantile-Based Categories
#'
#' @description This function takes a numeric column from a data frame or tibble and divides it into 2 or more of categories
#' by using a specified number of quantiles.
#' A new column with the suffix "_category" is added with the specified labels.
#' The number of categories and the label for each category are decided by users.
#'
#' @param numerical_data A data frame or tibble containing the numerical column to categorize.
#' @param numerical_var_name A character string of the numerical column name to categorize.
#' @param categorical_labels A character vector of labels for each category. Note: it should match the number of categories specified.
#' @param num_categories An integer specifying the number of categories to split into. Must be greater than 1.
#' @return A data frame or tibble with an additional categorical column based on quantiles.
#' @examples
#' # Example1: Using the penguins dataset to categorize body_mass_g
#' penguins_categorized <- categorize_by_quantiles(palmerpenguins::penguins, "body_mass_g", c("light", "average", "heavy"), 3)
#' # Move the new column body_mass_g_category to the front
#' penguins_categorized <- dplyr::select(penguins_categorized, body_mass_g_category, dplyr::everything())
#' # Print the result
#' head(penguins_categorized)
#' print(penguins_categorized)
#'
#' # Example2: Using a simple tibble to categorize "score" into two categories
#' # Define a simple tibble
#' simple_data_1 <- tibble::tibble(id = c("1", "2", "3", "4", "5", "6", "7", "8", "9","10"), score = c(0, 10, 20, 30, 40, 50, 60, 70, 80, 90))
#' data_categorized_1 <- categorize_by_quantiles(simple_data_1, "score", c("low", "high"), 2)
#' # Print the result
#' print(data_categorized_1)
#'
#' # Example3: Apply categorize_by_quantiles to categorize "score" into four categories
#' # Define a simple tibble
#' simple_data_2 <- tibble::tibble(id = c("1", "2", "3", "4", "5", "6", "7", "8", "9","10"), score = c(0, 1, 2, 3, 4, 5, 6, 7, 8, 9))
#' data_categorized_2 <- categorize_by_quantiles(simple_data_2, "score", c("low", "medium", "high", "very high"), 4)
#' # Print the result
#' print(data_categorized_2)
#' @export
categorize_by_quantiles <- function(numerical_data, numerical_var_name, categorical_labels, num_categories) {
  # Ensure numerical_data is a data frame or tibble
  if(!(is.data.frame(numerical_data) || inherits(numerical_data, "tbl_df"))){
    stop("Data must be a data frame or tibble!")
  }

  # Check if numerical_var_name exists
  if (!numerical_var_name %in% names(numerical_data)) {
    stop("The specified column name does not exist in the data!")
  }

  # Check that the specified column is numeric
  if (!is.numeric(numerical_data[[numerical_var_name]])) {
    stop("The specified column must be numeric!")
  }

  # Validate the number of targeted categories is greater than 1
  # Since the number 0 or zero or negative is making no sense
  if (num_categories <= 1) {
    stop("num_categories must be greater than 1 to create meaningful quantile categories!")
  }

  # Ensure the length of labels matches num_categories
  if (length(categorical_labels) != num_categories) {
    stop("The length of labels should match num_categories!")
  }

  # Calculate quantile-based breaks
  # Allow missing values
  quantile_breaks <- quantile(numerical_data[[numerical_var_name]], probs = seq(0, 1, length.out = num_categories + 1), na.rm = TRUE)

  # Create the new column name
  categorical_col_name <- paste0(numerical_var_name, "_category")

  # Use `cut()` to categorize data based on calculated quantile breaks
  numerical_data[[categorical_col_name]] <- cut(
    numerical_data[[numerical_var_name]],
    breaks = quantile_breaks,
    labels = categorical_labels,
    include.lowest = TRUE
  )

  return(numerical_data)
}
