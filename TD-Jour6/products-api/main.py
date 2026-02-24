from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from typing import Optional

app = FastAPI(title="CloudShop Products API")


class Product(BaseModel):
    name: str
    description: Optional[str] = None
    price: float
    stock: int = 0


# In-memory store — à remplacer par une vraie base de données
products_db: dict[int, dict] = {}
_next_id = 1


@app.get("/health")
def health():
    return {"status": "ok"}


@app.get("/products")
def list_products():
    return list(products_db.values())


@app.get("/products/{product_id}")
def get_product(product_id: int):
    product = products_db.get(product_id)
    if not product:
        raise HTTPException(status_code=404, detail="Product not found")
    return product


@app.post("/products", status_code=201)
def create_product(product: Product):
    global _next_id
    new_product = {"id": _next_id, **product.model_dump()}
    products_db[_next_id] = new_product
    _next_id += 1
    return new_product


@app.put("/products/{product_id}")
def update_product(product_id: int, product: Product):
    if product_id not in products_db:
        raise HTTPException(status_code=404, detail="Product not found")
    products_db[product_id] = {"id": product_id, **product.model_dump()}
    return products_db[product_id]


@app.delete("/products/{product_id}", status_code=204)
def delete_product(product_id: int):
    if product_id not in products_db:
        raise HTTPException(status_code=404, detail="Product not found")
    del products_db[product_id]
