ALTER SESSION SET CURRENT_SCHEMA = APPS;


SELECT  qlht.NAME
,       qlht.DESCRIPTION
,       CASE
            WHEN (qlhb.END_DATE_ACTIVE IS NULL OR qlhb.END_DATE_ACTIVE > SYSDATE)
            THEN 'Yes'
            ELSE 'No'
        END AS "Active Status"
,       qlhb.CURRENCY_CODE         
--multi-currency conversion code here could be currency_header_id or rounding_factor maybe
,       qlhb.START_DATE_ACTIVE                  
,       qlhb.END_DATE_ACTIVE
FROM    QP_LIST_HEADERS_B qlhb
,       QP_LIST_HEADERS_TL qlht
WHERE 1 = 1
AND     qlht.LIST_HEADER_ID = qlhb.LIST_HEADER_ID
AND     qlht.LANGUAGE       = 'US'
AND     qlht.NAME           LIKE '%OFFLINE%'
ORDER BY qlhb.START_DATE_ACTIVE;


QP_LIST_HEADERS_B;                               --Describing tables
QP_LIST_HEADERS_TL;
