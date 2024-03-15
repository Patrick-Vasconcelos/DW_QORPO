WITH cte_glosas as (
	SELECT 
		NFech,
		CodConvenio,
		DataFech,
		Saldo

	FROM sisac.dbo.Receber
),cte_receber as (
SELECT
	receber.Nfech,
	receber.CodConvenio,
	convenio.Descr,
	receber.DataEntrega,
	receber.DataPag,
	CASE
		WHEN receber.CodConvenio = '035' THEN 
			CASE
				WHEN MONTH(receber.DataEntrega) <= 11  THEN DATEADD(day,19, DATEFROMPARTS(YEAR(receber.DataEntrega), MONTH(receber.DataEntrega) + 1, 1))
				ELSE DATEADD(day,19, DATEFROMPARTS(YEAR(receber.DataEntrega) + 1 , 1 , 1))
			END
		WHEN receber.CodConvenio = '039' THEN 
			CASE
				WHEN MONTH(receber.DataEntrega) <= 11 THEN DATEADD(day,15, DATEFROMPARTS(YEAR(receber.DataEntrega), MONTH(receber.DataEntrega) + 1, 1))
				ELSE DATEADD(day,15,DATEFROMPARTS(YEAR(receber.DataEntrega) + 1 , 1 , 1))
			END
		WHEN receber.CodConvenio = '036' THEN
			CASE
				WHEN MONTH(receber.DataEntrega) <= 11 THEN DATEADD(day, 20, DATEFROMPARTS(YEAR(receber.DataEntrega), MONTH(receber.DataEntrega) + 1, 1))
				ELSE DATEADD(day,20,DATEFROMPARTS(YEAR(receber.DataEntrega) + 1 , 1 , 1))
			END
		WHEN receber.CodConvenio = '045' THEN 
			CASE
				WHEN MONTH(receber.DataEntrega) <= 11 THEN DATEADD(day, 19, DATEFROMPARTS(YEAR(receber.DataEntrega), MONTH(receber.DataEntrega) + 1, 1))
				ELSE DATEADD(day,19,DATEFROMPARTS(YEAR(receber.DataEntrega) + 1 , 1 , 1))
			END
		WHEN receber.CodConvenio = '046' THEN
			CASE
				WHEN MONTH(receber.DataEntrega) <= 11 THEN DATEADD(day, 29, DATEFROMPARTS(YEAR(receber.DataEntrega), MONTH(receber.DataEntrega) + 1, 1))
				ELSE DATEADD(day,29,DATEFROMPARTS(YEAR(receber.DataEntrega) + 1 , 1 , 1))
			END
		WHEN receber.CodConvenio = '047' THEN 
			CASE
				WHEN MONTH(receber.DataEntrega) <= 11 THEN DATEADD(day, 14, DATEFROMPARTS(YEAR(receber.DataEntrega), MONTH(receber.DataEntrega) + 1, 1))
				ELSE DATEADD(day,14,DATEFROMPARTS(YEAR(receber.DataEntrega) + 1 , 1 , 1))
			END
		WHEN receber.CodConvenio = '049' THEN
			CASE
				WHEN MONTH(receber.DataEntrega) <= 11 THEN DATEADD(day, 22, DATEFROMPARTS(YEAR(receber.DataEntrega), MONTH(receber.DataEntrega) + 1, 1))
				ELSE DATEADD(day,22,DATEFROMPARTS(YEAR(receber.DataEntrega) + 1 , 1 , 1))
			END
		WHEN receber.CodConvenio = '050' THEN
			CASE
				WHEN MONTH(receber.DataEntrega) <= 11 THEN DATEADD(day, 22, DATEFROMPARTS(YEAR(receber.DataEntrega), MONTH(receber.DataEntrega) + 1, 1))
				ELSE DATEADD(day,22,DATEFROMPARTS(YEAR(receber.DataEntrega) + 1 , 1 , 1))
			END
		WHEN receber.CodConvenio = '053' THEN
			CASE
				WHEN MONTH(receber.DataEntrega) <= 11 THEN DATEADD(day, 20, DATEFROMPARTS(YEAR(receber.DataEntrega), MONTH(receber.DataEntrega) + 1, 1))
				ELSE DATEADD(day,20,DATEFROMPARTS(YEAR(receber.DataEntrega) + 1 , 1 , 1))
			END
		WHEN receber.CodConvenio = '048' THEN DATEADD(day, 30,receber.DataEntrega)
		WHEN receber.CodConvenio = '073' THEN DATEADD(day, 90, receber.DataEntrega)
		WHEN receber.CodConvenio = '016' THEN DATEADD(day, 30, receber.DataEntrega)
		WHEN receber.CodConvenio = '056' THEN DATEADD(day, 30, receber.DataEntrega)
		WHEN receber.CodConvenio = '041' THEN DATEADD(day, 30, receber.DataEntrega)
		WHEN receber.CodConvenio = '042' THEN DATEADD(day, 30, receber.DataEntrega)
		WHEN receber.CodConvenio = '043' THEN DATEADD(day, 60, receber.DataEntrega) 
		WHEN receber.CodConvenio = '016' THEN DATEADD(day, 30, receber.DataEntrega)
		WHEN receber.CodConvenio = '044' THEN DATEADD(day, 30, receber.DataEntrega)
		WHEN receber.CodConvenio = '064' THEN DATEADD(day, 60, receber.DataEntrega)
		WHEN receber.CodConvenio = '066' THEN DATEADD(day, 90, receber.DataEntrega)
		WHEN receber.CodConvenio = '119' THEN DATEADD(day,90, receber.DataEntrega)
		WHEN receber.CodConvenio = '063' THEN DATEADD(day, 45, receber.DataEntrega)
		WHEN receber.CodConvenio = '069' THEN DATEADD(day, 45, receber.DataEntrega)
		WHEN receber.CodConvenio = '051' THEN DATEADD(day, 30, receber.DataEntrega)
		ELSE null
	END AS DataPrevisao,
	Nfiscal,
	CASE
		WHEN fechamento.Tipo = 'Int' THEN 'Honorario Individual'
		WHEN fechamento.Tipo = 'Con' THEN 'Consulta'
		WHEN fechamento.Tipo = 'Exa' THEN 'Exame'
		WHEN fechamento.Tipo = 'Pqa' THEN 'PQA'
		ELSE 'Nao Informado'
	END as Tipo_Guia,
	Valor,
	Glosa as GlosaSistema,
	(Valor - receber.ISS - receber.IRRF - receber.Pis - receber.Irpj - receber.Cofins - receber.Consoc - receber.Desconto) - ValorPag as ValorGlosa,
	receber.ISS,
	receber.IRRF,
	receber.PIs,
	receber.Cofins,
	Consoc,
	Outros,
	ValorPag as ValorLiquido,
	receber.Condicao,
	receber.Perda

	FROM sisac.dbo.Receber as receber

	LEFT JOIN sisac.dbo.fechamento as fechamento ON receber.NFech = fechamento.NFech
	LEFT JOIN sisac.dbo.CadConvenio as convenio ON receber.CodConvenio = convenio.CodConvenio
)

SELECT
	Nfech,
	CodConvenio,
	Descr,
	DataEntrega,
	DataPag,
	DataPrevisao,
	Nfiscal,
	Tipo_Guia,
	ROUND(Valor,2) as Valor,
	ROUND(ValorGlosa,2) as ValorGlosa,
	ROUND(GlosaSistema,2) as GlosaSistema,
	ROUND(Valor - ValorGlosa,2) as ValorBruto,
	ROUND(ISS,2)as ISS,
	ROUND(IRRF,2)as IRRF,
	ROUND(PIs,2)as PIs,
	ROUND(Cofins,2)as Cofins,
	ROUND(Consoc,2)as Consoc,
	ROUND(Outros,2)as Outros,
	ROUND(ValorLiquido,2)as ValorLiquido,	
	ROUND(Perda,2)as Perda,
	Condicao

FROM cte_receber

WHERE cte_receber.Condicao IN ('A', 'B', 'R')
