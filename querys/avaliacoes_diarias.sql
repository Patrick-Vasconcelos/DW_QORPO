WITH cte_fatura as(

	SELECT 
		LEFT(fatura.CodPaciente, 6) as CodPaciente,
		fatura.Data,
		fatura.Descr,
		fatura.Usuario,
		fatura.CodMedico
	FROM sisac.dbo.fatura as fatura
WHERE codTaxa Like '1111%' AND Descr LIKe 'avali%' AND Data >= '2023-16-08'
)
SELECT
	paciente.Paciente,
	cte_fatura.Data,
	cte_fatura.Descr,
	medico.Nome

FROM cte_fatura
LEFT JOIN sisac.dbo.CadMedico as medico ON cte_fatura.CodMedico = medico.CodMedico
LEFT JOIN sisac.dbo.CadPaciente as paciente ON cte_fatura.CodPaciente = paciente.CodPaciente		