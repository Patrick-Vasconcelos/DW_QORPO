SELECT 
	entrada.CodPaciente,
	paciente.Paciente,
	paciente.CPF,
	entrada.DataHoraEnt,
	entrada.Hist,
	medico.Nome,
	entrada.Recep,
	entrada.Total
FROM sisac.dbo.Entrada as entrada

LEFT JOIN sisac.dbo.CadPaciente as paciente ON entrada.CodPaciente = paciente.CodPaciente
LEFT JOIN sisac.dbo.CadMedico as medico ON entrada.CodMedico = medico.CodMedico

WHERE local = '363' AND LoteEnt NOT LIKE 'INAT'