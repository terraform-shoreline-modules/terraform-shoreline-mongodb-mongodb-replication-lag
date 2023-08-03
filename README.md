
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# MongoDB Replication Lag Incident
---

A MongoDB Replication Lag Incident occurs when there is a delay in the replication of data from the primary MongoDB instance to its secondary instances. This delay can cause data inconsistencies and affect the performance of the application. It is important to identify and resolve this incident as soon as possible to ensure that the application is functioning optimally.

### Parameters
```shell
# Environment Variables

export HOST="PLACEHOLDER"

export PORT="PLACEHOLDER"

export DATABASE="PLACEHOLDER"

export PASSWORD="PLACEHOLDER"

export USERNAME="PLACEHOLDER"

export MEMBER_NAME="PLACEHOLDER"

```

## Debug

### Connect to the MongoDB instance with <host> and <port>
```shell
mongo ${HOST}:${PORT}
```

### Check the status of the replica set
```shell
mongo ${HOSTNAME}:${PORT}/${DATABASE} -u ${USERNAME} -p ${PASSWORD} --authenticationDatabase admin --eval "rs.status()"
```

### Check the replication lag for all members of the replica set
```shell
mongo ${HOSTNAME}:${PORT}--eval "printjson(db.printSlaveReplicationInfo())"
```

### Check the replication lag for a specific member of the replica set
```shell
mongo ${HOSTNAME}:${PORT}/${DATABASE} --eval "printjson(db.printSlaveReplicationInfo())" | grep "${MEMBER_NAME}" -A 1 | grep "lagSeconds"
```

### Check the oplog size for all members of the replica set
```shell
mongo ${HOST}:${PORT}/admin --eval "db.getSiblingDB('local').oplog.rs.stats()"
```

### Check the oplog size for a specific member of the replica set
```shell
mongo ${MONGO_URI} --eval "db.getSiblingDB('local').oplog.rs.stats().storageSize"
```

### Check the slow queries log for any queries that may be causing replication lag
```shell
cat /var/log/mongodb/mongod.log | grep "slow query"
```

### Check the system logs for any errors or warnings related to replication
```shell
cat /var/log/mongodb/mongod.log/mongod.log | grep "repl"
```

### Check the network latency between the replica set members
```shell
ping ${HOST}
```

### Check the network throughput between the replica set members
```shell
iperf -c ${HOST}
```

## Repair

### Define the hostnames or IP addresses of the primary and secondary nodes
```shell
PRIMARY="PLACEHOLDER"

SECONDARY="PLACEHOLDER"
```

### Check the status of the primary node
```shell
if ping -c 1 $PRIMARY &> /dev/null

then

    echo "Primary node is up."

else

    echo "Primary node is down."

fi
```

### Check the status of the secondary node
```shell
if ping -c 1 $SECONDARY &> /dev/null

then

    echo "Secondary node is up."

else

    echo "Secondary node is down."

fi
```

### Reduce the write concern settings on the MongoDB cluster to allow for faster replication.
```shell


#!/bin/bash



# Set the MongoDB URI

MONGODB_URI="PLACEHOLDER"



# Set the new write concern settings

NEW_WRITE_CONCERN="PLACEHOLDER"



# Update the write concern settings on the MongoDB cluster

mongo $MONGODB_URI --eval "db.getMongo().setWriteConcern('$NEW_WRITE_CONCERN')"


```

### Increase the replication buffer size to allow for more data to be replicated between the primary and secondary nodes.
```shell
bash

#!/bin/bash



# Set the new replication buffer size

NEW_SIZE="PLACEHOLDER"



# Get the current replication buffer size

CURRENT_SIZE=$(mongo --eval "printjson(db.adminCommand({getCmdLineOpts: 1})).parsed.net.maxIncomingConnectionsBytes")



# Check if the new size is greater than the current size

if [ $NEW_SIZE -gt $CURRENT_SIZE ]

then

  # Update the replication buffer size

  sudo sed -i "s/maxIncomingConnectionsBytes=${CURRENT_SIZE}/maxIncomingConnectionsBytes=${NEW_SIZE}/" /etc/mongod.conf



  # Restart the MongoDB service to apply the changes

  sudo systemctl restart mongod

  

  # Output success message

  echo "Replication buffer size increased to ${NEW_SIZE} bytes."

else

  # Output error message

  echo "New size must be greater than the current size (${CURRENT_SIZE} bytes)."

fi


```