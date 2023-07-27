WITH cte_fatura as(
	SELECT
		LEFT(CodPaciente,6) as CodPaciente,
		CodTaxa,
		Descr,
		Data,
		CodMedico,
		Valor,
		Usuario

FROM sisac.dbo.Fatura as fatura
WHERE fatura.CodTaxa = '10101039'
)
SELECT paciente.Paciente, cte_fatura.CodTaxa, cte_fatura.Descr, cte_fatura.Data,medico.Nome,cte_fatura.Valor,cte_fatura.Usuario from cte_fatura
LEFT JOIN sisac.dbo.CadPaciente as paciente ON paciente.CodPaciente = cte_fatura.CodPaciente
LEFT JOIN sisac.dbo.CadMedico as medico ON medico.CodMedico = cte_fatura.CodMedico