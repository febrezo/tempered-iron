import logging
import os
import requests
import sys


# Grabbing environment variables
LOGGER_NAME = os.environ.get("LOGGER_NAME", "Default App Logger")
LOG_LEVEL = os.environ.get("LOG_LEVEL", "INFO")

logging.basicConfig(
    level=LOG_LEVEL,
    format=f"[%(levelname)s] {LOGGER_NAME} @ %(asctime)s | %(message)s",
    handlers=[
        logging.FileHandler(f'/log/{LOGGER_NAME}.log'),
        logging.StreamHandler()
    ]
)


def main():
    logging.info("Checking the public IP…")
    try:
        my_public_ip = requests.get("https://ifconfig.me").text
        logging.info(f"My public IP is: {my_public_ip}")
    except Exception as _:
        logging.error("Something happened when grabbing the public IP. Details: {_}. Closing…")
        sys.exit(-1)
    logging.info("Closing the application…")


if __name__ == "__main__":
    main()