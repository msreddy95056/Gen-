-- ═══════════════════════════════════════════════════════════
-- ViksitLearn – AP Digital Inclusion Platform
-- MySQL Schema + Seed Data
-- Run: mysql -u root -p < database.sql
-- ═══════════════════════════════════════════════════════════

CREATE DATABASE IF NOT EXISTS viksitlearn
  CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE viksitlearn;

-- ── USERS ────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS users (
  id            INT AUTO_INCREMENT PRIMARY KEY,
  full_name     VARCHAR(150) NOT NULL,
  email         VARCHAR(200) NOT NULL UNIQUE,
  phone         VARCHAR(20),
  password_hash VARCHAR(255) NOT NULL,
  district      VARCHAR(100),
  category      VARCHAR(150),
  role          ENUM('learner','admin') DEFAULT 'learner',
  is_active     BOOLEAN DEFAULT TRUE,
  created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- ── COURSES ──────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS courses (
  id            INT AUTO_INCREMENT PRIMARY KEY,
  title         VARCHAR(200) NOT NULL,
  description   TEXT,
  category      VARCHAR(100),
  duration_hrs  INT DEFAULT 0,
  total_modules INT DEFAULT 0,
  icon          VARCHAR(10) DEFAULT '📚',
  color_from    VARCHAR(20) DEFAULT '#0d2438',
  color_to      VARCHAR(20) DEFAULT '#1a4a6b',
  sync_status   ENUM('offline','syncing','online') DEFAULT 'offline',
  is_active     BOOLEAN DEFAULT TRUE,
  created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ── TOPICS ───────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS topics (
  id            INT AUTO_INCREMENT PRIMARY KEY,
  course_id     INT NOT NULL,
  title         VARCHAR(200) NOT NULL,
  description   TEXT,
  content       LONGTEXT,
  duration_min  INT DEFAULT 30,
  order_index   INT DEFAULT 0,
  topic_type    ENUM('video','reading','quiz','assignment') DEFAULT 'reading',
  is_free       BOOLEAN DEFAULT FALSE,
  created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE
);

-- ── ENROLLMENTS ──────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS enrollments (
  id          INT AUTO_INCREMENT PRIMARY KEY,
  user_id     INT NOT NULL,
  course_id   INT NOT NULL,
  enrolled_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY uq_enrollment (user_id, course_id),
  FOREIGN KEY (user_id)   REFERENCES users(id)   ON DELETE CASCADE,
  FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE
);

-- ── TOPIC PROGRESS ───────────────────────────────────────────
CREATE TABLE IF NOT EXISTS topic_progress (
  id           INT AUTO_INCREMENT PRIMARY KEY,
  user_id      INT NOT NULL,
  topic_id     INT NOT NULL,
  course_id    INT NOT NULL,
  status       ENUM('not_started','in_progress','completed') DEFAULT 'not_started',
  score        INT NULL,
  completed_at TIMESTAMP NULL,
  updated_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  UNIQUE KEY uq_progress (user_id, topic_id),
  FOREIGN KEY (user_id)   REFERENCES users(id)   ON DELETE CASCADE,
  FOREIGN KEY (topic_id)  REFERENCES topics(id)  ON DELETE CASCADE,
  FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE
);

-- ── CERTIFICATES ─────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS certificates (
  id        INT AUTO_INCREMENT PRIMARY KEY,
  user_id   INT NOT NULL,
  course_id INT NOT NULL,
  issued_by VARCHAR(150) DEFAULT 'AP Skill Dev Corp',
  issued_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id)   REFERENCES users(id)   ON DELETE CASCADE,
  FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE
);

-- ════════════════════════════════════════════════════════════
-- SEED SAMPLE USERS
-- Passwords are bcrypt hashed (cost=12)
-- ════════════════════════════════════════════════════════════
INSERT INTO users (full_name, email, phone, password_hash, district, category, role) VALUES

('Ravi Kumar',
 'ravi@viksit.com', '+91 9876543210',
 '$2b$12$0iigOl465Zb7mYrd6WPag.4Y5FcT.ZHEVLtAyOj.MNarmacCP9yLi',
 'Visakhapatnam', 'IT & Software Development', 'learner'),

('Priya Sharma',
 'priya@viksit.com', '+91 9845123456',
 '$2b$12$WwhJq53CYwN5WvUBtsDKjuNF6J3vDbL2M4zctci33KcPCb2W.qQ8K',
 'Vijayawada', 'Digital Marketing', 'learner'),

('Suresh Reddy',
 'suresh@viksit.com', '+91 9912345678',
 '$2b$12$BS.FGqXiom1nWOTTY2O9qe.aYzRgxfMbJokbXqLKi7j85DnJDULga',
 'Guntur', 'IT & Software Development', 'learner'),

('Anitha Devi',
 'anitha@viksit.com', '+91 9700123456',
 '$2b$12$BYtQpbvI..QaImyKFybwZuil7UF.mPc/iZ3yhRxdXd3Q6mksTk1RG',
 'Tirupati', 'Healthcare & Nursing', 'learner'),

('Kiran Babu',
 'kiran@viksit.com', '+91 9988776655',
 '$2b$12$8j4Tow60RpqauIIPAeaAq.HLm.m7.nxjZKmBA2EHJAbwloaNa1eAG',
 'Kurnool', 'Entrepreneurship', 'learner'),

('Admin User',
 'admin@viksit.com', '+91 9000000001',
 '$2b$12$V.Ph29wfjGow.3bG1eXuRunaJDY4TyYDHDOPC8M9NOVIFB4ylJNZC',
 'Visakhapatnam', 'IT & Software Development', 'admin');

-- ════════════════════════════════════════════════════════════
-- SEED COURSES
-- ════════════════════════════════════════════════════════════
INSERT INTO courses (title,description,category,duration_hrs,total_modules,icon,color_from,color_to,sync_status) VALUES
('Full-Stack Web Development',
 'Master React, Node.js and MongoDB. Build real-world projects and become job-ready.',
 'IT & Software',42,6,'💻','#0d2438','#1a4a6b','offline'),

('Digital Marketing & SEO',
 'Google Ads, Analytics, SEO and social media marketing to grow businesses online.',
 'Digital Marketing',28,6,'📊','#1a0d38','#3a1a6b','offline'),

('AI & Machine Learning Basics',
 'Python, data science, TensorFlow and real-world ML for beginners.',
 'IT & Software',36,6,'🤖','#0d2e1a','#1a6b3a','syncing'),

('Mobile App Development',
 'Build cross-platform apps with Flutter and React Native end-to-end.',
 'IT & Software',30,6,'📱','#2e1a0d','#6b3a1a','offline'),

('Cloud Computing & DevOps',
 'AWS, Docker, Kubernetes and CI/CD pipelines for modern cloud engineers.',
 'IT & Software',24,6,'☁️','#1a2e0d','#3a6b1a','offline'),

('Cybersecurity Fundamentals',
 'Ethical hacking, network security and best practices to protect digital systems.',
 'IT & Software',20,6,'🔒','#2e0d1a','#6b1a3a','offline');

-- ════════════════════════════════════════════════════════════
-- SEED TOPICS – Course 1: Full-Stack Web Development
-- ════════════════════════════════════════════════════════════
INSERT INTO topics (course_id,title,description,content,duration_min,order_index,topic_type,is_free) VALUES
(1,'Introduction to Web Development',
 'How the web works — HTTP, clients, servers and the full-stack ecosystem.',
 '<h2>Welcome to Full-Stack Web Development</h2><p>The web runs on three core technologies: <strong>HTML</strong> (structure), <strong>CSS</strong> (styling), and <strong>JavaScript</strong> (behaviour). As a full-stack developer you master both the <em>frontend</em> (what users see) and the <em>backend</em> (server, database, APIs).</p><h3>🌐 How the Web Works</h3><p>When you type a URL, your browser sends an <strong>HTTP request</strong> to a server. The server processes it and returns an <strong>HTTP response</strong> — usually an HTML page. This request-response cycle is the backbone of every website.</p><h3>📦 Full-Stack Overview</h3><ul><li><strong>Frontend:</strong> HTML, CSS, JavaScript / React</li><li><strong>Backend:</strong> Python (Flask/Django) / Node.js</li><li><strong>Database:</strong> MySQL, PostgreSQL, MongoDB</li><li><strong>DevOps:</strong> Git, Docker, CI/CD</li></ul><h3>🎯 What You Will Build</h3><p>By the end of this course you will build and deploy a complete web application with authentication, REST APIs, and a responsive UI.</p>',
 45,1,'reading',TRUE),

(1,'HTML5 & CSS3 Foundations',
 'Semantic HTML, Flexbox, Grid and responsive design principles.',
 '<h2>HTML5 & CSS3 Foundations</h2><p>HTML5 introduces semantic tags that make your code readable and SEO-friendly.</p><h3>🏗 Semantic HTML</h3><pre><code>&lt;header&gt;\n  &lt;nav&gt;&lt;a href="/"&gt;Home&lt;/a&gt;&lt;/nav&gt;\n&lt;/header&gt;\n&lt;main&gt;\n  &lt;article&gt;\n    &lt;h1&gt;Article Title&lt;/h1&gt;\n    &lt;p&gt;Content here&lt;/p&gt;\n  &lt;/article&gt;\n&lt;/main&gt;\n&lt;footer&gt;Footer&lt;/footer&gt;</code></pre><h3>🎨 CSS Flexbox</h3><pre><code>.container {\n  display: flex;\n  justify-content: space-between;\n  align-items: center;\n  gap: 1rem;\n}</code></pre><h3>📐 CSS Grid</h3><pre><code>.grid {\n  display: grid;\n  grid-template-columns: repeat(3, 1fr);\n  gap: 1.5rem;\n}</code></pre><h3>📱 Responsive Design</h3><p>Use media queries to adapt layouts for different screen sizes:</p><pre><code>@media (max-width: 768px) {\n  .grid { grid-template-columns: 1fr; }\n}</code></pre>',
 60,2,'reading',FALSE),

(1,'JavaScript ES6+ & DOM Manipulation',
 'Arrow functions, promises, async/await and interactive DOM programming.',
 '<h2>Modern JavaScript (ES6+)</h2><h3>⚡ Key ES6 Features</h3><pre><code>// Arrow functions\nconst greet = (name) => `Hello, ${name}!`;\n\n// Destructuring\nconst { name, age } = user;\nconst [first, ...rest] = array;\n\n// Spread operator\nconst merged = { ...obj1, ...obj2 };\n\n// Optional chaining\nconst city = user?.address?.city;</code></pre><h3>🔄 Async/Await</h3><pre><code>async function fetchCourses() {\n  try {\n    const res = await fetch("/api/courses");\n    const data = await res.json();\n    console.log(data);\n  } catch (err) {\n    console.error("Error:", err);\n  }\n}</code></pre><h3>🖱 DOM Manipulation</h3><pre><code>const btn = document.getElementById("myBtn");\nbtn.addEventListener("click", () => {\n  document.querySelector(".box").classList.toggle("active");\n});</code></pre>',
 75,3,'video',FALSE),

(1,'React.js – Components & Hooks',
 'Build reusable components with useState, useEffect and React Router.',
 '<h2>React.js Fundamentals</h2><p>React is a JavaScript library for building component-based UIs. Every piece of the UI is a component.</p><h3>🧩 Functional Component</h3><pre><code>import { useState, useEffect } from "react";\n\nfunction CourseCard({ course }) {\n  const [enrolled, setEnrolled] = useState(false);\n\n  useEffect(() => {\n    // runs after render\n    document.title = course.title;\n  }, [course]);\n\n  return (\n    &lt;div className="card"&gt;\n      &lt;h3&gt;{course.title}&lt;/h3&gt;\n      &lt;button onClick={() => setEnrolled(!enrolled)}&gt;\n        {enrolled ? "Unenroll" : "Enroll"}\n      &lt;/button&gt;\n    &lt;/div&gt;\n  );\n}</code></pre><h3>🔀 React Router</h3><pre><code>import { BrowserRouter, Routes, Route } from "react-router-dom";\n\n&lt;BrowserRouter&gt;\n  &lt;Routes&gt;\n    &lt;Route path="/" element={&lt;Home /&gt;} /&gt;\n    &lt;Route path="/courses" element={&lt;Courses /&gt;} /&gt;\n    &lt;Route path="/courses/:id" element={&lt;CoursePage /&gt;} /&gt;\n  &lt;/Routes&gt;\n&lt;/BrowserRouter&gt;</code></pre>',
 90,4,'video',FALSE),

(1,'Node.js & REST API with Flask',
 'Build REST APIs, handle authentication with JWT and connect to MySQL.',
 '<h2>Building REST APIs with Python Flask</h2><h3>🐍 Flask Setup</h3><pre><code>pip install flask flask-mysqldb flask-jwt-extended\n\nfrom flask import Flask, jsonify, request\nfrom flask_jwt_extended import JWTManager, jwt_required\n\napp = Flask(__name__)\napp.config["JWT_SECRET_KEY"] = "your-secret"\njwt = JWTManager(app)\n\n@app.route("/api/courses", methods=["GET"])\n@jwt_required()\ndef get_courses():\n    # fetch from MySQL\n    return jsonify(courses)</code></pre><h3>🔐 JWT Authentication</h3><pre><code>from flask_jwt_extended import create_access_token\n\n@app.route("/api/auth/login", methods=["POST"])\ndef login():\n    email = request.json.get("email")\n    password = request.json.get("password")\n    # verify user in DB\n    token = create_access_token(identity=user_id)\n    return jsonify(token=token)</code></pre><h3>🗄 MySQL Connection</h3><pre><code>import mysql.connector\n\nconn = mysql.connector.connect(\n    host="localhost", user="root",\n    password="pass", database="viksitlearn"\n)\ncursor = conn.cursor(dictionary=True)\ncursor.execute("SELECT * FROM courses")\ncourses = cursor.fetchall()</code></pre>',
 80,5,'reading',FALSE),

(1,'Deployment & Final Project',
 'Deploy your app on cloud, set up CI/CD, and submit your capstone project.',
 '<h2>Deployment & Final Project</h2><h3>🚀 Deploying Flask Backend</h3><pre><code># Install gunicorn\npip install gunicorn\n\n# Run production server\ngunicorn -w 4 -b 0.0.0.0:5000 server:app</code></pre><h3>🐳 Docker Setup</h3><pre><code># Dockerfile\nFROM python:3.11-slim\nWORKDIR /app\nCOPY requirements.txt .\nRUN pip install -r requirements.txt\nCOPY . .\nCMD ["gunicorn", "-w", "4", "server:app"]\n\n# docker-compose.yml\nservices:\n  backend:\n    build: ./backend\n    ports: ["5000:5000"]\n    depends_on: [db]\n  db:\n    image: mysql:8\n    environment:\n      MYSQL_DATABASE: viksitlearn\n      MYSQL_ROOT_PASSWORD: secret</code></pre><h3>🎯 Capstone Project</h3><p>Build a complete <strong>Learning Management System</strong> with user auth, course listing, progress tracking and a deployed URL. Submit your GitHub repo link for review.</p>',
 120,6,'assignment',FALSE);

-- ════════════════════════════════════════════════════════════
-- SEED TOPICS – Course 2: Digital Marketing & SEO
-- ════════════════════════════════════════════════════════════
INSERT INTO topics (course_id,title,description,content,duration_min,order_index,topic_type,is_free) VALUES
(2,'Digital Marketing Overview','Fundamentals of the digital marketing landscape.',
 '<h2>Digital Marketing Overview</h2><p>Digital marketing covers all online channels to reach customers: Search, Social, Email, Content, and Paid Advertising.</p><h3>📣 Core Channels</h3><ul><li><strong>SEO</strong> – organic search visibility</li><li><strong>SEM / PPC</strong> – paid ads (Google Ads)</li><li><strong>Social Media</strong> – Instagram, Facebook, LinkedIn</li><li><strong>Email Marketing</strong> – newsletters & automation</li><li><strong>Content Marketing</strong> – blogs, videos, podcasts</li></ul><h3>📊 Key Metrics</h3><p>CTR (Click-Through Rate), CPC (Cost Per Click), ROAS (Return on Ad Spend), CAC (Customer Acquisition Cost), LTV (Lifetime Value).</p>',
 40,1,'reading',TRUE),

(2,'SEO – Search Engine Optimization','On-page, off-page SEO and keyword research strategies.',
 '<h2>SEO Fundamentals</h2><h3>🔍 Keyword Research</h3><p>Use tools like Google Keyword Planner, Ahrefs, or Semrush to find keywords with high volume and low competition.</p><h3>📄 On-Page SEO</h3><ul><li>Title tags (50-60 chars)</li><li>Meta descriptions (150-160 chars)</li><li>Header hierarchy (H1 → H2 → H3)</li><li>Image alt text</li><li>Internal linking</li></ul><h3>🔗 Off-Page SEO</h3><p>Build high-quality backlinks through guest posts, PR, and directory listings. Domain Authority (DA) score matters.</p><h3>⚡ Technical SEO</h3><ul><li>Page speed (Core Web Vitals)</li><li>Mobile-first design</li><li>Structured data (schema.org)</li><li>XML sitemaps & robots.txt</li></ul>',
 55,2,'reading',FALSE),

(2,'Google Ads & PPC Campaigns','Create, manage and optimise paid search campaigns.',
 '<h2>Google Ads (PPC)</h2><h3>🎯 Campaign Types</h3><ul><li>Search Campaigns – text ads on Google search</li><li>Display Campaigns – image ads across web</li><li>Shopping Campaigns – product listings</li><li>Video Campaigns – YouTube ads</li></ul><h3>💰 Bidding Strategies</h3><p>Manual CPC, Target CPA, Target ROAS, Maximize Clicks, Maximize Conversions.</p><h3>📝 Ad Copywriting</h3><p>Headlines (30 chars max), Descriptions (90 chars), strong CTAs, and relevant keywords in ad text.</p><h3>🔑 Quality Score</h3><p>Google rates your ads 1-10 based on CTR, ad relevance, and landing page experience. Higher score = lower CPC.</p>',
 60,3,'video',FALSE),

(2,'Social Media Marketing','Strategy for Instagram, LinkedIn, Facebook and YouTube.',
 '<h2>Social Media Marketing</h2><h3>📱 Platform Strategy</h3><ul><li><strong>Instagram</strong> – visual brand, Reels, Stories</li><li><strong>LinkedIn</strong> – B2B, professional networking</li><li><strong>Facebook</strong> – community, events, Marketplace</li><li><strong>YouTube</strong> – long-form video content</li></ul><h3>📅 Content Calendar</h3><p>Plan 30 days in advance. Mix: 40% educational, 30% entertaining, 20% promotional, 10% user-generated.</p><h3>📊 Analytics</h3><p>Track engagement rate, reach, impressions, follower growth, and conversions from each platform.</p>',
 50,4,'video',FALSE),

(2,'Email Marketing & Automation','Build email lists and create automated drip campaigns.',
 '<h2>Email Marketing</h2><h3>📧 List Building</h3><p>Use lead magnets (free ebooks, templates), pop-ups, and landing pages to grow your subscriber list.</p><h3>🤖 Automation Flows</h3><ul><li>Welcome sequence (3-5 emails)</li><li>Abandoned cart recovery</li><li>Re-engagement campaigns</li><li>Post-purchase follow-ups</li></ul><h3>📊 Key Metrics</h3><p>Open rate (avg 20-25%), Click rate (avg 2-3%), Unsubscribe rate (&lt;0.5%), Bounce rate.</p>',
 45,5,'reading',FALSE),

(2,'Analytics & Reporting','Google Analytics 4, data interpretation and campaign reporting.',
 '<h2>Analytics & Reporting</h2><h3>📈 Google Analytics 4</h3><p>GA4 is event-based. Track page views, sessions, conversions, and user journeys with custom events.</p><h3>📊 Key Reports</h3><ul><li>Acquisition – where users come from</li><li>Engagement – what users do</li><li>Monetisation – revenue metrics</li><li>Retention – returning users</li></ul><h3>📋 Monthly Report Template</h3><p>Include: Traffic overview, top channels, conversion rate, top pages, campaign performance, and recommendations for next month.</p>',
 50,6,'assignment',FALSE);

-- ════════════════════════════════════════════════════════════
-- SEED TOPICS – Course 3: AI & Machine Learning
-- ════════════════════════════════════════════════════════════
INSERT INTO topics (course_id,title,description,content,duration_min,order_index,topic_type,is_free) VALUES
(3,'Introduction to AI & ML','History, types, and real-world applications of AI.',
 '<h2>Introduction to AI & ML</h2><h3>🤖 What is AI?</h3><p>Artificial Intelligence (AI) is the simulation of human intelligence in machines. Machine Learning (ML) is a subset of AI where machines learn from data.</p><h3>📚 Types of ML</h3><ul><li><strong>Supervised Learning</strong> – learns from labelled data (e.g., spam detection)</li><li><strong>Unsupervised Learning</strong> – finds patterns in unlabelled data (e.g., clustering)</li><li><strong>Reinforcement Learning</strong> – learns by reward/penalty (e.g., game AI)</li></ul><h3>🌍 Real-World Applications</h3><p>Healthcare diagnosis, fraud detection, recommendation systems, self-driving cars, chatbots, image recognition.</p>',
 40,1,'reading',TRUE),

(3,'Python for Data Science','NumPy, Pandas and Matplotlib for data analysis.',
 '<h2>Python for Data Science</h2><h3>🐍 NumPy</h3><pre><code>import numpy as np\narr = np.array([1, 2, 3, 4, 5])\nprint(arr.mean(), arr.std())  # 3.0, 1.41</code></pre><h3>🐼 Pandas</h3><pre><code>import pandas as pd\ndf = pd.read_csv("students.csv")\nprint(df.head())\nprint(df.describe())\ndf_clean = df.dropna()  # remove null rows</code></pre><h3>📊 Matplotlib</h3><pre><code>import matplotlib.pyplot as plt\nplt.plot([1,2,3],[4,6,5])\nplt.xlabel("Month")\nplt.ylabel("Students")\nplt.title("Enrollment Trend")\nplt.show()</code></pre>',
 60,2,'reading',FALSE),

(3,'Machine Learning with Scikit-Learn','Linear regression, classification and model evaluation.',
 '<h2>ML with Scikit-Learn</h2><h3>🔢 Linear Regression</h3><pre><code>from sklearn.linear_model import LinearRegression\nfrom sklearn.model_selection import train_test_split\n\nX_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2)\nmodel = LinearRegression()\nmodel.fit(X_train, y_train)\nprint("Score:", model.score(X_test, y_test))</code></pre><h3>🌳 Decision Tree</h3><pre><code>from sklearn.tree import DecisionTreeClassifier\nclf = DecisionTreeClassifier(max_depth=3)\nclf.fit(X_train, y_train)\npredictions = clf.predict(X_test)</code></pre><h3>📊 Model Evaluation</h3><pre><code>from sklearn.metrics import accuracy_score, classification_report\nprint(accuracy_score(y_test, predictions))\nprint(classification_report(y_test, predictions))</code></pre>',
 75,3,'video',FALSE),

(3,'Neural Networks & Deep Learning','TensorFlow, Keras and building your first neural network.',
 '<h2>Neural Networks & Deep Learning</h2><h3>🧠 What is a Neural Network?</h3><p>Inspired by the brain — layers of interconnected neurons that learn complex patterns from data.</p><h3>🔧 Keras Model</h3><pre><code>import tensorflow as tf\n\nmodel = tf.keras.Sequential([\n    tf.keras.layers.Dense(128, activation="relu", input_shape=(784,)),\n    tf.keras.layers.Dropout(0.2),\n    tf.keras.layers.Dense(64, activation="relu"),\n    tf.keras.layers.Dense(10, activation="softmax")\n])\n\nmodel.compile(optimizer="adam",\n              loss="sparse_categorical_crossentropy",\n              metrics=["accuracy"])\n\nmodel.fit(X_train, y_train, epochs=10, batch_size=32)</code></pre>',
 90,4,'video',FALSE),

(3,'NLP & Computer Vision Basics','Text processing, sentiment analysis and image classification.',
 '<h2>NLP & Computer Vision</h2><h3>📝 NLP – Text Processing</h3><pre><code>from sklearn.feature_extraction.text import TfidfVectorizer\nfrom sklearn.naive_bayes import MultinomialNB\n\nvectorizer = TfidfVectorizer()\nX = vectorizer.fit_transform(texts)\nclf = MultinomialNB().fit(X, labels)</code></pre><h3>🖼 Image Classification (CNN)</h3><pre><code>model = tf.keras.Sequential([\n    tf.keras.layers.Conv2D(32,(3,3),activation="relu",input_shape=(28,28,1)),\n    tf.keras.layers.MaxPooling2D(2,2),\n    tf.keras.layers.Flatten(),\n    tf.keras.layers.Dense(64,activation="relu"),\n    tf.keras.layers.Dense(10,activation="softmax")\n])</code></pre>',
 70,5,'video',FALSE),

(3,'AI Capstone Project','Build and present a complete ML pipeline from data to deployment.',
 '<h2>AI Capstone Project</h2><h3>🎯 Project Brief</h3><p>Choose one of the following projects:</p><ul><li><strong>Project A</strong> – Student dropout prediction using ML</li><li><strong>Project B</strong> – Crop disease detection using CNN</li><li><strong>Project C</strong> – Sentiment analysis of AP government scheme feedback</li></ul><h3>📋 Deliverables</h3><ol><li>Jupyter Notebook with full pipeline</li><li>Model accuracy report</li><li>Flask API wrapping the model</li><li>Short presentation (5 slides)</li></ol><h3>🏅 Evaluation Criteria</h3><p>Data preprocessing (25%), Model performance (30%), Code quality (20%), Presentation (25%).</p>',
 120,6,'assignment',FALSE);

-- ════════════════════════════════════════════════════════════
-- SEED TOPICS – Course 4: Mobile App Development
-- ════════════════════════════════════════════════════════════
INSERT INTO topics (course_id,title,description,content,duration_min,order_index,topic_type,is_free) VALUES
(4,'Intro to Mobile Development','Native vs cross-platform, Flutter vs React Native overview.',
 '<h2>Mobile App Development Overview</h2><h3>📱 Native vs Cross-Platform</h3><ul><li><strong>Native:</strong> Swift (iOS), Kotlin (Android) — best performance</li><li><strong>Cross-Platform:</strong> Flutter, React Native — one codebase, two platforms</li></ul><h3>🐦 Why Flutter?</h3><p>Flutter by Google uses the Dart language and compiles to native ARM code. It has a rich widget library and hot-reload for fast development.</p>',
 35,1,'reading',TRUE),
(4,'Dart Language Basics','Variables, functions, classes and async programming in Dart.',
 '<h2>Dart Language</h2><pre><code>// Variables\nString name = "Ravi";\nint age = 25;\ndouble score = 98.5;\nbool isEnrolled = true;\n\n// Functions\nString greet(String name) => "Hello, $name!";\n\n// Class\nclass Student {\n  final String name;\n  int score;\n  Student(this.name, this.score);\n  void display() => print("$name: $score");\n}\n\n// Async\nFuture<void> fetchData() async {\n  final res = await http.get(Uri.parse(url));\n  print(res.body);\n}</code></pre>',
 50,2,'reading',FALSE),
(4,'Flutter Widgets & UI','Stateless, Stateful widgets, layouts and Material Design.',
 '<h2>Flutter Widgets</h2><pre><code>class CourseCard extends StatefulWidget {\n  @override\n  _CourseCardState createState() => _CourseCardState();\n}\n\nclass _CourseCardState extends State<CourseCard> {\n  bool enrolled = false;\n  @override\n  Widget build(BuildContext context) {\n    return Card(\n      child: Column(children: [\n        Text("Full-Stack Dev", style: TextStyle(fontSize:18)),\n        ElevatedButton(\n          onPressed: () => setState(() => enrolled = !enrolled),\n          child: Text(enrolled ? "Enrolled ✓" : "Enroll"),\n        )\n      ]),\n    );\n  }\n}</code></pre>',
 70,3,'video',FALSE),
(4,'State Management with Provider','Global state, ChangeNotifier and Consumer widgets.',
 '<h2>State Management – Provider</h2><pre><code>// Model\nclass CourseModel extends ChangeNotifier {\n  List<Course> _courses = [];\n  List<Course> get courses => _courses;\n\n  Future<void> fetchCourses() async {\n    _courses = await api.getCourses();\n    notifyListeners();\n  }\n}\n\n// Usage\nConsumer<CourseModel>(\n  builder: (ctx, model, _) => ListView.builder(\n    itemCount: model.courses.length,\n    itemBuilder: (_,i) => CourseCard(model.courses[i]),\n  ),\n)</code></pre>',
 65,4,'video',FALSE),
(4,'REST API Integration','HTTP calls, JSON parsing and connecting to Flask backend.',
 '<h2>API Integration in Flutter</h2><pre><code>import "package:http/http.dart" as http;\nimport "dart:convert";\n\nFuture<List<Course>> fetchCourses(String token) async {\n  final res = await http.get(\n    Uri.parse("http://localhost:5000/api/courses"),\n    headers: {"Authorization": "Bearer $token"},\n  );\n  if (res.statusCode == 200) {\n    final List data = json.decode(res.body)["courses"];\n    return data.map((e) => Course.fromJson(e)).toList();\n  }\n  throw Exception("Failed to load courses");\n}</code></pre>',
 60,5,'reading',FALSE),
(4,'App Deployment','Build APK/IPA, Play Store and App Store submission guide.',
 '<h2>App Deployment</h2><h3>🤖 Android (APK)</h3><pre><code>flutter build apk --release\n# Output: build/app/outputs/flutter-apk/app-release.apk</code></pre><h3>🍎 iOS (IPA)</h3><pre><code>flutter build ipa\n# Requires Mac + Xcode + Apple Developer account</code></pre><h3>📦 Play Store Steps</h3><ol><li>Create keystore & sign APK</li><li>Create app in Google Play Console</li><li>Upload APK, fill store listing</li><li>Submit for review (1-3 days)</li></ol>',
 90,6,'assignment',FALSE);

-- ════════════════════════════════════════════════════════════
-- SEED TOPICS – Course 5: Cloud Computing & DevOps
-- ════════════════════════════════════════════════════════════
INSERT INTO topics (course_id,title,description,content,duration_min,order_index,topic_type,is_free) VALUES
(5,'Cloud Computing Fundamentals','IaaS, PaaS, SaaS and major cloud providers overview.',
 '<h2>Cloud Computing Fundamentals</h2><h3>☁️ Service Models</h3><ul><li><strong>IaaS</strong> – Infrastructure (VMs, storage) — AWS EC2</li><li><strong>PaaS</strong> – Platform (runtime, DB) — Heroku, GCP App Engine</li><li><strong>SaaS</strong> – Software (Gmail, Salesforce)</li></ul><h3>🏢 Major Providers</h3><p>AWS (33% market), Azure (22%), Google Cloud (12%). Each has 200+ services covering compute, storage, AI, networking.</p>',
 40,1,'reading',TRUE),
(5,'AWS Core Services','EC2, S3, RDS, Lambda and IAM basics.',
 '<h2>AWS Core Services</h2><pre><code># Launch EC2 via AWS CLI\naws ec2 run-instances \\\n  --image-id ami-0c55b159cbfafe1f0 \\\n  --instance-type t2.micro \\\n  --key-name MyKeyPair\n\n# Upload to S3\naws s3 cp myfile.txt s3://my-bucket/\n\n# Invoke Lambda\naws lambda invoke \\\n  --function-name myFunction \\\n  --payload "{"key":"value"}" \\\n  output.json</code></pre>',
 70,2,'reading',FALSE),
(5,'Docker & Containerisation','Images, containers, Dockerfile and Docker Compose.',
 '<h2>Docker</h2><pre><code># Dockerfile for Flask app\nFROM python:3.11-slim\nWORKDIR /app\nCOPY requirements.txt .\nRUN pip install -r requirements.txt\nCOPY . .\nEXPOSE 5000\nCMD ["gunicorn","-w","4","server:app"]\n\n# Build & run\ndocker build -t viksitlearn-api .\ndocker run -p 5000:5000 viksitlearn-api\n\n# Docker Compose\nservices:\n  api:\n    build: ./backend\n    ports: ["5000:5000"]\n  db:\n    image: mysql:8\n    environment:\n      MYSQL_DATABASE: viksitlearn\n      MYSQL_ROOT_PASSWORD: secret</code></pre>',
 80,3,'video',FALSE),
(5,'Kubernetes Basics','Pods, deployments, services and scaling in K8s.',
 '<h2>Kubernetes (K8s)</h2><pre><code># deployment.yaml\napiVersion: apps/v1\nkind: Deployment\nmetadata:\n  name: viksitlearn-api\nspec:\n  replicas: 3\n  selector:\n    matchLabels:\n      app: api\n  template:\n    metadata:\n      labels: {app: api}\n    spec:\n      containers:\n      - name: api\n        image: viksitlearn-api:latest\n        ports:\n        - containerPort: 5000\n\n# Apply\nkubectl apply -f deployment.yaml\nkubectl get pods\nkubectl scale deployment viksitlearn-api --replicas=5</code></pre>',
 70,4,'video',FALSE),
(5,'CI/CD with GitHub Actions','Automate testing and deployment pipelines.',
 '<h2>CI/CD with GitHub Actions</h2><pre><code># .github/workflows/deploy.yml\nname: Deploy ViksitLearn\non:\n  push:\n    branches: [main]\njobs:\n  test-and-deploy:\n    runs-on: ubuntu-latest\n    steps:\n    - uses: actions/checkout@v3\n    - name: Set up Python\n      uses: actions/setup-python@v4\n      with: {python-version: "3.11"}\n    - name: Install & Test\n      run: |\n        pip install -r requirements.txt\n        pytest tests/\n    - name: Deploy to AWS\n      run: |\n        aws s3 sync . s3://my-bucket\n      env:\n        AWS_ACCESS_KEY_ID: ${{ secrets.AWS_KEY }}\n        AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET }}</code></pre>',
 65,5,'reading',FALSE),
(5,'Cloud Project: Deploy Full App','Deploy the complete ViksitLearn app on AWS with RDS.',
 '<h2>Capstone: Cloud Deployment</h2><h3>🎯 Goal</h3><p>Deploy the ViksitLearn Flask + MySQL app fully on AWS:</p><ol><li>MySQL on <strong>AWS RDS</strong></li><li>Flask API on <strong>AWS EC2</strong> (or Elastic Beanstalk)</li><li>Frontend on <strong>AWS S3 + CloudFront</strong></li><li>Domain with <strong>Route 53</strong></li><li>SSL via <strong>ACM</strong></li></ol><h3>📋 Deliverables</h3><p>Submit a live URL, architecture diagram, and monthly cost estimate.</p>',
 120,6,'assignment',FALSE);

-- ════════════════════════════════════════════════════════════
-- SEED TOPICS – Course 6: Cybersecurity
-- ════════════════════════════════════════════════════════════
INSERT INTO topics (course_id,title,description,content,duration_min,order_index,topic_type,is_free) VALUES
(6,'Cybersecurity Fundamentals','CIA triad, threat landscape and security principles.',
 '<h2>Cybersecurity Fundamentals</h2><h3>🔐 CIA Triad</h3><ul><li><strong>Confidentiality</strong> – only authorised access</li><li><strong>Integrity</strong> – data is accurate and unaltered</li><li><strong>Availability</strong> – systems are accessible when needed</li></ul><h3>🦠 Threat Landscape</h3><p>Malware, Phishing, Ransomware, DDoS, Man-in-the-Middle, SQL Injection, Zero-day exploits.</p>',
 40,1,'reading',TRUE),
(6,'Network Security','Firewalls, VPNs, IDS/IPS and secure protocols.',
 '<h2>Network Security</h2><h3>🛡 Firewalls</h3><p>Packet filtering, stateful inspection, and application-layer firewalls (WAF).</p><h3>🔒 VPN Types</h3><ul><li>Site-to-Site VPN – connects two networks</li><li>Remote Access VPN – individual users</li><li>SSL VPN – browser-based</li></ul><h3>🔑 Secure Protocols</h3><p>HTTPS (TLS 1.3), SSH (port 22), SFTP, DNSSEC, WPA3 for Wi-Fi.</p>',
 55,2,'reading',FALSE),
(6,'Ethical Hacking & Pen Testing','Reconnaissance, scanning, exploitation methodology (CEH).',
 '<h2>Ethical Hacking</h2><h3>🎯 Penetration Testing Phases</h3><ol><li><strong>Reconnaissance</strong> – passive (OSINT) and active info gathering</li><li><strong>Scanning</strong> – Nmap, Nessus port and vulnerability scans</li><li><strong>Exploitation</strong> – Metasploit, SQLMap</li><li><strong>Post-Exploitation</strong> – privilege escalation, persistence</li><li><strong>Reporting</strong> – document findings and remediation</li></ol><pre><code># Nmap scan\nnmap -sV -O -A 192.168.1.1\n\n# SQLMap test\nsqlmap -u "http://site.com/page?id=1" --dbs</code></pre>',
 80,3,'video',FALSE),
(6,'Web Application Security','OWASP Top 10, XSS, CSRF, SQL Injection and secure coding.',
 '<h2>Web Application Security</h2><h3>🔟 OWASP Top 10 (2023)</h3><ol><li>Broken Access Control</li><li>Cryptographic Failures</li><li>Injection (SQL, NoSQL, LDAP)</li><li>Insecure Design</li><li>Security Misconfiguration</li><li>Vulnerable Components</li><li>Auth Failures</li><li>Software Integrity Failures</li><li>Logging Failures</li><li>SSRF</li></ol><h3>🛡 Secure Flask Code</h3><pre><code># Use parameterised queries — NEVER string format\ncursor.execute("SELECT * FROM users WHERE email=%s", (email,))\n\n# Validate & sanitise all inputs\nfrom wtforms.validators import Email, Length</code></pre>',
 70,4,'video',FALSE),
(6,'Cryptography Basics','Symmetric, asymmetric encryption, hashing and PKI.',
 '<h2>Cryptography</h2><h3>🔑 Symmetric Encryption</h3><p>Same key to encrypt/decrypt. Fast. Examples: AES-256, ChaCha20.</p><h3>🗝 Asymmetric Encryption</h3><p>Public key encrypts, private key decrypts. Examples: RSA-2048, ECC. Used in TLS, SSH.</p><h3>#️⃣ Hashing</h3><pre><code>import bcrypt\nhash = bcrypt.hashpw(password.encode(), bcrypt.gensalt())\nbcrypt.checkpw(password.encode(), hash)  # True/False</code></pre>',
 60,5,'reading',FALSE),
(6,'Security Audit & Compliance','ISO 27001, GDPR, audit checklists and incident response.',
 '<h2>Security Audit & Compliance</h2><h3>📋 Key Standards</h3><ul><li><strong>ISO 27001</strong> – Information security management</li><li><strong>GDPR</strong> – Data protection and privacy (EU)</li><li><strong>IT Act 2000</strong> – India cybercrime laws</li><li><strong>CERT-In</strong> – Indian Computer Emergency Response</li></ul><h3>🚨 Incident Response Plan</h3><ol><li>Preparation</li><li>Detection & Analysis</li><li>Containment</li><li>Eradication</li><li>Recovery</li><li>Post-Incident Review</li></ol>',
 55,6,'assignment',FALSE);

-- ════════════════════════════════════════════════════════════
-- AUTO-ENROLL ALL SAMPLE USERS IN ALL 6 COURSES
-- ════════════════════════════════════════════════════════════
INSERT IGNORE INTO enrollments (user_id, course_id)
SELECT u.id, c.id
FROM users u
CROSS JOIN courses c
WHERE u.email IN (
  'ravi@viksit.com','priya@viksit.com','suresh@viksit.com',
  'anitha@viksit.com','kiran@viksit.com','admin@viksit.com'
)
AND c.is_active = 1;

-- ════════════════════════════════════════════════════════════
-- SEED SAMPLE TOPIC PROGRESS for ravi@viksit.com (user_id=1)
-- Makes the dashboard look realistic with partial progress
-- ════════════════════════════════════════════════════════════
INSERT IGNORE INTO topic_progress (user_id, topic_id, course_id, status, completed_at) VALUES
-- Course 1 (Full-Stack): 4 of 6 topics done
(1, 1, 1, 'completed', DATE_SUB(NOW(), INTERVAL 5 DAY)),
(1, 2, 1, 'completed', DATE_SUB(NOW(), INTERVAL 4 DAY)),
(1, 3, 1, 'completed', DATE_SUB(NOW(), INTERVAL 3 DAY)),
(1, 4, 1, 'completed', DATE_SUB(NOW(), INTERVAL 2 DAY)),
(1, 5, 1, 'in_progress', NULL),
-- Course 2 (Digital Marketing): 3 of 6 done
(1, 7,  2, 'completed', DATE_SUB(NOW(), INTERVAL 6 DAY)),
(1, 8,  2, 'completed', DATE_SUB(NOW(), INTERVAL 5 DAY)),
(1, 9,  2, 'completed', DATE_SUB(NOW(), INTERVAL 3 DAY)),
(1, 10, 2, 'in_progress', NULL),
-- Course 3 (AI & ML): 2 of 6 done
(1, 13, 3, 'completed', DATE_SUB(NOW(), INTERVAL 7 DAY)),
(1, 14, 3, 'completed', DATE_SUB(NOW(), INTERVAL 6 DAY)),
-- Course 4 (Mobile): 5 of 6 done
(1, 19, 4, 'completed', DATE_SUB(NOW(), INTERVAL 10 DAY)),
(1, 20, 4, 'completed', DATE_SUB(NOW(), INTERVAL 9 DAY)),
(1, 21, 4, 'completed', DATE_SUB(NOW(), INTERVAL 8 DAY)),
(1, 22, 4, 'completed', DATE_SUB(NOW(), INTERVAL 7 DAY)),
(1, 23, 4, 'completed', DATE_SUB(NOW(), INTERVAL 6 DAY)),
-- Course 5 (Cloud): 1 of 6 done
(1, 25, 5, 'completed', DATE_SUB(NOW(), INTERVAL 2 DAY)),
-- Course 6 (Cybersecurity): 3 of 6 done
(1, 31, 6, 'completed', DATE_SUB(NOW(), INTERVAL 4 DAY)),
(1, 32, 6, 'completed', DATE_SUB(NOW(), INTERVAL 3 DAY)),
(1, 33, 6, 'completed', DATE_SUB(NOW(), INTERVAL 1 DAY));

-- Certificate for ravi (completed Mobile App Dev — 5/6, close enough for demo)
-- (Only issued when 6/6 done — this is just for demo display via the certs table)
