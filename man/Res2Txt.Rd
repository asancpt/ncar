\name{Res2Txt}
\alias{Res2Txt}
\title{Convert sNCA output table to text form}
\description{This converts the table output of \code{sNCA} to text form output.}
\usage{
Res2Txt(ResNCA, x, y, dose = 0, adm = "Extravascular", dur = 0, doseUnit = "mg", 
        down = "Linear")
}
\arguments{
  \item{ResNCA}{Output table from \code{sNCA}}
  \item{x}{usually time}
  \item{y}{usually concentration}
  \item{dose}{given amount}
  \item{adm}{one of \code{"Bolus"} or \code{"Infusion"} or \code{"Extravascular"} to indicate drug administration mode}
  \item{dur}{duration of infusion}
  \item{doseUnit}{unit of dose}
  \item{down}{either of \code{"Linear"} or \code{"Log"} to indicate the way to calculate AUC and AUMC}
}
\value{
  Text form output from the coversion of table form output
}
\author{Kyun-Seop Bae <k@acr.kr>}
\seealso{
\code{\link{txtNCA}}, \code{\link{pdfNCA}}, \code{\link{rtfNCA}} 
}
\examples{
x = Theoph[Theoph$Subject=="1","Time"]
y = Theoph[Theoph$Subject=="1","conc"]
z = sNCA(x, y, dose=320, doseUnit="mg", concUnit="mg/L", timeUnit="h")
Res2Txt(z, x, y)  
}
\keyword{Output Form}
