SELECT
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

WHERE exame.Descr LIKE 'Fisio%' AND exame.DataSist >= '2023-26-07'


ORDER BY exame.DataSist