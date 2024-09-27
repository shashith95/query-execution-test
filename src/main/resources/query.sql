SELECT Appointments.patient_id               AS patient_id_35,
       Appointments.patient_full_name        AS patient_full_name_34,
       Appointments.age                      AS age_33,
       Appointments.patient_gender           AS patient_gender_32,
       Appointments.nationality              AS nationality_31,
       Appointments.clinic_id                AS clinic_id_30,
       Appointments.clinic_name              AS clinic_name_29,
       Appointments.doctor_id                AS doctor_id_28,
       Appointments.doctor_name              AS doctor_name_27,
       TO_CHAR(CAST(Appointments.appointment_date_time AT TIME ZONE 'UTC' AT TIME ZONE 'Asia/Kuwait' AS TIMESTAMP),
               'DD-MON-YYYY HH24:MI:SS')     AS appointment_date_time_26,
       Appointments.appointment_id           AS appointment_id_25,
       Appointments.appointment_status       AS appointment_status_24,
       Appointments.appointment_type         AS appointment_type_23,
       TO_CHAR(CAST(Appointments.start_date_time AT TIME ZONE 'UTC' AT TIME ZONE 'Asia/Kuwait' AS TIMESTAMP),
               'DD-MON-YYYY HH24:MI:SS')     AS start_date_time_22,
       TO_CHAR(CAST(Appointments.end_time AT TIME ZONE 'UTC' AT TIME ZONE 'Asia/Kuwait' AS TIMESTAMP),
               'DD-MON-YYYY HH24:MI:SS')     AS end_time_21,
       TO_CHAR(CAST(Appointments.complete_date_time AT TIME ZONE 'UTC' AT TIME ZONE 'Asia/Kuwait' AS TIMESTAMP),
               'DD-MON-YYYY HH24:MI:SS')     AS complete_date_time_20,
       Appointments.id_number                AS id_number_19,
       Appointments.id_type                  AS id_type_18,
       Appointments.mobile_number            AS mobile_number_17,
       Appointments.visit_type               AS visit_type_16,
       Appointments.arrived_by_id            AS arrived_by_id_15,
       Appointments.arrived_by_name          AS arrived_by_name_14,
       TO_CHAR(CAST(Appointments.arrived_on AT TIME ZONE 'UTC' AT TIME ZONE 'Asia/Kuwait' AS TIMESTAMP),
               'DD-MON-YYYY HH24:MI:SS')     AS arrived_on_13,
       Appointments.booked                   AS booked_12,
       Appointments.cancelled_by_id          AS cancelled_by_id_11,
       Appointments.cancelled_by_name        AS cancelled_by_name_10,
       TO_CHAR(CAST(Appointments.cancelled_on AT TIME ZONE 'UTC' AT TIME ZONE 'Asia/Kuwait' AS TIMESTAMP),
               'DD-MON-YYYY HH24:MI:SS')     AS cancelled_on_9,
       Appointments.cas_status               AS cas_status_8,
       Appointments.category                 AS category_7,
       Appointments.cencelled_status_remarks AS cencelled_status_remarks_6,
       Appointments.created_by_id            AS created_by_id_5,
       Appointments.created_by_name          AS created_by_name_4,
       TO_CHAR(CAST(Appointments.created_on AT TIME ZONE 'UTC' AT TIME ZONE 'Asia/Kuwait' AS TIMESTAMP),
               'DD-MON-YYYY HH24:MI:SS')     AS created_on_3,
       TO_CHAR(CAST(Appointments.reservation_created_on AT TIME ZONE 'UTC' AT TIME ZONE 'Asia/Kuwait' AS TIMESTAMP),
               'DD-MON-YYYY HH24:MI:SS')     AS reservation_created_on_2,
       TO_CHAR(CAST(Appointments.reservation_created_date AT TIME ZONE 'UTC' AT TIME ZONE 'Asia/Kuwait' AS TIMESTAMP),
               'DD-MON-YYYY HH24:MI:SS')     AS reservation_created_date_1,
       TO_CHAR(CAST(Appointments.reservation_modified_date AT TIME ZONE 'UTC' AT TIME ZONE 'Asia/Kuwait' AS TIMESTAMP),
               'DD-MON-YYYY HH24:MI:SS')     AS reservation_modified_date_0
FROM (select A.APPOINTMENT_ID                                           as Booked,
             HI.LINK                                                    AS HOSPITAL_ID,
             A.APPOINTMENT_ID,
             a.reference_no,
             a.referral_doctor,
             a.referral_facility,
             EXTRACT(YEAR FROM AGE(CURRENT_DATE, date_of_birth))        AS AGE,
             a.referral_remarks,
             A.CREATED_ON,
             A.APPOINTMENT_TYPE,
             A.IS_WAITING_LIST,
             A.VISIT_TYPE,
             r.created_by                                               as CREATED_BY_ID,
             (SELECT RMRRG_EMPLOYEE.employee_name || ' ' || RMRRG_EMPLOYEE.EMPLOYEE_alias
              FROM RM_RESOURCEREG.RMRRG_EMPLOYEE
              WHERE cast(R.created_by as VARCHAR(255)) =
                    cast(RMRRG_EMPLOYEE.employee_code as VARCHAR(255))) AS CREATED_BY_NAME,
             CASE
                 WHEN r.status = 'CNX' THEN 'Cancelled'
                 WHEN r.status = 'NEW' THEN 'New'
                 WHEN r.status = 'CNF' THEN 'Confirmed'
                 WHEN r.status = 'ARR' THEN 'Arrived'
                 WHEN r.status = 'RSH' THEN 'Rescheduled '
                 WHEN r.status = 'NSH' THEN 'No Show'
                 WHEN r.status = 'SEN' THEN 'Seen'
                 WHEN r.status = 'DCH' THEN 'Discharged'
                 WHEN r.status = 'BLK' THEN 'Block'
                 WHEN r.status = 'REQ' THEN 'Requested'
                 ELSE r.status END                                      AS appointment_status,
             r.status                                                   AS status_code,
             r.cas_status,
             r.category,
             r.context_id,
             r.context_status,
             r.context_type,
             r.is_over_book,
             r.old_appointment_id,
             r.over_book_count,
             r.over_bookable,
             r.parent_appointment_id,
             r.status                                                   AS reservation_status,
             r.remarks                                                  AS reservation_remarks,
             r.created_date                                             AS reservation_created_date,
             r.modified_date                                            AS reservation_modified_date,
             r.is_auto_invoiceable,
             r.created_on                                               AS reservation_created_on,
             r.start_time                                               AS start_date_time,
             r.end_time                                                 AS end_time,
             r.start_time                                               as appointment_date_time,
             pr.reservation_patient_id,
             CAST(pr.patient_id AS int)                                 AS patient_ID,
             pr.patient_type,
             pnt.ID_NUMBER,
             ins.payment_type                                           as payer_type,
             ins.payer_group_value                                      as insurance_details,
             case
                 when pnt.id_type = 'nid' then 'National Identity'
                 when pnt.id_type = 'UNKNOWN_BABY' then ' '
                 else pnt.id_type end                                   as ID_type,
             pnt.first_name || ' ' || pnt.last_name                     AS patient_full_name,
             pnt.date_of_birth                                          AS patient_date_of_birth,
             p.PAYMENT_TYPE                                             as PAYMENT_TYPE,
             CASE
                 WHEN pnt.gender = '1' THEN 'Male'
                 WHEN pnt.gender = 'Male' THEN 'Male'
                 WHEN pnt.gender = '2' THEN 'Female'
                 WHEN pnt.gender = 'Female' THEN 'Female'
                 ELSE 'Other'
                 END                                                    AS patient_gender,
             con.mobile_number                                          as mobile_number,
             (SELECT NATIONALITY
              FROM RM_MASTERDATA.RMMSD_COUNTRY
              WHERE ISO_COUNTRY_CODE_ALPHA2 = UPPER(pnt.NATIONALITY))   AS NATIONALITY,
             rrs.resource_id                                            as DOCTOR_ID,
             (SELECT RMRRG_EMPLOYEE.employee_name || ' ' || RMRRG_EMPLOYEE.EMPLOYEE_THIRD_NAME
              FROM RM_RESOURCEREG.RMRRG_EMPLOYEE
              WHERE cast(rrs.resource_id as VARCHAR(255)) =
                    cast(RMRRG_EMPLOYEE.employee_ID as VARCHAR(255)))   AS DOCTOR_NAME,
             (select cli.id
              from RM_MASTERDATA.rmmsd_clinic cli
                       LEFT JOIN RM_RESERVATION.rmrms_reservation_criterion RC on rc.criterion_id = cli.id
              where criterion_type = 'CLINIC'
                and cli.is_active = true
                and r.reservation_id = rc.reservation_id)               as clinic_id,
             (select cli.clinic_description
              from RM_MASTERDATA.rmmsd_clinic cli
                       LEFT JOIN RM_RESERVATION.rmrms_reservation_criterion RC on rc.criterion_id = cli.id
              where criterion_type = 'CLINIC'
                and cli.is_active = true
                and r.reservation_id = rc.reservation_id)               as clinic_name,
             (select max(insu.payer_group)
              from RF_EMPI.patient_insurance insu
              where pr.patient_id = insu.upi)                           as Patient_Category,
             (SELECT max(T.TIME)
              FROM RM_RESERVATION.RMRMS_RESERVATION_STATE_TRANS T
              WHERE a.reservation_id = t.reservation_id
                and r.reservation_id = t.reservation_id
                AND T.STATE = 'ARR')                                    AS arrived_on,
             (select T.LOGIN_USER_ID
              FROM RM_RESERVATION.RMRMS_RESERVATION_STATE_TRANS t
              where a.reservation_id = t.reservation_id
                and T.STATE = 'ARR'
              order by created_on desc fetch first 1 row only)          as arrived_BY_ID,
             (SELECT RMRRG_EMPLOYEE.employee_name || ' ' || RMRRG_EMPLOYEE.EMPLOYEE_THIRD_NAME
              FROM RM_RESOURCEREG.RMRRG_EMPLOYEE
                       INNER JOIN RM_RESERVATION.RMRMS_RESERVATION_STATE_TRANS T
                                  ON RMRRG_EMPLOYEE.EMPLOYEE_id = cast(T.LOGIN_USER_ID as int)
              WHERE a.reservation_id = t.reservation_id
                AND T.STATE = 'ARR'
              order by created_on desc fetch first 1 row only)          AS arrived_BY_NAME,
             (SELECT max(T.TIME)
              FROM RM_RESERVATION.RMRMS_RESERVATION_STATE_TRANS T
              WHERE a.reservation_id = t.reservation_id
                and r.reservation_id = t.reservation_id
                AND T.STATE = 'CNX')                                    AS CANCELLED_on,
             (select T.LOGIN_USER_ID
              FROM RM_RESERVATION.RMRMS_RESERVATION_STATE_TRANS t
              where a.reservation_id = t.reservation_id
                and T.STATE = 'CNX'
              order by created_on desc fetch first 1 row only)          as CANCELLED_BY_ID,
             (SELECT RMRRG_EMPLOYEE.employee_name || ' ' || RMRRG_EMPLOYEE.EMPLOYEE_THIRD_NAME
              FROM RM_RESOURCEREG.RMRRG_EMPLOYEE
                       INNER JOIN RM_RESERVATION.RMRMS_RESERVATION_STATE_TRANS T
                                  ON RMRRG_EMPLOYEE.EMPLOYEE_id = cast(T.LOGIN_USER_ID as int)
              WHERE a.reservation_id = t.reservation_id
                AND T.STATE = 'CNX'
              order by created_on desc fetch first 1 row only)          AS CANCELLED_BY_NAME,
             (SELECT T.STATUS_REMARK
              FROM RM_RESERVATION.RMRMS_RESERVATION_STATE_TRANS T
              WHERE a.reservation_id = t.reservation_id
                AND T.STATE = 'CNX'
              order by created_on desc fetch first 1 row only)          AS cencelled_status_remarks,
             (SELECT max(T.TIME)
              FROM RM_RESERVATION.RMRMS_RESERVATION_STATE_TRANS T
              WHERE a.reservation_id = t.reservation_id
                and r.reservation_id = t.reservation_id
                AND T.STATE = 'SEN')                                    AS seen_on,
             (SELECT max(T.TIME)
              FROM RM_RESERVATION.RMRMS_RESERVATION_STATE_TRANS T
              WHERE a.reservation_id = t.reservation_id
                and r.reservation_id = t.reservation_id
                AND T.STATE = 'CNF')                                    AS CONFIRMED_on,
             (select T.LOGIN_USER_ID
              FROM RM_RESERVATION.RMRMS_RESERVATION_STATE_TRANS t
              where a.reservation_id = t.reservation_id
                and T.STATE = 'CNF'
              order by created_on desc fetch first 1 row only)          as CONFIREMED_BY_ID,
             (SELECT RMRRG_EMPLOYEE.employee_name || ' ' || RMRRG_EMPLOYEE.EMPLOYEE_alias
              FROM RM_RESOURCEREG.RMRRG_EMPLOYEE
                       INNER JOIN RM_RESERVATION.RMRMS_RESERVATION_STATE_TRANS T
                                  ON RMRRG_EMPLOYEE.EMPLOYEE_code::text =T.LOGIN_USER_ID :: text WHERE a.reservation_id = t.reservation_id
 AND T.STATE = 'CNF'
      order by created_on desc fetch first 1 row only) AS CONFIREMED_BY_NAME,
     (select DISTINCT max(EHPOM_PATIENT_POMR.SEEN_AT_STATUS_DONE_ON)
      from EH_POMR.EHPOM_PATIENT_POMR
      WHERE EHPOM_PATIENT_POMR.APPOINTMENT_ID = A.APPOINTMENT_ID)
         AS Complete_Date_Time,
     (select SELECTED_ICD_CODE
      from EH_POMR.EHPOM_PATIENT_PROBLEM b
      where b.APPOINTMENT_ID = a.appointment_id fetch first 1 row only) as ICD_Code,
     (SELECT start_time
      from RM_RESERVATION.rmrms_reservation
               inner join RM_RESERVATION.rmrms_reservation_patient
                          ON rmrms_reservation.reservation_id = rmrms_reservation_patient.reservation_id
      where RM_RESERVATION.rmrms_reservation_patient.patient_id = pr.patient_id
        and RM_RESERVATION.rmrms_reservation.reservation_id != r.reservation_id
      order by start_time desc fetch first 1 row ONLY) as Previous_Visit_Date FROM RM_RESERVATION.rmrms_appointment a
LEFT JOIN RM_RESERVATION.rmrms_reservation r
ON a.reservation_id = r.reservation_id
    LEFT JOIN RM_RESERVATION.rmrms_reservation_patient pr ON r.reservation_id = pr.reservation_id
    LEFT JOIN empi.patient p on pr.patient_id = p.mrn
    LEFT JOIN empi.patient_insurance ins on ins.id = p.id
    LEFT join empi.person pnt on pnt.id = p.id
    LEFT join empi.contact con on con.patient_id = p.id and contact_type='PERSONAL-CONTACT'
    LEFT JOIN RM_RESERVATION.rmrms_reservation_resource rrs ON r.reservation_id = rrs.reservation_id
    LEFT JOIN RM_RESERVATION.RMRMS_RESOURCE_HIERARCHY HI ON HI.RESOURCE_HIERARCHY_ID = RRS.RESOURCE_HIERARCHY_ID) Appointments
WHERE ( CAST (Appointments.appointment_date_time AT TIME ZONE 'UTC' AT TIME ZONE 'Asia/Kuwait' AS TIMESTAMP) >= TO_TIMESTAMP('2024-09-22 00:00:00.000000000'
    , 'YYYY-MM-DD HH24:MI:SS.FF')
  AND CAST (Appointments.appointment_date_time AT TIME ZONE 'UTC' AT TIME ZONE 'Asia/Kuwait' AS TIMESTAMP) <= TO_TIMESTAMP('2024-09-30 23:59:59.999999999'
    , 'YYYY-MM-DD HH24:MI:SS.FF') )
  AND (Appointments.hospital_id IN (330))
