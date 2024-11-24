from feedparser import parse
from datetime import datetime, timedelta
import os
from boto3 import client

# Retrieve environment variables
INTERVAL = int(os.environ['INTERVAL'])
SNS_TOPIC_ARN = os.environ['SNS_TOPIC_ARN']
PI_MODEL = os.environ['PI_MODEL']
SHOP_REGION = os.environ['SHOP_REGION']
RSS_FEED = os.environ['RSS_FEED']


def handler(event, context):
    """
    Lambda function handler.
    Checks stock and sends a message if stock is available.
    """
    shops = checkStock(RSS_FEED)
    if not shops:
        print("No stock available.")
        return
    sendMessage(shops, PI_MODEL)
   
def sendMessage(shops: list[str], model: str) -> None:
    """
    Sends a message to the SNS topic with the stock information.
    
    Args:
        shops (list[str]): List of shops with stock.
        model (str): Model of the Raspberry Pi.
    """

    sns = client('sns')
    link = formatLink(shops)
    shopsCSV = ", ".join(shops)
    message = f"{model} in stock at {shopsCSV}.\n{link}"
    sns.publish(TopicArn=SNS_TOPIC_ARN, Message=message, Subject=f"{model} in stock!")

def checkStock(rssFeed: str) -> list[str]:
    """
    Checks the RSS feed for stock availability.
    
    Args:
        rssFeed (str): URL of the RSS feed.
    
    Returns:
        list[str]: List of unique shops with stock.
    """

    shops = []
    parsedRssFeed = parse(rssFeed)
    feedEntries = parsedRssFeed.get('entries')
    for entry in feedEntries:
        dateString = entry.get('published')
        parsedDate = datetime.strptime(dateString, "%a, %d %b %Y %H:%M:%S %Z")
        tags = entry.get('tags')
        shop,country,model = extractTags(tags)
        if not dateInRange(parsedDate, INTERVAL):
            break
        if model == PI_MODEL and country == SHOP_REGION:
            shops.append(shop)
    shops = list(set(shops))
    return shops

def dateInRange(publishDate: datetime, interval: int) -> bool:
    """
    Checks if the publish date is within the specified interval.
    
    Args:
        publishDate (datetime): The date the entry was published.
        interval (int): The interval in minutes.
    
    Returns:
        bool: True if the publish date is within the interval.
    """

    timeInterval = timedelta(minutes=interval)
    currentDate = datetime.now()
    timeDifference = currentDate - publishDate 
    return timeDifference < timeInterval

def extractTags(tags: list[dict]) -> tuple:
    """
    Extracts the shop, country, and model tags from the entry tags.
    
    Args:
        tags (list[dict]): List of tags from the RSS feed entry.
    
    Returns:
        tuple: A tuple containing the shop, country, and model.
    """

    return tuple(item['term'] for item in tags)

def formatLink(shops: list[str]) -> str:
    """
    Formats the link to the shops.
    
    Args:
        shops (list[str]): List of shops with stock.
    
    Returns:
        str: Formatted link. e.g. https://rpilocator.com?vendor=shop1%2shop2
    """

    shopsString = "%2".join(shops)
    link = f"https://rpilocator.com?vendor={shopsString}"
    return link