rtfNCA = function(fileName="Temp-NCA.rtf", concData, colSubj="Subject", colTime="Time", colConc="conc", dose=0, adm="Extravascular", dur=0, doseUnit="mg", timeUnit="h", concUnit="ug/L", down="Linear", R2ADJ=0, MW=0) 
{
#  require(rtf)
  rtf = RTF(fileName)
  addHeader(rtf, title="Individual Noncompartmental Analysis Result")
  addNewLine(rtf)
  addHeader(rtf, "Table of Contents")
  addTOC(rtf)
  setFontSize(rtf, font.size=10)

  maxx = max(concData[,colTime])
  maxy = max(concData[,colConc])
  miny = min(concData[concData[,colConc]>0,colConc])

  IDs = unique(concData[,colSubj])
  nID = length(IDs)
  Res = vector()
  for (i in 1:nID) {
    cID = IDs[i]
    x = concData[concData[,colSubj]==cID, colTime]
    y = concData[concData[,colSubj]==cID, colConc]
    tabRes = sNCA(x, y, dose=dose, adm=adm, dur=dur, doseUnit=doseUnit, timeUnit=timeUnit, concUnit=concUnit, down=down, R2ADJ=R2ADJ, MW=MW)
    txtRes = Res2Txt(tabRes, x, y, dose=dose, adm=adm, dur=dur, doseUnit=doseUnit, down=down)
    Res = c(Res, txtRes)

    addPageBreak(rtf)
    addHeader(rtf, paste("Subject ID =", cID), TOC.level=1)
    for (j in 1:length(txtRes)) addParagraph(rtf, txtRes[j])

    addPageBreak(rtf)
    addHeader(rtf, paste("Subject ID =", cID))
    addPlot(rtf, plot.fun=plot, width=6, height=4, res=300, x=x, y=y, type="b", cex=0.7,
          xlim=c(0,maxx), ylim=c(0,maxy),
          xlab=paste0("Time (", timeUnit, ")"), ylab=paste0("Concentration (", concUnit, ")"))
    addPlot(rtf, plot.fun=Plot4rtf, width=6, height=4, res=300, x=x, y=y, type="b", cex=0.7,
          xlim=c(0, maxx), ylim=c(miny, maxy),
          xlab=paste0("Time (", timeUnit, ")"), ylab=paste0("Concentration (log interval) (", concUnit, ")"), tabRes=tabRes)
  }

  done(rtf)
}

