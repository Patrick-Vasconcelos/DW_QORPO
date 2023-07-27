WITH cte_fatura as(

	SELECT 
		LEFT(fatura.CodPaciente, 6) as CodPaciente,
		fatura.Data,
		fatura.Descr,
		fatura.Usuario,
		fatura.CodMedico,
		fatura.codTaxa,
		fatura.Honor
	FROM sisac.dbo.fatura as fatura
WHERE fatura.codTaxa Like '1111%' AND fatura.codTaxa NOT IN ('11111118', '11111138', '11113182') AND Data >= '2023-17-07'

)
SELECT
	paciente.Paciente,
	cte_fatura.Data,
	cte_fatura.Descr,
	medico.Nome,
	cte_fatura.codTaxa,
	cte_fatura.Honor

FROM cte_fatura
LEFT JOIN sisac.dbo.CadMedico as medico ON cte_fatura.CodMedico = medico.CodMedico
LEFT JOIN sisac.dbo.CadPaciente as paciente ON cte_fatura.CodPaciente = paciente.CodPaciente		