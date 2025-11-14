# AI Image Generator with PyTorch - QWEN Context

**Repository:** [ai-image-generator-pytorch](https://github.com/laurentvv/ai-image-generator-pytorch.git)

## Project Overview

This is an experimental image generation project using Stable Diffusion v1.4 with PyTorch and CUDA 13.0. The project is set up to work optimally with limited VRAM (6GB) GPUs like the RTX 3060, featuring various performance optimizations to enable AI image generation on consumer hardware.

### Technologies Used:
- **Python 3.13** (Experimental)
- **PyTorch 2.9.1** with CUDA 13.0 (Nightly build)
- **Stable Diffusion v1.4** for image generation
- **Diffusers library** from Hugging Face
- **NVIDIA RTX 3060 6GB** GPU (target hardware)

## Project Structure

```
D:\temp\image_gen\
├── main.py                 # Main image generation script
├── test_pytorch.py         # PyTorch/CUDA verification script
├── README.md              # Installation guide and documentation
├── .venv/                 # Python virtual environment
└── .vscode/               # VS Code configuration
```

## Key Components

### 1. main.py
- Implements Stable Diffusion Pipeline for image generation
- Uses `CompVis/stable-diffusion-v1-4` model by default
- Includes VRAM optimization techniques for 6GB GPU
- Features configurable parameters (resolution, steps, prompts)

### 2. test_pytorch.py
- Simple script to verify PyTorch and CUDA installation
- Checks GPU availability and properties
- Reports PyTorch/CUDA versions and VRAM capacity

### 3. README.md
- Comprehensive installation guide
- Performance benchmarks
- Troubleshooting section
- Optimization recommendations

## Building and Running

### Setup Commands:

1. **Create Virtual Environment:**
```powershell
python3.13 -m venv .venv
.venv\Scripts\activate
```

2. **Install PyTorch with CUDA 13.0:**
```powershell
pip install torch torchvision --index-url https://download.pytorch.org/whl/cu130
```

3. **Install Dependencies:**
```powershell
pip install diffusers transformers accelerate pillow huggingface_hub
```

4. **Verify Installation:**
```powershell
python test_pytorch.py
```

5. **Generate Images:**
```powershell
python main.py
```

### Key Optimizations for 6GB VRAM:
- `enable_model_cpu_offload()` - Critical for 6GB VRAM
- `enable_attention_slicing()` - Saves additional VRAM
- Using `torch.float16` instead of float32
- Limiting resolution to 512x512

## Development Conventions

### Performance Considerations:
- The setup uses experimental CUDA 13.0 and Python 3.13
- XFormers is not available, leading to ~30% performance reduction
- Recommended parameters: 512x512 resolution, 50 inference steps, float16 precision

### Model Configuration:
- Default model: `CompVis/stable-diffusion-v1-4`
- Safety checker disabled for performance
- Negative prompts supported for better quality

### Expected Performance:
- Model loading: ~3-4 seconds
- Generation time: 7-18 seconds for 50 steps (512x512)
- VRAM usage: ~4.8 GB out of 6 GB
- Speed: 2.7 - 6.5 iterations per second

## Known Limitations

1. **Experimental Stack**: Python 3.13 + CUDA 13.0 are experimental and may contain bugs
2. **No XFormers**: No available builds for cu130 + Python 3.13, reducing performance
3. **Limited VRAM**: Optimized for 6GB VRAM, restricting resolution and batch sizes
4. **Python Compatibility**: Some packages may not have builds for Python 3.13

This project is designed as an experimental setup for AI image generation using cutting-edge but unstable technology stack. For production use, consider using Python 3.11 + CUDA 11.8 instead.

## Qwen Added Memories
- PROD1
