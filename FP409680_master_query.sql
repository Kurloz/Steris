SELECT qlht.name                        AS "Modifier Number"                    -- header modifier number
,      qlht.description                 AS "Modifier Name"
,      qll.list_line_no                 AS "Modifier No"                        -- line modifier number, use list_line_no,
,      qll.modifier_level_code          AS "Level"                              --^it looks like the id but they do not always match
,      qup.meaning                      AS "Modifier Type"
,      NULL                             AS "Active?"                            --Active? column filler
,      qll.start_date_active            AS "Start Date"
,      qll.end_date_active              AS "End Date"
,      qll.automatic_flag               AS "Automatic"
,      qll.override_flag                AS "Override"
,      qpp.name                         AS "Pricing Phase"
,      qup2.meaning                     AS "Incompatibility Group"
,      NULL                             AS "Bucket"                             --Bucket column filler
,      qup3.meaning                     AS "Proration Type"
,      NULL                             AS "Comparison Value"                   --Comparison Value column filler
,      NULL                             AS "Product Attribute"                  --Product Attribute column filler
,      msib.segment1                    AS "Product Attribute Value"
,      msib.description                 AS "Product Description"
,      qll.product_precedence           AS "Precedence"
,      NULL                             AS "Volume Type"                        --Volume Type column filler
,      NULL                             AS "Break Type"                         --Break Type column filler
,      NULL                             AS "Operator"                           --Operator column filler
,      qpa.product_uom_code             AS "UOM"
,      NULL                             AS "Value From"                         --Value From column filler
,      NULL                             AS "Value To"                           --Value To column filler
,      NULL                             AS "Change Name"                        --Change Name column filler
,      NULL                             AS "Include On Returns"                 --Include On Returns column filler
,      NULL                             AS "Formula"                            --Formula column filler
,      qll.arithmetic_operator          AS "Application method"
,      qll.operand                      AS "Value"
,      qp.qualifier_attr_value          AS "PFAM"
FROM qp_list_headers_tl     qlht
,    qp_list_lines          qll
,    qp_lookups             qup
,    qp_lookups             qup2
,    qp_lookups             qup3
,    qp_pricing_phases      qpp
,    qp_qualifiers          qp
,    qp_pricing_attributes  qpa
,    mtl_system_items_b     msib
WHERE 1 = 1
AND SYSDATE BETWEEN NVL(qll.start_date_active, SYSDATE - 1) AND NVL(qll.end_date_active, SYSDATE + 1)
AND qlht.language                         = 'US'
AND qlht.name                             = '38352'
AND qll.list_header_id                    = qlht.list_header_id
AND qpp.pricing_phase_id                  = qll.pricing_phase_id
AND qup.lookup_type                       = 'LIST_LINE_TYPE_CODE'
AND qup3.lookup_type                      = 'PRORATION_TYPE'
AND qup3.lookup_code                      = qll.proration_type_code
AND qup.lookup_code                       = qll.list_line_type_code
AND qup2.lookup_type                  (+) = 'INCOMPATIBILITY_GROUPS'
AND qup2.lookup_code                  (+) = qll.incompatibility_grp_code
AND qp.list_line_id                   (+) = qll.list_line_id
AND msib.organization_id              (+) = 203
AND msib.inventory_item_id            (+) = qpa.product_attr_value
AND qpa.list_line_id                  (+) = qll.list_line_id
AND qpa.product_attribute_context     (+) = 'ITEM'
AND qpa.product_attribute             (+) = 'PRICING_ATTRIBUTE1';
