from conexao import dw_qorpo
from dotenv import load_dotenv
from os import getenv


env = load_dotenv(r'C:\Users\USER\.env.txt')

usuario_dw = getenv('usuario_DW')
senha_dw = getenv('senha_DW')



conexao, cursor = dw_qorpo.conecta_ao_banco(username=usuario_dw,password=senha_dw)

consulta = dw_qorpo.consulta_ao_banco(query='Indicacoes',conexao=conexao)

dw_qorpo.salvar_em_excel(nome_arquivo='indicacoes',consulta=consulta)

conexao.close()
