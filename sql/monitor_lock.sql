select substr(ai.appl_name,1,10) as Application,
substr(ai.primary_auth_id,1,10) as AuthID,
int(ap.locks_held) as "# Locks",
int(ap.lock_escals) as "Escalations",
int(ap.lock_timeouts) as "Lock Timeouts",
int(ap.deadlocks) as "Deadlocks",
int(ap.int_deadlock_rollbacks) as "Dlock Victim",
substr(inbound_comm_address,1,15) as "IP Address"
from
sysibmadm.snapappl ap,
sysibmadm.snapappl_info ai
where ap.agent_id=ai.agent_id;