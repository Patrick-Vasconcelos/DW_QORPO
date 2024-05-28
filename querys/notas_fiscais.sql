WITH cte_recebepart as (
SELECT
	LEFT(CodPaciente,6) as CodPaciente,
	CodPaciente as CodMovimento,
	NParc,
	Paciente,
	CPF,
	Hist,
	DataSist,
	Valor,
	Usuario,
	NFiscal,
	Resp,
	RPS 

FROM sisac.dbo.recebepartc as recebepart
WHERE Paciente NOT LIKE 'ESTACI%'
)

SELECT  cte_recebepart.CodPaciente,
	CodMovimento,
	NParc,
	cte_recebepart.Paciente,
	cte_recebepart.CPF,
	paciente.cpf cpf_cadastro_paciente,
	Hist,
	cte_recebepart.DataSist,
	Valor,
	cte_recebepart.Usuario,
	NFiscal,
	cte_recebepart.Resp,
	RPS 
	
FROM cte_recebepart 

LEFT JOIN sisac.dbo.CadPaciente as paciente ON cte_recebepart.CodPaciente = paciente.CodPaciente
ORDER BY DataSist