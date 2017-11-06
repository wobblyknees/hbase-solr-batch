solrctl instancedir --generate $HOME/hbase_collection_config
cp schema.xml $HOME/hbase_collection_config/conf
solrctl instancedir --create hbase_collection_config $HOME/hbase_collection_config
solrctl collection --create hbase_collection -s 3 -c hbase_collection_config
