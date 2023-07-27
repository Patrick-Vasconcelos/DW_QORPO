SELECT medico.Nome, DataHora,agenda.Nome as Paciente, agenda.Usuario, agenda.codMovimento, agenda.Procedimentos,
    CASE 
        WHEN ConfAtd = 'S' THEN 'Atendido'
        WHEN ConfAtd = 'C' THEN 'Confirmado e nao atendido'
        WHEN ConfAtd = 'N' THEN 'Nao confirmado e nao atendido'
        ELSE 'Valor inválido'
    END AS status

FROM sisac.dbo.Agenda as agenda
LEFT JOIN sisac.dbo.CadMedico as medico ON agenda.CodMedico = medico.CodMedico
WHERE agenda.Tipo LIKE 'FISIO%' AND agenda.CodMedico = 170  AND MONTH(DataHora) = (MONTH(GETDATE()) - 1)
ORDER BY agenda.CodMedico, DataHora