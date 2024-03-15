WITH cte_recebe as (
SELECT
	CodPaciente,
	NParc,
	Hist,
	Data,
	CAST(DataSist as DATE) as DataSist,
	DataPag,
	Valor,
	Desconto,
	FORMAPG,
	Cheque,
	Banco,
	Obs,
	Usuario,
	Paciente,
	SUBSTRING(Paciente, CHARINDEX('[C.CORRENTE]', Paciente) + LEN('[C.CORRENTE]'), LEN(Paciente)) AS NomePaciente,
	CodBanco,
	ValorPag,
	DescontoB
FROM sisac.dbo.recebepart
WHERE Hist LIKE 'Adiantamento%'
) 

SELECT 
	DataSist,
	CodPaciente,
	LTRIM(NomePaciente) as NomePaciente,
	FORMAT(SUM(Valor), 'C' , 'pt-BR') as Valor,
	Obs,
	Usuario
	
FROM cte_recebe

WHERE DataSist >='2024-03-08'

GROUP BY DataSist,CodPaciente, NomePaciente, Obs, Usuario

-- WHERE NomePaciente LIKE '%EVA %'
-- WHERE CodPaciente = '050753'