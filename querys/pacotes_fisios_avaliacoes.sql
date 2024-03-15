WITH Cte_recebe as (
SELECT
	CAST(DataSist as DATE) as DataSist,
	CodPaciente,
	Paciente,
	NParc,
	Hist,
	DataPag,
	Valor,
	Desconto,
	ValorPag,
	DescontoB,
	FORMAPG,
	Cheque,
	Banco,
	Obs,
	Usuario,
	CodBanco

FROM sisac.dbo.recebepart
WHERE Hist LIKE 'SESS%INDI%' OR Hist LIKE 'PACOTE%' OR Hist LIKE 'AVALIA%' OR Hist LIKE 'PLANO%' OR Hist LIKE '%Bodytech%' OR Hist LIKE '%Centro de Treinamento%'
) 

SELECT
	DataSist,
	LEFT(Cte_recebe.CodPaciente, 6) as CodPaciente,
	Cte_recebe.CodPaciente as CodMovimento,
	Paciente,
	Hist,
	Valor,
	Usuario,
	Obs

FROM Cte_recebe

WHERE DataSist >= '2024-03-08'