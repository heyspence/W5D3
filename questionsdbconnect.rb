require 'sqlite3'
require 'singleton'

class QuestionsDatabase < sqlite3::Database
    include Singleton

    def initialize
        super('questions.db')
        self.type_translation = true
        self.results_as_hash = true
    end
end

class Question
    class self.all
        data= QuestionsDatabase.instance.execute('SELECT * FROM questions')
        data.map do {|ele|Question.new(ele)}

    end
    def initialize(arg)
        id=arg['id']
        title=arg['title']
        body=arg['body']
        author_id=arg['author_id']
    end
end
table1=QuestionsDatabase.new
