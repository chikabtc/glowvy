#!/bin/bash

# NOTE: Be sure to replace all instances of 165.22.248.31
# with your own domain or IP address.
echo "==== Creating default tables in psql ===="

#create tables 
psql -U present -d dimodo -a -f sql/config/config.pgsql
echo "  Created Tables "

#insert datas into tables ...  
psql -U present -d dimodo -a -f sql/config/default.pgsql
echo "  Created mail defaults "

psql -U present -d dimodo -a -f sql/config/ward.pgsql
echo "  insert wards "

psql -U present -d dimodo -a -f sql/config/district.pgsql
echo "  insert districts"

psql -U present -d dimodo -a -f sql/config/province.pgsql
echo "  insert provinces"

psql -U present -d dimodo -a -f sql/config/category.pgsql
echo "  insert categories"

echo "==== Done creating dimodo default tables ===="
