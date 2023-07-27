SELECT medico.Nome, agenda.DataSist, DataHora,agenda.Nome as Paciente, agenda.Usuario, agenda.Procedimentos
    

FROM sisac.dbo.Agenda as agenda
LEFT JOIN sisac.dbo.CadMedico as medico ON agenda.CodMedico = medico.CodMedico
WHERE agenda.Tipo LIKE 'Fisio%' AND Procedimentos LIKE 'aval%' AND  agenda.DataSist >= '2023-26-07'
ORDER BY agenda.DataSist