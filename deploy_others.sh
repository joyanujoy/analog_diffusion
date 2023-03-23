export MODEL_ID="wavymulder/Analog-Diffusion" # change this
export SAFETY_MODEL_ID="CompVis/stable-diffusion-safety-checker"
export IS_FP16=1
export USERNAME="joyanujoy"
export REPLICATE_MODEL_ID="analog_diffusion"

echo "MODEL_ID=$MODEL_ID" > .env
echo "SAFETY_MODEL_ID=$SAFETY_MODEL_ID" >> .env
echo "IS_FP16=$IS_FP16" >> .env

# rembg background remover
export XDG_DATA_HOME=rembg
# because cog loads it from this inside predict.py
echo "XDG_DATA_HOME=$XDG_DATA_HOME" >> .env
mkdir -p $XDG_DATA_HOME
mkdir -p $XDG_DATA_HOME/.u2net
wget https://github.com/danielgatis/rembg/releases/download/v0.0.0/u2netp.onnx -O $XDG_DATA_HOME/.u2net/u2netp.onnx
wget https://github.com/danielgatis/rembg/releases/download/v0.0.0/u2net.onnx -O $XDG_DATA_HOME/.u2net/u2net.onnx
wget https://github.com/danielgatis/rembg/releases/download/v0.0.0/u2net_human_seg.onnx -O $XDG_DATA_HOME/.u2net/u2net_human_seg.onnx
wget https://github.com/danielgatis/rembg/releases/download/v0.0.0/u2net_cloth_seg.onnx -O $XDG_DATA_HOME/.u2net/u2net_cloth_seg.onnx

# for t2i adaptor
export XDG_CACHE_HOME=diffusers-cache
echo "XDG_CACHE_HOME=diffusers-cache" >> .env

# Download and cache weights.
sudo cog run python script/download-weights.py

# Do run the tests. Tests will download and cache t2i and clip interrogator/blip weights.
sudo cog run python test.py --test_img2img --test_text2img --test_adapter

sudo cog push r8.im/$USERNAME/$REPLICATE_MODEL_ID
