# Raspberry Pi Stock Tracker

This project uses an AWS lambda to track an RSS feed and provide updates on Raspberry Pi stock availability via AWS SNS.

## Features

- Monitors an RSS feed for updates on Raspberry Pi stock.
- Sends notifications when new stock is available.
- Utilizes AWS services for scalability and reliability.

## Prerequisites

- AWS account
- Python 3.13
- Terraform installed

## Installation

1. Clone the repository:
    ```bash
    git clone https://github.com/WaterSpooner/RaspberryPiStock.git
    cd RaspberryPiStock
    ```

2. Install the required Python packages:
    ```bash
    cd lambda
    pip install -r requirements.txt -t .
    ```

3. Configure your AWS credentials:
    ```bash
    aws configure
    ```

3. Deploy infrastructure to aws:
    ```bash
    terraform init
    terraform plan
    terraform apply
    ```

## AWS Services Used

- **AWS Lambda**: To run the stock tracking script.
- **Amazon SNS**: To send notifications.
- **Amazon CloudWatch**: To run the lambda on a schedule (default every 60 minutes)
