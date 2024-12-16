from transformers import BartForConditionalGeneration, BartTokenizer
from concurrent.futures import ThreadPoolExecutor
import torch

def preprocess_text(text, max_length):
    # Preprocess the text by truncating it to the maximum length
    return text[:max_length]

def summarize_chunk(chunk, model, tokenizer, device):
    inputs = tokenizer(chunk, return_tensors="pt", truncation=True, max_length=512).to(device)
    summary_ids = model.generate(inputs.input_ids, max_length=150, min_length=30, do_sample=False)
    summary = tokenizer.decode(summary_ids[0], skip_special_tokens=True)
    return summary

def summarize_results(results, prompt):
    # List to hold all individual summaries
    all_summaries = []
    
    # Load model and tokenizer once
    model_name = "facebook/bart-large-cnn"
    device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
    model = BartForConditionalGeneration.from_pretrained(model_name).to(device)
    tokenizer = BartTokenizer.from_pretrained(model_name)

    # Summarize each link separately
    for result in results:
        # Extract the text content from the scraped result
        scraped_text = result["text"]

        temp = prompt.replace("Generate searchable prompt:", "")
        # Limit the length of the input text
        MAX_INPUT_LENGTH = 5000  # Adjust as needed based on the model's maximum input length

        # Preprocess the scraped text
        preprocessed_text = preprocess_text(scraped_text, MAX_INPUT_LENGTH)

        # Split the text into smaller chunks
        max_chunk_length = 512  # Maximum length of each chunk
        chunks = [preprocessed_text[i:i + max_chunk_length] for i in range(0, len(preprocessed_text), max_chunk_length)]

        # Process chunks in parallel
        with ThreadPoolExecutor() as executor:
            summaries_for_link = list(executor.map(lambda chunk: summarize_chunk(chunk, model, tokenizer, device), chunks))

        # Combine the summaries for this link
        full_summary= ' '.join(summaries_for_link)
        
        # Add the required string above the summary and append to all_summaries
        
        all_summaries.append(full_summary)

    # Combine all summaries into a single string
    combined_summary = ' '.join(all_summaries)
    full_summary_with_prompt = "This is the Prompt: " + temp + ": USE THIS INFORMATION TO GIVE AN ANSWER FOR THE PROMPT IF IT IS USEFUL ALSO FIX ANY SPELLING ERRORS YOU MIGHT SEE IN THE PROMPT. " + combined_summary
    
    return full_summary_with_prompt