CREATE TABLE Clients (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name VARCHAR(255),
  contact_info VARCHAR(255)
);

CREATE TABLE Products (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name VARCHAR(255),
  description TEXT,
  cost DECIMAL(10, 2)
);

CREATE TABLE Orders (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  order_date DATE,
  status_ VARCHAR(50),
  client_id INTEGER REFERENCES Clients(id),
  product_id INTEGER REFERENCES Products(id)
);

CREATE TABLE Employees (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name VARCHAR(255),
  position VARCHAR(255),
  contact_info VARCHAR(255)
);

CREATE TABLE EmployeeOrders (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  employee_id INTEGER REFERENCES Employees(id),
  order_id INTEGER REFERENCES Orders(id),
  role VARCHAR(50)
);

-- Заполняем таблицу "Clients"
INSERT INTO Clients (name, contact_info) VALUES
  ('Client1', '123-456-7890'),
  ('Client2', '456-789-0123'),
  ('Client3', '789-012-3456'),
  ('Client4', '012-345-6789'),
  ('Client5', '234-567-8901');

-- Заполняем таблицу "Products"
INSERT INTO Products (name, description, cost) VALUES
  ('Product1', 'Description1', 100.50),
  ('Product2', 'Description2', 75.25),
  ('Product3', 'Description3', 120.75),
  ('Product4', 'Description4', 90.00),
  ('Product5', 'Description5', 150.00);

-- Заполняем таблицу "Orders"
INSERT INTO Orders (order_date, status, client_id, product_id) VALUES
  ('2024-01-01', 'Processing', 1, 3),
  ('2024-01-02', 'Shipped', 2, 1),
  ('2024-01-03', 'Pending', 3, 5),
  ('2024-01-04', 'Completed', 4, 2),
  ('2024-01-05', 'Processing', 5, 4);

-- Заполняем таблицу "Employees"
INSERT INTO Employees (name, position, contact_info) VALUES
  ('Alexander Ivanov', 'Manager', 'manager1@example.com'),
  ('Ekaterina Smirnova', 'Developer', 'developer1@example.com'),
  ('Dmitry Petrov', 'Developer', 'developer2@example.com'),
  ('Anna Kuznetsova', 'Manager', 'manager2@example.com'),
  ('Igor Morozov', 'QA Engineer', 'qa1@example.com');

-- Заполняем таблицу "EmployeeOrders"
INSERT INTO EmployeeOrders (employee_id, order_id, role) VALUES
  (1, 1, 'Manager'),
  (2, 1, 'Developer'),
  (3, 2, 'Developer'),
  (4, 3, 'Manager'),
  (5, 4, 'QA Engineer');


-- Триггер перед удалением из таблицы "Clients"
DELIMITER //
CREATE TRIGGER before_delete_clients
BEFORE DELETE ON Clients
FOR EACH ROW
BEGIN
  DECLARE client_has_orders INT;

  -- Проверяем, есть ли у клиента связанные заказы
  SELECT COUNT(*) INTO client_has_orders FROM Orders WHERE client_id = OLD.id;

  -- Если у клиента есть заказы, отменяем удаление
  IF client_has_orders > 0 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Не удается удалить клиента. У клиента есть связанные заказы.';
  END IF;
END;
//
DELIMITER ;

-- Триггер перед удалением из таблицы "Products"
DELIMITER //
CREATE TRIGGER before_delete_products
BEFORE DELETE ON Products
FOR EACH ROW
BEGIN
  DECLARE product_has_orders INT;

  -- Проверяем, есть ли у продукта связанные заказы
  SELECT COUNT(*) INTO product_has_orders FROM Orders WHERE product_id = OLD.id;

  -- Если у продукта есть заказы, отменяем удаление
  IF product_has_orders > 0 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Не удается удалить продукт. С продуктом связаны заказы.';
  END IF;
END;
//
DELIMITER ;

-- Триггер перед обновлением таблицы "Orders"
DELIMITER //
CREATE TRIGGER before_update_orders
BEFORE UPDATE ON Orders
FOR EACH ROW
BEGIN
  -- Проверяем, что статус заказа является допустимым
  IF NEW.status NOT IN ('Processing', 'Shipped', 'Pending', 'Completed') THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Недействительный статус заказа.';
  END IF;
END;
//
DELIMITER ;

-- Триггер перед обновлением таблицы "Employees"
DELIMITER //
CREATE TRIGGER before_update_employees
BEFORE UPDATE ON Employees
FOR EACH ROW
BEGIN
  -- Проверяем, что должность сотрудника является допустимой
  IF NEW.position NOT IN ('Manager', 'Developer', 'QA Engineer') THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Недопустимая должность сотрудника.';
  END IF;
END;
//
DELIMITER ;

DELIMITER //
CREATE TRIGGER before_update_orders_status
BEFORE UPDATE ON Orders
FOR EACH ROW
BEGIN
  IF OLD.status = 'Completed' THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Не удается обновить статус выполненного заказа.';
  END IF;
END;
//
DELIMITER ;

DELIMITER //
CREATE TRIGGER before_insert_update_products_name_unique
BEFORE INSERT OR UPDATE ON Products
FOR EACH ROW
BEGIN
  IF (SELECT COUNT(*) FROM Products WHERE name = NEW.name AND id != NEW.id) > 0 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Продукт с таким названием уже существует.';
  END IF;
END;
//
DELIMITER ;

