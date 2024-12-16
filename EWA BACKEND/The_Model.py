# Import the required packages
import os
import textwrap

import google.generativeai as genai

# Define a function to format text as Markdown
def to_markdown(text):
    text = text.replace('•', '  *')
    return textwrap.indent(text, '> ', predicate=lambda _: True)



# Define a function to generate text from a prompt using a specified model
def generate_text(prompt, model_name='gemini-1.5-flash'):
    # Set your API key
    GOOGLE_API_KEY = 'AIzaSyBOIi6zQB2WTOihJpYGzEnU3u7sdVZR_7Y'  # Replace with your actual API key
    # Configure the API key
    genai.configure(api_key=GOOGLE_API_KEY)
    model = genai.GenerativeModel(model_name)
    response = model.generate_content(prompt)
    formatted_response = to_markdown(response.text)
    return formatted_response

# Example prompt
def model(prompt):
  
  response = generate_text(prompt)
  return response