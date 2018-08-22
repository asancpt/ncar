txtNCA = function(x, y, dose=0, adm="Extravascular", dur=0, doseUnit="mg", timeUnit="h", concUnit="ug/L", iAUC="", down="Linear", R2ADJ=0, MW=0)
{
  Res = sNCA(x=x, y=y, dose=dose, adm=adm, dur=dur, doseUnit=doseUnit, timeUnit=timeUnit, concUnit=concUnit, iAUC=iAUC, down=down, R2ADJ=R2ADJ, MW=MW)
  Result = Res2Txt(ResNCA=Res, x=x, y=y, dose=dose, adm=adm, dur=dur, doseUnit=doseUnit, down=down)
  return(Result)
}  

