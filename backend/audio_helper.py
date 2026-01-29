import os
from gtts import gTTS
import pygame
import tempfile

class AudioHelper:
    def __init__(self):
        pygame.mixer.init()
        self.temp_dir = tempfile.gettempdir()
        
    def text_to_speech(self, text: str, lang: str = 'en'):
        try:
            filename = os.path.join(self.temp_dir, f"tts_{hash(text)}.mp3")
            
            if not os.path.exists(filename):
                tts = gTTS(text=text, lang=lang, slow=False)
                tts.save(filename)
            
            return filename
        except Exception as e:
            print(f"Error generating speech: {e}")
            return None
    
    def play_audio(self, text: str, lang: str = 'en'):
        try:
            filename = self.text_to_speech(text, lang)
            if filename:
                pygame.mixer.music.load(filename)
                pygame.mixer.music.play()
                return True
        except Exception as e:
            print(f"Error playing audio: {e}")
        return False
    
    def play_sound_effect(self, effect_type: str):
        sound_map = {
            "correct": "correct.wav",
            "wrong": "wrong.wav",
            "level_up": "levelup.wav",
            "achievement": "achievement.wav"
        }
        
        try:
            sound_file = sound_map.get(effect_type)
            if sound_file and os.path.exists(f"sounds/{sound_file}"):
                sound = pygame.mixer.Sound(f"sounds/{sound_file}")
                sound.play()
        except Exception as e:
            print(f"Error playing sound effect: {e}")
    
    def stop_audio(self):
        try:
            pygame.mixer.music.stop()
        except Exception as e:
            print(f"Error stopping audio: {e}")
