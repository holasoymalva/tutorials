import db from '../database/db.js';

class Product {
  static getAll() {
    const stmt = db.prepare('SELECT * FROM products');
    return stmt.all();
  }

  static getById(id) {
    const stmt = db.prepare('SELECT * FROM products WHERE id = ?');
    return stmt.get(id);
  }

  static create(name, description, price, stock) {
    const stmt = db.prepare(
      'INSERT INTO products (name, description, price, stock) VALUES (?, ?, ?, ?)'
    );
    const result = stmt.run(name, description, price, stock);
    return { id: result.lastInsertRowid, name, description, price, stock };
  }

  static update(id, name, description, price, stock) {
    const stmt = db.prepare(
      'UPDATE products SET name = ?, description = ?, price = ?, stock = ? WHERE id = ?'
    );
    const result = stmt.run(name, description, price, stock, id);
    return result.changes > 0;
  }

  static delete(id) {
    const stmt = db.prepare('DELETE FROM products WHERE id = ?');
    const result = stmt.run(id);
    return result.changes > 0;
  }
}

export default Product;
