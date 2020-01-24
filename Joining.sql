SELECT DISTINCT ottt.TRANSACTION_TYPE_ID
,               ottt.NAME
,               ottt.DESCRIPTION
,               hou.NAME AS "Operating Unit"
,               CASE
                    WHEN xp.PARAMETER_TYPE       = 'ORDER_TYPE_HIST'
                    THEN 'Y'
                    ELSE 'N'
                END AS "Included On Store"
FROM XXECOMM_PARAMETERS         xp
,    OE_TRANSACTION_TYPES_ALL   otta
,    OE_TRANSACTION_TYPES_TL    ottt
,    HR_OPERATING_UNITS         hou
WHERE 1 = 1
AND xp.PARAMETER_VALUE_NUM  (+) = otta.TRANSACTION_TYPE_ID
AND otta.TRANSACTION_TYPE_ID    = ottt.TRANSACTION_TYPE_ID
AND otta.ORG_ID                 = hou.ORGANIZATION_ID
AND otta.TRANSACTION_TYPE_CODE  = 'ORDER'
AND ottt.LANGUAGE               = 'US'
AND (otta.END_DATE_ACTIVE       IS NULL          OR otta.END_DATE_ACTIVE > SYSDATE)
AND (otta.ORG_ID                = 82             OR otta.ORG_ID = 83)
ORDER BY ottt.TRANSACTION_TYPE_ID;

SELECT otta.TRANSACTION_TYPE_ID                  -- Failed OUTER JOIN, correct syntax?
FROM OE_TRANSACTION_TYPES_ALL otta
LEFT OUTER JOIN XXECOMM_PARAMETERS
ON otta.TRANSACTION_TYPE_ID     = XXECOMM_PARAMETERS.PARAMTER_VALUE_NUM;


SELECT DISTINCT otta.ORG_ID                      -- Finding org id's
,               ottt.NAME
FROM OE_TRANSACTION_TYPES_ALL   otta
,    OE_TRANSACTION_TYPES_TL    ottt
WHERE ottt.TRANSACTION_TYPE_ID  = otta.TRANSACTION_TYPE_ID;


SELECT *                                         -- order types contained on webstore
FROM XXECOMM_PARAMETERS
WHERE PARAMETER_TYPE            = 'ORDER_TYPE_HIST';


OE_TRANSACTION_TYPES_ALL;                        -- describing tables
OE_TRANSACTION_TYPES_TL;
HR_OPERATING_UNITS;
