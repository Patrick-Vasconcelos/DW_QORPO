




WITH cte_repasse as (
SELECT
	CONCAT(repasse.CodPaciente, repasse.CodTaxa) as id_repasse,
	LEFT(CodPaciente, 6) as CodPaciente,
	repasse.Data as DataAtendimento,
	repasse.Descr as Procedimento,
	repasse.CodTaxa,
	repasse.CodMedico,
	repasse.Modo,
	repasse.Local,
	repasse.CodConvenio,
	repasse.NFech,
	repasse.Descr,
	-- datapagamento da tabela receber
	repasse.Total as ValorBruto
	-- glosa, criar cte com condicao G
	-- liquido


FROM  sisac.dbo.repasse as repasse

WHERE condicao = 'A'

), cte_glosa as (


SELECT
	CONCAT(glosa.CodPaciente,glosa.CodTaxa) as id_glosa,
	glosa.CodPaciente,
	glosa.CodTaxa,
	glosa.total as Glosa,
	glosa.Obs
	

FROM sisac.dbo.repasse as glosa
WHERE condicao = 'G'

)



SELECT
	cte_repasse.DataAtendimento,
	paciente.Paciente,
	cte_repasse.CodTaxa,
	cte_repasse.Procedimento,
	CASE 
		WHEN cte_repasse.Modo = 'HM' THEN 'Cirurgiao'
		WHEN cte_repasse.Modo = 'HPA' THEN '1 Auxiliar'
		WHEN cte_repasse.Modo = 'HSA' THEN '2 Auxiliar'   
		ELSE cte_repasse.Modo
	END AS Modo,
	medico.Nome,
	local.Descr,
	convenio.Descr,
	cte_repasse.NFech,
	receber.DataPag,
	cte_repasse.ValorBruto,
	cte_glosa.Glosa,
	cte_repasse.ValorBruto - cte_glosa.Glosa as ValorLiquido,
	cte_glosa.Obs as Motivo
	

FROM cte_repasse

LEFT JOIN cte_glosa ON cte_repasse.id_repasse = cte_glosa.id_glosa
LEFT JOIN sisac.dbo.Receber as receber ON cte_repasse.NFech = receber.NFech
LEFT JOIN sisac.dbo.CadPaciente as paciente ON cte_repasse.CodPaciente = paciente.CodPaciente
LEFT JOIN sisac.dbo.CadConvenio as convenio ON cte_repasse.CodConvenio = convenio.CodConvenio
LEFT JOIN sisac.dbo.CadMedico as medico ON cte_repasse.CodMedico = medico.CodMedico
LEFT JOIN sisac.dbo.Local as local ON cte_repasse.Local = local.Local

ORDER BY DataAtendimento