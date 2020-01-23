SELECT DISTINCT ottt.transaction_type_ID         
,               ottt.NAME
,               ottt.DESCRIPTION
,               CASE
                    WHEN xp.parameter_type = 'ORDER_TYPE_HIST'
                    THEN 'Y'
                    ELSE 'N'
                END AS "Included On Store"
FROM xxecomm_parameters         xp
,    oe_transaction_types_all   otta
,    oe_transaction_types_tl    ottt
WHERE 1 = 1
AND otta.transaction_type_id    = ottt.transaction_type_id
AND ottt.language               = 'US'
AND (otta.end_date_active       IS NULL                     OR otta.end_date_active > SYSDATE)
AND (otta.org_id                = 82                        OR otta.org_id = 83)
ORDER BY ottt.transaction_type_ID;


SELECT DISTINCT otta.org_id                      -- Finding org id's
,               ottt.name
FROM oe_transaction_types_all   otta
,    oe_transaction_types_tl    ottt
WHERE ottt.transaction_type_id  = otta.transaction_type_id;


SELECT *                                         -- order types contained on webstore
FROM XXECOMM_PARAMETERS
WHERE parameter_type            = 'ORDER_TYPE_HIST';


oe_transaction_types_all;                        -- describing tables
oe_transaction_types_tl;
