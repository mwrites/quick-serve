import os
import gradio as gr
import requests
from io import BytesIO


# Read the URL from an environment variable, with a default value if not set
predict_url = os.getenv('PREDICT_URL', 'http://0.0.0.0:8000/predict')
examples = ['british_short_hair_cat.jpg', 'scottish_fold_cat.jpg']


def classify_image(img):
    buffered = BytesIO()
    img.save(buffered, format='JPEG')
    buffered.seek(0)
    files = {'file': ('image.jpg', buffered, 'image/jpeg')}
    response = requests.post(predict_url, files=files)
    response.raise_for_status()
    return response.json()


with gr.Blocks() as demo:
    gr.Markdown("# Cat Breed Classifier")
    with gr.Row():
        with gr.Column():
            image = gr.Image(type="pil")
            submit_button = gr.Button("Classify")
        with gr.Column():
            label = gr.Label()
    gr.Examples(examples=examples, inputs=image)
    submit_button.click(fn=classify_image, inputs=image, outputs=label)


if __name__ == "__main__":
    demo.launch(inline=False)