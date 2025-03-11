name="i2v_512_test"

ckpt='checkpoints/i2v_512_v1/model.ckpt'
config='configs/inference_i2v_512_v1.0.yaml'

# Get input parameters with defaults
if [ -z "$1" ]; then
  echo "No image path provided, using default directory"
  condimage_dir="prompts/i2v_prompts"
else
  condimage_dir="$1"
  echo "Using image from: $condimage_dir"
fi

if [ -z "$2" ]; then
  echo "No prompt provided, using default prompt file"
  prompt_file="prompts/i2v_prompts/test_prompts.txt"
else
  # Create a temporary prompt file with the provided prompt
  prompt_file="prompts/i2v_prompts/temp_prompt.txt"
  echo "$2" > $prompt_file
  echo "Using custom prompt: $2"
fi

res_dir="results"

# Use high resolution settings for better quality
python3 scripts/evaluation/inference.py \
--seed 123 \
--mode 'i2v' \
--ckpt_path $ckpt \
--config $config \
--savedir $res_dir/$name \
--n_samples 1 \
--bs 1 --height 768 --width 768 \
--unconditional_guidance_scale 12.0 \
--ddim_steps 50 \
--ddim_eta 1.0 \
--prompt_file $prompt_file \
--cond_input $condimage_dir \
--fps 30 \
--frames 120

