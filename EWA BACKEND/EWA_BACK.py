from flask import Flask, request, jsonify
from flask_cors import CORS
from transformers import T5ForConditionalGeneration, T5Tokenizer
import torch

import third_module as summerizer
import The_Model as model
import Scrape as scraper

app = Flask(__name__)
CORS(app)

@app.route("/", methods=["POST"])
def home():
    if request.method == "POST":
        data = request.get_json()
        prompt = data.get("prompt")
        
        if not prompt:
            return jsonify({"error": "No prompt provided"}), 400
        
        x, y = load_model()
        generated_prompts, Userprompt = run_model(x, y, prompt)
        temp = summerizer.summarize_results(scraper.Stage_2(generated_prompts), Userprompt)
        final_result = model.model(temp)
        
        return jsonify({"message": final_result})
    else:
        return jsonify({"error": "Method not allowed"}), 405

def load_model():
    model_load_path = 'best_model.pt'
    device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
    model_state_dict = torch.load(model_load_path, map_location=device)
    model_id = "google/flan-t5-base"
    loaded_model = T5ForConditionalGeneration.from_pretrained(model_id, state_dict=model_state_dict).to(device)
    tokenizer = T5Tokenizer.from_pretrained(model_id)
    return loaded_model, tokenizer

def run_model(loaded_model, tokenizer, user_input):
    generated_prompts = generate_searchable_prompts(user_input, loaded_model, tokenizer)
    generated_prompts.append(user_input)
    torch.cuda.empty_cache()
    return generated_prompts, user_input

def generate_searchable_prompts(user_input, model, tokenizer, num_prompts=2):
    device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
    input_text = user_input
    input_ids = tokenizer.encode(input_text, return_tensors="pt").to(device)
    output_ids = model.generate(
        input_ids,
        max_length=150,
        num_beams=20,
        no_repeat_ngram_size=5,
        top_k=50,
        top_p=0.99,
        num_return_sequences=num_prompts,
    )
    output_tokens = tokenizer.batch_decode(output_ids, skip_special_tokens=True)
    return output_tokens

if __name__ == "__main__":
    app.run(debug=True)
