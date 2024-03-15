WITH cte_pagar AS (
SELECT
	CONCAT(CodFornecedor, NFiscal) as CodPagar,
	CodFornecedor,
	NParc,
	Duplicata,
	JurosDia,
	ValorPag,
	DataPag,
	JurosPag,
	Cheque,
	Banco

FROM sisac.dbo.Pagar

), cte_pagar_c AS (
SELECT
	CONCAT(CodFornecedor, Nfiscal) as CodPagar,
	NParc,
	NFiscal,
	CodFornecedor,
	DataEmissao,
	ContaFin,
	Historico,
	Valor,
	Desconto,
	Multa

FROM sisac.dbo.PagarC

)


SELECT

	cte_pagar_c.CodPagar as codpagar,
	cte_pagar.CodPagar as codpagar_c,
	cte_pagar.NParc as parcela,
	cte_pagar_c.NParc as numparcelas,
	cte_pagar_c.NFiscal,
	cte_pagar_c.CodFornecedor,
	fornecedor.Razao,
	cte_pagar_c.DataEmissao,
	cte_pagar_c.ContaFin,
	cte_pagar_c.Historico,
	cte_pagar.Duplicata,
	cte_pagar_c.Valor,
	cte_pagar.JurosDia,
	cte_pagar.ValorPag,
	cte_pagar.DataPag,
	cte_pagar.JurosPag,
	cte_pagar_c.Desconto,
	cte_pagar_c.Multa,
	cte_pagar.Cheque,
	cte_pagar.Banco


FROM cte_pagar

LEFT JOIN cte_pagar_c ON cte_pagar.CodPagar = cte_pagar_c.CodPagar
LEFT JOIN sisac.dbo.Fornecedor as fornecedor ON cte_pagar.CodFornecedor = fornecedor.CodFornecedor

ORDER BY  DataEmissao, NFiscal