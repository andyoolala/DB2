#!/usr/bin/env bash

source_db=$1
target_db=$2
db_dir=$3
out_file="create_db_${target_db}.clp"

gen_crtdb(){
echo -e "create db ${target_db} on /${db_dir}/${target_db} using codeset big5 territory TW collate using identity;\n"
echo -e "update db cfg for ${target_db} using AUTO_MAINT off;\n"
echo -e "update db cfg for ${target_db} using AUTO_TBL_MAINT off;\n"
echo -e "update db cfg for ${target_db} using AUTO_RUNSTATS off;\n"
echo -e "update db cfg for ${target_db} using AUTO_STMT_STATS off;\n"
echo -e "update db cfg for ${target_db} using LOGFILSIZ 20000;\n"
echo -e "update db cfg for ${target_db} using LOGPRIMARY 6;\n"
echo -e "update db cfg for ${target_db} using LOGSECOND 6;\n"
}

gen_ddl(){
db2look -d ${source_db}  -e -x -l -noview -nofed | sed "s/${source_db}/${target_db}/g"
}

procedure(){
echo -e "## Step 1. create database directory"
echo -e "mkdir /${db_dir}/${target_db}"
echo -e "## Step 2. check database ddl file"
echo -e "cat  ${out_file}"
echo -e "## Step 3. create database objects"
echo -e "db2 -tvf ${out_file} | tee -a ${out_file}.log"
}

gen_crtdb > ${out_file}
gen_ddl >> ${out_file}
procedure