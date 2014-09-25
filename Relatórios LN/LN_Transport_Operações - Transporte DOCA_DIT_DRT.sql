     SELECT znsls005.t$entr$c   ENTREGA,
            znsls005.t$orde$c   INSTANCIA,
            cisli940.t$docn$l   NF,
            cisli940.t$seri$l   SERIE,
            ( select a.t$fovn$l 
                from ttccom130201 a
               where a.t$cadr = cisli940.t$sfra$l ) 
                                CNPJ_FILIAL,
            znfmd630.t$fili$c   NR_FILIAL
       FROM tznsls005201 znsls005
 INNER JOIN tcisli940201 cisli940 
         ON cisli940.t$fire$l = znsls005.t$firs$c
 INNER JOIN tznfmd630201 znfmd630 
         ON znfmd630.t$orno$c = znsls005.t$orno$c
      WHERE znsls005.t$orde$c != ' '
