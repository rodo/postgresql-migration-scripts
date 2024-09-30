clean:
	rm output/0*.sql

all:
	psql -f data/data.sql
	psql -f output/01_test_before.sql
	psql -f output/02_add_columns.sql
	psql -f output/03_test_after.sql
	psql -f output/04_update.sql
	psql -f output/05_vacuum.sql
	psql -f output/06_check_datas.sql
	psql -f output/07_switch.sql
	psql -f output/08_drop.sql
	psql -f output/09_test_clean.sql

load:
	psql -Xf data/data.sql
	pg_prove output/01_test_before.sql && psql -Xf output/02_add_columns.sql && pg_prove output/03_test_after.sql && psql -Xf output/04_update.sql && psql -Xf output/05_vacuum.sql && psql -Xf output/06_check_datas.sql
