from conexao import dw_qorpo
from dotenv import load_dotenv
from os import getenv
import time
import warnings


if __name__ == "__main__":
    warnings.filterwarnings("ignore")
    load_dotenv(r'C:\Users\patri\.env.txt')
    
    usuario_dw = getenv('usuario_DW')
    senha_dw = getenv('senha_DW')
    host_dw = getenv('host_DW')
    banco_dw = getenv('banco_DW') 
   
    dw = dw_qorpo(usuario=usuario_dw, senha=senha_dw,host=host_dw,banco=banco_dw)

    conexao, cursor = dw.conecta_ao_banco()
    dw.salva_multiplos_excel(conexao=conexao)
    dw.envia_multiplos_emails()

    conexao.close()
