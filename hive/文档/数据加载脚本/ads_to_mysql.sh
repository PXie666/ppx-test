#! /bin/bash
#ads_to_mysql.sh 表名/all
#1、判断参数是否传入
if [ $# -lt 1 ]
then
	echo "必须输入all/表名..."
	exit
fi
#2、根据表名导数据
case $1 in
"all")
	python /opt/module/datax/bin/datax.py -p"-DtableName=ads_city_stats" /opt/module/datax/job/hdfs_to_mysql.json
	python /opt/module/datax/bin/datax.py -p"-DtableName=ads_driver_stats" /opt/module/datax/job/hdfs_to_mysql.json
	python /opt/module/datax/bin/datax.py -p"-DtableName=ads_express_city_stats" /opt/module/datax/job/hdfs_to_mysql.json
	python /opt/module/datax/bin/datax.py -p"-DtableName=ads_express_org_stats" /opt/module/datax/job/hdfs_to_mysql.json
	python /opt/module/datax/bin/datax.py -p"-DtableName=ads_express_province_stats" /opt/module/datax/job/hdfs_to_mysql.json
	python /opt/module/datax/bin/datax.py -p"-DtableName=ads_express_stats" /opt/module/datax/job/hdfs_to_mysql.json
	python /opt/module/datax/bin/datax.py -p"-DtableName=ads_line_stats" /opt/module/datax/job/hdfs_to_mysql.json
	python /opt/module/datax/bin/datax.py -p"-DtableName=ads_order_cargo_type_stats" /opt/module/datax/job/hdfs_to_mysql.json
	python /opt/module/datax/bin/datax.py -p"-DtableName=ads_order_stats" /opt/module/datax/job/hdfs_to_mysql.json
	python /opt/module/datax/bin/datax.py -p"-DtableName=ads_org_stats" /opt/module/datax/job/hdfs_to_mysql.json
	python /opt/module/datax/bin/datax.py -p"-DtableName=ads_shift_stats" /opt/module/datax/job/hdfs_to_mysql.json
	python /opt/module/datax/bin/datax.py -p"-DtableName=ads_trans_order_stats" /opt/module/datax/job/hdfs_to_mysql.json
	python /opt/module/datax/bin/datax.py -p"-DtableName=ads_trans_order_stats_td" /opt/module/datax/job/hdfs_to_mysql.json
	python /opt/module/datax/bin/datax.py -p"-DtableName=ads_trans_stats" /opt/module/datax/job/hdfs_to_mysql.json
	python /opt/module/datax/bin/datax.py -p"-DtableName=ads_truck_stats" /opt/module/datax/job/hdfs_to_mysql.json
;;
"ads_city_stats")
    python /opt/module/datax/bin/datax.py -p"-DtableName=ads_city_stats" /opt/module/datax/job/hdfs_to_mysql.json
;;
"ads_driver_stats")
    python /opt/module/datax/bin/datax.py -p"-DtableName=ads_driver_stats" /opt/module/datax/job/hdfs_to_mysql.json
;;
"ads_express_city_stats")
    python /opt/module/datax/bin/datax.py -p"-DtableName=ads_express_city_stats" /opt/module/datax/job/hdfs_to_mysql.json
;;
"ads_express_org_stats")
    python /opt/module/datax/bin/datax.py -p"-DtableName=ads_express_org_stats" /opt/module/datax/job/hdfs_to_mysql.json
;;
"ads_express_province_stats")
    python /opt/module/datax/bin/datax.py -p"-DtableName=ads_express_province_stats" /opt/module/datax/job/hdfs_to_mysql.json
;;
"ads_express_stats")
    python /opt/module/datax/bin/datax.py -p"-DtableName=ads_express_stats" /opt/module/datax/job/hdfs_to_mysql.json
;;
"ads_line_stats")
    python /opt/module/datax/bin/datax.py -p"-DtableName=ads_line_stats" /opt/module/datax/job/hdfs_to_mysql.json
;;
"ads_order_cargo_type_stats")
    python /opt/module/datax/bin/datax.py -p"-DtableName=ads_order_cargo_type_stats" /opt/module/datax/job/hdfs_to_mysql.json
;;
"ads_order_stats")
    python /opt/module/datax/bin/datax.py -p"-DtableName=ads_order_stats" /opt/module/datax/job/hdfs_to_mysql.json
;;
"ads_org_stats")
    python /opt/module/datax/bin/datax.py -p"-DtableName=ads_org_stats" /opt/module/datax/job/hdfs_to_mysql.json
;;
"ads_shift_stats")
    python /opt/module/datax/bin/datax.py -p"-DtableName=ads_shift_stats" /opt/module/datax/job/hdfs_to_mysql.json
;;
"ads_trans_order_stats")
    python /opt/module/datax/bin/datax.py -p"-DtableName=ads_trans_order_stats" /opt/module/datax/job/hdfs_to_mysql.json
;;
"ads_trans_order_stats_td")
    python /opt/module/datax/bin/datax.py -p"-DtableName=ads_trans_order_stats_td" /opt/module/datax/job/hdfs_to_mysql.json
;;
"ads_trans_stats")
    python /opt/module/datax/bin/datax.py -p"-DtableName=ads_trans_stats" /opt/module/datax/job/hdfs_to_mysql.json
;;
"ads_truck_stats")
    python /opt/module/datax/bin/datax.py -p"-DtableName=ads_truck_stats" /opt/module/datax/job/hdfs_to_mysql.json
;;
*)
	echo "表名输入错误..."
;;
esac

