SELECT 
	entrada.DataHoraEnt as DATA,
	paciente.Paciente,
	medico.Nome,
	entrada.Hist

FROM sisac.dbo.Entrada as entrada

LEFT JOIN sisac.dbo.CadPaciente as paciente ON entrada.CodPaciente	 = paciente.CodPaciente
LEFT JOIN sisac.dbo.CadMedico as medico ON entrada.CodMedico = medico.CodMedico

WHERE DataHoraEnt >= DATEADD(day, -1, CAST(GETDATE() AS DATE)) AND DataHoraEnt < CAST(GETDATE() AS DATE) AND Hist LIKE 'ava%'

