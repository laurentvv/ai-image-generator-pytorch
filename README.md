# 🔧 **SETUP STABLE DIFFUSION - GUIDE D'INSTALLATION PYTHON 3.13 + CUDA 13.0**

## 🤖 **PROJET GITHUB**

**Repository:** [ai-image-generator-pytorch](https://github.com/laurentvv/ai-image-generator-pytorch.git)

---

## 🖥️ **COMPATIBILITÉ**

**Système testé :** Windows 11 uniquement
*Remarque : Le script d'installation PowerShell (.ps1) est conçu spécifiquement pour Windows. Pour d'autres systèmes, suivez les étapes manuelles.*

---

## 🖥️ **CONFIGURATION ACTUELLE**

| Composant | Version | Statut |
|-----------|---------|--------|
| **OS** | Windows 11 | ✅ |
| **GPU** | NVIDIA RTX 3060 6Go | ✅ |
| **Python** | 3.13.0 | ✅ *Expérimental* |
| **CUDA** | 13.0 | ✅ *Nightly build* |
| **PyTorch** | 2.9.1+cu130 | ✅ *Nightly build* |
| **Pilote NVIDIA** | 581.15 | ✅ |
| **Stable Diffusion** | v1.4 | ✅ |

*Configuration testée et fonctionnelle, mais considérée comme expérimentale*

---

## 🎯 **PERFORMANCES MESURÉES**

- **Chargement du modèle** : ~3-4 secondes
- **Génération** : 7-18 secondes pour 50 steps (512x512)
- **Vitesse** : 2.7 - 6.5 it/s selon les optimisations
- **VRAM utilisée** : ~4.8 Go / 6 Go
- **Résolution maximale** : 512x512 (recommandé pour 6Go VRAM)

---

## 🚀 **INSTALLATION RAPIDE**

### **Étape 1 : Prérequis**

```powershell
# Python 3.13 doit être installé avec "Add to PATH" coché
python --version  # Doit afficher Python 3.13.x

# Mettre à jour pip
python -m pip install --upgrade pip setuptools wheel
```

### **Étape 2 : Créer l'environnement**

```powershell
python3.13 -m venv .venv
.venv\Scripts\activate
```

### **Étape 3 : Installer PyTorch avec CUDA 13.0**

```powershell
pip install torch torchvision --index-url https://download.pytorch.org/whl/cu130
```

### **Étape 4 : Installer Stable Diffusion et dépendances**

```powershell
pip install diffusers transformers accelerate pillow huggingface_hub
```

### **Étape 5 : Vérifier l'installation**

`test_pytorch.py` :
```python
import torch
print(f"PyTorch: {torch.__version__}")
print(f"CUDA: {torch.version.cuda}")
print(f"GPU: {torch.cuda.get_device_name(0)}")
```

Lancer le test :
```powershell
python test_pytorch.py
```

**Résultat attendu :**
```
PyTorch: 2.9.1+cu130
CUDA: 13.0
GPU: NVIDIA GeForce RTX 3060 Laptop GPU
```

---

## 📖 **UTILISATION DE BASE**

### **Script de génération (`main.py`)**

```python
from diffusers import StableDiffusionPipeline
import torch

# Configuration
MODEL_ID = "CompVis/stable-diffusion-v1-4"
PROMPT = "professional portrait of a cat astronaut, detailed, photorealistic"
OUTPUT = "output.png"

# Chargement du modèle
pipe = StableDiffusionPipeline.from_pretrained(
    MODEL_ID,
    torch_dtype=torch.float16,  # ESSENTIEL pour la vitesse
    safety_checker=None,
    requires_safety_checker=False
).to("cuda")

# Optimisations pour 6Go VRAM
pipe.enable_model_cpu_offload()  # 🔥 CRUCIAL pour 6Go
pipe.enable_attention_slicing()  # Économise VRAM

# Génération
generator = torch.Generator(device="cuda").manual_seed(42)
image = pipe(
    prompt=PROMPT,
    width=512,
    height=512,
    num_inference_steps=50,
    guidance_scale=7.5,
    generator=generator
).images[0]

# Sauvegarde
image.save(OUTPUT)
print(f"✅ Image générée: {OUTPUT}")
```

### **Lancer la génération**

```powershell
python main.py
```

---

## ⚠️ **LIMITATIONS & CONSEILS**

### **1. XFormers non disponible**
- **Aucune build** pour cu130 + Python 3.13
- **Conséquence** : -30% de performance par rapport à cu118
- **Alternative** : Utilisez `enable_model_cpu_offload()` et `enable_attention_slicing()`

### **2. CUDA 13.0 expérimental**
- **Nightly build** : Peut contenir des bugs
- **Compatibilité** : Testé fonctionnel sur RTX 3060 mais non garanti
- **Performance** : Légèrement inférieure à CUDA 11.8

### **3. Python 3.13**
- **Support limité** : Certains packages peuvent ne pas avoir de builds
- **Solution** : Utilisez `--pre` pour installer les versions nightly

### **4. RTX 3060 6Go - Contraintes**
- **Résolution max** : 512x512 (recommandé)
- **Batch size** : 1 image max
- **Attention** : Surveillez la VRAM avec `nvidia-smi`

---

## 🔧 **OPTIMISATIONS POUR RTX 3060 6Go**

### **Réduction de la consommation VRAM**

```python
# Ajoutez ces lignes après pipe.to("cuda")
pipe.enable_model_cpu_offload()  # 🔥 ESSENTIEL
pipe.enable_attention_slicing()   # 🔥 ESSENTIEL
pipe.enable_vae_slicing()         # Optionnel
```

### **Paramètres recommandés**

| Paramètre | Valeur | Raison |
|-----------|--------|--------|
| `width/height` | 512x512 | Limite VRAM |
| `num_inference_steps` | 30-50 | Qualité/vitesse |
| `guidance_scale` | 7.5 | Équilibre créativité |
| `torch_dtype` | `float16` | -50% mémoire |
| `batch_size` | 1 | Obligatoire |

---

## 📸 **EXEMPLES DE PROMPTS (TESTÉS)**

### **Portrait réaliste**
```python
PROMPT = "professional portrait of a young woman, soft lighting, 85mm lens, bokeh background, sharp focus, detailed eyes, studio photography, 8k"
NEGATIVE_PROMPT = "blurry, deformed, ugly, bad anatomy, cartoon, anime, painting"
```

### **Paysage nature**
```python
PROMPT = "mountain landscape at sunset, golden hour, snow peaks, pine trees, lake reflection, national geographic style, 8k"
NEGATIVE_PROMPT = "blurry, low quality, oversaturated, watermark, text, signature"
```

### **Art digital**
```python
PROMPT = "cyberpunk neon city, rain, wet pavement reflections, Blade Runner style, digital art, cinematic lighting, 4k"
NEGATIVE_PROMPT = "blurry, low quality, cartoon, amateur, photography, realistic"
```

---

## 🐛 **DÉPANNAGE**

### **Problème : "CUDA out of memory"**
```python
# Solution 1 : Réduire la résolution
width=384, height=384

# Solution 2 : Augmenter le slicing
pipe.enable_attention_slicing(1)
```

### **Problème : Installation lente**
- **Cause** : Téléchargement de PyTorch (2.5 Go)
- **Solution** : Utiliser un réseau stable, patience 3-10 min

### **Problème : "Could not find version"**
- **Cause** : Python 3.13 + cu130 pas encore mainstream
- **Solution** : Utiliser `--pre` pour nightly builds

---

## 📊 **BENCHMARKS**

| Configuration | Temps (50 steps) | VRAM | Qualité |
|---------------|------------------|------|---------|
| **Actuelle (cu130)** | 7-18s | 4.8 Go | ✅ Bonne |
| **Stable (cu118)** | 5-7s | 4.5 Go | ✅ Excellente |
| **CPU only** | 5-8 min | N/A | ❌ Très lente |

---

## 🎓 **RESSOURCES UTILES**

- **Modèle officiel** : https://huggingface.co/CompVis/stable-diffusion-v1-4
- **PyTorch nightly** : https://pytorch.org/get-started/locally/
- **Diffusers docs** : https://huggingface.co/docs/diffusers
- **VRAM monitor** : `nvidia-smi -l 1` dans PowerShell

---

## 🚀 **INSTALLATION AUTOMATISÉE**

### **Script d'installation PowerShell**

Un script d'installation automatisé est disponible pour configurer l'environnement :

```powershell
# Télécharger et exécuter le script d'installation
./install.ps1
```

Le script effectue automatiquement toutes les étapes d'installation :
- Vérifie la présence de Python 3.13
- Crée un environnement virtuel
- Installe PyTorch avec CUDA 13.0
- Installe toutes les dépendances depuis requirements.txt
- Vérifie l'installation

---

## ⚡ **COMMANDES RAPIDES**

```powershell
# Activer l'environnement
.venv\Scripts\activate

# Lancer une génération
python main.py

# Voir l'utilisation GPU
nvidia-smi

# Désinstaller tout
pip uninstall torch torchvision torchaudio diffusers transformers accelerate -y
```

---

## 📌 **NOTES IMPORTANTES**

- **Setup expérimental** : Python 3.13 + CUDA 13.0 sont en phase de développement
- **Production** : Pour un usage professionnel, considérez Python 3.11 + CUDA 11.8
- **Mises à jour** : Vérifiez régulièrement les nouvelles versions de PyTorch
- **Communauté** : Signalez les bugs sur GitHub PyTorch/diffusers

---

**✅ Votre installation fonctionne parfaitement - Profitez de la génération d'images !**