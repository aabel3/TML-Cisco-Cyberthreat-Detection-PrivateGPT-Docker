# 📝 Submission Summary

## Overview

This final project builds a real-time cyberthreat detection and network monitoring solution. Network data from a Cisco Packet Tracer simulation streams through Kafka on Confluent Cloud into a Dockerized TML solution and a PrivateGPT container, and the hosts at risk appear on a live dashboard.

## Expectations

- Detect, in real time and without prior knowledge, which hosts an attacker has hacked or taken offline
- Set up and connect to a Kafka cluster on Confluent Cloud
- Containerize the TML-Cisco solution and run it with the PrivateGPT container
- Show the dashboard with the hosts at risk
- Answer the 16 questions about the data ([questions.md](questions.md))
- Document the problem, solution, components, integration, importance, scaling and conclusions ([solution-writeup.md](solution-writeup.md))

## Approach

1. Review the Packet Tracer network and its addressing.
2. Create the Confluent Cloud cluster and confirm data arrives in the topic.
3. Start PrivateGPT and the TML-Cisco container with Docker.
4. Open the dashboard and follow the simulated attack.
5. Capture screenshots of each component and answer the questions.

## Deliverables

| Deliverable | Location |
|-------------|----------|
| Network diagram | [`screenshots/01`](../screenshots/01-cisco-packet-tracer-network-diagram.png) |
| Dashboard showing hosts at risk | [`screenshots/02`](../screenshots/02-dashboard-hosts-at-risk.png), [`screenshots/03`](../screenshots/03-dashboard-anomaly-probability-detail.png) |
| Data in Confluent Cloud | [`screenshots/04`](../screenshots/04-confluent-cloud-topic-messages.png) |
| Docker run commands and running containers | [`screenshots/05`](../screenshots/05-docker-run-privategpt.png) – [`screenshots/08`](../screenshots/08-docker-stop-and-rerun-producer-container.png), [`scripts/`](../scripts/) |
| Answers to the 16 questions | [`docs/questions.md`](questions.md) |
| Final write-up | [`docs/solution-writeup.md`](solution-writeup.md) |
| Solution videos | See the references below |

## Conclusion

A containerized, AI-assisted pipeline detected anomalous hosts in a simulated Cisco network in real time. Kafka on Confluent Cloud carried the data, the TML-Cisco container scored each host, PrivateGPT added a written assessment, and the dashboard presented the hosts at risk. The project combined cloud streaming, networking, machine learning, containers and cybersecurity in one real-world scenario.

## References

- [Docker Hub](https://hub.docker.com/)
- [smaurice101/raspberrypi – tml-cisco-pt/docker](https://github.com/smaurice101/raspberrypi/tree/main/tml-cisco-pt/docker)
- [smaurice101/raspberrypi – repository](https://github.com/smaurice101/raspberrypi)
- [Confluent Cloud documentation](https://docs.confluent.io/cloud/current/overview.html)
- [TML-Cisco solution video](https://www.youtube.com/watch?v=dVM2yz7wdQA)
- [TML-Cisco-PrivateGPT quick video](https://www.youtube.com/watch?v=foZQJcnSXcs)
