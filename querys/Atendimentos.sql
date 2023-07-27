SELECT
	medico.Nome,
	count(entrada.codmedico) as qtd_sessoes

FROM sisac.dbo.Entrada as entrada


LEFT JOIN sisac.dbo.CadMedico as medico ON entrada.codMedico = medico.codMedico
LEFT JOIN sisac.dbo.CadPaciente as paciente ON entrada.codPaciente = paciente.codPaciente

WHERE entrada.Prontuario LIKE 'FISIOTERAPIA' AND entrada.DataHoraEnt BETWEEN '2023-01-04' AND '2023-30-04' AND entrada.LoteEnt NOT LIKE 'INAT'
GROUP BY medico.Nome
ORDER BY qtd_sessoes DESC