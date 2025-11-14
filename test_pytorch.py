# test_pytorch.py - Script simple pour vérifier PyTorch GPU
# Repository: https://github.com/laurentvv/ai-image-generator-pytorch.git

import torch

print("=" * 60)
print("TEST DE L'INSTALLATION PYTORCH")
print("=" * 60)

try:
    # Version PyTorch
    print(f"TORCH VERSION: {torch.__version__}")

    # Version CUDA
    print(f"CUDA VERSION: {torch.version.cuda}")

    # GPU disponible ?
    if torch.cuda.is_available():
        print("GPU DETECTE: OUI")
        print(f"GPU NOM: {torch.cuda.get_device_name(0)}")

        # VRAM totale
        vram = torch.cuda.get_device_properties(0).total_memory / (1024**3)
        print(f"VRAM: {vram:.1f} Go")
    else:
        print("GPU DETECTE: NON")
        print("ATTENTION: Utilisation du CPU (plus lent)")

except Exception as e:
    print(f"ERREUR: {e}")
    print("PyTorch n'est pas correctement installé")

print("=" * 60)
