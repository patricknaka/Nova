
SELECT DISTINCT
      znrec007.t$cvpc$c   NR_CONTRATO,
      znrec007.t$seqn$c   NR_SEQ,
      znrec007.t$canc$c   NR_FLAG_CANCELAMENTO,
      tfacr200.t$itbp     CD_PARCEIRO,
      CASE WHEN regexp_replace(znrec007.t$fovn$c, '[^0-9]', '') IS NULL
		THEN '00000000000000' 
		WHEN LENGTH(regexp_replace(znrec007.t$fovn$c, '[^0-9]', ''))<11
		THEN '00000000000000'
		ELSE regexp_replace(znrec007.t$fovn$c, '[^0-9]', '') END  NR_CNPJ_CPF,
      znrec007.t$svpc$c   CD_STATUS,
      znrec007.t$fire$c   NR_REFERENCIA_FISCAL,
      znrec007.t$ttyp$c ||znrec007.t$docn$c CD_CHAVE_PRIMARIA,
      znrec007.t$amnt$c   VL_VPC,
      znrec007.t$logn$c   DS_USUARIO_ULTIMA_ALTERACAO,
      CASE WHEN regexp_replace(znrec007.t$fovf$c, '[^0-9]', '') IS NULL
		THEN '00000000000000' 
		WHEN LENGTH(regexp_replace(znrec007.t$fovf$c, '[^0-9]', ''))<11
		THEN '00000000000000'
		ELSE regexp_replace(znrec007.t$fovf$c, '[^0-9]', '') END  NR_CNPJ_FILIAL,
      znrec007.t$datf$c   DT_INICIAL,
      znrec007.t$datt$c   DT_FINAL,
      znrec007.t$datp$c   DT_VENCIMENTO,
      znrec007.t$paym$c   CD_METODO_PAGAMENTO,
      znrec007.t$dept$c   CD_DEPARTAMENTO,
      znrec007.t$seto$c   CD_SETOR,
      znrec007.t$fami$c   CD_FAMILIA,
      znrec007.t$sfam$c   CD_SUB_FAMILIA,
      znrec007.t$boni$c   DS_FLAG_PEDIDO_BONIFICADO,
      znrec007.t$mvpc$c   CD_MODALIDADE_VPC,
      znrec007.t$udat$c   DT_ULTIMA_ALTERACAO
FROM
      baandb.tznrec007201 znrec007,
      baandb.ttfacr200201 tfacr200
WHERE
      znrec007.t$ttyp$c = tfacr200.t$ttyp AND
      znrec007.t$docn$c = tfacr200.t$ninv
ORDER BY 1, 2

