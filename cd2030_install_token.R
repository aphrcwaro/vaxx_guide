
if (!requireNamespace("devtools", quietly = TRUE)) {
  install.packages("devtools")
}
devtools::install_github("aphrcwaro/cd2030.rmncah", 
                         auth_token = "g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")
library(cd2030.rmncah)
dashboard()
