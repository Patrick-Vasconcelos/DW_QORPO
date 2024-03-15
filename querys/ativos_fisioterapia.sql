
SELECT 
	DISTINCT paciente.Paciente

FROM DW_SISAC.dbo.vw_fAgenda as agenda


LEFT JOIN sisac.dbo.CadPaciente as paciente ON agenda.CodPaciente = paciente.CodPaciente

WHERE agenda.DataHora > '2023-19-06' AND agenda.ConfAtd = 'S'