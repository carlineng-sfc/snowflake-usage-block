view: storage_usage {
  sql_table_name: ACCOUNT_USAGE_DEV.STORAGE_USAGE ;;

  dimension_group: read {
    type: time
    timeframes: [
      raw,
      date,
      week,
      week_of_year,
      day_of_week,
      day_of_month,
      month_num,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.READ_DATE ;;
  }

  dimension: stage_bytes {
    type: number
    sql: ${TABLE}.STAGE_BYTES ;;
  }

  dimension: stage_tb {
    type: number
    sql: ${stage_bytes} / power(1024,4) ;;
  }

  dimension: storage_bytes {
    type: number
    sql: ${TABLE}.STORAGE_BYTES ;;
  }

  dimension: storage_tb {
    type: number
    sql: ${storage_bytes} / power(1024,4) ;;
  }

  dimension: failsafe_bytes {
    type: number
    sql: ${TABLE}.FAILSAFE_BYTES ;;
  }

  dimension: failsafe_tb {
    type: number
    sql: ${failsafe_bytes} / power(1024,4) ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }

  measure: billable_tb {
    type: average
    sql: ${stage_tb} + ${storage_tb} + ${failsafe_tb};;
  }

  measure: curr_mtd_billable_tb {
    type: average
    sql:  ${stage_tb} + ${storage_tb} + ${failsafe_tb};;
    filters: {field: read_date value: "this month"}
    value_format_name: decimal_4
  }

  measure: prior_mtd_billable_tb {
    type: average
    sql:  ${stage_tb} + ${storage_tb} + ${failsafe_tb};;
    filters: {field: read_date value: "last month"}
    value_format_name: decimal_4
  }


}