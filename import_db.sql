PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS users;

CREATE TABLE users(
    id INTEGER PRIMARY KEY,
    fname TEXT NOT NULL,
    lname TEXT NOT NULL
);

DROP TABLE IF EXISTS questions;

CREATE TABLE questions(
    id INTEGER PRIMARY KEY,
    title TEXT NOT NULL,
    body TEXT NOT NULL,
    author_id INTEGER NOT NULL, 

    FOREIGN KEY(author_id) REFERENCES users(id)
);

DROP TABLE IF EXISTS question_follows;

CREATE TABLE question_follows(
    id INTEGER PRIMARY KEY,
    questions_id INTEGER,
    users_id INTEGER,

    FOREIGN KEY(questions_id) REFERENCES questions(id)
    FOREIGN KEY(users_id) REFERENCES users(id)
);

DROP TABLE IF EXISTS replies;

CREATE TABLE replies(
    id INTEGER PRIMARY KEY,
    questions_id INTEGER NOT NULL,
    parent_reply_id INTEGER,
    body TEXT NOT NULL,
    users_id INTEGER NOT NULL,

    FOREIGN KEY(users_id) REFERENCES users(id)
    FOREIGN KEY(questions_id) REFERENCES questions(id)
);

DROP TABLE IF EXISTS question_likes;

CREATE TABLE question_likes(
    id INTEGER PRIMARY KEY,
    users_id INTEGER NOT NULL,
    questions_id INTEGER NOT NULL,

    FOREIGN KEY(users_id) REFERENCES users(id)
    FOREIGN KEY(questions_id) REFERENCES questions(id)
);


INSERT INTO 
    users (fname, lname)
VALUES
    ('Stephen', 'Chao'),
    ('Spencer', 'Heywood'),
    ('Amin', 'Babar');

INSERT INTO 
    questions (title, body, author_id)
VALUES
    ('new_question','I have a question',1),
    ('next_question','What to eat',2),
    ('final_question','How to get to Penn station',3);

INSERT INTO 
    replies (questions_id,parent_reply_id,body,users_id)
VALUES
    (1,NULL,'How can I help you',1),
    (2,NULL,'Pizza',2),
    (3,NULL,'follow the yellow brick road',3);
