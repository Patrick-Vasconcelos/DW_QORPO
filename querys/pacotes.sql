SELECT
	entrada.DataHoraEnt,
	entrada.Hist,
	paciente.Paciente,
	entrada.recep,
	entrada.CodAmb

FROM sisac.dbo.Entrada as entrada
LEFT JOIN sisac.dbo.CadPaciente as paciente ON entrada.CodPaciente = paciente.CodPaciente
WHERE DataHoraEnt > '2023-26-07' AND ( CodAmb ='11111157' OR CodAmb ='11111158' OR CodAmb ='11111159')