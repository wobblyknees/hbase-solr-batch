hbase shell << EOF
create 'sample_table', {NAME => 'data'}
put 'sample_table', 'row1', 'data','value'
put 'sample_Table', 'row2', 'data','value2'
