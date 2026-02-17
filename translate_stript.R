library(deeplr)
library(readr)
library(stringr)
library(fs)

# Set your DeepL API key
Sys.setenv(DEEPL_AUTH_KEY = "90bfd573-c31d-4dc6-a28c-4ea5d1535021:fx")

# List all *.fr.qmd files
fr_files <- dir_ls(path = ".", glob = "*.fr.qmd")

for (file in fr_files) {
  lines <- read_lines(file)
  
  # Split YAML, code chunks, and narrative text
  is_chunk <- FALSE
  translated_lines <- c()
  
  for (line in lines) {
    if (str_detect(line, "^```")) {
      is_chunk <- !is_chunk
      translated_lines <- c(translated_lines, line)
    } else if (is_chunk || str_detect(line, "^---") || str_trim(line) == "") {
      translated_lines <- c(translated_lines, line)  # don't translate
    } else {
      # Translate only narrative content
      translated_line <- tryCatch({
        deeplr::translate2(text = line, target_lang = "FR")
      }, error = function(e) {
        message("Translation error: ", e$message)
        return(line)
      })
      translated_lines <- c(translated_lines, translated_line)
    }
  }
  
  # Write to a new file with _translated suffix
  output_file <- str_replace(file, "\\.fr\\.qmd$", ".fr.qmd")
  write_lines(translated_lines, output_file)
  message("Translated file saved: ", output_file)
}
