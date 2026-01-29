import json
import os
from datetime import datetime
from typing import Dict, List, Optional

class LearningSystem:
    def __init__(self):
        self.progress_file = "user_progress.json"
        self.load_progress()
        
    def load_progress(self):
        if os.path.exists(self.progress_file):
            with open(self.progress_file, 'r', encoding='utf-8') as f:
                self.progress = json.load(f)
        else:
            self.progress = {
                "level": 1,
                "total_points": 0,
                "completed_lessons": [],
                "current_streak": 0,
                "best_streak": 0,
                "last_activity": None,
                "module_progress": {},
                "achievements": []
            }
    
    def save_progress(self):
        with open(self.progress_file, 'w', encoding='utf-8') as f:
            json.dump(self.progress, f, indent=2, ensure_ascii=False)
    
    def add_points(self, points: int):
        self.progress["total_points"] += points
        self.check_level_up()
        self.save_progress()
    
    def check_level_up(self):
        points_for_next_level = self.progress["level"] * 100
        if self.progress["total_points"] >= points_for_next_level:
            self.progress["level"] += 1
            return True
        return False
    
    def complete_lesson(self, lesson_id: str, module: str, score: int):
        if lesson_id not in self.progress["completed_lessons"]:
            self.progress["completed_lessons"].append(lesson_id)
        
        if module not in self.progress["module_progress"]:
            self.progress["module_progress"][module] = {
                "completed": 0,
                "total_score": 0,
                "best_score": 0
            }
        
        self.progress["module_progress"][module]["completed"] += 1
        self.progress["module_progress"][module]["total_score"] += score
        if score > self.progress["module_progress"][module]["best_score"]:
            self.progress["module_progress"][module]["best_score"] = score
        
        self.update_streak()
        self.add_points(score)
        self.check_achievements()
        self.save_progress()
    
    def update_streak(self):
        today = datetime.now().strftime("%Y-%m-%d")
        if self.progress["last_activity"] != today:
            self.progress["current_streak"] += 1
            if self.progress["current_streak"] > self.progress["best_streak"]:
                self.progress["best_streak"] = self.progress["current_streak"]
            self.progress["last_activity"] = today
    
    def check_achievements(self):
        achievements = [
            {"id": "first_lesson", "name": "Premier pas", "condition": len(self.progress["completed_lessons"]) >= 1},
            {"id": "five_lessons", "name": "Apprenant motivé", "condition": len(self.progress["completed_lessons"]) >= 5},
            {"id": "ten_lessons", "name": "Super élève", "condition": len(self.progress["completed_lessons"]) >= 10},
            {"id": "streak_3", "name": "Régularité", "condition": self.progress["current_streak"] >= 3},
            {"id": "streak_7", "name": "Une semaine parfaite", "condition": self.progress["current_streak"] >= 7},
            {"id": "level_5", "name": "Niveau 5 atteint", "condition": self.progress["level"] >= 5},
        ]
        
        for achievement in achievements:
            if achievement["condition"] and achievement["id"] not in self.progress["achievements"]:
                self.progress["achievements"].append(achievement["id"])
                return achievement["name"]
        return None
    
    def get_level(self) -> int:
        return self.progress["level"]
    
    def get_points(self) -> int:
        return self.progress["total_points"]
    
    def get_streak(self) -> int:
        return self.progress["current_streak"]


class LessonContent:
    MODULES = {
        "colors": {
            "name": "Couleurs",
            "icon": "🎨",
            "lessons": [
                {
                    "id": "colors_1",
                    "title": "Couleurs de base",
                    "level": 1,
                    "questions": [
                        {"question": "What color is the apple?", "answer": "red", "options": ["red", "blue", "green"], "image": "🍎"},
                        {"question": "What color is the sky?", "answer": "blue", "options": ["red", "blue", "yellow"], "image": "☁️"},
                        {"question": "What color is the sun?", "answer": "yellow", "options": ["yellow", "green", "purple"], "image": "☀️"},
                        {"question": "What color is grass?", "answer": "green", "options": ["green", "orange", "pink"], "image": "🌿"},
                    ]
                },
                {
                    "id": "colors_2",
                    "title": "Plus de couleurs",
                    "level": 2,
                    "questions": [
                        {"question": "What color is an orange?", "answer": "orange", "options": ["orange", "purple", "brown"], "image": "🍊"},
                        {"question": "What color is a grape?", "answer": "purple", "options": ["purple", "white", "black"], "image": "🍇"},
                        {"question": "What color is chocolate?", "answer": "brown", "options": ["brown", "pink", "gray"], "image": "🍫"},
                        {"question": "What color is snow?", "answer": "white", "options": ["white", "black", "red"], "image": "❄️"},
                    ]
                }
            ]
        },
        "animals": {
            "name": "Animaux",
            "icon": "🐾",
            "lessons": [
                {
                    "id": "animals_1",
                    "title": "Animaux domestiques",
                    "level": 1,
                    "questions": [
                        {"question": "What animal says 'meow'?", "answer": "cat", "options": ["cat", "dog", "bird"], "image": "🐱"},
                        {"question": "What animal says 'woof'?", "answer": "dog", "options": ["dog", "cat", "mouse"], "image": "🐶"},
                        {"question": "What animal says 'tweet'?", "answer": "bird", "options": ["bird", "fish", "rabbit"], "image": "🐦"},
                        {"question": "What animal hops and has long ears?", "answer": "rabbit", "options": ["rabbit", "hamster", "turtle"], "image": "🐰"},
                    ]
                },
                {
                    "id": "animals_2",
                    "title": "Animaux de la ferme",
                    "level": 2,
                    "questions": [
                        {"question": "What animal says 'moo'?", "answer": "cow", "options": ["cow", "pig", "sheep"], "image": "🐮"},
                        {"question": "What animal says 'oink'?", "answer": "pig", "options": ["pig", "horse", "chicken"], "image": "🐷"},
                        {"question": "What animal gives us eggs?", "answer": "chicken", "options": ["chicken", "duck", "goose"], "image": "🐔"},
                        {"question": "What animal says 'baa'?", "answer": "sheep", "options": ["sheep", "goat", "donkey"], "image": "🐑"},
                    ]
                },
                {
                    "id": "animals_3",
                    "title": "Animaux sauvages",
                    "level": 3,
                    "questions": [
                        {"question": "What is the king of the jungle?", "answer": "lion", "options": ["lion", "tiger", "bear"], "image": "🦁"},
                        {"question": "What animal has a long trunk?", "answer": "elephant", "options": ["elephant", "giraffe", "rhino"], "image": "🐘"},
                        {"question": "What animal has black and white stripes?", "answer": "zebra", "options": ["zebra", "horse", "donkey"], "image": "🦓"},
                        {"question": "What animal swings in trees?", "answer": "monkey", "options": ["monkey", "koala", "sloth"], "image": "🐵"},
                    ]
                }
            ]
        },
        "numbers": {
            "name": "Nombres",
            "icon": "🔢",
            "lessons": [
                {
                    "id": "numbers_1",
                    "title": "Nombres 1-5",
                    "level": 1,
                    "questions": [
                        {"question": "How many fingers on one hand?", "answer": "five", "options": ["five", "four", "three"], "image": "✋"},
                        {"question": "How many eyes do you have?", "answer": "two", "options": ["two", "one", "three"], "image": "👀"},
                        {"question": "How many noses do you have?", "answer": "one", "options": ["one", "two", "zero"], "image": "👃"},
                        {"question": "How many wheels on a tricycle?", "answer": "three", "options": ["three", "two", "four"], "image": "🚲"},
                    ]
                },
                {
                    "id": "numbers_2",
                    "title": "Nombres 6-10",
                    "level": 2,
                    "questions": [
                        {"question": "How many legs does an insect have?", "answer": "six", "options": ["six", "eight", "four"], "image": "🐜"},
                        {"question": "How many days in a week?", "answer": "seven", "options": ["seven", "six", "five"], "image": "📅"},
                        {"question": "How many legs does a spider have?", "answer": "eight", "options": ["eight", "six", "ten"], "image": "🕷️"},
                        {"question": "How many fingers on both hands?", "answer": "ten", "options": ["ten", "eight", "twelve"], "image": "🙌"},
                    ]
                }
            ]
        },
        "greetings": {
            "name": "Salutations",
            "icon": "👋",
            "lessons": [
                {
                    "id": "greetings_1",
                    "title": "Dire bonjour",
                    "level": 1,
                    "questions": [
                        {"question": "How do you say 'bonjour' in English?", "answer": "hello", "options": ["hello", "goodbye", "thanks"], "image": "👋"},
                        {"question": "How do you say 'au revoir' in English?", "answer": "goodbye", "options": ["goodbye", "hello", "sorry"], "image": "👋"},
                        {"question": "How do you say 'merci' in English?", "answer": "thank you", "options": ["thank you", "please", "sorry"], "image": "🙏"},
                        {"question": "How do you say 's'il te plaît' in English?", "answer": "please", "options": ["please", "thanks", "yes"], "image": "🙏"},
                    ]
                },
                {
                    "id": "greetings_2",
                    "title": "Politesse",
                    "level": 2,
                    "questions": [
                        {"question": "What do you say when you make a mistake?", "answer": "sorry", "options": ["sorry", "thanks", "bye"], "image": "😔"},
                        {"question": "What do you say in the morning?", "answer": "good morning", "options": ["good morning", "good night", "good afternoon"], "image": "🌅"},
                        {"question": "What do you say before sleeping?", "answer": "good night", "options": ["good night", "good morning", "goodbye"], "image": "🌙"},
                        {"question": "What do you say when someone helps you?", "answer": "thank you", "options": ["thank you", "sorry", "hello"], "image": "❤️"},
                    ]
                }
            ]
        },
        "food": {
            "name": "Nourriture",
            "icon": "🍕",
            "lessons": [
                {
                    "id": "food_1",
                    "title": "Fruits",
                    "level": 2,
                    "questions": [
                        {"question": "What fruit is yellow and monkeys love it?", "answer": "banana", "options": ["banana", "apple", "orange"], "image": "🍌"},
                        {"question": "What red fruit grows on trees?", "answer": "apple", "options": ["apple", "strawberry", "cherry"], "image": "🍎"},
                        {"question": "What orange fruit has the same name as its color?", "answer": "orange", "options": ["orange", "lemon", "peach"], "image": "🍊"},
                        {"question": "What small red fruit has seeds on the outside?", "answer": "strawberry", "options": ["strawberry", "raspberry", "cherry"], "image": "🍓"},
                    ]
                },
                {
                    "id": "food_2",
                    "title": "Repas",
                    "level": 3,
                    "questions": [
                        {"question": "What do you drink in the morning?", "answer": "milk", "options": ["milk", "juice", "water"], "image": "🥛"},
                        {"question": "What do you eat with butter and jam?", "answer": "bread", "options": ["bread", "rice", "pasta"], "image": "🍞"},
                        {"question": "What Italian food has tomato sauce and cheese?", "answer": "pizza", "options": ["pizza", "pasta", "burger"], "image": "🍕"},
                        {"question": "What sweet food do bees make?", "answer": "honey", "options": ["honey", "sugar", "jam"], "image": "🍯"},
                    ]
                }
            ]
        },
        "body": {
            "name": "Corps humain",
            "icon": "👤",
            "lessons": [
                {
                    "id": "body_1",
                    "title": "Visage",
                    "level": 2,
                    "questions": [
                        {"question": "What do you see with?", "answer": "eyes", "options": ["eyes", "ears", "nose"], "image": "👀"},
                        {"question": "What do you hear with?", "answer": "ears", "options": ["ears", "eyes", "mouth"], "image": "👂"},
                        {"question": "What do you smell with?", "answer": "nose", "options": ["nose", "mouth", "ears"], "image": "👃"},
                        {"question": "What do you eat with?", "answer": "mouth", "options": ["mouth", "nose", "eyes"], "image": "👄"},
                    ]
                },
                {
                    "id": "body_2",
                    "title": "Corps",
                    "level": 2,
                    "questions": [
                        {"question": "What do you use to write?", "answer": "hand", "options": ["hand", "foot", "head"], "image": "✋"},
                        {"question": "What do you walk with?", "answer": "feet", "options": ["feet", "hands", "legs"], "image": "👣"},
                        {"question": "What connects your hand to your body?", "answer": "arm", "options": ["arm", "leg", "neck"], "image": "💪"},
                        {"question": "What do you think with?", "answer": "brain", "options": ["brain", "heart", "stomach"], "image": "🧠"},
                    ]
                }
            ]
        }
    }
    
    @classmethod
    def get_all_modules(cls):
        return cls.MODULES
    
    @classmethod
    def get_module(cls, module_id: str):
        return cls.MODULES.get(module_id)
    
    @classmethod
    def get_lessons_for_level(cls, level: int):
        available_lessons = []
        for module_id, module in cls.MODULES.items():
            for lesson in module["lessons"]:
                if lesson["level"] <= level:
                    available_lessons.append({
                        "module_id": module_id,
                        "module_name": module["name"],
                        "module_icon": module["icon"],
                        **lesson
                    })
        return available_lessons
