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
