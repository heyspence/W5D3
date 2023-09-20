require 'sqlite3'
require 'singleton'
require 'byebug'

class QuestionsDatabase < SQLite3::Database
    include Singleton

    def initialize
        super('questions.db')
        self.type_translation = true
        self.results_as_hash = true
    end
end

class Question
    def self.all
        data = QuestionsDatabase.instance.execute('SELECT * FROM questions;')
        data.map { |ele| Question.new(ele) }
    end

    def self.find_by_id(id)
        question = QuestionsDatabase.instance.execute(<<-SQL, id)
        SELECT 
            * 
        FROM 
            questions 
        WHERE 
            id = ?
        SQL

        question.map { |ele| self.new(ele) }
    end

    def self.find_by_author_id(author_id)
        question = QuestionsDatabase.instance.execute(<<-SQL, author_id)
        SELECT 
            *
        FROM 
            questions
        WHERE
            author_id = ?;
        SQL
        Question.new(question[0])
    end

    attr_accessor :id, :title, :body, :author_id

    def initialize(arg)
        @id = arg['id']
        @title = arg['title']
        @body = arg['body']
        @author_id = arg['author_id']
    end


    def author
        User.find_by_user_id(id)
    end


    def replies
        Reply.find_by_question_id(id)
    end
end


class User
    def self.all
        data = QuestionsDatabase.instance.execute('SELECT * FROM users;')
        data.map {|ele| User.new(ele)}
    end

    def self.find_by_name(fname,lname)
        user = QuestionsDatabase.instance.execute(<<-SQL, fname,lname)
        SELECT
            *
        FROM
            users
        WHERE
            fname = ?
        AND lname = ?
        SQL
        User.new(user[0])
    end

    attr_accessor :id, :fname, :lname

    def initialize(arg)
        @id = arg['id']
        @fname = arg['fname']
        @lname = arg['lname']
    end

    def authored_questions
        Question.find_by_author_id(id)
    end

    def authored_replies
        Reply.find_by_user_id(id)
    end
end

class Reply
    def self.all
        data = QuestionsDatabase.instance.execute('SELECT * FROM replies;')
        data.map {|ele| Reply.new(ele)}
    end

    attr_accessor :id, :quesitons_id, :parent_reply_id, :body, :users_id
    
    def initialize(data)
        @id = data['id']
        @questions_id = data['questions_id']
        @parent_reply_id = data['parent_reply_id']
        @body = data['body']
        @users_id = data['users_id']
    end


    def self.find_by_user_id(user_id)
        reply=QuestionsDatabase.instance.execute(<<-SQL,user_id)
        SELECT
            *
        FROM
            replies
        WHERE
            users_id = ?
        SQL
    end


    def self.find_by_question_id(question_id)
        replies = QuestionsDatabase.instance.execute(<<-SQL,question_id)
        SELECT
            *
        FROM
            replies
        WHERE
            questions_id = ?
        SQL
    end


    def author
        User.find_by_user_id(users_id)
    end


    def question
        Reply.find_by_question_id(questions_id)
    end


    def parent_reply 
        Reply.find_by_user_id(parent_reply_id)
    end


    def child_replies
        children = QuestionsDatabase.instance.execute(<<-SQL, self.id)
        SELECT 
            *
        FROM 
            replies
        WHERE
            parent_reply_id = ?
        SQL
        children.map { |child| Reply.new(child) }
    end
end

