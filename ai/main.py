from fastapi import FastAPI

# from price_prediction.api import router as price_router
# from recommendation.api import router as recommendation_router
# from product_automation.api import router as product_automation_router

app = FastAPI(title="Seasonal Kitchen AI")


@app.get("/health")
def health():
    return {"status": "ok"}


# app.include_router(price_router, prefix="/price-prediction")
# app.include_router(recommendation_router, prefix="/recommendation")
# app.include_router(product_automation_router, prefix="/product-automation")
