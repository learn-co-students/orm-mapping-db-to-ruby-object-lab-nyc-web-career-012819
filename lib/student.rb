require 'pry'

class Student
  attr_accessor :id, :name, :grade

  # INSTANCE METHODS ********************************************

  def initialize(attributes = {})
    @id = attributes[:id]
    @name = attributes[:name]
    @grade = attributes[:grade]
  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade) 
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end

  # CLASS METHODS ********************************************

  def self.all
    Student.instantiate(DB[:conn].execute("SELECT * FROM students"))
  end

  def self.new_from_db(row)
    Student.new({ :id => row[0], :name => row[1], :grade => row[2] })
  end

  def self.find_by_name(name)
    sql = <<-SQL
      SELECT * FROM students WHERE name = ?
    SQL

    Student.instantiate(DB[:conn].execute(sql, name)).first
  end

  def self.all_students_in_grade_9
    Student.instantiate(DB[:conn].execute("SELECT * FROM students WHERE grade = 9;"))
  end

  def self.students_below_12th_grade
    Student.instantiate(DB[:conn].execute("SELECT * FROM students WHERE grade < 12;"))
  end

  def self.first_X_students_in_grade_10(limit)
    Student.instantiate(DB[:conn].execute("SELECT * FROM students WHERE grade = 10 LIMIT #{limit};"))
  end

  def self.first_student_in_grade_10
    Student.instantiate(DB[:conn].execute("SELECT * FROM students WHERE grade = 10;")).first
  end

  def self.all_students_in_grade_X(grade)
    Student.instantiate(DB[:conn].execute("SELECT * FROM students WHERE grade = #{grade};"))
  end
  
  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end

  # PRIVATE METHODS ********************************************

  private

  def self.instantiate(db_rows)
    db_rows.map { |db_row| Student.new_from_db(db_row) }
  end
end
