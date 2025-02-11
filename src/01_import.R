# Header start =================================================================
# 01_import.R
#
# Author: Hennch Cornelius (cornelius.hennch@charite.de)
#
# Description: Imports data for the analysis
#
# Input: Data exported from PsychEQ.
# Output: Variable key as excel readable file.
#
# Code written according to Hadley Wickhams "tidyverse style guide"
# Header end ===================================================================


# 1. import SPSS file ----------------------------------------------------------

raw_data <- haven::read_sav(here("data", "raw", "psychoEQExport_2.8.2024_8.5.sav")) %>%
  haven::as_factor() %>%
  select(!contains("PRN")) %>%
  clean_names()

# import dekiz identifiers
dekiz_patients <- readxl::read_excel(here("data", "raw", "PEQ_Liste_DeKIZ_23.xlsx"),
                                     range = "B1:E384",
                                     col_types = c("text", "text", "text", "date")) %>%
  rename(code = `PEQ No.`)

# import tk identifiers
tk_patients <- readxl::read_excel(here("data", "raw", "PEQ_Liste_TK.xlsx"),
                                     # range = "B1:E384",
                                     col_types = c("text", "text", "text", "date"))

# names
names(tk_patients) <- names(dekiz_patients)

# bind_together
patient_id <- bind_rows(tk_patients, dekiz_patients)

# add labels
labelled::var_label(patient_id) <- names(patient_id)


# 2. examine variables ---------------------------------------------------------

# variable key for overview
var_key <- labelled::var_label(raw_data) %>%
  as.data.frame() %>%
  pivot_longer(everything(), names_to = "var_name", values_to = "label")

if (save_output) {
  # export
  write.xlsx(var_key, here("output", "tables", "variable_key.xlsx"))

}
