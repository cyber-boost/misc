#!/bin/bash

# Model download script
# Downloads GGUF model files from Hugging Face instead of storing in Git

set -e

MODELS_DIR="./models"
mkdir -p "$MODELS_DIR"

# Base URL for Hugging Face model downloads
# Update these URLs with the actual model repositories you use
declare -A MODELS=(
    ["LFM2.5-1.2B-Instruct-Q8_0.gguf"]="https://huggingface.co/lfai/LFM2.5-1.2B-Instruct-GGUF/resolve/main/LFM2.5-1.2B-Instruct-Q8_0.gguf"
    ["LFM2.5-1.2B-Thinking-Q4_K_M.gguf"]="https://huggingface.co/lfai/LFM2.5-1.2B-Thinking-GGUF/resolve/main/LFM2.5-1.2B-Thinking-Q4_K_M.gguf"
    ["Qwen3-Zro-Cdr-Reason-V2-0.8B-NEO3-EX-D_AU-Q8_0.gguf"]="https://huggingface.co/bartowski/Qwen3-Zro-Cdr-Reason-V2-0.8B-NEO3-EX-D_AU-GGUF/resolve/main/Qwen3-Zro-Cdr-Reason-V2-0.8B-NEO3-EX-D_AU-Q8_0.gguf"
    ["functiongemma-270m-it-F16.gguf"]="https://huggingface.co/bartowski/functiongemma-270m-it-GGUF/resolve/main/functiongemma-270m-it-F16.gguf"
    ["mmproj-Qwen3-VL-8B-Instruct-F16.gguf"]="https://huggingface.co/bartowski/Qwen3-VL-8B-Instruct-GGUF/resolve/main/mmproj-Qwen3-VL-8B-Instruct-F16.gguf"
    ["mmproj-model-f16.gguf"]="https://huggingface.co/mmproj/mmproj-model-GGUF/resolve/main/mmproj-model-f16.gguf"
)

echo "Downloading model files to $MODELS_DIR..."
echo ""

for filename in "${!MODELS[@]}"; do
    url="${MODELS[$filename]}"
    filepath="$MODELS_DIR/$filename"

    if [ -f "$filepath" ]; then
        echo "✓ $filename already exists, skipping..."
    else
        echo "↓ Downloading $filename..."
        if command -v wget &> /dev/null; then
            wget --progress=bar:force -O "$filepath" "$url" || {
                echo "✗ Failed to download $filename"
                rm -f "$filepath"
                continue
            }
        elif command -v curl &> /dev/null; then
            curl -L --progress-bar -o "$filepath" "$url" || {
                echo "✗ Failed to download $filename"
                rm -f "$filepath"
                continue
            }
        else
            echo "✗ Error: wget or curl is required"
            exit 1
        fi
        echo "✓ Downloaded $filename"
    fi
    echo ""
done

echo "All models downloaded successfully!"
echo ""
echo "Total size:"
du -sh "$MODELS_DIR"
```
