
import openai
import os

openai.api_type = "azure"
openai.api_key = os.environ.get("AZURE_OPENAI_API_KEY")
openai.api_base = os.environ.get("AZURE_OPENAI_ENDPOINT", "https://file123.openai.azure.com")
openai.api_version = "2025-04-14"  # Or the version matching your deployment

response = openai.ChatCompletion.create(
    engine="gpt4-deployment",  # Your deployment name
    messages=[
        {"role": "system", "content": "You are a helpful assistant."},
        {"role": "user", "content": "Tell me a detailed summary of World War 2 in 1000 words."}
    ],
    temperature=0.7,
    max_tokens=500  # Approx. 500 tokens output
)

print(response.choices[0].message["content"])
