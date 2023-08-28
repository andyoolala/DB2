SELECT
con.application_handle,
con.application_id,
con.application_name,
con.client_pid,
uow.uow_start_time,
uow.uow_log_space_used
FROM
table(mon_get_connection(cast(null as bigint), -1)) as con,
table(mon_get_unit_of_work(null, -1)) as uow
WHERE
con.application_handle = uow.application_handle and
uow.uow_log_space_used != 0
ORDER BY uow.uow_start_time ;