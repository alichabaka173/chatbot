import json
import google.generativeai as genai

with open("config.json", "r") as f:
    config = json.load(f)

API_KEY = config["GEMINI_API_KEY"]
genai.configure(api_key=API_KEY)

class AITutor:
    def __init__(self):
        self.model = genai.GenerativeModel("gemini-2.0-flash")
        self.conversation_history = []
        self.system_prompt = """You are a friendly English teacher for children aged 5-10 years old.
Your role is to:
- Help children learn English in a fun and engaging way
- Use simple words and short sentences
- Be encouraging and positive
- Correct mistakes gently
- Use emojis to make learning fun
- Adapt to the child's level
- Answer questions about English words, grammar, and pronunciation
- Create simple exercises when asked

Always respond in a way that's appropriate for young children.
Keep responses short and clear.
Use examples they can relate to (animals, toys, family, food, etc.)."""
        
    def chat(self, user_message: str, context: dict = None) -> str:
        try:
            full_prompt = self.system_prompt + "\n\n"
            
            if context:
                if "level" in context:
                    full_prompt += f"Child's current level: {context['level']}\n"
                if "topic" in context:
                    full_prompt += f"Current topic: {context['topic']}\n"
            
            full_prompt += f"\nChild says: {user_message}\n\nRespond in a friendly, educational way:"
            
            response = self.model.generate_content(full_prompt)
            return response.text
        except Exception as e:
            return f"Oops! I had a little problem 😅 Can you try again?"
    
    def get_hint(self, question: str, correct_answer: str) -> str:
        try:
            prompt = f"""A child is learning English and struggling with this question:
Question: {question}
Correct answer: {correct_answer}

Give a helpful hint (not the answer!) in simple English that a 5-10 year old can understand.
Use an emoji and keep it to one short sentence."""
            
            response = self.model.generate_content(prompt)
            return response.text
        except Exception as e:
            return "Think about what you know! You can do it! 💪"
    
    def explain_word(self, word: str) -> str:
        try:
            prompt = f"""Explain the English word '{word}' to a child aged 5-10 years old.
Include:
- Simple definition
- An example sentence
- A fun fact or emoji
Keep it very short and simple!"""
            
            response = self.model.generate_content(prompt)
            return response.text
        except Exception as e:
            return f"The word '{word}' is a great English word! Keep learning! 🌟"
    
    def create_custom_quiz(self, topic: str, difficulty: int = 1) -> list:
        try:
            prompt = f"""Create 4 multiple choice questions about '{topic}' for children learning English.
Difficulty level: {difficulty}/5
Format each question as JSON with: question, answer, options (3 choices), emoji

Return ONLY a valid JSON array, nothing else."""
            
            response = self.model.generate_content(prompt)
            questions = json.loads(response.text)
            return questions
        except Exception as e:
            return []
    
    def get_encouragement(self, score: int, total: int) -> str:
        try:
            percentage = (score / total) * 100
            prompt = f"""A child just completed a quiz and got {score} out of {total} questions correct ({percentage:.0f}%).
Give them encouraging feedback in one short sentence with an emoji.
Be positive and motivating!"""
            
            response = self.model.generate_content(prompt)
            return response.text
        except Exception as e:
            if percentage >= 80:
                return "Amazing work! You're a star! ⭐"
            elif percentage >= 60:
                return "Great job! Keep practicing! 🌟"
            else:
                return "Good try! Practice makes perfect! 💪"
