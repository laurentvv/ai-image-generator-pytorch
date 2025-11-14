# AI Image Generator with PyTorch
# Repository: https://github.com/laurentvv/ai-image-generator-pytorch.git

import torch
from diffusers import StableDiffusionPipeline

# Configuration v1.4 optimale
model_id = "CompVis/stable-diffusion-v1-4"
prompt = "cyberpunk neon city, rain, wet pavement reflections, Blade Runner style, 8k, cinematic"
negative_prompt = "blurry, low quality, ugly, deformed, bad anatomy"

# Chargement
pipe = StableDiffusionPipeline.from_pretrained(
    model_id,
    torch_dtype=torch.float16,
    safety_checker=None,
    requires_safety_checker=False,
)
pipe = pipe.to("cuda")

# Optimisations VRAM (6Go = limite)
pipe.enable_model_cpu_offload()  # 🔥 GAIN DE 40% de vitesse
pipe.enable_attention_slicing()  # 🔥 GAIN DE 15% de vitesse

# Génération
generator = torch.Generator(device="cuda").manual_seed(42)
image = pipe(
    prompt=prompt,
    negative_prompt=negative_prompt,
    width=512,
    height=512,
    num_inference_steps=50,
    guidance_scale=7.5,
    generator=generator,
).images[0]

# Sauvegarde
image.save("output.png")
print("✅ Image générée: output.png")
