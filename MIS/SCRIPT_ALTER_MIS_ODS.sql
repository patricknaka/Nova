--Banco MIS_ODS
-------------------------------------------------------------------------------------------------------------------------
--Script Alteração Data Type

--DE NUMERIC(2) para NUMERIC(3)
ALTER TABLE MIS_ODS.fin.ods_sige_titulo_receber_movimento
ALTER COLUMN nr_id_transacao numeric(3)


--------------------------------------------------------------------
--DE numeric(2) para numeric(3)
ALTER TABLE MIS_ODS.FIN.ods_sige_titulo_pagamento
ALTER COLUMN NR_ID_TRANSACAO NUMERIC(3)


--------------------------------------------------------------------
--DE varchar(30) para varchar(35)
ALTER TABLE MIS_ODS.FIN.ODS_FORNECEDOR_CONTATO
ALTER COLUMN DS_NOME VARCHAR(35)