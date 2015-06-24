SELECT DISTINCT

  ' '                           CODIGO_CLIENTE,     --02
  ' '                           CONCEITO,           --03
  tccom130.t$ftyp$l             TIPO_VAREJO,        --04
  tccom100.t$nama               CLIENTE_VAREJO,     --05
  'NIKE.COM'                    FILIAL,             --06
  ' '                           PONTUALIDADE,       --07
  ' '                           TIPO_BLOQUEIO,      --08
  ltrim(rtrim(tccom130.t$namc)) ENDERECO,           --09
  tccom130.t$cste               UF,                 --10
  CASE WHEN tccom130.t$ftyp$l = 'PJ' THEN
    '0'
    WHEN tccom130.t$ftyp$l = 'PF' THEN
      '1'
    ELSE ' ' END                  PF_PJ,            --11
  CASE WHEN tccom130.t$ftyp$l = 'PJ' THEN
    tccom966.t$stin$d
    WHEN tccom130.t$ftyp$l = 'PF' THEN
      ' '
    ELSE ' ' END                RG_IE,              --12
  tccom130.t$fovn$l             CPF_CGC,            --13
  tccom130.t$dsca               CIDADE,             --14
  tccom130.t$bldg               COMPLEMENTO,        --15
  tccom130.t$pstc               CEP,                --16
  NVL(SUBSTR(replace(replace(replace(tccom130.t$telp,'(',''),')',''),'-',''),3,13),' ') TELEFONE,   ---SUBSTR(tccom130.t$telp,3,13) 	TELEFONE,           --17
  tccom130.t$tefx               FAX,                --18
  ' '                           LIMITE_CREDITO,     --19
  ' '                           SEM_CREDITO,        --20
  ' '                           ANIVERSARIO,        --21
  CASE WHEN tccom100.t$crdt < to_date('01-01-1980','DD-MM-YYYY') THEN
      NULL
  ELSE CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR( tccom100.t$crdt, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
          AT time zone 'America/Sao_Paulo') AS DATE) END
                                CADASTRAMENTO,      --22
  NVL(SUBSTR(replace(replace(replace(tccom130.t$telp,'(',''),')',''),'-',''),1,2),' ') DDD,                --23
  ' '                           SEXO,               --24
  ' '                           OBS,                --25
    CASE WHEN tccom130.t$ftyp$l = 'PJ' THEN
      'C'
    WHEN tccom130.t$ftyp$l = 'PF' THEN
      'R'
    ELSE ' ' END                TIPO_TELEF,         --26
    tccom130.t$info             EMAIL,              --27
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ZNSLS400.DT_ULT_COMP, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
          AT time zone 'America/Sao_Paulo') AS DATE)
                                ULTIMA_COMPRA,      --28
    tccom130.t$dist$l           BAIRRO,             --29
    '1'                         STATUS,             --30
    ' '                         TIPO_LOGRADOURO,    --31
    tccom130.t$hono             NUMERO,             --22
    ' '                         ESTADO_CIVIL,       --23
    --SUBSTR(ZNSLS400.t$te1f$c,1,2) DDD_CELULAR,        --24
    --SUBSTR(ZNSLS400.t$te1f$c,3,13)CELULAR             --25
    nvl(SUBSTR(replace(replace(replace(ZNSLS400.t$te1f$c,'(',''),')',''),'-',''),1,2),' ') DDD_CELULAR,        --24
    nvl(SUBSTR(replace(replace(replace(ZNSLS400.t$te1f$c,'(',''),')',''),'-',''),3,13),' ') CELULAR             --25
   
FROM  baandb.ttccom100601 tccom100

  LEFT JOIN baandb.ttccom130601 tccom130
         ON tccom130.t$cadr = tccom100.t$cadr
         
  LEFT JOIN baandb.ttccom966601 tccom966
         ON tccom966.t$comp$d = tccom130.t$comp$d
         
  LEFT JOIN ( select  MAX(a.t$dtem$c)  DT_ULT_COMP,
                      a.t$ofbp$c,
					  a.t$te1f$c,
					  a.t$te2f$c
              from    baandb.tznsls400601  a
              group by 	a.t$ofbp$c,
						a.t$te1f$c,
						a.t$te2f$c) ZNSLS400
         ON   ZNSLS400.t$ofbp$c = tccom100.t$bpid
     
WHERE tccom100.t$bprl = 2     --Cliente