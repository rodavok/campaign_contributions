# campaign_contributions

usage cleaning.R infile outfile

creates a new CSV file with the additional features:
CREDIT(bool)=indicates transaction was +
DEBIT(bool)=indicates transaction was -
INKIND(bool)=indicates transaction should be treated as NaN
AMOUNT=adjusted transaction amounts depending on debit, credit, or inkind
CLEAN_DATE=DATE1_10 column as true datetime
