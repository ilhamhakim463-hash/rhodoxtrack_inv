"""
db.py — RhodoxTrack Database Schema & Models
MySQL via SQLAlchemy, port 3307
"""
from flask_sqlalchemy import SQLAlchemy
from datetime import datetime

db = SQLAlchemy()


class User(db.Model):
    __tablename__ = "users"
    id         = db.Column(db.Integer, primary_key=True)
    username   = db.Column(db.String(80), unique=True, nullable=False)
    password   = db.Column(db.String(255), nullable=False)
    role       = db.Column(db.Enum("admin", "kasir"), default="kasir", nullable=False)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)

    def is_admin(self):
        return self.role == "admin"


class Category(db.Model):
    __tablename__ = "categories"
    id       = db.Column(db.Integer, primary_key=True)
    name     = db.Column(db.String(100), unique=True, nullable=False)
    products = db.relationship("Product", backref="category", lazy=True)


class Product(db.Model):
    __tablename__ = "products"
    id            = db.Column(db.Integer, primary_key=True)
    name          = db.Column(db.String(150), nullable=False)
    sku           = db.Column(db.String(50), unique=True, nullable=False)
    barcode       = db.Column(db.String(50), unique=True, nullable=True)
    category_id   = db.Column(db.Integer, db.ForeignKey("categories.id"), nullable=False)
    unit          = db.Column(db.String(20), nullable=False, default="pcs")
    min_stock     = db.Column(db.Float, default=10)
    current_stock = db.Column(db.Float, default=0)
    avg_cost      = db.Column(db.Float, default=0)
    selling_price = db.Column(db.Float, default=0)
    is_active     = db.Column(db.Boolean, default=True)
    created_at    = db.Column(db.DateTime, default=datetime.utcnow)

    @property
    def stock_status(self):
        if self.current_stock <= 0:
            return "habis"
        elif self.current_stock <= self.min_stock:
            return "rendah"
        return "aman"

    @property
    def margin_pct(self):
        if self.avg_cost > 0 and self.selling_price > 0:
            return round((self.selling_price - self.avg_cost) / self.selling_price * 100, 1)
        return 0.0


class InventoryTransaction(db.Model):
    __tablename__ = "inventory_transactions"
    id          = db.Column(db.Integer, primary_key=True)
    product_id  = db.Column(db.Integer, db.ForeignKey("products.id"), nullable=False)
    type        = db.Column(db.Enum("purchase", "sale", "adjustment", "return"), nullable=False)
    qty         = db.Column(db.Float, nullable=False)
    unit_price  = db.Column(db.Float, default=0)
    total_price = db.Column(db.Float, default=0)
    note        = db.Column(db.String(255))
    user_id     = db.Column(db.Integer, db.ForeignKey("users.id"), nullable=False)
    created_at  = db.Column(db.DateTime, default=datetime.utcnow)

    product = db.relationship("Product", backref="transactions")
    user    = db.relationship("User",    backref="transactions")


class HPPLog(db.Model):
    __tablename__ = "hpp_log"
    id             = db.Column(db.Integer, primary_key=True)
    product_id     = db.Column(db.Integer, db.ForeignKey("products.id"), nullable=False)
    old_avg_cost   = db.Column(db.Float)
    new_avg_cost   = db.Column(db.Float)
    old_stock      = db.Column(db.Float)
    new_stock      = db.Column(db.Float)
    transaction_id = db.Column(db.Integer, db.ForeignKey("inventory_transactions.id"))
    created_at     = db.Column(db.DateTime, default=datetime.utcnow)

    product     = db.relationship("Product")
    transaction = db.relationship("InventoryTransaction")


class AuditTrail(db.Model):
    __tablename__ = "audit_trail"
    id         = db.Column(db.Integer, primary_key=True)
    user_id    = db.Column(db.Integer, db.ForeignKey("users.id"))
    action     = db.Column(db.String(100), nullable=False)
    target     = db.Column(db.String(100))
    target_id  = db.Column(db.Integer)
    detail     = db.Column(db.Text)
    ip_address = db.Column(db.String(45))
    created_at = db.Column(db.DateTime, default=datetime.utcnow)

    user = db.relationship("User")


def update_avg_cost(product, new_qty, new_unit_price, transaction, db_session):
    old_stock    = product.current_stock
    old_avg_cost = product.avg_cost
    if old_stock + new_qty > 0:
        new_avg = (old_stock * old_avg_cost + new_qty * new_unit_price) / (old_stock + new_qty)
    else:
        new_avg = new_unit_price
    db_session.add(HPPLog(
        product_id=product.id, old_avg_cost=old_avg_cost,
        new_avg_cost=round(new_avg, 2), old_stock=old_stock,
        new_stock=old_stock + new_qty, transaction_id=transaction.id
    ))
    product.avg_cost      = round(new_avg, 2)
    product.current_stock = round(old_stock + new_qty, 3)


def log_audit(user_id, action, target, target_id, detail, ip, db_session):
    db_session.add(AuditTrail(
        user_id=user_id, action=action, target=target,
        target_id=target_id, detail=detail, ip_address=ip
    ))


def hpp_report(product):
    return {
        "product_id"   : product.id,
        "product_name" : product.name,
        "current_stock": product.current_stock,
        "avg_cost"     : product.avg_cost,
        "total_hpp"    : round(product.current_stock * product.avg_cost, 2),
        "selling_price": product.selling_price,
        "margin_pct"   : product.margin_pct,
    }
