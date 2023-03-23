"""
Override Config dataclass in clip_interrogator to fix an error in it. The git repo has
caption_model = None when it should be
caption_model: str = None
"""
from dataclasses import dataclass
from typing import Optional, Any
import torch
import os
import clip_interrogator


@dataclass
class Config:
    # models can optionally be passed in directly
    caption_model: Any = None
    caption_processor: Any = None
    clip_model: Any = None
    clip_preprocess: Any = None

    # blip settings
    caption_max_length: int = 32
    caption_model_name: Optional[
        str
    ] = "blip-large"  # use a key from CAPTION_MODELS or None
    caption_offload: bool = False

    # clip settings
    clip_model_name: str = "ViT-L-14/openai"
    clip_model_path: Optional[str] = None
    clip_offload: bool = False

    # interrogator settings
    cache_path: str = "cache"  # path to store cached text embeddings
    download_cache: bool = (
        True  # when true, cached embeds are downloaded from huggingface
    )
    chunk_size: int = 2048  # batch size for CLIP, use smaller for lower VRAM
    data_path: str = os.path.join(os.path.dirname(clip_interrogator.__file__), "data")
    device: str = (
        "mps"
        if torch.backends.mps.is_available()
        else "cuda"
        if torch.cuda.is_available()
        else "cpu"
    )
    flavor_intermediate_count: int = 2048
    quiet: bool = False  # when quiet progress bars are not shown

    def apply_low_vram_defaults(self):
        self.caption_model_name = "blip-base"
        self.caption_offload = True
        self.clip_offload = True
        self.chunk_size = 1024
        self.flavor_intermediate_count = 1024
