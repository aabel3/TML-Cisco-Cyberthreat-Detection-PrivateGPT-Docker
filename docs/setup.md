# ⚙️ Setup Guide

Step-by-step instructions to rebuild the TML-Cisco cyberthreat detection lab.

> Components, topics and ports are in [architecture.md](architecture.md). Every container step has a helper in [`scripts/`](../scripts/).

---

## 1. Prepare the VM

```bash
sudo apt-get update
sudo apt-get install -y docker.io
sudo chmod 666 /var/run/docker.sock     # lab convenience: lets any user run docker
docker run hello-world
```

You also need a Docker Hub account (`<dockerhub-username>` below).

---

## 2. Set up Kafka on Confluent Cloud

1. Create a [Confluent Cloud](https://confluent.io) account and a Kafka cluster on AWS, GCP or Microsoft Azure.
2. Copy the **bootstrap server** (`<host>:9092`) from the cluster settings.
3. Create an **API key** for the cluster and save the key and secret. The secret is only shown once.
4. Create the topic `cisco-network-mainstream`, or let the producer create it.

Keep the bootstrap server, key and secret private. Do not commit them or paste them into screenshots.

---

## 3. Build your TML-Cisco image

1. Copy the Dockerfile from [`tml-cisco-pt/docker`](https://github.com/smaurice101/raspberrypi/tree/main/tml-cisco-pt/docker) into an empty folder.
2. Build the image and push it to Docker Hub. Add any build arguments that the instructions in that folder list:

   ```bash
   docker build -t <dockerhub-username>/tml-cisco-networkcyberthreats-privategpt-amd64 .
   docker login
   docker push <dockerhub-username>/tml-cisco-networkcyberthreats-privategpt-amd64
   ```

---

## 4. Start PrivateGPT

Helper: [`scripts/run-privategpt.bash`](../scripts/run-privategpt.bash)

```bash
docker run -d -p 8001:8001 --env PORT=8001 --env GPU=0 \
  --env CUDA_VISIBLE_DEVICES=0 maadsdocker/tml-privategpt-no-gpu-amd64
```

[Screenshot 5](../screenshots/05-docker-run-privategpt.png) shows the command and the container ID that Docker prints.

---

## 5. Start the TML-Cisco container

Helper: [`scripts/run-tml-cisco.bash`](../scripts/run-tml-cisco.bash)

1. Create your settings file from the template and fill in the Confluent values:

   ```bash
   cp configs/tml-cisco.env.example configs/tml-cisco.env
   vim configs/tml-cisco.env
   ```

2. Start the container:

   ```bash
   ./scripts/run-tml-cisco.bash configs/tml-cisco.env
   ```

   Or run the command directly:

   ```bash
   docker run -d -p 8080:8080 --net host \
     --env VIPERVIZPORT=8080 --env RUNTYPE=-2 \
     --env PGPTIP="http://127.0.0.1" --env PGPTPORT=8001 --env PGPTROLLBACK=4 \
     --env BROKERHOSTPORT=<bootstrap-server>:9092 \
     --env KAFKAPRODUCETOPIC=cisco-network-mainstream \
     --env CLOUDUSERNAME=<confluent-api-key> \
     --env CLOUDPASSWORD=<confluent-api-secret> \
     <dockerhub-username>/tml-cisco-networkcyberthreats-privategpt-amd64
   ```

   MariaDB starts first (`Starting MariaDB database server: mariadbd.`).

3. Confirm both containers run:

   ```bash
   docker container ls
   ```

---

## 6. Send the network data

On the machine that runs Cisco Packet Tracer, open the provided network file and start the producer container with `RUNTYPE=-1` and the same Confluent settings:

```bash
sudo docker run -d --net="host" --env RUNTYPE=-1 \
  --env BROKERHOSTPORT=<bootstrap-server>:9092 \
  --env KAFKAPRODUCETOPIC=cisco-network-mainstream \
  --env CLOUDUSERNAME=<confluent-api-key> \
  --env CLOUDPASSWORD=<confluent-api-secret> \
  maadsdocker/tml-cisco-network-cyberthreats-amd64
```

To restart it, list the containers, stop the old one and run the command again ([screenshot 8](../screenshots/08-docker-stop-and-rerun-producer-container.png)):

```bash
docker container ls
docker stop <container-id>
```

In the Confluent Cloud console, open the topic `cisco-network-mainstream` and check messages arrive ([screenshot 4](../screenshots/04-confluent-cloud-topic-messages.png)).

---

## 7. Open the dashboard

```
http://localhost:8080/tml-cisco-network-privategpt-monitor.html?topic=cisco-network-preprocess,cisco-network-privategpt&offset=-1&groupid=&rollbackoffset=150&topictype=prediction&append=0&secure=1
```

Press **START STREAMING**. If you run the dashboard on another port, change `8080` in the URL to match `VIPERVIZPORT`.

---

## 8. Verify

[`scripts/verify-solution.bash`](../scripts/verify-solution.bash) checks both containers and their ports. Expected output for every check is in [verification.md](verification.md).
