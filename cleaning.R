#!/usr/bin  /env Rscript
args = commandArgs(trailingOnly = TRUE)

library(tidyverse)
library(lubridate)

# test if there is at least one argument: if not, return an error
if (length(args)==0) {
  stop('Usage: cleaning infile outfile', call.=FALSE)
  } else if (length(args)==1) {
  # default output file
  args[2] = 'out.txt'
  }

#while(FALSE){
headers <- c('FILER_ID',
              'FREPORT_ID',
              'TRANSACTION_CODE',
              'E_YEAR',
              'T3_TRID',
              'DATE1_10',
              'DATE2_12',
              'CONTRIB_CODE_20',
              'CONTRIB_TYPE_CODE_25',
              'CORP_30',
              'FIRST_NAME_40',
              'MID_INIT_42',
              'LAST_NAME_44',
              'ADDR_1_50',
              'CITY_52',
              'STATE_54',
              'ZIP_56',
              'CHECK_NO_60',
              'CHECK_DATE_62',
              'AMOUNT_70',
              'AMOUNT2_72',
              'DESCRIPTION_80',
              'OTHER_RECPT_CODE_90',
              'PURPOSE_CODE1_100',
              'PURPOSE_CODE2_102',
              'EXPLANATION_110',
              'XFER_TYPE_120',
              'CHKBOX_130',
              'CREREC_UID',
              'CREREC_DATE')
#}

types <- c('cccciccccccccccccccddccccccccc')

#txntypes[1]: credits
#txntypes[2]: inkind
#txntypes[3]: debits
txntypes <- c(c('A', 'B', 'C', 'G', 'I', 'L'),
             c('D'),
             c('F', 'H', 'J', 'M', 'N', 'Q'))


infile <- args[1]
sprintf('Loading %s ...', infile)
cf <- read_csv(infile, col_names = headers, col_types = types, locale = locale(encoding ='ISO-8859-1'), progress = show_progress())

#function(FILER_ID, START, END) #int, date, date
cf <- cf %>%
  #optional id filter
  #filter(
    #cf$FILER_ID %in% idlist #FILER_ID
    #) %>%
  group_by(TRANSACTION_CODE) %>% 
  mutate(
    CREDIT = TRANSACTION_CODE %in% txntypes[1],
    DEBIT = TRANSACTION_CODE %in% txntypes[2],
    INKIND = TRANSACTION_CODE %in% txntypes[3]
  ) %>% 
  ungroup(
  ) %>% 
  mutate(
    CLEAN_DATE = paste(substr(DATE1_10, 1, 6), E_YEAR, sep = ""),
    CLEAN_DATE = parse_date_time(DATE1_10, 'mdy'),
    AMOUNT = case_when(
      DEBIT == TRUE ~ -AMOUNT_70,
      CREDIT == TRUE ~ AMOUNT_70,
      INKIND == TRUE ~ NaN
    )
)

outfile <- args[2]
sprintf('writing %s ...', outfile)
cf %>% write_csv(outfile)
  
  
  
  