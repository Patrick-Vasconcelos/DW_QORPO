SELECT
	recebe.GrupoEmp,
	recebe.Filial,
	recebe.Condicao,
	recebe.Data,
	recebe.Hist,
	recebe.NBOL,
	recebe.NFech,
	entrada.Tipo,
	recebe.Estorno,
	recebe.Valor,
	recebe.ValorPag,
	recebe.Paciente
FROM sisac.dbo.RecebePart as recebe

INNER JOIN sisac.dbo.RecebePartC as recebecartao ON (recebecartao.CodPaciente = recebe.CodPaciente)
AND recebecartao.GrupoEmp = recebe.GrupoEmp AND recebecartao.Filial = recebe.Filial

INNER JOIN sisac.dbo.Entrada as entrada ON (recebecartao.CodPaciente = entrada.CodMovimento)
AND recebecartao.GrupoEmp = entrada.GrupoEmp AND recebecartao.Filial = entrada.Filial