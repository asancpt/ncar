rtfNCA = function(fileName="Temp-NCA.rtf", concData, key = "Subject", colTime="Time", colConc="conc", dose=0, adm="Extravascular", dur=0, doseUnit="mg", timeUnit="h", concUnit="ug/L", down="Linear", R2ADJ=0, MW=0)
{
  rtf = RTF(fileName)
  addHeader(rtf, title="Individual Noncompartmental Analysis Result")
  addNewLine(rtf)
  addHeader(rtf, "Table of Contents")
  addTOC(rtf)
  setFontSize(rtf, font.size=10)

  maxx = max(concData[,colTime])
  maxy = max(concData[,colConc])
  miny = min(concData[concData[,colConc]>0, colConc])

  nKey = length(key)
  IDs = unique(as.data.frame(concData[,key], ncol=nKey))
  nID = nrow(IDs)

  if (length(dose) == 1) {
    dose = rep(dose, nID)
  } else if (length(dose) != nID) {
    stop("Count of dose does not match with number of NCAs!")
  }

  Res = vector()
  for (i in 1:nID) {
    strHeader = paste0(key[1], "=", IDs[i, 1])
    strCond = paste0("concData[concData$", key[1], "=='", IDs[i, 1], "'")
    if (nKey > 1) {
      for (j in 2:nKey) {
        strCond = paste0(strCond, " & concData$", key[j], "=='", IDs[i,j], "'")
        strHeader = paste0(strHeader, ", ", key[j], "=", IDs[i,j])
      }
    }
    strCond = paste0(strCond, ",]")
    tData = eval(parse(text=strCond))
    if (nrow(tData) > 0) {
      x = tData[,colTime]
      y = tData[,colConc]
      tabRes = sNCA(x, y, dose=dose[i], adm=adm, dur=dur, doseUnit=doseUnit, timeUnit=timeUnit, concUnit=concUnit, down=down, R2ADJ=R2ADJ, MW=MW)
      txtRes = Res2Txt(tabRes, x, y, dose=dose[i], adm=adm, dur=dur, doseUnit=doseUnit, down=down)
      Res = c(Res, txtRes)

      addPageBreak(rtf)
      addHeader(rtf, strHeader, TOC.level=1)
      for (j in 1:length(txtRes)) addParagraph(rtf, txtRes[j])

      addPageBreak(rtf)
      addHeader(rtf, strHeader)
      addPlot(rtf, plot.fun=plot, width=6, height=4, res=300, x=x, y=y, type="b", cex=0.7,
              xlim=c(0,maxx), ylim=c(0,maxy),
              xlab=paste0("Time (", timeUnit, ")"), ylab=paste0("Concentration (", concUnit, ")"))
      addPlot(rtf, plot.fun=Plot4rtf, width=6, height=4, res=300, x=x, y=y, type="b", cex=0.7,
              xlim=c(0, maxx), ylim=c(miny, maxy),
              xlab=paste0("Time (", timeUnit, ")"), ylab=paste0("Concentration (log interval) (", concUnit, ")"), tabRes=tabRes)
    }
  }
  done(rtf)
}


