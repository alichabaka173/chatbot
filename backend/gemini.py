import json
import google.generativeai as genai

with open("config.json", "r") as f:
    config = json.load(f)

API_KEY = config["GEMINI_API_KEY"]

genai.configure(api_key=API_KEY)
gemini_model = genai.GenerativeModel("gemini-2.0-flash")
chat = gemini_model.start_chat()

def ask_gemini(question: str) -> str:
    """
    Legacy function - Use AITutor class from ai_tutor.py instead
    """
    try:
        response = chat.send_message(question)
        return response.text
    except Exception as e:
        return f"⚠️ Error with Gemini API: {e}"
