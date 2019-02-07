require "pry"

class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    # create a new Student object given a row from the database
    newSong = self.new
    newSong.id = row[0]
    newSong.name = row[1]
    newSong.grade = row[2]
    newSong
  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
      Student.helper_func(DB[:conn].execute("SELECT * FROM students;"))
      # DB[:conn].execute(sql).map { |row| self.new_from_db(row) }
  end

  def self.helper_func(db_connect)
    db_connect.map { |row| self.new_from_db(row) }
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE students.name = ?
      LIMIT 1;
      SQL

      Student.helper_func(DB[:conn].execute(sql, name)).first
      # DB[:conn].execute(sql, name).map { |row| self.new_from_db(row) }.first
  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
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

  def self.all_students_in_grade_9
      Student.helper_func(DB[:conn].execute("SELECT * FROM students WHERE students.grade = 9;"))
      # DB[:conn].execute(sql).map { |row| self.new_from_db(row) }
  end

  def self.students_below_12th_grade
      Student.helper_func(DB[:conn].execute("SELECT * FROM students WHERE students.grade < 12;"))
      # DB[:conn].execute(sql).map { |row| self.new_from_db(row) }
  end

  def self.first_X_students_in_grade_10(x)
    Student.helper_func(DB[:conn].execute("SELECT * FROM students WHERE students.grade = 10 LIMIT #{x};"))
  end

  def self.first_student_in_grade_10
    # Student.helper_func(DB[:conn].execute("SELECT * FROM students WHERE students.grade = 10 LIMIT 1;"))[0]
    Student.helper_func(DB[:conn].execute("SELECT * FROM students WHERE students.grade = 10;")).first
    #differences are at the end. These two are the same.
  end

  def self.all_students_in_grade_X(x)
    Student.helper_func(DB[:conn].execute("SELECT * FROM students WHERE students.grade = #{x};"))
  end

end
