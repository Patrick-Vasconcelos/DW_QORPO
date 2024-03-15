
WITH cte_receber AS (
SELECT
	receber.NFech,
	fechamento.Tipo,
	receber.CodConvenio,
	LEFT(repasse.CodPaciente,6) as CodPaciente,
	repasse.CodMedico,
	repasse.CodTaxa,
	repasse.Descr,
	repasse.Modo,
	repasse.Local,
	repasse.FPGTO,
	repasse.Total as total_tabela_repasse,
	repasse.Perc as percentual_tabela_repasse,
	repasse.Valor as valor_tabela_repasse,
	receber.DataRef,
	receber.DataPag,
	receber.Valor,
	receber.ValorPag,
	Glosa,
	Iss,
	IRRF,
	Outros,
	Pis,
	IRPJ,
	Cofins,
	Consoc

FROM sisac.dbo.Receber as receber

LEFT JOIN sisac.dbo.Fechamento as fechamento ON receber.Nfech = fechamento.NFech
LEFT JOIN sisac.dbo.Repasse as repasse ON receber.Nfech = repasse.NFech

) 

SELECT 
	cte_receber.NFech,
	MAX(cte_receber.Tipo) as Tipo,
	MAX(cte_receber.CodConvenio) as CodCovenio,
	MAX(convenio.Razao) as Razao,
	MAX(cte_receber.CodPaciente) as CodPaciente,
	MAX(paciente.Paciente) as Paciente,
	MAX(cte_receber.CodMedico) as CodMedico,
	MAX(cte_receber.CodTaxa) as CodTaxa,
	MAX(cte_receber.Descr) as Descr,
	MAX(cte_receber.Modo) as Modo,
	MAX(cte_receber.Local) as Local,
	MAX(local.Descr) as Local_descr,
	MAX(cte_receber.FPGTO) as FPGTO,
	MAX(cte_receber.total_tabela_repasse) as total_tabela_repasse,
	MAX(cte_receber.percentual_tabela_repasse) as percesntual_tabela_repasse,
	MAX(cte_receber.valor_tabela_repasse) as valor_tabela_repasse,
	MAX(cte_receber.DataRef) as DataRef,
	MAX(cte_receber.DataPag) as DataPag,
	MAX(cte_receber.Valor) as Valor,
	MAX(cte_receber.ValorPag) as ValorPag,
	MAX(cte_receber.Glosa) as Glosa,
	MAX(cte_receber.Iss) as Iss,
	MAX(cte_receber.IRRF) as IRRF,
	MAX(cte_receber.Outros) as Outros,
	MAX(cte_receber.Pis) as Pis,
	MAX(cte_receber.IRPJ) as IRPJ,
	MAX(cte_receber.Cofins) as Cofins,
	MAX(cte_receber.Consoc) as Consoc

FROM cte_receber

LEFT JOIN sisac.dbo.CadConvenio as convenio ON cte_receber.CodConvenio = convenio.CodConvenio
LEFT JOIN sisac.dbo.CadPaciente as paciente ON cte_receber.CodPaciente = paciente.CodPaciente
LEFT JOIN sisac.dbo.Local as local ON cte_receber.Local = local.Local

GROUP BY NFech
ORDER BY NFech