context("duplicates related functions")

#### mark_duplicates ####

result <- mark_duplicates(example_c14_date_list)

test_that("mark_duplicates gives back a c14_date_list", {
  expect_s3_class(
    result,
    "c14_date_list"
  )
})

test_that("mark_duplicates gives back a c14_date_list with the additional
          column duplicate_group", {
  expect_true(
    all(
      c(colnames(example_c14_date_list), "duplicate_group") %in%
        colnames(result)
    )
  )
})

test_that("mark_duplicates gives back a c14_date_list with the additional
          column duplicate_group and this column is of type integer", {
  expect_type(
    result$duplicate_group,
    "integer"
  )
})

#### remove_duplicates ####

result2 <- remove_duplicates(result)

test_that("remove_duplicates gives back a c14_date_list", {
  expect_s3_class(
    result2,
    "c14_date_list"
  )
})

test_that("remove_duplicates gives back a c14_date_list with the additional
          column duplicate_remove_log", {
  expect_true(
    all(
      c(colnames(result), "duplicate_remove_log") %in%
        colnames(result2)
    )
  )
})

test_that("remove_duplicates gives back a c14_date_list with the additional
          column duplicate_remove_log and this column is of type character", {
  expect_type(
    result2$duplicate_remove_log,
    "character"
  )
})

result3 <- remove_duplicates(example_c14_date_list)

test_that("remove_duplicates alone gives the same result as the other functions combined,
          because it calls the other functions in case of missing variables.", {
  expect_equal(
    result2,
    result3
  )
})
