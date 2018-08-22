Res2Txt = function(ResNCA, x, y, dose=0, adm="Extravascular", dur=0, doseUnit="mg", down="Linear")
{
  if (!(is.numeric(x) & is.numeric(y) & is.numeric(dose) & is.numeric(dur) & is.character(adm) & is.character(down))) stop("Check input types!")

  n = length(x)
  if (n != length(y)) stop("Length of y is different from the length of x!")

  if (length(y[y > 0]) < 3) return("Too few non-zero points for NCA")

  adm = UT(adm)
  down = UT(down)
  if (adm == "INFUSION" & !(dur > 0)) stop("Infusion mode should have dur larger than 0!")

  NApoints = is.na(x) | is.na(y)
  x = x[!NApoints]             # remove NA points in x
  y = y[!NApoints]             # remove NA points in y

  iLastNonZero = max(which(y > 0)) # Index of last non-zero y
  x0 = x[1:iLastNonZero] # Till Non-zero concentration. i.e. removing trailing zeros
  y0 = y[1:iLastNonZero] # Till Non-zero concentration. i.e. removing trailing zeros
  x1 = x0[y0 != 0]             # remove all points with zeros in y (including mid) for LAMZ
  y1 = y0[y0 != 0]             # remove all points with zeros in y

  C0Imputed = FALSE
  if (adm == "BOLUS") {
    if (y[1] > y[2] & y[2] > 0) {
      C0 = exp(-x[1]*(log(y[2]) - log(y[1]))/(x[2] - x[1]) + log(y[1]))
    } else {
      C0 = y[x==min(x[y > 0])]
    }
    x2 = c(0, x)
    y2 = c(C0, y)
    x3 = c(0, x0)
    y3 = c(C0, y0)
    C0Imputed = TRUE
  } else {
    if (is.na(x[x==0][1])) {
      x2 = c(0, x)
      y2 = c(0, y)
      x3 = c(0, x0)
      y3 = c(0, y0)
      C0Imputed = TRUE
    } else {
      x2 = x             # for AUCALL including trailing zero y values
      y2 = y
      x3 = x0            # for AUCLST without trailing zero y values
      y3 = y0
    }
  }

  tabAUC = AUC(x3, y3, down=down)

  Res = ResNCA
  UsedPoints = attr(Res, "UsedPoints")
  if (C0Imputed == TRUE) UsedPoints = UsedPoints + 1

# Begin Making Summary Table
  if (!is.na(Res["LAMZ"])) {
    iL = which(x3==Res["LAMZLL"])
    iU = which(x3==Res["LAMZUL"])
    xr0 = x3[iL:iU]
    yr0 = y3[iL:iU]
    ypr = exp(Res["b0"] - Res["LAMZ"]*xr0)
    yre = yr0 - ypr
  } else {
    iL = 0
    iU = 0
    ypr = NA
    ype = NA
  }
 # End Making Summary Table
  DateTime = strsplit(as.character(Sys.time())," ")[[1]]

  Result = vector()
  cLineNo = 1
  Result[cLineNo] = paste("                        NONCOMPARTMENTAL ANALYSIS REPORT") ; cLineNo = cLineNo + 1
  Result[cLineNo] = paste0("                       Package version ", packageVersion("ncar"), " (", packageDescription("ncar")$Date, ")") ; cLineNo = cLineNo + 1
  Result[cLineNo] = paste("                         ", version$version.string) ; cLineNo = cLineNo + 1
  Result[cLineNo] = "" ; cLineNo = cLineNo + 1
  Result[cLineNo] = paste("Date and Time:", Sys.time(), Sys.timezone()) ; cLineNo = cLineNo + 1
  Result[cLineNo] = "" ; cLineNo = cLineNo + 1
  Result[cLineNo] = "Calculation Setting" ; cLineNo = cLineNo + 1
  Result[cLineNo] = "-------------------" ; cLineNo = cLineNo + 1
  if (adm == "BOLUS") { Adm = "Bolus IV" }
  else if (adm == "INFUSION") { Adm = "Constant Infusion" }
  else { Adm = "Extravascular" }
  Result[cLineNo] = paste("Drug Administration:", Adm) ; cLineNo = cLineNo + 1
  Result[cLineNo] = paste("Observation count excluding trailing zero:", length(x0)) ; cLineNo = cLineNo + 1
  Result[cLineNo] = paste("Dose at time 0:", paste(dose, doseUnit)) ; cLineNo = cLineNo + 1
  if (adm == "INFUSION") {
    Result[cLineNo] = paste("Length of Infusion:", dur) ; cLineNo = cLineNo + 1
  }
  if (down == "LINEAR") {
    Result[cLineNo] = "AUC Calculation Method: Linear-up Linear-down" ; cLineNo = cLineNo + 1
  } else if (down == "LOG") {
    Result[cLineNo] = "AUC Calculation Method: Linear-up Log-down" ; cLineNo = cLineNo + 1
  } else {
    Result[cLineNo] = paste("AUC Calculation Method: Unknown") ; cLineNo = cLineNo + 1
  }
  Result[cLineNo] = "Weighting for lambda z: Uniform (Ordinary Least Square, OLS)" ; cLineNo = cLineNo + 1
  Result[cLineNo] = "Lambda z selection criterion: Heighest adjusted R-squared value with precision=1e-4" ; cLineNo = cLineNo + 1
  Result[cLineNo] = "" ; cLineNo = cLineNo + 1
  Result[cLineNo] = "" ; cLineNo = cLineNo + 1
  Result[cLineNo] = "Fitting, AUC, AUMC Result" ; cLineNo = cLineNo + 1
  Result[cLineNo] = "-------------------------" ; cLineNo = cLineNo + 1
  Result[cLineNo] = "      Time         Conc.      Pred.   Residual       AUC       AUMC" ; cLineNo = cLineNo + 1
  Result[cLineNo] = "---------------------------------------------------------------------" ; cLineNo = cLineNo + 1
  for (i in 1:length(x3)) {
    Str = sprintf("%11.4f", Round(x3[i],4))
    if (C0Imputed & i == 1) { Str = paste(Str, "+") }
    else if (i %in% UsedPoints) { Str = paste(Str, "*") }
    else { Str = paste(Str, " ") }
    Str = paste(Str, sprintf("%10.4f", Round(y3[i], 4)))
    if (i %in% UsedPoints) { Str = paste(Str, sprintf("%10.4f", Round(ypr[i - iL + 1], 4))) }
    else { Str = paste(Str, "          ") }
    if (i %in% UsedPoints) { Str = paste(Str, sprintf("%+10.3e", yre[i - iL + 1])) }
    else { Str = paste(Str, "          ") }
    Str = paste(Str, sprintf("%10.4f", Round(tabAUC[i,1], 4)))
    Str = paste(Str, sprintf("%10.4f", Round(tabAUC[i,2], 4)))
    Result[cLineNo] = Str ; cLineNo = cLineNo + 1
  }
  Result[cLineNo] = "" ; cLineNo = cLineNo + 1
  if (C0Imputed) {
    Result[cLineNo] = "+: Back extrapolated concentration" ; cLineNo = cLineNo + 1
  }
  Result[cLineNo] = "*: Used for the calculation of Lambda z." ; cLineNo = cLineNo + 1
  Result[cLineNo] = "" ; cLineNo = cLineNo + 1
  Result[cLineNo] = "" ; cLineNo = cLineNo + 1
  Result[cLineNo] = "Calculated Values" ; cLineNo = cLineNo + 1
  Result[cLineNo] = "-----------------" ; cLineNo = cLineNo + 1


  RetNames = names(Res)
  for (i in 1:length(RetNames)) {
    if (RetNames[i] != "b0" & !is.na(Res[RetNames[i]])) {
      SYNO = RptCfg[RptCfg$PPTESTCD==RetNames[i], "SYNONYM"]
      if (RetNames[i] == "LAMZNPT") {
        Result[cLineNo] = paste(sprintf("%-10s", RetNames[i]), sprintf("%-40s", SYNO), sprintf("%8d", Round(Res[RetNames[i]], 4))) ; cLineNo = cLineNo + 1
      } else {
        Result[cLineNo] = paste(sprintf("%-10s", RetNames[i]), sprintf("%-40s", SYNO), sprintf("%13.4f", Round(Res[RetNames[i]], 4)), attr(Res, "units")[i]) ; cLineNo = cLineNo + 1
      }
    }
  }

  return(Result)
}

