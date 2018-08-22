#BasicUtil.R

toproper = function(string)
{
  return(paste0(toupper(substr(string, 1, 1)), tolower(substr(string, 2, nchar(string)))))
}

Note = function() file.show(system.file("NOTE.txt", package="NonCompart"))

PrepPDF = function(FileName, Paper="letter", FontFamily="Courier")
{
  pdf(FileName, paper=Paper, width=8.5, height=11, family=FontFamily, title="NCA Report")
}

ClosePDF = function()
{
  dev.off()
}

AddPage = function(Cex=0.8, Header1="", Header2="", Header3="", Footer1="", Footer2="", Footer3="", PrintRowNum=FALSE, StartRowNum=1)
{
  if (Cex < 0.1 | Cex > 1.2) stop("Too small or too large cex!")
  nCol = trunc(242 - 190*Cex)
  nRow = trunc(155 - 125*Cex)
  options(width=max(10, trunc(300 - 250*Cex)))

  par(oma=c(0,0,0,0), mfrow=c(1,1), mar=c(0, 0, 0, 0), adj=0, cex=Cex)
  plot(0, 0, type="n", ylim=c(2*nRow-1, 0), xlim=c(0, nCol-1), xaxt="n", yaxt="n", ylab="", xlab="", bty="n")
  if (PrintRowNum == TRUE) for(j in 1:nRow) text(-2 - 1 + 3 - floor(log10(j + StartRowNum - 1)), 2*j - 1, paste0(j + StartRowNum - 1, ":"), offset=0)
  text(0, -3, Header1, pos=4)
  text(nCol/2, -3, Header2, pos=3)
  text(nCol, -3, Header3, pos=2)

  text(0, 2*nRow + 1, Footer1, pos=4)
  text(nCol/2, 2*nRow + 1, Footer2, pos=1)
  text(nCol, 2*nRow + 1, Footer3, pos=2)
}

Text1 = function(Row, Col, Text, Cex=0.8)
{
  if (Cex < 0.1 | Cex > 1.2) stop("Too small or too large cex!")
  nCol = trunc(242 - 190*Cex)
  nRow = trunc(155 - 125*Cex)
  if (Col > nCol | Row > nRow) stop("Text seems out of paper!")

  text(Col - 1, 2*Row - 1, Text, cex=Cex, offset=0)
}

TextM = function(MTxt, StartRow=0, Cex=0.8, Header1="", Header2="", Header3="", Footer2="", Footer1="", Footer3="", PrintRowNum=FALSE)
{
  if (Cex < 0.1 | Cex > 1.2) stop("Too small or too large cex!")
  nRow = trunc(155 - 125*Cex)

  for (i in 1:length(MTxt)) {
    if ((StartRow + i)%%nRow == 1) AddPage(Cex=Cex, Header1=Header1, Header2=Header2, Header3=Header3, Footer2=Footer2, Footer1=Footer1, Footer3=Footer3, PrintRowNum=PrintRowNum)
    Text1((StartRow + i - 1)%%nRow + 1, 1, MTxt[i])
  }
}

Plot4rtf = function(x, y, type, cex, xlim, ylim, xlab, ylab, tabRes)
{
  UsedPoints = attr(tabRes, "UsedPoints")
  x0 = x[y > 0]
  y0 = y[y > 0]  
  plot(x0, log10(y0), type=type, cex=cex, xlim=xlim, ylim=log10(ylim), yaxt="n", xlab=xlab, ylab=ylab)
  points(x[UsedPoints], log10(y[UsedPoints]), pch=16)
  yticks = seq(round(log10(ylim[1])), ceiling(log10(ylim[2])))
  ylabels = sapply(yticks, function(i) as.expression(bquote(10^ .(i))))
  axis(2, at=yticks, labels=ylabels)
  x1 = tabRes["LAMZLL"]
  x2 = tabRes["LAMZUL"]
  deltaX = x1 * 0.05
  y1 = log10(2.718281828)*(tabRes["b0"] - tabRes["LAMZ"] * (x1 - deltaX))
  y2 = log10(2.718281828)*(tabRes["b0"] - tabRes["LAMZ"] * (x2 + deltaX))
  lines(c(x1 - deltaX, x2 + deltaX), c(y1, y2), lty=2, col="red")
}
