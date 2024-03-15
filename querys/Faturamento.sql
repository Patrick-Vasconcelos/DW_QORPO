SELECT
	entrada.CodPaciente,
	entrada.CodMovimento,
	paciente.Paciente,
	entrada.DataFech,
	entrada.CodConvenio,
	convenio.Razao,
	entrada.CodAmb,
	entrada.Hist,
	entrada.CodMedico,
	medico.Nome,
	entrada.Local,
	entrada.Recep,
	entrada.Total

FROM sisac.dbo.Entrada as entrada


LEFT JOIN sisac.dbo.cadPaciente as paciente ON entrada.CodPaciente = paciente.CodPaciente
LEFT JOIN sisac.dbo.cadMedico as medico ON entrada.CodMedico = medico.CodMedico
LEFT JOIN sisac.dbo.CadConvenio as convenio ON entrada.Codconvenio = convenio.CodConvenio


WHERE entrada.Tipo = '6' AND entrada.LoteEnt NOT IN ('INAT') AND entrada.CodConvenio NOT IN ('000')

ORDER BY DataFech