select distinct 
acp201.t$ifbp             Parceiro, 
com100.t$nama             Nome, 
com130.t$fovn$l           CPJ_CPF, 
acp201.t$ttyp             Tp_Trans, 
acp201.t$ninv             Documento,  
acp201.t$schn             Parcela, 
acp200.t$amnt             Vr_Pagto, 

cast((from_tz(to_timestamp(to_char(acp200b.T$DOCD, 'dd-mon-yyyy hh24:mi:ss'),
                'dd-mon-yyyy hh24:mi:ss'), 'gmt') at time zone 'america/sao_paulo') as date) Dt_Docto, 
cast((from_tz(to_timestamp(to_char(acp201.T$PAYD, 'dd-mon-yyyy hh24:mi:ss'),
                'dd-mon-yyyy hh24:mi:ss'), 'gmt') at time zone 'america/sao_paulo') as date) Dt_Vcto_Previsto,
cast((from_tz(to_timestamp(to_char(acp201.T$ODUE$L, 'dd-mon-yyyy hh24:mi:ss'),
                'dd-mon-yyyy hh24:mi:ss'), 'gmt') at time zone 'america/sao_paulo') as date) Dt_Vcto_Original, 
cast((from_tz(to_timestamp(to_char(acp200.t$docd, 'dd-mon-yyyy hh24:mi:ss'),
                'dd-mon-yyyy hh24:mi:ss'), 'gmt') at time zone 'america/sao_paulo') as date) Dt_Pagto,

acp201.t$paym               Met_Pgto, 
acp201.t$brel               Cod_Banco_para_Pgto, 
acp200.t$tdoc               Tp_Trans_Bx, 
acp200.t$docn               Docn_Bx,
acp201.t$bank               Cod_Banco_PN, 

acp200b.t$docn$l             NF, 
acp200b.t$seri$l             Serie,  -- buscando as infs. do tipo de pgto = 1 que contém a NF/serie

decode(acp201.t$pyst$l, '2', 'Aberto', '3', 'Selecionado', '4', 'Pago_Parcial', '5', 'Pago')Status,
tccom122.t$cpay         cond_pag_cod,
tcmcs013.t$dsca         cond_pag_desc

,nvl(cast((from_tz(to_timestamp(to_char(cisli940.t$date$l, 'dd-mon-yyyy hh24:mi:ss'),
                'dd-mon-yyyy hh24:mi:ss'), 'gmt') at time zone 'america/sao_paulo') as date)
                ,cast((from_tz(to_timestamp(to_char(tdrec940.t$idat$l, 'dd-mon-yyyy hh24:mi:ss'),
                'dd-mon-yyyy hh24:mi:ss'), 'gmt') at time zone 'america/sao_paulo') as date)) data_nota_fiscal

from baandb.ttfacp201301 acp201, 
baandb.ttfacp200301 acp200, 
baandb.ttccom100301 com100, 
baandb.ttccom130301 com130, 
baandb.ttfacp200301 acp200b,
baandb.ttccom122301 tccom122, --Parceiro Negocio Faturador
baandb.ttcmcs013301 tcmcs013--Condicao de Pagamento

,baandb.tcisli940301 cisli940 -- Nota Fiscal
,baandb.ttdrec940301 tdrec940 -- Recebimento Fiscal


where acp201.t$pyst$l = 5 --- 5 pago
 and acp201.t$ifbp = com100.t$bpid
 and com100.t$cadr = com130.t$cadr
 and acp201.t$ttyp = acp200.t$ttyp
 and acp201.t$ninv = acp200.t$ninv
 and acp200.t$tpay = 2                 -- lendo a tab. acp200 para tipo de pgto = 2 para buscar os dados de pagto (Vr pago/Dtpgto)
 
 and acp201.t$ttyp = acp200b.t$ttyp    -- lendo novamente a tab. acp200 para tipo de pgto = 1, para buscar NF/serie/DtDocto
 and acp201.t$ninv = acp200b.t$ninv
 and acp200b.t$tpay = 1
 
 --Nota Fiscal
 and acp200.t$ttyp = cisli940.t$ityp$l (+)
 and acp200.t$ninv = cisli940.t$idoc$l (+)
 and acp200.t$ifbp = cisli940.t$bpid$l (+)
 --Recebimento Fiscal 
 and acp200.t$ttyp = tdrec940.t$ttyp$l (+)
 and acp200.t$ninv = tdrec940.t$invn$l (+)
 and acp200.t$ifbp =  tdrec940.t$bpid$l(+)
 
 and tccom122.t$ifbp = acp201.t$ifbp
 and tccom122.t$cpay = tcmcs013.t$cpay
 
-- and rec940.T$DOCN$L = acp200b.T$DOCN$L    -- lendo a tab. rec940 para buscar infs. Fiscais
-- and rec940.T$SERI$L = acp200b.T$SERI$L
          
 and acp200.t$tdoc <> 'ENC'
                
 and cast((from_tz(to_timestamp(to_char(acp200.t$docd, 'dd-mon-yyyy hh24:mi:ss'),
                'dd-mon-yyyy hh24:mi:ss'), 'gmt') at time zone 'america/sao_paulo') as date) between :de and :ate

--and acp200.t$ifbp = '100004970'

order by acp201.t$ifbp, acp201.t$ttyp, acp201.t$ninv, acp201.t$schn
