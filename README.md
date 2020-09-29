# `ncar-package`: Noncompartmental Analysis for Pharmacokinetic Report

## Description


 It can report a noncompartmental analysis (NCA) with industrial strength.


## Details


 The main functions are

- pdfNCA to produce PDF file format NCA.
- rtfNCA to produce rtf file format NCA.


## Author

Kyun-Seop Bae <k@acr.kr>

## References

*  Gabrielsson J, Weiner D. Pharmacokinetic and Pharmacodynamic Data Analysis - Concepts and Applications. 5th ed. 2016.  
*  Shargel L, Yu A. Applied Biopharmaceutics and Pharmacokinetics. 7th ed. 2015.  
*  Rowland M, Tozer TN. Clinical Pharmacokinetics and Pharmacodynamics - Concepts and Applications. 4th ed. 2011.  
*  Gibaldi M, Perrier D. Pharmacokinetics. 2nd ed. revised and expanded. 1982. 


## Examples

```r 
 # Theoph and Indometh data: dose in mg, conc in mg/L, time in h
 
 # Output to PDF file
 #pdfNCA(fileName="NCA-Theoph.pdf", Theoph, key="Subject", colTime="Time",
 #       colConc="conc", dose=320, doseUnit="mg", timeUnit="h", concUnit="mg/L")
 #pdfNCA(fileName="NCA-Theoph.pdf", Theoph, key=c("Subject", "Wt"), colTime="Time",
 #       colConc="conc", dose=320, doseUnit="mg", timeUnit="h", concUnit="mg/L")
 #pdfNCA(fileName="NCA-Indometh.pdf", Indometh, key="Subject", colTime="time",
 #       colConc="conc", adm="Infusion", dur=0.5, dose=25, doseUnit="mg",
 #       timeUnit="h", concUnit="mg/L")
 
 
 # Output to RTF file
 #rtfNCA(fileName="NCA-Theoph.rtf", Theoph, key="Subject", colTime="Time",
 #       colConc="conc", dose=320, doseUnit="mg", timeUnit="h", concUnit="mg/L")
 #rtfNCA(fileName="NCA-Theoph.rtf", Theoph, key=c("Subject", "Wt"), colTime="Time",
 #       colConc="conc", dose=320, doseUnit="mg", timeUnit="h", concUnit="mg/L")
 #rtfNCA(fileName="NCA-Indometh.rtf", Indometh, key="Subject", colTime="time",
 #       colConc="conc", adm="Infusion", dur=0.5, dose=25, doseUnit="mg",
 #       timeUnit="h", concUnit="mg/L")
 ``` 

