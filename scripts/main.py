from conexao import dw_qorpo
from dotenv import load_dotenv
from os import getenv


env = load_dotenv(r'C:\Users\Qorpo\.env')

usuario_dw = getenv('usuario_DW')
senha_dw = getenv('senha_DW')

conexao, cursor = dw_qorpo.conecta_ao_banco(username=usuario_dw,password=senha_dw)

sql1 = """SELECT 
	-- exame.CodPacRef as CodPaciente,
	exame.DataSist as DataIndicacao,
	paciente.Paciente,
	paciente.Sexo,
	paciente.DataNasc,
	medico.Nome as Solicitante
	
	FROM SISAC.dbo.SolicExa as exame
	LEFT JOIN SISAC.dbo.CadPaciente paciente on exame.CodPacRef = paciente.CodPaciente
	LEFT JOIN SISAC.dbo.CadMedico medico on exame.CodMedico = medico.CodMedico

	WHERE exame.Descr = 'Fisioterapia'
	ORDER BY exame.DataSist
	"""

sql2 = """SELECT  CodAmb,Descr,CH,Grupo FROM SISAC.dbo.TabAMB
	WHERE CodConvenio = '072' AND Grupo IS NOT NULL
	ORDER BY Grupo DESC
	"""

sql = """WITH cte_fatura as (
	SELECT
		LEFT(fatura.CodPaciente, 6) as CodPaciente,
		fatura.CodTaxa,
		fatura.Descr,
		fatura.GrupoProc,
		fatura.Data,
		fatura.Valor,
		fatura.Quant,
		fatura.CodMedico,
		medico.Nome,
		fatura.Usuario

	FROM SISAC.dbo.fatura as fatura
	LEFT JOIN sisac.dbo.CadMedico medico on fatura.CodMedico = medico.CodMedico


	) 

	SELECT 
		--- cte_fatura.CodPaciente,
		paciente.Paciente,
		cte_fatura.Nome as Profissional,
		cte_fatura.CodTaxa,
		cte_fatura.Descr,
		--- paciente.CodConvenio,
		convenio.Descr,
		--- cte_fatura.GrupoProc,
		cte_fatura.Data,
		cte_fatura.Valor,
		cte_fatura.usuario
		
		--- cte_fatura.Quant
		--- cte_fatura.CodMedico,
		

	FROM cte_fatura
	LEFT JOIN sisac.dbo.CadPaciente paciente on cte_fatura.CodPaciente = paciente.CodPaciente
	LEFT JOIN sisac.dbo.CadConvenio convenio on paciente.CodConvenio = convenio.CodConvenio

	WHERE CodTaxa LIKE '1010%'
	ORDER BY paciente
	"""

consulta = dw_qorpo.consulta_ao_banco(query=sql,conexao=conexao)

dw_qorpo.salvar_em_excel(nome_arquivo='faturados',consulta=consulta)

conexao.close()
