WITH cte_fatura as (
SELECT 

LEFT(fatura.CodPaciente, 6) as CodPaciente,
fatura.CodTaxa,
fatura.Descr,
fatura.Data,
fatura.Valor,
fatura.CodMedico

FROM SISAC.dbo.Fatura as fatura

WHERE fatura.CodTaxa LIKE '1010%'
)

SELECT

cte_fatura.Data,
paciente.Paciente,
medico.Nome,
convenio.Descr,
cte_fatura.Descr,
cte_fatura.Valor


FROM cte_fatura

LEFT JOIN sisac.dbo.CadPaciente as paciente ON cte_fatura.CodPaciente= paciente.CodPaciente
LEFT JOIN sisac.dbo.CadMedico as medico ON cte_fatura.CodMedico = medico.CodMedico
LEFT JOIN sisac.dbo.CadConvenio as convenio ON paciente.CodConvenio = convenio.CodConvenio

WHERE cte_fatura.Data > '2023-01-04'