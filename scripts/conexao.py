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
import datetime

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
        # self.lista_nome = ['financeiro_consulta', 'financeiro_estacionamento', 'financeiro_exames', 'financeiro_pqa', 'financeiro_pilates']
        self.lista_nome = ['repasse']
        # self.lista_nome = ['Agendas_socios']
        # self.lista_nome = ['a_pagar']
     
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
        part = MIMEBase('application', 'vnd.openxmlformats-officedocument.spreadsheetml.sheet')
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
    

class calculador_plantoes():

    def __init__(self) -> None:
        self.url_cadmedico = 'https://docs.google.com/spreadsheets/d/e/2PACX-1vQ__KgzzjYneQe-8taFViRNT183LScS8lJTTI1ONqPbrEXJa5OcQeCQThH7PS2yG6z_jlQixD5gaQe3/pub?gid=1249023783&single=true&output=csv'
        self.url = 'https://docs.google.com/spreadsheets/d/e/2PACX-1vQ__KgzzjYneQe-8taFViRNT183LScS8lJTTI1ONqPbrEXJa5OcQeCQThH7PS2yG6z_jlQixD5gaQe3/pub?gid=165409388&single=true&output=csv'
        self.sender_email = 'faturamento.qorpo@gmail.com'
        self.sender_password = getenv('senha_webmail_plantao')

    def cria_plantoes(self):
        
        df = pd.read_csv(self.url)
        df['Data Pagamento'] = pd.to_datetime(df['Data Pagamento'],format='%d/%m/%Y')

        plantoes_sao_camilo, plantoes_mk = self.separa_plantoes(df=df)
        print("acrescentando horas trabalhadas")
        try:
            plantoes_sao_camilo = self.acrescenta_horas_trabalhadas(plantoes_sao_camilo)
            plantoes_mk = self.acrescenta_horas_trabalhadas(plantoes_mk)
        except Exception as e:
            print("erro ao acrescentar horarios")

        print("acrescentando valores dos plantoes")
        try:
            plantoes_sao_camilo['Valor'] = plantoes_sao_camilo.apply(self.calcular_valor, axis=1)
            plantoes_mk['Valor'] = plantoes_mk.apply(self.calcular_valor, axis=1)
        except Exception as e:
            print("erro ao acrescentar os valores dos plantoes")

        return plantoes_sao_camilo,plantoes_mk

    def salva_excel_plantao(self, plantoes_sao_camilo, plantoes_mk):

        plantoes_sao_camilo = plantoes_sao_camilo[['Nome Completo', 'Dia do Plantão', 'Horário de Início do Plantão', 'Horário de Fim do Plantão','Horas', 'Hospital', 'Data Pagamento', 'Valor']]
        plantoes_mk = plantoes_mk[['Nome Completo', 'Dia do Plantão', 'Horário de Início do Plantão', 'Horário de Fim do Plantão','Horas', 'Hospital','Data Pagamento', 'Valor']]

        plantoes_sao_camilo.to_excel("docs/plantoes_sao_camilo.xlsx",index=False)
        plantoes_mk.to_excel("docs/plantoes_mk.xlsx", index=False)

    def acrescenta_horas_trabalhadas(self,df):
    
        df_cadmedico = pd.read_csv(self.url_cadmedico)
        df_cadmedico = df_cadmedico[['Nome', 'email']]
        df_cadmedico.columns = ['Nome Completo', 'email']


        df['Dia do Plantão'] = pd.to_datetime(df['Dia do Plantão'], format='%d/%m/%Y')
        df['Inicio'] = pd.to_datetime(df['Dia do Plantão'].astype(str) + ' ' + df['Horário de Início do Plantão'])
        df['Fim'] = pd.to_datetime(df['Dia do Plantão'].astype(str) + ' ' + df['Horário de Fim do Plantão'])

        df['Horas'] = (df['Fim'] - df['Inicio']).dt.total_seconds() / 3600
        df.loc[df['Fim'] < df['Inicio'], 'Horas'] += 24
        df['Mes'] = df['Dia do Plantão'].dt.to_period('M')

        horas_trabalhadas = df.groupby(['Nome Completo', 'Mes'])['Horas'].sum().reset_index()
        horas_trabalhadas.columns = ['Nome Completo', 'Mes', 'Horas_Trabalhadas']

        df = df.merge(horas_trabalhadas, on=['Nome Completo', 'Mes'])
        df = pd.merge(df, df_cadmedico, on='Nome Completo')

        return df
    
    def separa_plantoes(self, df):
        
        filtro_mk = df['Hospital'] == 'Monte Klinikum'
        plantoes_mk = df[filtro_mk]
        plantoes_mk = plantoes_mk[['Nome Completo', 'Dia do Plantão',
                                'Horário de Início do Plantão', 'Horário de Fim do Plantão', 'Hospital',
                                    'Data Pagamento']]

        filtro_sao_camilo = df['Hospital'] == 'São Camilo'
        plantoes_sao_camilo = df[filtro_sao_camilo]
        plantoes_sao_camilo = plantoes_sao_camilo[['Nome Completo', 'Dia do Plantão',
                                                'Horário de Início do Plantão', 'Horário de Fim do Plantão', 'Hospital',
                                                    'Data Pagamento']]
        
        return plantoes_sao_camilo,plantoes_mk

    def envia_demonstrativos(self, Data_pagamento):

        self.data_pagamento = pd.to_datetime(Data_pagamento, format='%d/%m/%Y')

        try:
            print("criando tabela de plantoes...")
            plantoes_sao_camilo, plantoes_mk = self.cria_plantoes()
        except Exception as e:
            print(f"erro ao criar tabelas :{e}")



        plantoes_sao_camilo = plantoes_sao_camilo[plantoes_sao_camilo['Data Pagamento'] == self.data_pagamento]
        plantoes_mk = plantoes_mk[plantoes_mk['Data Pagamento'] == self.data_pagamento]

        print("salvando tabelas em excel")
        try:
            self.salva_excel_plantao(plantoes_sao_camilo=plantoes_sao_camilo, plantoes_mk=plantoes_mk)
        except Exception as e:
            print(f"falha ao salvar excel {e}")

        
        plantoes = pd.concat([plantoes_sao_camilo, plantoes_mk], ignore_index=True)

        grupo_medicos = plantoes.groupby(['Nome Completo','Hospital'])

        for (medico,hospital) , dados in grupo_medicos:
            email_medico = dados['email'].iloc[0]
            data_pagamento_ = dados['Data Pagamento'].dt.strftime('%d/%m/%Y').iloc[0]
            horas_totais = int(dados['Horas_Trabalhadas'].iloc[0])
            dados = dados[['Nome Completo', 'Dia do Plantão', 'Horário de Início do Plantão', 'Horário de Fim do Plantão','Horas' , 'Hospital', 'Data Pagamento', 'Valor']]
            valor_receber = dados['Valor'].sum()
            dados['Dia do Plantão'] = dados['Dia do Plantão'].dt.strftime('%d/%m/%Y')
            dados['Data Pagamento'] = dados['Data Pagamento'].dt.strftime('%d/%m/%Y')
            tabela_plantao = dados.to_html(index=False)

            assunto = f'Informações de Plantões - {medico} - {hospital}'
            corpo_email = f"""
            <html>
            <head></head>
            <body>
            <p>Olá {medico},</p>
            <p>Aqui está o demonstrativo de plantões realizados no Hospital {hospital}, pagos na data {data_pagamento_}, totalizando {horas_totais} horas trabalhadas.</p>
            <p>Valor total = R${valor_receber}:</p>
            {tabela_plantao}
            </body>
            </html>
            """
            self.enviar_email(email_medico, assunto, corpo_email)

    def calcular_valor(self,row):
        hospital = row['Hospital']
        dia = row['Dia do Plantão']
        dia_semana = dia.weekday()
        horas_trabalhadas = row['Horas_Trabalhadas']
        horas = row['Horas']

        if hospital == 'São Camilo':
            if horas_trabalhadas >= 96:
                if horas == 6:
                    return 625
                else:
                    return 1250

            else:
                if horas == 6:
                    if dia_semana <5:
                        return 450
                    else:
                        return 625
                else:
                    if dia_semana <5:
                        return 900
                    else:
                        return 1250

        else:
            if horas == 12:
                if dia_semana < 4:
                    return 1000
                else:
                    return 1100
                    
            else:
                if dia_semana < 5:
                    return 450
                else:
                    return 550

    def enviar_email(self,destinatario, subject, body):
        smtp_server = 'smtp.gmail.com'
        smtp_port = 587
        msg = MIMEMultipart()
        msg['From'] = self.sender_email
        msg['To'] = destinatario
        msg['Subject'] = subject
        msg.attach(MIMEText(body, 'html'))

        try:
            server = smtplib.SMTP(smtp_server, smtp_port)
            server.starttls()
            server.login(self.sender_email, self.sender_password)
            server.sendmail(self.sender_email, destinatario, msg.as_string())
            server.quit()
            print(f'Email enviado com sucesso para {destinatario}')
        except Exception as e:
            print(f'Erro ao enviar o email para {destinatario}: {e}')