# 📄 Solution Write-Up

## What problem does the solution solve?

Networks are attacked and taken offline faster than people can read logs. Signature-based tools only catch attacks they already know, and watching a large network by hand does not scale. This solution detects, in real time, which hosts in a Cisco network are being hacked or have gone offline, without being told which hosts the attacker is targeting. It turns a continuous stream of network data into a short list of hosts at risk that a person can act on immediately.

## How does it solve it?

1. **Data** – Cisco Packet Tracer simulates the network. A producer container sends the network data as JSON to the Kafka topic `cisco-network-mainstream` on Confluent Cloud.
2. **TML** – The TML-Cisco container reads each JSON message, groups it into time windows and calculates statistics for every host: maximum, average, variance and trend of inbound and outbound packets, plus an **anomaly probability** for each direction.
3. **Detection** – A host whose anomaly probability is above 0.85 is a host at risk. Because the model learns each host's normal pattern, it flags hosts that change suddenly, such as a host that stops sending or receives a flood.
4. **PrivateGPT** – The processed data is sent to a PrivateGPT container, which writes a short assessment of each host, such as "this host should be investigated". These go to the topic `cisco-network-privategpt`.
5. **Dashboard** – Viperviz shows the results live: the Hosts At Risk banner, packet pie charts, anomaly probability bars, the data table and the PrivateGPT answers ([screenshot 2](../screenshots/02-dashboard-hosts-at-risk.png), [screenshot 3](../screenshots/03-dashboard-anomaly-probability-detail.png)).

### What TML is doing

- **Processing the JSON** – TML consumes the JSON messages from Kafka, extracts the packet counts for each host and interface, and applies the preprocess types (for example Max, Avg, Variance and AnomProb) over each time window.
- **Dashboarding** – The results are written back to Kafka topics and Viperviz streams them to the browser over a web socket, so the page updates without refreshing.

### Where the data is stored in Confluent Cloud

The raw network data is stored in the topic `cisco-network-mainstream` on the Confluent Cloud cluster, with one week of retention ([screenshot 4](../screenshots/04-confluent-cloud-topic-messages.png)). The processed results are in `cisco-network-preprocess` and `cisco-network-privategpt`.

## Technology components

| Component | Purpose |
|-----------|---------|
| Transactional Machine Learning (TML) | Real-time processing and anomaly detection |
| PrivateGPT | AI assessment of the processed data |
| Cisco Packet Tracer | Simulated network and attack target |
| Apache Kafka on Confluent Cloud | Streaming platform for the data |
| Python | The TML processing scripts |
| Docker | Packaging and running the containers |
| MariaDB | Database inside the TML container |
| tmux | Runs the services in named sessions inside the container |
| Viperviz dashboard | Real-time visualization |

## How the components are linked

Packet Tracer → producer container → Kafka topic `cisco-network-mainstream` → TML-Cisco container → Kafka topic `cisco-network-preprocess` → PrivateGPT (port 8001) → Kafka topic `cisco-network-privategpt` → dashboard. The TML-Cisco container knows where PrivateGPT is from `PGPTIP` and `PGPTPORT`, and where Kafka is from `BROKERHOSTPORT`, `CLOUDUSERNAME` and `CLOUDPASSWORD`. Screenshots [5](../screenshots/05-docker-run-privategpt.png), [6](../screenshots/06-docker-run-tml-cisco-container.png) and [7](../screenshots/07-docker-container-ls.png) show the containers that implement the links.

## Why it matters

- **Speed** – Attacks show up as they happen, shrinking the time an attacker has.
- **Proactive** – It finds unknown attacks from changes in behaviour, not from known signatures.
- **Less manual work** – Analysts read a short list of hosts instead of raw logs.
- **Clear decisions** – The dashboard and PrivateGPT answers show which host to investigate first.
- **Portable** – Docker and a managed Kafka service make it easy to deploy anywhere.

## How would it scale?

| Area | Approach |
|------|----------|
| Kafka | Add partitions to `cisco-network-mainstream` for more parallel readers. Confluent Cloud adds brokers and capacity as needed |
| TML processing | Run several TML containers in one consumer group so they share the partitions, and give them more CPU and memory |
| PrivateGPT | Run several containers behind a load balancer, or use a GPU image for heavier analysis |
| Dashboard | Put several dashboard servers behind a load balancer |
| Database | Add MariaDB replication for reads, and sharding for very large data |
| Orchestration | Run the containers on Kubernetes so they restart and scale automatically (see the Kubernetes lab) |
| Network | Make sure there is enough bandwidth between the data sources, Kafka and the processors, and feed in real devices as well as the simulation |

## Concluding thoughts

The lab shows how streaming, machine learning, AI, containers and a live dashboard can be combined into a working security tool. Detecting an attacker without knowing the targets is the strongest part of the design. Next steps would be automated responses (for example isolating a host), richer threat intelligence and integration with a security orchestration platform.
