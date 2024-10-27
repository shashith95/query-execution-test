SELECT Invoice_list_last.PATIENT_ID                 AS PATIENT_ID_45,
       Invoice_list_last.IS_PACKAGE_INVOICE         AS IS_PACKAGE_INVOICE_44,
       Invoice_list_last.INVOICE_NUMBER             AS INVOICE_NUMBER_43,
       Invoice_list_last.INVOICE_TYPE               AS INVOICE_TYPE_42,
       TO_CHAR(CAST(FROM_TZ(Invoice_list_last.CREATED_DATE, 'UTC') AT TIME ZONE 'Asia/Kuwait' AS TIMESTAMP),
               'DD-MON-YYYY HH24:MI:SS')            AS CREATED_DATE_41,
       TO_CHAR(CAST(FROM_TZ(Invoice_list_last.FINALIZE_INVOIE_DATE, 'UTC') AT TIME ZONE 'Asia/Kuwait' AS TIMESTAMP),
               'DD-MON-YYYY HH24:MI:SS')            AS FINALIZE_INVOIE_DATE_40,
       Invoice_list_last.ADMISSION_NO               AS ADMISSION_NO_39,
       Invoice_list_last.APPOINTMENT_ID             AS APPOINTMENT_ID_38,
       Invoice_list_last.PATIENT_TYPE               AS PATIENT_TYPE_37,
       Invoice_list_last.PATIENT_NAME               AS PATIENT_NAME_36,
       Invoice_list_last.CLINIC_ID                  AS CLINIC_ID_35,
       Invoice_list_last.CLINIC_NAME                AS CLINIC_NAME_34,
       Invoice_list_last.DOCTOR_ID                  AS DOCTOR_ID_33,
       Invoice_list_last.DOCTOR_NAME                AS DOCTOR_NAME_32,
       Invoice_list_last.PROCEDUREID                AS PROCEDUREID_31,
       Invoice_list_last.PROCEDURE_NAME             AS PROCEDURE_NAME_30,
       Invoice_list_last.PRICE                      AS PRICE_29,
       Invoice_list_last.SUBCATEGORYID              AS SUBCATEGORYID_28,
       Invoice_list_last.SUBGROUPDESCRIPTION        AS SUBGROUPDESCRIPTION_27,
       Invoice_list_last.COMPANY_ID                 AS COMPANY_ID_26,
       Invoice_list_last.SUBGROUPID                 AS SUBGROUPID_25,
       Invoice_list_last.COMPANYSHARE               AS COMPANYSHARE_24,
       Invoice_list_last.COMPANYPAID                AS COMPANYPAID_23,
       Invoice_list_last.COMPANYCREDIT              AS COMPANYCREDIT_22,
       Invoice_list_last.COMPANYCLEARED             AS COMPANYCLEARED_21,
       Invoice_list_last.PATIENTSHARE               AS PATIENTSHARE_20,
       Invoice_list_last.PATIENT_PAID_SHARE         AS PATIENT_PAID_SHARE_19,
       Invoice_list_last.PATIENT_CREDIT             AS PATIENT_CREDIT_18,
       Invoice_list_last.PATIENTCLEARED             AS PATIENTCLEARED_17,
       Invoice_list_last.DISCOUNT_AMOUNT            AS DISCOUNT_AMOUNT_16,
       Invoice_list_last.IS_REFUNDED                AS IS_REFUNDED_15,
       Invoice_list_last.PRIMARY_DOCTOR_ID          AS PRIMARY_DOCTOR_ID_14,
       Invoice_list_last.PRIMARY_DOCTOR_NAME        AS PRIMARY_DOCTOR_NAME_13,
       Invoice_list_last.REFUND_INVOCE_NO           AS REFUND_INVOCE_NO_12,
       Invoice_list_last.REFUND_DATE                AS REFUND_DATE_11,
       Invoice_list_last.REFUND_AMOUNT              AS REFUND_AMOUNT_10,
       Invoice_list_last.QUANTITY                   AS QUANTITY_9,
       Invoice_list_last.ORDER_ID                   AS ORDER_ID_8,
       Invoice_list_last.APPROVAL_NUMBER            AS APPROVAL_NUMBER_7,
       Invoice_list_last.INVOICE_STATUS             AS INVOICE_STATUS_6,
       Invoice_list_last.TAXAMOUNT                  AS TAXAMOUNT_5,
       Invoice_list_last.PATIENTTAXAMOUNT           AS PATIENTTAXAMOUNT_4,
       Invoice_list_last.COMPANYTAXAMOUNT           AS COMPANYTAXAMOUNT_3,
       Invoice_list_last.NATIONALITY                AS NATIONALITY_2,
       Invoice_list_last.PARENT_INVOICE_NO          AS PARENT_INVOICE_NO_1,
       Invoice_list_last.CASH_REVENUE_INCLUSIVE_TAX AS CASH_REVENUE_INCLUSIVE_TAX_0
FROM (SELECT bit.created_date                                                                          as OrderInvoiceDate,
             bit.created_by                                                                            as CreatedBy,
             INV.CREATED_DATE                                                                          AS FINALIZE_INVOIE_DATE,
             NVL(inv.invoice_status, CASE
                                         WHEN BIT.IS_ACTIVE = 1 THEN 'ACTIVE'
                                         else ' ' end)                                                 AS invoice_status,
             bit.approval_number,
             bit.order_id,
             bit.quantity,
             bit.clinic_id,
             bit.clinic_name,
             rd.EMPLOYEE_CODE                                                                          as doctor_id,
             rd.EMPLOYEE_ALIAS                                                                         as doctor_name,
             rd.EMPLOYEE_CODE                                                                          AS PRIMARY_DOCTOR_ID,
             rd.EMPLOYEE_ALIAS                                                                         AS PRIMARY_DOCTOR_NAME,
             BIT.PRICE,
             bit.procedure_sub_group_id                                                                AS SubGroupId,
             nvl((select cv.NAME
                  from RM_MASTERDATA.RMMSD_CATEGORY_VALUE cv
                           left join RM_MASTERDATA.RMMSD_CATEGORY c on c.ID = cv.CATEGORY_ID
                           left join RM_MASTERDATA.RMMSD_MODULE m on m.ID = c.MODULE_ID
                  where lower(m.MODULE_NAME) like 'procedure'
                    and lower(c.CATEGORY_NAME) like 'subgroup'
                    and cv.ID = bit.PROCEDURE_SUB_GROUP_ID),
                 (SELECT DISTINCT upper(mpt.description) as uomVal
                  FROM PH_PHARMACY.phbas_mas_params mp
                           INNER JOIN PH_PHARMACY.phbas_mas_params_trans mpt
                                      ON mp.parameter_master_id = mpt.parameter_master_id and mpt.culture_code = 'en'
                  where mp.parameter_code = bit.PROCEDURE_SUB_GROUP_ID))                               as SubGroupDescription,
             bit.category_id                                                                           AS SubCategoryId,
             0                                                                                         AS CompanyPaid,
             0                                                                                         AS CompanyCleared,
             0                                                                                         AS PatientCleared,
             (select max(r.INVOICE_NO)
              from BL_INVOICE.BLINV_ACCEPTED_INVOICE r
              where r.parent_invoice_no = BIT.invoice_id)                                              as refund_invoce_no,
             (select max(cast(r.created_date as VARCHAR(30)))
              from BL_INVOICE.BLINV_ACCEPTED_INVOICE r
              where r.parent_invoice_no = BIT.invoice_id)                                              as refund_DATE,
             CASE WHEN bit.IS_REFUNDED = 1 THEN bit.patient_share_with_tax ELSE 0 END                  AS REFUND_AMOUNT,
             ACP.admission_id                                                                          as admission_NO,
             0                                                                                            APPOINTMENT_ID,
             (SELECT NATIONALITY
              FROM RM_MASTERDATA.RMMSD_COUNTRY
              WHERE ISO_COUNTRY_CODE_ALPHA2 = UPPER(empi.NATIONALITY))                                 AS NATIONALITY,
             CASE
                 WHEN bit.INVOICE_TYPE = 'PACKAGE' THEN 'TRUE'
                 ELSE 'FALSE' END                                                                      AS Is_Package_Invoice,
             bit.created_date,
             CASE
                 WHEN BIT.CREDIT_AMOUNT !=0 THEN ROUND(bit.PATIENT_SHARE_AMOUNT, 2) - ROUND(BIT.CREDIT_AMOUNT, 2)
                 WHEN inv.settlement_type = 'REFUND' THEN 0
                 ELSE ROUND(bit.PATIENT_SHARE_AMOUNT, 2)
                 END                                                                                   AS PatientShare,
             CASE
                 WHEN (ROUND(BIT.CREDIT_AMOUNT, 2) + ROUND(CREDIT_TAX_AMOUNT, 2)) !=0 THEN (
                     ROUND(bit.PATIENT_SHARE_WITH_TAX, 2) - (ROUND(BIT.CREDIT_AMOUNT, 2) + ROUND(CREDIT_TAX_AMOUNT, 2)))
                 WHEN inv.settlement_type = 'REFUND' THEN 0
                 ELSE ROUND(bit.PATIENT_SHARE_WITH_TAX, 2) END                                         AS cash_revenue_inclusive_tax,
             bit.patient_paid_share,
             bit.user_id,
             bit.user_name,
             ACP.is_deleted,
             bit.is_refunded,
             bit.TRANSACTION_TYPE,
             bit.hospital                                                                              as hospital_id,
             bit.order_Type,
             'REGULAR'                                                                                 AS INVOICE_TYPE,
             bia.nic_number                                                                            as ID_NUMBER,
             bit.PATIENT_ID,
             bia.patient_name                                                                          AS patient_name,
             BIT.INVOICE_NUMBER                                                                        AS INVOICE_NUMBER,
             INV.INVOICE_NO                                                                            AS PARENT_INVOICE_NO,
             bit.PATIENT_TYPE,
             CASE
                 WHEN bit.PATIENT_TYPE != 'OPD' THEN bia.DISCHARGED_DATE
                 ELSE NULL
                 END                                                                                   AS discharge_date,
             CASE
                 WHEN bit.PATIENT_TYPE != 'OPD' THEN bit.INVOICE_DATE
                 ELSE NULL
                 END                                                                                   AS final_invoice_date,
             bit.PROCEDURE_CODE                                                                        AS ProcedureId,
             bit.PROCEDURE_NAME,
             bit.TAX_TYPE                                                                              AS tax_type_dec,
             CASE
                 WHEN bit.TAX_TYPE = 'TAXABLE' THEN '51000001'
                 WHEN bit.TAX_TYPE = 'ZERO RATED' THEN '51000002'
                 WHEN bit.TAX_TYPE = 'EXEMPTED PARTIAL' THEN '51000003'
                 WHEN bit.TAX_TYPE = 'EXEMPTED FULL' THEN '51000004'
                 ELSE '00000000'
                 END                                                                                   AS tax_type,
             case WHEN inv.settlement_type = 'REFUND' THEN 0 else bit.GROSS_AMOUNT end                 as gross_amount,
             case
                 WHEN inv.settlement_type = 'REFUND' THEN 0
                 else bit.DISCOUNT_AMOUNT end                                                          as discount_amount,
             case
                 WHEN inv.settlement_type = 'REFUND' THEN 0
                 else COALESCE(bit.GROSS_AMOUNT - bit.DISCOUNT_AMOUNT, 0) end                          AS net_revenu_amount,
             case
                 WHEN inv.settlement_type = 'REFUND' THEN 0
                 else COALESCE(bit.CREDIT_AMOUNT, 0) end                                               AS patient_credit,
             case WHEN inv.settlement_type = 'REFUND' THEN 0 else bit.COMPANY_SHARE_AMOUNT end         AS CompanyShare,
             bit.TAX_PERCENTAGE,
             case
                 WHEN inv.settlement_type = 'REFUND' THEN 0
                 else bit.credit_tax_amount end                                                        AS patient_credit_tax,
             case
                 WHEN inv.settlement_type = 'REFUND' THEN 0
                 else ((bit.PATIENT_SHARE_WITH_TAX - bit.PATIENT_SHARE_AMOUNT) +
                       (bit.COMPANY_SHARE_WITH_TAX - bit.COMPANY_SHARE_AMOUNT)) end                    AS TaxAmount,
             case
                 WHEN inv.settlement_type = 'REFUND' THEN 0
                 else (bit.PATIENT_SHARE_WITH_TAX - bit.PATIENT_SHARE_AMOUNT) end                      AS PatientTaxAmount,
             case
                 WHEN inv.settlement_type = 'REFUND' THEN 0
                 else (bit.COMPANY_SHARE_WITH_TAX - bit.COMPANY_SHARE_AMOUNT) end                      AS CompanyTaxAmount,
             case WHEN inv.settlement_type = 'REFUND' THEN 0 else bit.COMPANY_SHARE_WITH_TAX end       AS CompanyCredit,
             case
                 WHEN inv.settlement_type = 'REFUND' THEN 0
                 else COALESCE((bit.CREDIT_AMOUNT + bit.credit_tax_amount), 0) end                     AS patient_credit_inclusive_tax,
             case
                 WHEN inv.settlement_type = 'REFUND' THEN 0
                 else (bit.NET_AMOUNT + ((bit.PATIENT_SHARE_WITH_TAX - bit.PATIENT_SHARE_AMOUNT) +
                                         (bit.COMPANY_SHARE_WITH_TAX - bit.COMPANY_SHARE_AMOUNT))) end AS total_revenue_inclusive_tax,
             INV.PAYER_contract_ID                                                                     AS company_id,
             INV.PAYER_contract_NAME                                                                   AS COMPANY_NAME,
             bit.COMPANY_ID                                                                            AS payer_group_id,
             bit.COMPANY_NAME                                                                          AS payer_group_name
-- pay.sub_payment_mode as payment_mode
      FROM "BL_INVOICE".BLINV_IP_INVOICE_TRANSACTIONS bit
LEFT JOIN BL_INVOICE.BLINV_ACCEPTED_INVOICE ACP
      ON ACP.ID = bit.invoice_id
          LEFT OUTER JOIN "BL_INVOICE".BLINV_INVOICE_ADMISSION bia ON bia.id = bit.REFERENCE_ID
          LEFT JOIN BL_INVOICE.BLINV_INVOICE INV ON inv.visit_id = bit.REFERENCE_ID
          LEFT OUTER JOIN "RF_EMPI".EMRED_PATIENTS empi ON bit.PATIENT_ID = empi.UPI
          LEFT JOIN RM_RESOURCEREG.RMRRG_EMPLOYEE rd ON rd.EMPLOYEE_ID = bia.DOCTOR_ID
      -- LEFT JOIN RM_RESOURCEREG.RMRRG_EMPLOYEE rd ON rd.EMPLOYEE_ID = bia.DOCTOR_ID
-- left join BL_INVOICE.BLINV_IP_PAYMENT_TRANSACTIONS pay on pay.transaction_id=bit.id
      WHERE bit.TRANSACTION_TYPE = 'INVOICE'
      UNION ALL
      SELECT
          bit.created_date as OrderInvoiceDate, bit.created_by as CreatedBy, BI.CREATED_DATE AS FINALIZE_INVOIE_DATE, NVL(bi.invoice_status, CASE WHEN bit.IS_ACTIVE =1 THEN 'ACTIVE' else ' ' end ) AS invoice_status, bit.approval_number, bit.order_id, bit.quantity, bit.clinic_id, bit.clinic_name, rd.EMPLOYEE_CODE as doctor_id, rd.EMPLOYEE_ALIAS as doctor_name, rd.EMPLOYEE_CODE AS PRIMARY_DOCTOR_ID, rd.EMPLOYEE_ALIAS AS PRIMARY_DOCTOR_NAME, BIT.PRICE, bit.procedure_sub_group_id AS SubGroupId, nvl( (select cv.NAME
          from RM_MASTERDATA.RMMSD_CATEGORY_VALUE cv
          left join RM_MASTERDATA.RMMSD_CATEGORY c on c.ID = cv.CATEGORY_ID
          left join RM_MASTERDATA.RMMSD_MODULE m on m.ID = c.MODULE_ID
          where lower (m.MODULE_NAME) like 'procedure'
          and lower (c.CATEGORY_NAME) like 'subgroup' and cv.ID = bit.PROCEDURE_SUB_GROUP_ID), ( SELECT DISTINCT upper (mpt.description) as uomVal
          FROM PH_PHARMACY.phbas_mas_params mp
          INNER JOIN PH_PHARMACY.phbas_mas_params_trans mpt ON mp.parameter_master_id = mpt.parameter_master_id and mpt.culture_code = 'en'
          where mp.parameter_code = bit.PROCEDURE_SUB_GROUP_ID )) as SubGroupDescription, bit.category_id AS SubCategoryId, 0 AS CompanyPaid, 0 AS CompanyCleared, 0 AS PatientCleared, case when IS_REFUNDED = 1 then (SELECT MAX (I.INVOICE_NO)
          from BL_INVOICE.blinv_invoice i WHERE I.PARENT_ID = bit.invoice_id) else ' ' end AS refund_invoce_no, case when IS_REFUNDED = 1 then (SELECT MAX (cast (i.created_date as VARCHAR (30)))
          from BL_INVOICE.blinv_invoice i WHERE I.PARENT_ID = bit.invoice_id) else ' ' end AS refund_DATE, CASE WHEN IS_REFUNDED = 1 THEN refundable_patient_share ELSE 0 END AS REFUND_AMOUNT, 0 as admission_NO, BIT.reference_id as appointment_no, ( SELECT NATIONALITY
          FROM RM_MASTERDATA.RMMSD_COUNTRY
          WHERE ISO_COUNTRY_CODE_ALPHA2 = UPPER (empi.NATIONALITY)
          ) AS NATIONALITY, CASE WHEN bit.INVOICE_TYPE = 'PACKAGE' THEN 'TRUE'
          ELSE 'FALSE' END AS Is_Package_Invoice, bit.created_date, CASE WHEN BIT.CREDIT_AMOUNT !=0 THEN ROUND(bit.PATIENT_SHARE_AMOUNT, 2) - ROUND(BIT.CREDIT_AMOUNT, 2) ELSE ROUND(bit.PATIENT_SHARE_AMOUNT, 2)
          END AS PatientShare, CASE WHEN (ROUND(BIT.CREDIT_AMOUNT, 2) + ROUND(CREDIT_TAX_AMOUNT, 2)) !=0 THEN (ROUND(bit.PATIENT_SHARE_WITH_TAX, 2 )- (ROUND(BIT.CREDIT_AMOUNT, 2) + ROUND(CREDIT_TAX_AMOUNT, 2)))
          ELSE ROUND(bit.PATIENT_SHARE_WITH_TAX, 2) END AS cash_revenue_inclusive_tax, bit.patient_paid_share, bit.user_id, bit.user_name, BIT.is_deleted, bit.is_refunded, bit.TRANSACTION_TYPE, bit.hospital as hospital_id, bit.order_Type, CASE WHEN bit.order_Type = 'MEDICATION' THEN 'PHARMACY' ELSE 'REGULAR' END AS INVOICE_TYPE, bit.id_number as ID_NUMBER, bit.PATIENT_ID, bit.FIRST_NAME || ' ' || bit.MIDDLE_NAME || ' ' || bit.LAST_NAME AS patient_name, case when bit.TRANSACTION_TYPE = 'INVOICE' THEN bit.INVOICE_NUMBER
          ELSE BIT.REFUND_INVOICE_NUMBER END AS INVOICE_NUMBER, bit.INVOICE_NUMBER AS PARENT_INVOICE_NO, bit.PATIENT_TYPE, null as discharge_date, null as final_invoice_date, bit.PROCEDURE_CODE AS ProcedureId, bit.PROCEDURE_NAME, bit.TAX_TYPE AS tax_type_dec, CASE
          WHEN bit.TAX_TYPE = 'TAXABLE' THEN '51000001'
          WHEN bit.TAX_TYPE = 'ZERO RATED' THEN '51000002'
          WHEN bit.TAX_TYPE = 'EXEMPTED PARTIAL' THEN '51000003'
          WHEN bit.TAX_TYPE = 'EXEMPTED FULL' THEN '51000004'
          ELSE '00000000'
          END AS tax_type, bit.GROSS_AMOUNT, bit.DISCOUNT_AMOUNT, COALESCE (bit.GROSS_AMOUNT - bit.DISCOUNT_AMOUNT, 0) AS net_revenu_amount, COALESCE (bit.CREDIT_AMOUNT, 0) AS patient_credit, bit.COMPANY_SHARE_AMOUNT AS CompanyShare, bit.TAX_PERCENTAGE, bit.credit_tax_amount AS patient_credit_tax, ((bit.PATIENT_SHARE_WITH_TAX - bit.PATIENT_SHARE_AMOUNT) + (bit.COMPANY_SHARE_WITH_TAX - bit.COMPANY_SHARE_AMOUNT)) AS TaxAmount, (bit.PATIENT_SHARE_WITH_TAX - bit.PATIENT_SHARE_AMOUNT) AS PatientTaxAmount, (bit.COMPANY_SHARE_WITH_TAX - bit.COMPANY_SHARE_AMOUNT) AS CompanyTaxAmount, bit.COMPANY_SHARE_WITH_TAX AS CompanyCredit, COALESCE ((bit.CREDIT_AMOUNT + bit.credit_tax_amount), 0) AS patient_credit_inclusive_tax, (bit.NET_AMOUNT + ((bit.PATIENT_SHARE_WITH_TAX - bit.PATIENT_SHARE_AMOUNT) + (bit.COMPANY_SHARE_WITH_TAX - bit.COMPANY_SHARE_AMOUNT))) AS total_revenue_inclusive_tax, bi.PAYER_CONTRACT_ID AS company_id, bi.PAYER_CONTRACT_NAME AS COMPANY_NAME, bit.COMPANY_ID AS payer_group_id, bit.COMPANY_NAME AS payer_group_name
--pay.sub_payment_mode as payment_mode
      FROM "BL_INVOICE".BLINV_INVOICE_TRANSACTIONS bit
          INNER JOIN "BL_INVOICE".BLINV_INVOICE bi
      ON bi.id = bit.INVOICE_ID
          LEFT OUTER JOIN "RF_EMPI".EMRED_PATIENTS empi ON bit.PATIENT_ID = empi.UPI
          LEFT JOIN RM_RESOURCEREG.RMRRG_EMPLOYEE rd ON rd.EMPLOYEE_ID = bi.DOCTOR_ID
-- left join BL_INVOICE.BLINV_PAYMENT_TRANSACTIONS pay on pay.transaction_id = bit.id
      WHERE bit.TRANSACTION_TYPE = 'INVOICE'
        AND ( bIT.PATIENT_TYPE ='OPD')
        and ( ORDER_TYPE = 'PROCEDURE'
         OR (ORDER_TYPE = 'MEDICATION'
        AND bi.LOCATION_TYPE = 'BILLING'))
      UNION ALL


      SELECT
          bit.created_date as OrderInvoiceDate, bit.created_by as CreatedBy, INV.CREATED_DATE AS FINALIZE_INVOIE_DATE, NVL(inv.invoice_status, CASE WHEN BIT.IS_ACTIVE =1 THEN 'ACTIVE' else ' ' end ) AS invoice_status, bit.approval_number, bit.order_id, bit.quantity, bit.clinic_id, bit.clinic_name, rd.EMPLOYEE_CODE as doctor_id, rd.EMPLOYEE_ALIAS as doctor_name, rd.EMPLOYEE_CODE AS PRIMARY_DOCTOR_ID, rd.EMPLOYEE_ALIAS AS PRIMARY_DOCTOR_NAME, BIT.PRICE, bit.procedure_sub_group_id AS SubGroupId, (select cv.NAME
          from RM_MASTERDATA.RMMSD_CATEGORY_VALUE cv
          left join RM_MASTERDATA.RMMSD_CATEGORY c on c.ID = cv.CATEGORY_ID
          left join RM_MASTERDATA.RMMSD_MODULE m on m.ID = c.MODULE_ID
          where lower (m.MODULE_NAME) like 'procedure'
          and lower (c.CATEGORY_NAME) like 'subgroup' and cv.ID = bit.PROCEDURE_SUB_GROUP_ID) as SubGroupDescription, bit.category_id AS SubCategoryId, 0 AS CompanyPaid, 0 AS CompanyCleared, 0 AS PatientCleared, (select max (r.INVOICE_NO)
          from BL_INVOICE.BLINV_ACCEPTED_INVOICE r where r.parent_invoice_no = BIT.invoice_id ) as refund_invoce_no, (select max (cast (r.created_date as VARCHAR (30)))
          from BL_INVOICE.BLINV_ACCEPTED_INVOICE r where r.parent_invoice_no = BIT.invoice_id ) as refund_DATE, CASE WHEN bit.IS_REFUNDED = 1 THEN bit.patient_share_with_tax ELSE 0 END AS REFUND_AMOUNT, CASE WHEN INV.PATIENT_TYPE = 'ER' THEN inv.reference_id ELSE 0 END AS admission_NO, CASE WHEN INV.PATIENT_TYPE = 'OPD' THEN inv.reference_id ELSE 0 END AS APPOINTMENT_ID, ( SELECT NATIONALITY
          FROM RM_MASTERDATA.RMMSD_COUNTRY
          WHERE ISO_COUNTRY_CODE_ALPHA2 = UPPER (empi.NATIONALITY)
          ) AS NATIONALITY, 'FALSE' Is_Package_Invoice, bit.created_date, CASE WHEN BIT.CREDIT_AMOUNT !=0 THEN ROUND(bit.PATIENT_SHARE_AMOUNT, 2) - ROUND(BIT.CREDIT_AMOUNT, 2) ELSE ROUND(bit.PATIENT_SHARE_AMOUNT, 2)
          END AS PatientShare, CASE WHEN (ROUND(BIT.CREDIT_AMOUNT, 2) + ROUND(CREDIT_TAX_AMOUNT, 2)) !=0 THEN (ROUND(bit.PATIENT_SHARE_WITH_TAX, 2 )- (ROUND(BIT.CREDIT_AMOUNT, 2) + ROUND(CREDIT_TAX_AMOUNT, 2)))
          ELSE ROUND(bit.PATIENT_SHARE_WITH_TAX, 2) END AS cash_revenue_inclusive_tax, bit.patient_paid_share, bit.user_id, bit.user_name, CHL.is_deleted, bit.is_refunded, bit.TRANSACTION_TYPE, bit.hospital as hospital_id, bit.order_Type, 'CHILD' AS INVOICE_TYPE, bit.id_number as ID_NUMBER, bit.PATIENT_ID, UPPER (EMPI.first_name ||' '|| EMPI.last_name) AS PATIENT_NAME,
--nvl(CHLp.patient_share_amount,0) AS patient_SHARE,
          chl.invoice_no AS INVOICE_NUMBER, chl.PARENT_INVOICE_NO AS PARENT_INVOICE_NO, bit.PATIENT_TYPE, NULL discharge_date, CASE
          WHEN bit.PATIENT_TYPE != 'OPD' THEN bit.INVOICE_DATE
          ELSE NULL
          END AS final_invoice_date, CHLP.procedure_code AS ProcedureId, CHLP.procedure_name, bit.TAX_TYPE AS tax_type_dec, CASE
          WHEN bit.TAX_TYPE = 'TAXABLE' THEN '51000001'
          WHEN bit.TAX_TYPE = 'ZERO RATED' THEN '51000002'
          WHEN bit.TAX_TYPE = 'EXEMPTED PARTIAL' THEN '51000003'
          WHEN bit.TAX_TYPE = 'EXEMPTED FULL' THEN '51000004'
          ELSE '00000000'
          END AS tax_type, CHLp.GROSS_AMOUNT, nvl(CHLp.discount_amount, 0) DISCOUNT_AMOUNT, COALESCE (CHLp.GROSS_AMOUNT - CHLp.DISCOUNT_AMOUNT, 0) AS net_revenu_amount, 0 AS patient_credit, CHLp.COMPANY_SHARE_AMOUNT AS CompanyShare, bit.TAX_PERCENTAGE, bit.credit_tax_amount AS patient_credit_tax, ((CHLp.PATIENT_SHARE_WITH_TAX - CHLp.PATIENT_SHARE_AMOUNT) + (CHLp.COMPANY_SHARE_WITH_TAX - CHLp.COMPANY_SHARE_AMOUNT)) AS TaxAmount, (CHLp.PATIENT_SHARE_WITH_TAX - CHLp.PATIENT_SHARE_AMOUNT) AS PatientTaxAmount, (CHLp.COMPANY_SHARE_WITH_TAX - CHLp.COMPANY_SHARE_AMOUNT) AS CompanyTaxAmount, CHLp.COMPANY_SHARE_WITH_TAX AS CompanyCredit, 0 AS patient_credit_inclusive_tax, (CHLp.NET_AMOUNT + ((CHLp.PATIENT_SHARE_WITH_TAX - CHLp.PATIENT_SHARE_AMOUNT) + (CHLp.COMPANY_SHARE_WITH_TAX - CHLp.COMPANY_SHARE_AMOUNT))) AS total_revenue_inclusive_tax, INV.PAYER_contract_ID AS company_id, INV.PAYER_contract_NAME AS COMPANY_NAME, bit.COMPANY_ID AS payer_group_id, bit.COMPANY_NAME AS payer_group_name
--pay.sub_payment_mode as payment_mode
      from BL_INVOICE.BLINV_CHILD_INVOICE CHL
          LEFT JOIN BL_INVOICE.BLINV_CHILD_PROCEDURE CHLP
      ON CHLP.CHILD_INVOICE_ID = CHL.ID
          LEFT JOIN BL_INVOICE.blinv_invoice_transactions BIT ON BIT.INVOICE_ID = chl.parent_invoice_id
-- left join BL_INVOICE.BLINV_PAYMENT_TRANSACTIONS pay on pay.transaction_id = bit.id
          LEFT JOIN BL_INVOICE.BLINV_INVOICE INV ON inv.id = bit.invoice_id
          LEFT JOIN RM_RESOURCEREG.RMRRG_EMPLOYEE rd ON rd.EMPLOYEE_ID = INV.DOCTOR_ID
          LEFT OUTER JOIN "RF_EMPI".EMRED_PATIENTS empi ON bit.PATIENT_ID = empi.UPI
      union ALL


      SELECT
          bi.created_date as OrderInvoiceDate, bi.created_by as CreatedBy, null AS FINALIZE_INVOIE_DATE, CASE WHEN bip.is_deleted =1 THEN 'CANCELLED'
          WHEN bi.TRANSACTION_TYPE = 'REFUND' THEN 'REFUNDED' ELSE 'INVOICED' END AS invoice_status, '' AS approval_number, 0 AS order_id, 0 AS quantity, bip.CLINIC_ID, bip.CLINIC AS clinic_name, rd.EMPLOYEE_CODE as doctor_id, rd.EMPLOYEE_ALIAS as doctor_name, rd.EMPLOYEE_CODE AS PRIMARY_DOCTOR_ID, rd.EMPLOYEE_ALIAS AS PRIMARY_DOCTOR_NAME, bip.PRICE, bip.SUB_GROUP_ID AS SubGroupId, nvl( (select cv.NAME
          from RM_MASTERDATA.RMMSD_CATEGORY_VALUE cv
          left join RM_MASTERDATA.RMMSD_CATEGORY c on c.ID = cv.CATEGORY_ID
          left join RM_MASTERDATA.RMMSD_MODULE m on m.ID = c.MODULE_ID
          where lower (m.MODULE_NAME) like 'procedure'
          and lower (c.CATEGORY_NAME) like 'subgroup' and cv.ID = bip.GROUP_ID), ( SELECT DISTINCT upper (mpt.description) as uomVal
          FROM PH_PHARMACY.phbas_mas_params mp
          INNER JOIN PH_PHARMACY.phbas_mas_params_trans mpt ON mp.parameter_master_id = mpt.parameter_master_id and mpt.culture_code = 'en'
          where mp.parameter_code = bip.GROUP_ID )) as SubGroupDescription, bip.GROUP_ID AS SubCategoryId, 0 AS CompanyPaid, 0 AS CompanyCleared, 0 AS PatientCleared, null as refund_invoce_no, null as refund_DATE, 0 AS REFUND_AMOUNT, 0 as admission_NO, 0 APPOINTMENT_ID, ( SELECT NATIONALITY
          FROM RM_MASTERDATA.RMMSD_COUNTRY
          WHERE ISO_COUNTRY_CODE_ALPHA2 = UPPER (ep.NATIONALITY)
          ) AS NATIONALITY, 'FALSE' AS Is_Package_Invoice, bi.created_date, ROUND(bip.PATIENT_SHARE_AMOUNT, 2) AS PatientShare, ROUND(bip.PATIENT_SHARE_WITH_TAX, 2) AS cash_revenue_inclusive_tax, bip.PATIENT_SHARE_AMOUNT as patient_paid_share, bip.user_id, bip.user_name, bip.is_deleted, 0 AS is_refunded, bi.TRANSACTION_TYPE, bi.hospital as hospital_id, bi.INVOICE_Type AS order_Type, 'REGULAR' AS INVOICE_TYPE, ep.id_number as ID_NUMBER, bi.PATIENT_ID, EP.FIRST_NAME || ' ' || EP.MIDDLE_NAME || ' ' || EP.LAST_NAME AS patient_name, bi.INVOICE_NO AS INVOICE_NUMBER, bi.INVOICE_NO AS PARENT_INVOICE_NO, bi.PATIENT_TYPE, NULL AS discharge_date, null AS final_invoice_date, bip.PROCEDURE_CODE AS ProcedureId, bip.PROCEDURE_NAME AS PROCEDURE_NAME, bip.TAX_TYPE AS tax_type_dec, CASE
          WHEN bip.TAX_TYPE = 'TAXABLE' THEN '51000001'
          WHEN bip.TAX_TYPE = 'ZERO RATED' THEN '51000002'
          WHEN bip.TAX_TYPE = 'EXEMPTED PARTIAL' THEN '51000003'
          WHEN bip.TAX_TYPE = 'EXEMPTED FULL' THEN '51000004'
          ELSE '00000000'
          END AS tax_type, ROUND(bip.GROSS_AMOUNT, 2) AS GROSS_AMOUNT, ROUND(bip.DISCOUNT_AMOUNT, 2) AS DISCOUNT_AMOUNT, COALESCE (ROUND(bip.GROSS_AMOUNT, 2) - ROUND(bip.DISCOUNT_AMOUNT, 2), 0) AS net_revenu_amount, ROUND(COALESCE (0, 0), 2) AS patient_credit, ROUND(bip.COMPANY_SHARE_AMOUNT, 2) AS CompanyShare, 0 AS TAX_PERCENTAGE, ROUND((0), 2) AS patient_credit_tax, ((bi.PATIENT_SHARE_WITH_TAX - bi.PATIENT_SHARE_AMOUNT) + (bi.COMPANY_SHARE_WITH_TAX - bi.COMPANY_SHARE_AMOUNT)) AS TaxAmount, (bi.PATIENT_SHARE_WITH_TAX - bi.PATIENT_SHARE_AMOUNT) AS PatientTaxAmount, (bi.COMPANY_SHARE_WITH_TAX - bi.COMPANY_SHARE_AMOUNT) AS CompanyTaxAmount, bi.COMPANY_SHARE_WITH_TAX AS CompanyCredit, ROUND(COALESCE ((0 + 0), 0), 2) AS patient_credit_inclusive_tax, ROUND(
          CASE WHEN (ROUND(0, 2) + ROUND(0, 2)) !=0 THEN (ROUND(bip.PATIENT_SHARE_WITH_TAX, 2 )- (ROUND(0, 2) + ROUND(0, 2)))
          ELSE ROUND(bip.PATIENT_SHARE_WITH_TAX, 2) END + ROUND(bip.COMPANY_SHARE_WITH_TAX, 2) +
          ROUND(COALESCE ((0 + 0), 0), 2), 2 ) AS total_revenue_inclusive_tax, bpc.ID AS company_id, bpc.CONTRACT_NAME AS COMPANY_NAME, TO_CHAR(BPG.ID) AS payer_group_id, BPG.GROUP_NAME AS payer_group_name
      FROM bl_invoice.blinv_invoice bi
-- left JOIN bl_invoice.BLINV_INTER_COMPANY_INVOICE_DETAIL bic ON bic.INVOICE = bi.ID
          LEFT JOIN (SELECT INVOICE_ID, procedure_id, IS_SOURCE, TRANSACTION_TYPE FROM bl_invoice.BLINV_INTER_COMPANY_TRANSACTIONS GROUP BY INVOICE_ID, procedure_id, IS_SOURCE, TRANSACTION_TYPE) bic
      ON bic.INVOICE_ID = bi.ID
          left JOIN BL_INVOICE.BLINV_INVOICE_PROCEDURE bip ON bic.procedure_id = bip.id
          -- left JOIN bl_invoice.BLINV_INTER_COMPANY_PROCEDURE_ORDER bicpo ON bip.id = bicpo.PROCEDURE_ID
-- left JOIN bl_billing.BLBIL_PAYER_CONTRACT_POLICIES bpcp ON bpcp.INTER_COMPANY_HOSPITAL = bicpo.HOSPITAL_ID
          left JOIN bl_billing.BLBIL_PAYER_CONTRACT bpc ON bpc.id = bip.PAYER_CONTRACT_ID
          left JOIN bl_billing.BLBIL_PAYER_GROUP bpg ON bpg.id = bpc.PAYER_GROUP_ID
          LEFT JOIN RF_EMPI.EMRED_PATIENTS ep ON ep.mrn = bi.PATIENT_ID
          LEFT JOIN RM_RESOURCEREG.RMRRG_EMPLOYEE rd ON rd.EMPLOYEE_ID = bi.DOCTOR_ID
      WHERE bi.IS_INTER_COMPANY_INVOICE = 1
        AND ((bic.IS_SOURCE = 0
        AND bic.TRANSACTION_TYPE = 1)
         OR (bic.IS_SOURCE = 1
        AND bic.TRANSACTION_TYPE IN (2
          , 3)))
        AND bi.SETTLEMENT_TYPE != 'REFUND') Invoice_list_last
WHERE (CAST(FROM_TZ(Invoice_list_last.CREATED_DATE, 'UTC') AT TIME ZONE 'Asia/Kuwait' AS TIMESTAMP) >=
       TO_TIMESTAMP('2024-09-01 00:00:00.000000000', 'YYYY-MM-DD HH24:MI:SS.FF') AND
       CAST(FROM_TZ(Invoice_list_last.CREATED_DATE, 'UTC') AT TIME ZONE 'Asia/Kuwait' AS TIMESTAMP) <=
       TO_TIMESTAMP('2024-09-28 23:59:59.999999999', 'YYYY-MM-DD HH24:MI:SS.FF'))
  AND (Invoice_list_last.HOSPITAL_ID IN (156))
