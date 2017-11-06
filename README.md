Sample setup for HBase Solr Batch Indexer

Setup the hbase table

```
hbase shell << EOF
create 'sample_table', {NAME => 'data'}
put 'sample_table', 'row1', 'data','value'
put 'sample_Table', 'row2', 'data','value2'
```

Generate a solr instance directory that we can modiry

```
solrctl instancedir --generate $HOME/hbase_collection_config
```

The assumption is we're not using Sentry, so we can just copy the schema.xml over

```
cp schema.xml $HOME/hbase_collection_config/conf
```

Create the solr index

```
solrctl instancedir --create hbase_collection_config $HOME/hbase_collection_config
solrctl collection --create hbase_collection -s 2 -c hbase_collection_config
```

If using Kerberos, you'll need to set this environment variable

```
export HADOOP_OPTS="-Djava.security.auth.login.config=/home/cloudera/hbase-solr-batch/jaas.conf"
```

NOTE: If using TLS, ensure your truststores are setup correctly as well - I set it at JAVA_HOME level

We need to make sure that the morphlines.conf is accessible on all datanodes

```
scp morphlines.conf <user>@<host>/opt/cloudera/hbase-solr/
```


Run the MR Indexer

```
hadoop --config /etc/hadoop/conf \
jar /opt/cloudera/parcels/CDH/jars/hbase-indexer-mr-1.5-cdh5.11.0-job.jar \
--conf /etc/hbase/conf/hbase-site.xml \
-D 'mapred.child.java.opts=-Xmx500m' \
--hbase-indexer-file $HOME/morphline-hbase-mapper.xml \
--zk-host mstr1.feetytoes.com/solr \
--collection hbase_collection \
--go-live
```

To query the collection:

```
curl -k --negotiate -u : "https://dn1.feetytoes.com:8985/solr/hbase_collection/query?q=*:*"
```
