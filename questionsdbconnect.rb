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
        question.map { |datum| Question.new(datum) }
    end

    attr_accessor :id, :title, :body, :author_id

    def initialize(arg)
        @id = arg['id']
        @title = arg['title']
        @body = arg['body']
        @author_id = arg['author_id']
    end
end


class Users
    def self.all
        data = QuestionsDatabase.instance.execute('SELECT * FROM users;')
        data.map {|ele| Users.new(ele)}
    end

    def self.find_by_name(fname,lname)
        user=QuestionsDatabase.instance.execute(<<-SQL, fname,lname)
        SELECT
            *
        FROM
            users
        WHERE
            fname = ?
        AND lname = ?
        SQL
        user.map { |ele| self.new(ele) }
    end

    attr_accessor :id, :fname, :lname

    def initialize(arg)
        @id=arg['id']
        @fname=arg['fname']
        @lname=arg['lname']
    end
end

class Reply
    def self.all
        data = QuestionsDatabase.instance.execute('SELECT * FROM replies;')
        data.map {|ele| Reply.new(ele)}
    end

    def initialize(data)
        @id = data['id']
        @questions_id = data['questions_id']
        @parent_reply_id = data['parent_reply_id']
        @body = data['body']
        @users_id = data['users_id']
    end
end

