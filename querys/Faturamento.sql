SELECT Data,Descr,CodTaxa,GrupoProc,Valor, Quant,ValorAcresc,Honor, Usuario  FROM sisac.dbo.Fatura
WHERE Data > '2023-30-04' AND CodTaxa LIKE '111%'
ORDER BY CodTaxa
