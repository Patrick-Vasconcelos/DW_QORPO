import pyodbc
import pandas.io.sql as psql


class dw_qorpo():
    def conecta_ao_banco(driver= 'ODBC Driver 18 for SQL Server', server= 'SRV-002', database = 'SISAC', username=None,password=None,trusted_connection='no'):

        string_conexao = f"DRIVER={driver};SERVER={server};DATABASE={database};ENCRYPT=no;UID={username};PWD={password};TRUSTED_CONNECTION={trusted_connection}"
        
        conexao = pyodbc.connect(string_conexao)
        cursor = conexao.cursor()

        return conexao, cursor

    def consulta_ao_banco(query,conexao):

        df = psql.read_sql(query,conexao)

        return df

    def salvar_em_excel(consulta, nome_arquivo='consulta'):

        consulta.to_excel(f"docs/{nome_arquivo}.xlsx", index=False)

