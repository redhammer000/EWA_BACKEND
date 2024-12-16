import os
import re
import threading
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.chrome.options import Options
import concurrent.futures
import json

def Stage_2(prompts):
    # Take user input for the search query
    search_query = prompts
    final_result = []
    for i in search_query:
        # Perform the search and scrape text content from each link
        final_result.extend(search_and_scrape(i))
    return final_result

def sanitize_filename(filename):
    # Replace special characters with underscores
    return re.sub(r'[^\w.-]', '_', filename)

def scrape_text_from_link(link):
    # Initialize the WebDriver in headless mode with logging suppressed
    chrome_options = Options()
    chrome_options.add_argument("--headless")
    chrome_options.add_argument("--log-level=3")  # Suppress console log messages
    chrome_options.add_argument("--disable-logging")
    chrome_options.add_experimental_option("excludeSwitches", ["enable-logging"])

    driver = webdriver.Chrome(options=chrome_options)

    result = None

    try:
        # Open the link
        driver.get(link)

        # Wait for the page to load
        WebDriverWait(driver, 10).until(EC.presence_of_element_located((By.TAG_NAME, 'body')))

        # Extract text content from the webpage
        page_text = driver.find_element(By.TAG_NAME, 'body').text

        # Store the result in the results list as a JSON object
        result = {"link": link, "text": page_text}

    except:
        # If an exception occurs, just skip this link
        result = None

    finally:
        # Close the browser window
        driver.quit()

    return result

def search_and_scrape(search_query):
    # Initialize the WebDriver in headless mode with logging suppressed
    chrome_options = Options()
    chrome_options.add_argument("--headless")
    chrome_options.add_argument("--log-level=3")  # Suppress console log messages
    chrome_options.add_argument("--disable-logging")
    chrome_options.add_experimental_option("excludeSwitches", ["enable-logging"])

    driver = webdriver.Chrome(options=chrome_options)

    results = []

    try:
        # Open the browser and navigate to Google
        driver.get("https://www.google.com")

        # Locate the search input element and send a search query
        search_input = WebDriverWait(driver, 10).until(EC.presence_of_element_located((By.NAME, "q")))
        search_input.send_keys(search_query + Keys.RETURN)

        # Wait for the search results to load
        WebDriverWait(driver, 10).until(EC.presence_of_all_elements_located((By.CSS_SELECTOR, 'h3')))

        # Extract and print the top 5 links
        search_results = driver.find_elements(By.CSS_SELECTOR, 'h3')[:2]
        top_links = [result.find_element(By.XPATH, "..").get_attribute("href") for result in search_results]

        # Scrape text content from each link using threading
        with concurrent.futures.ThreadPoolExecutor() as executor:
            futures = [executor.submit(scrape_text_from_link, link) for link in top_links]
            for future in concurrent.futures.as_completed(futures):
                result = future.result()
                if result is not None:
                    results.append(result)

    except Exception as e:
        print(f"Error: {e}")

    finally:
        # Close the browser window when done
        driver.quit()

    return results
