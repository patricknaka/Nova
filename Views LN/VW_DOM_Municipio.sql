select  a.t$ccty PAIS,
        a.t$cste ESTADO,
        a.t$city COD_MUNICIPIO,
        a.t$dsca DESCRICAO_MUNICIPIO,
        e.t$dsca DESCRICAO_ESTADO,
        p.t$dsca DESCRICAO_PAIS
from  ttccom139201 a,
      ttcmcs143201 e,
      ttcmcs020101 p
where e.t$cste=a.t$cste
and   p.t$ccty=a.t$ccty
