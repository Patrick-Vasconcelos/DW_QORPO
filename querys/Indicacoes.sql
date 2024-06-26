SELECT
	--- exame.NSolic,
	exame.DataSist as DataIndicacao,
	--- exame.CodPacRef as CodPaciente,
	paciente.Paciente,
    paciente.Telefone2,
	paciente.Sexo,
	paciente.DataNasc,
	--- exame.CodMedico,
	medico.Nome as Solicitante,
	exame.Tipo,
	exame.Descr,
    exame.Indicacao
	
	FROM SISAC.dbo.SolicExa as exame
	LEFT JOIN SISAC.dbo.CadPaciente paciente on exame.CodPacRef = paciente.CodPaciente
	LEFT JOIN SISAC.dbo.CadMedico medico on exame.CodMedico = medico.CodMedico

	WHERE exame.Descr LIKE 'Fisioterapia%' AND exame.DataSist >= '2024-13-05'

	ORDER BY exame.DataSist