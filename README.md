# Analog Diffusion with Lora, Clip Interrogator

Run inference on Replicate:

[![Replicate](https://replicate.com/joyanujoy/analog_diffusion/badge)](https://replicate.com/joyanujoy/analog_diffusion)

This repo is adapted from the original lore-inference repo by [cloneofsimo](https://github.com/replicate/lora-inference.git). I'm using this for running experiments easily without having to spin up a GPU server for automatic111 webui. Main modifications are:

* Add RealESRGAN for upscaling
* Add Clip Interrogator for auto generating initial img2img prompt
* Add rembg for background removal from init image.
* Automatically resize adaptor condition image size to match output image.
* Modify replicate output schema to return additonal info - seed, clip interrogator generated prompt etc.[API works but breaks replicate web UI explorer]
* Modify the scripts for download weights, test and deploy to download and cache large model files. Bake the cache files into container image to avoid long wait for model downloads everytime container warms up.

## Deployments

Deploy & Push to replicate with bash script

First, make a model at replicate.com. Create one [here](https://replicate.com/create)

Specify the following parameter file at `deploy_others.sh` file.

```bash
export MODEL_ID="lambdalabs/dreambooth-avatar" # change this to model at huggingface or your local repository.
export SAFETY_MODEL_ID="CompVis/stable-diffusion-safety-checker"
export IS_FP16=1
export USERNAME="cloneofsimo" # change this to your replicate ID.
export REPLICATE_MODEL_ID="avatar" #replciate model ID,
```

Run it with

```bash
bash deploy_others.sh
```
