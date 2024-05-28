#%%
import pandas as pd

import datetime
import smtplib
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText

#%%

url = 'https://docs.google.com/spreadsheets/d/e/2PACX-1vQ__KgzzjYneQe-8taFViRNT183LScS8lJTTI1ONqPbrEXJa5OcQeCQThH7PS2yG6z_jlQixD5gaQe3/pub?gid=165409388&single=true&output=csv'
url_cadmedico = 'https://docs.google.com/spreadsheets/d/e/2PACX-1vQ__KgzzjYneQe-8taFViRNT183LScS8lJTTI1ONqPbrEXJa5OcQeCQThH7PS2yG6z_jlQixD5gaQe3/pub?gid=1249023783&single=true&output=csv'
# %%
df_cadmedico = pd.read_csv(url_cadmedico)
df_cadmedico = df_cadmedico[['Nome', 'email']]
df_cadmedico.columns = ['Nome Completo', 'email']

#%%

def acrescenta_valor_plantao(df):
    df['Dia do Plantão'] = pd.to_datetime(df['Dia do Plantão'], format='%d/%m/%Y')
    df['Inicio'] = pd.to_datetime(df['Dia do Plantão'].astype(str) + ' ' + df['Horário de Início do Plantão'])
    df['Fim'] = pd.to_datetime(df['Dia do Plantão'].astype(str) + ' ' + df['Horário de Fim do Plantão'])


    # df['Horas'] = (pd.to_datetime(df['Horário de Fim do Plantão'].astype(str)) - pd.to_datetime(df['Horário de Início do Plantão'].astype(str))).dt.total_seconds() / 3600
    df['Horas'] = (df['Fim'] - df['Inicio']).dt.total_seconds() / 3600
    df.loc[df['Fim'] < df['Inicio'], 'Horas'] += 24
    df['Mes'] = df['Dia do Plantão'].dt.to_period('M')

    horas_trabalhadas = df.groupby(['Nome Completo', 'Mes'])['Horas'].sum().reset_index()
    horas_trabalhadas.columns = ['Nome Completo', 'Mes', 'Horas_Trabalhadas']

    df = df.merge(horas_trabalhadas, on=['Nome Completo', 'Mes'])
    df = pd.merge(df, df_cadmedico, on='Nome Completo')

    return df

#%%
def calcular_valor(row):
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

#%%

df = pd.read_csv(url)
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

#%%
plantoes_sao_camilo = acrescenta_valor_plantao(plantoes_sao_camilo)
plantoes_mk = acrescenta_valor_plantao(plantoes_mk)

#%%

plantoes_mk['Valor'] = plantoes_mk.apply(calcular_valor, axis=1)
plantoes_sao_camilo['Valor'] = plantoes_sao_camilo.apply(calcular_valor, axis=1)

#%%

plantoes_mk.to_excel("../docs/plantoes_mk.xlsx",index=False)
plantoes_sao_camilo.to_excel("../docs/plantoes_sao_camilo.xlsx", index=False)

#%%
plantoes_sao_camilo.head()
# %%

plantoes_sao_camilo['Data Pagamento'] = pd.to_datetime(plantoes_sao_camilo['Data Pagamento'],format='%d/%m/%Y')
plantoes_mk['Data Pagamento'] = pd.to_datetime(plantoes_mk['Data Pagamento'],format='%d/%m/%Y')
data_pagamento = pd.to_datetime('27/05/2024',format='%d/%m/%Y')

plantoes_sao_camilo = plantoes_sao_camilo[plantoes_sao_camilo['Data Pagamento'] == data_pagamento]
plantoes_mk = plantoes_mk[plantoes_mk['Data Pagamento'] == data_pagamento]


#%%

plantoes = pd.concat([plantoes_sao_camilo, plantoes_mk], ignore_index=True)

grupo_medicos = plantoes.groupby(['Nome Completo','Hospital'])
# %%

smtp_server = 'smtp.gmail.com'
smtp_port = 587
sender_email = 'financeiro.qorpo@gmail.com'
sender_password = 'zkofkrpkeymehzca'


#%%

def enviar_email(destinatario, subject, body):
    msg = MIMEMultipart()
    msg['From'] = sender_email
    msg['To'] = destinatario
    msg['Subject'] = subject
    msg.attach(MIMEText(body, 'html'))

    try:
        server = smtplib.SMTP(smtp_server, smtp_port)
        server.starttls()
        server.login(sender_email, sender_password)
        server.sendmail(sender_email, destinatario, msg.as_string())
        server.quit()
        print(f'Email enviado com sucesso para {destinatario}')
    except Exception as e:
        print(f'Erro ao enviar o email para {destinatario}: {e}')

#%%

for (medico,hospital) , dados in grupo_medicos:
    email_medico = dados['email'].iloc[0]
    data_pagamento_ = dados['Data Pagamento'].dt.strftime('%d/%m/%Y').iloc[0]
    dados = dados[['Nome Completo', 'Dia do Plantão', 'Horário de Início do Plantão', 'Horário de Fim do Plantão', 'Hospital', 'Data Pagamento', 'Valor']]
    dados['Dia do Plantão'] = dados['Dia do Plantão'].dt.strftime('%d/%m/%Y')
    dados['Data Pagamento'] = dados['Data Pagamento'].dt.strftime('%d/%m/%Y')
    tabela_plantao = dados.to_html(index=False)
    assunto = f'Informações de Plantões - {medico} - {hospital}'
    corpo_email = f"""
    <html>
    <head></head>
    <body>
    <p>Olá {medico},</p>
    <p>Aqui estão os seus plantões pagos na data {data_pagamento_} pelo o {hospital}:</p>
    {tabela_plantao}
    </body>
    </html>
    """
    enviar_email(email_medico, assunto, corpo_email)
    