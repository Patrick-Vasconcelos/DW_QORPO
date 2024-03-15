import pyodbc
import pandas as pd
import smtplib
import time
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
from email.mime.base import MIMEBase
from email import encoders
from dotenv import load_dotenv
from os import getenv

load_dotenv(r'C:\Users\patri\.env.txt')

def import_query(path):
    with open(path, 'r') as open_file:
        return open_file.read()


class dw_qorpo():
    
    def __init__(self, usuario, senha, host, banco):
        self.user = usuario
        self.senha = senha
        self.host = host
        self.banco = banco
           
        self.destinatarios_arquivos = [
        ('patrickvasc@qorpo.com.br', ['pacotes_fisios_avaliacoes', 'adiantamentos_saldo'], 'Relatório para NF', 'Segue arquivo: '),
        ('89patrick89@gmail.com', ['a_pagar', 'a_receber'], 'Relatório Financeiro', 'Segue arquivo: ')
        ]
        self.lista_nome = ['a_receber', 'a_pagar'] 
     
    def conecta_ao_banco(self, driver= 'ODBC Driver 17 for SQL Server',trusted_connection='no'):

        string_conexao = f"DRIVER={driver};SERVER={self.host};DATABASE={self.banco};ENCRYPT=no;UID={self.user};PWD={self.senha};TRUSTED_CONNECTION={trusted_connection};CHARSET=UTF8"
        
        conexao = pyodbc.connect(string_conexao)
        cursor = conexao.cursor()

        return conexao, cursor

    def consulta_ao_banco(self,query,conexao):

        query = import_query(f'querys/{query}.sql')

        df = pd.read_sql(query,con=conexao)

        return df

    def salvar_em_excel(self,consulta, nome_arquivo='consulta', path = 'docs/'):
        
        with pd.ExcelWriter(f"{path}{nome_arquivo}.xlsx", engine='xlsxwriter', options={'encoding': 'utf-8'}) as writer:
            consulta.to_excel(writer, index=False)

    def envia_email(self,assunto, corpo, destinatario, nome_arquivo,path='docs/'):
        senha_email = getenv('senha_webmail')
        de_email = '89patrick89@gmail.com'
        path_excel = f"{path}{nome_arquivo}.xlsx"

        smtp_server = 'smtp.gmail.com'
        smtp_port = 587
        
        mensagem_corpo = f'{corpo} {nome_arquivo} em anexo'

        msg = MIMEMultipart()
        msg['From'] = de_email
        msg['To'] = destinatario
        msg['Subject'] = assunto
        
        msg.attach(MIMEText(mensagem_corpo, 'plain'))

        attachment = open(path_excel, 'rb')
        part = MIMEBase('application', 'octet-stream')
        part.set_payload((attachment).read())
        encoders.encode_base64(part)
        part.add_header('Content-Disposition', f'attachment; filename= {nome_arquivo}')
        msg.attach(part)

        try:
            print("tentando conectar ao server..")
            server = smtplib.SMTP(smtp_server, smtp_port)
            print(f"conectou ao server!!")
            server.starttls()
            server.login(de_email, senha_email)
            
            print(f"enviando email do arquivo {nome_arquivo} do email {de_email} para o email {destinatario}")
            server.sendmail(de_email, destinatario, msg.as_string())
            print("E-mail enviado com sucesso!")
            server.quit()
        except FileNotFoundError:
            print(f"arquivo {nome_arquivo} não encontrado, email não enviado !")
        
        except Exception as e:
            print("Erro ao enviar e-mail:", str(e))

    def envia_multiplos_emails(self):
        for destinatario, arquivos_anexo, assunto, corpo in self.destinatarios_arquivos:
            for arquivo_anexo in arquivos_anexo:
                self.envia_email(assunto=assunto, corpo=corpo, destinatario=destinatario, nome_arquivo=arquivo_anexo)
                time.sleep(1)
    
    def salva_multiplos_excel(self,conexao):
        for nome in self.lista_nome:
            print(f"criando excel {nome}")
            consulta = self.consulta_ao_banco(query=nome,conexao=conexao)
            self.salvar_em_excel(nome_arquivo=nome,consulta=consulta)
            time.sleep(1)