DECLARE

header_id       NUMBER;
rec_count				NUMBER;
group_num       NUMBER;

tp_code         VARCHAR(35);
partner_code    VARCHAR(35);
group_code      VARCHAR2(35);
tran_id         VARCHAR2(30);
net_code        VARCHAR2(150);
doc_id          VARCHAR2(200);
partner_desc    VARCHAR2(240);

BEGIN

GO_BLOCK('xxec_partners_v');

FIRST_RECORD;

rec_count     := 0;
header_id     := 0;
group_num     := 0;
group_code    := NULL;
tp_code       := NULL;
partner_code  := NULL;
partner_desc  := NULL;
tran_id       := NULL;
net_code      := NULL;

LOOP

	IF CHECKBOX_CHECKED('xxec_partners_v.sel_list') THEN

		rec_count     := rec_count + 1;
		header_id     := :xxec_partners_v.tp_header_id;
		doc_id        := :xxec_partners_v.document_id;
		partner_code  := :xxec_partners_v.partner;
    partner_desc  := :xxec_partners_v.tp_description;
    tran_id       := :xxec_partners_v.translator_code;
    net_code      := :xxec_partners_v.network;
    group_code    := :xxec_partners_v.tp_group_code;
    group_num     := :xxec_partners_v.tp_group_id;

		IF (:group_change.partner_replacement_replace IS NOT NULL) THEN

			partner_code := REPLACE(partner_code, :group_change.partner_replacement_replace, :group_change.partner_replacement_with);

      UPDATE  ece_tp_headers
      SET     tp_code           = partner_code
      ,       last_updated_by   = apps.fnd_global.user_id
      ,       last_update_date  = SYSDATE
      WHERE   1 = 1
      AND     header_id         = tp_header_id;

		END IF;

    IF (:group_change.description_replacement_replac IS NOT NULL) THEN

      partner_desc := REPLACE(partner_desc, :group_change.description_replacement_replac, :group_change.description_replacement_with);

      UPDATE  ece_tp_headers
      SET     tp_description    = partner_desc
      ,       last_updated_by   = apps.fnd_global.user_id
      ,       last_update_date  = SYSDATE
      WHERE   1 = 1
      AND     header_id         = tp_header_id;

    END IF;

    IF (:group_change.translator_code_replace IS NOT NULL) THEN

      tran_id := REPLACE(tran_id, :group_change.translator_code_replace, :group_change.translator_code_with);

      UPDATE  ece_tp_details
      SET     translator_code   = tran_id
      ,       last_updated_by   = apps.fnd_global.user_id
      ,       last_update_date  = SYSDATE
      WHERE   1 = 1
      AND     header_id         = tp_header_id;

    END IF;

    IF (:group_change.network IS NOT NULL) THEN

      net_code := :group_change.network;

      UPDATE  ece_tp_headers
      SET     attribute7        = net_code
      ,       last_updated_by   = apps.fnd_global.user_id
      ,       last_update_date  = SYSDATE
      WHERE   1 = 1
      AND     header_id         = tp_header_id;

    END IF;

    IF (:group_change.group_new IS NOT NULL) THEN

      group_code  := :group_change.group_new;

      SELECT  tp_group_id
      INTO    group_num
      FROM    ece_tp_group
      WHERE   1 = 1
      AND     tp_group_code     = group_code;

      UPDATE  ece_tp_headers
      SET     tp_group_id       = group_num
      ,       last_updated_by   = apps.fnd_global.user_id
      ,       last_update_date  = SYSDATE
      WHERE   1 = 1
      AND     header_id         = tp_header_id;

    END IF;

	END IF;

	EXIT WHEN :system.last_record = 'TRUE';

	NEXT_RECORD;

END LOOP;

FND_MESSAGE.SET_STRING('There were ' || rec_count || ' selected rows. Info: ' || header_id || ', ' || doc_id || ', ' || partner_code);  -- For testing
FND_MESSAGE.SHOW();

COMMIT;

END;
