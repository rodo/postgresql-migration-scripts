clean:
	rm 0*.sql

all:
	psql -f data/data.sql
	psql -f 01_test_before.sql
	psql -f 02_add_columns.sql
	psql -f 03_test_after.sql
	psql -f 04_update.sql
	psql -f 05_vacuum.sql
	psql -f 06_check_datas.sql
	psql -f 07_switch.sql
	psql -f 08_drop.sql
	psql -f 09_test_clean.sql
