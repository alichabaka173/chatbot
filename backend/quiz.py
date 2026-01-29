import torch
import torch.nn as nn
import torch.nn.functional as F
import random

# Questions fixes
questions = [
    {"question": "What color is 🍎 ?", "answer": "red"},
    {"question": "What animal says 'meow'?", "answer": "cat"},
    {"question": "How do you say 'bonjour' in English?", "answer": "hello"}
]

answers_vocab = ["red", "cat", "hello"]

# Mini modèle PyTorch
class SimpleModel(nn.Module):
    def __init__(self, vocab_size):
        super(SimpleModel, self).__init__()
        self.fc1 = nn.Linear(vocab_size, 8)
        self.fc2 = nn.Linear(8, vocab_size)

    def forward(self, x):
        x = F.relu(self.fc1(x))
        return F.softmax(self.fc2(x), dim=1)

# Instance globale du modèle
model_torch = SimpleModel(len(answers_vocab))

def get_random_question():
    return random.choice(questions)

def check_answer(user_answer, current_question):
    user_answer = user_answer.strip().lower()
    if user_answer in answers_vocab:
        idx = answers_vocab.index(user_answer)
        one_hot = torch.zeros(1, len(answers_vocab))
        one_hot[0, idx] = 1
        prediction = model_torch(one_hot)
        predicted_idx = torch.argmax(prediction).item()

        return answers_vocab[predicted_idx] == current_question["answer"]
    return None
