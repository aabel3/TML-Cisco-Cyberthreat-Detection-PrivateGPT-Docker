# ❓ The 16 Dashboard Questions

During the live demonstration an attacker hacks or shuts down hosts without saying which, and the 16 questions are answered from the running dashboard. This page lists where each answer comes from. Answers that depend on the live attack are not recorded here, because they change every run.

## Where to look on the dashboard

| Dashboard item | Shows |
|----------------|-------|
| Hosts At Risk banner | Hosts above the 0.85 anomaly threshold, and hosts where anomalies were found |
| Tiles | Total Kafka messages processed, `N out of M` hosts at potential risk, the time window analysed |
| Pie charts | Inbound and outbound packets, **Max** and **Avg**, split by host |
| Anomaly probability bars | AnomProb for inbound and outbound packets per host (hover for the value) |
| Table | One row per host and statistic, with the **Process Type** (for example Max, Avg, Variance, AnomProb), value and Kafka key |
| PrivateGPT panel | A short written assessment of each host, including whether it should be investigated |

## Questions

| # | Question | How to answer it |
|---|----------|------------------|
| 1 | Which machines are hosts at risk? | The Hosts At Risk banner. The capture shows `5.11, 5.16, 6.17`, with anomalies in `5.14, 5.31` |
| 2 | Which hosts at risk cannot be pinged? | Ping each host in Cisco Packet Tracer (live) |
| 3 | Average outbound packets for hosts at risk | Outbound Packets **Avg** pie chart or the table rows with Process Type `Avg` |
| 4 | Average inbound packets for hosts at risk | Inbound Packets **Avg** pie chart or table |
| 5 | Maximum outbound packets for hosts at risk | Outbound Packets **Max** pie chart or table |
| 6 | Maximum inbound packets for hosts at risk | Inbound Packets **Max** pie chart or table |
| 7 | Hosts at risk with increasing outbound bytes | Trend rows for outbound packets in the table (live) |
| 8 | Hosts at risk with decreasing outbound bytes | Trend rows for outbound packets in the table (live) |
| 9 | Hosts at risk with increasing inbound bytes | Trend rows for inbound packets in the table (live) |
| 10 | Hosts at risk with decreasing inbound packets | Trend rows for inbound packets in the table (live) |
| 11 | Which machines are down on switch 1? | Hosts that stop sending data or ping in Packet Tracer; VLAN 1 (`5.x`) hangs off the multilayer switch (live) |
| 12 | Which machines are down on switch 2? | Same check for VLAN 2 (`6.x`) (live) |
| 13 | Highest variance in inbound packets | Table rows with Process Type `Variance` for inbound packets, highest value |
| 14 | Highest variance in outbound packets | Table rows with Process Type `Variance` for outbound packets, highest value |
| 15 | Anomaly probability in outbound packets above 80% | Anomaly probability bars, outbound side, any host above 0.80 |
| 16 | Anomaly probability in inbound packets above 80% | Anomaly probability bars, inbound side, any host above 0.80 |

## Recorded from the captures

- **Question 1:** hosts at risk `5.11, 5.16, 6.17`; anomalies found in `5.14, 5.31` ([screenshot 2](../screenshots/02-dashboard-hosts-at-risk.png)).
- **Questions 15 and 16:** host `192.168.6.13` had an outbound anomaly probability of `0.711` (71.10%) and an inbound anomaly probability of `0.758` (75.80%), both below 80% ([screenshot 3](../screenshots/03-dashboard-anomaly-probability-detail.png)). Other hosts in the same chart show values above 0.80, for example `0.85` and `0.856`.
