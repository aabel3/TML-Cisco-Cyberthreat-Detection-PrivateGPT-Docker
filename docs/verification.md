# ✅ Verification

Each check below lists the command, the expected output (taken from the project screenshots) and the matching screenshot. The captures are from 23 July 2025. Credentials and cluster addresses in the captures are covered with black boxes.

---

## Packet Tracer network

The logical network shows the ISR4331 router with `192.168.5.1` on `gig0/0/0` (VLAN 1) and `192.168.6.1` on `gig0/0/1` (VLAN 2), and the hosts `5.x` and `6.x`.

Screenshot: [Network diagram](../screenshots/01-cisco-packet-tracer-network-diagram.png)

---

## Kafka on Confluent Cloud

Topic `cisco-network-mainstream` on `cluster_0`: the **Messages** tab shows about 67,000 messages produced in the last hour, a retention time of 1 week, and JSON values such as `{"connectedAPMacAddress": "0060.5C01.6031", "connectedAPName": "Access Point1", "connectedInterfaceName": "Por…`.

Screenshot: [Confluent topic](../screenshots/04-confluent-cloud-topic-messages.png)

---

## PrivateGPT container

```bash
docker run -d -p 8001:8001 --env PORT=8001 --env GPU=0 --env CUDA_VISIBLE_DEVICES=0 maadsdocker/tml-privategpt-no-gpu-amd64
```

Docker prints the new container ID.

Screenshot: [docker run PrivateGPT](../screenshots/05-docker-run-privategpt.png)

---

## TML-Cisco container

```bash
docker run -p 9000:9000 --env RUNTYPE=-2 --env VIPERVIZPORT=9000 ... <dockerhub-username>/tml-cisco-networkcyberthreats-privategpt-amd64
```

```
Stopping MariaDB database server: mariadbd.
Starting MariaDB database server: mariadbd.
```

Screenshot: [docker run TML-Cisco](../screenshots/06-docker-run-tml-cisco-container.png)

---

## Both containers running

```bash
docker container ls
```

```
f6efe8a40ad7   maadsdocker/tml-privategpt-no-gpu-amd64                  ...   Up 39 minutes   0.0.0.0:8001->8001/tcp
b0f460a90994   <dockerhub-username>/tml-cisco-networkcyberthreats-...   ...   Up 40 minutes   0.0.0.0:9000->9000/tcp
```

Screenshot: [docker container ls](../screenshots/07-docker-container-ls.png)

---

## Producer container restart

`docker container ls`, `docker stop <id>` and a fresh `docker run` of `maadsdocker/tml-cisco-network-cyberthreats-amd64` with `--net="host"` and `RUNTYPE=-1`.

Screenshot: [Stop and restart](../screenshots/08-docker-stop-and-rerun-producer-container.png)

---

## Dashboard

Browse to the dashboard URL and press **START STREAMING**. The capture shows:

- Header: `Kafka Topic: cisco-network-preprocess`
- `112839` Total Kafka Messages Processed
- `5 out of 42` Hosts At Potential Risk (>0.85)
- `Hosts At Risk: 5.11,5.16,6.17 - Anomalies Found in Hosts: 5.14,5.31`
- Pie charts: Inbound Packets Max, Outbound Packets Max, Inbound Packets Avg, Outbound Packets Avg

Screenshot: [Hosts at risk](../screenshots/02-dashboard-hosts-at-risk.png)

### Anomaly probability

Hovering a host in the anomaly probability bars shows its details:

```
Host Machine: 192.168.6.13
inboundpackets (AnomProb):  0.758 (75.80%)
outboundpackets (AnomProb): 0.711 (71.10%)
```

Screenshot: [Anomaly detail](../screenshots/03-dashboard-anomaly-probability-detail.png)
