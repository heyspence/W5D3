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

    def initialize(arg)
        @id = arg['id']
        @title = arg['title']
        @body = arg['body']
        @author_id = arg['author_id']
    end
end

