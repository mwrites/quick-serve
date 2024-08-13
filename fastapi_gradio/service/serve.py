import PIL
from fastai.learner import load_learner
from fastapi import FastAPI, UploadFile, HTTPException
from huggingface_hub import hf_hub_download


# Download the model from Hugging Face Hub
model_path = hf_hub_download(repo_id="mwrites/cat_breed", filename="model.pkl")

# assuming it's a fastai model
model = load_learner(model_path)
categories = model.dls.vocab


app = FastAPI()


@app.post("/predict")
async def post_predict_cat_breed(file: UploadFile):
    try:
        file_contents = await file.read()
        pred,idx,prob = model.predict(file_contents)
        return dict(zip(categories, map(float, prob)))
    except PIL.UnidentifiedImageError as e:
        raise HTTPException(status_code=400, detail="File is not an image")
