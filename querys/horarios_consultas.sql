SELECT 
	paciente.Paciente,
	convenio.Descr,
	medico.Nome,
	entrada.DataHoraAgd,
	entrada.DataHoraEnt,
	entrada.DataHoraSai,
	entrada.Hist,
	entrada.CodCid
		
FROM sisac.dbo.Entrada as entrada

LEFT JOIN sisac.dbo.CadConvenio as convenio ON entrada.CodConvenio = convenio.CodConvenio
LEFT JOIN sisac.dbo.CadPaciente as paciente ON entrada.CodPaciente = paciente.CodPaciente
LEFT JOIN sisac.dbo.CadMedico as medico ON entrada.CodMedico = medico.CodMedico

WHERE MONTH(DataHoraEnt) = MONTH(GETDATE()) AND CodAmb like '1010%'


ORDER BY entrada.CodMedico, DataHoraAgd