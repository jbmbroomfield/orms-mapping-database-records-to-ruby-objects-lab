class Student
	attr_accessor :id, :name, :grade

	# def initialize(name, grade, id=nil)
	# 	self.name = name
	# 	self.grade = grade
	# 	self.id = id
	# end

	def self.new_from_db(row)
		id, name, grade = row
		song = self.new
		song.name = name
		song.grade = grade
		song.id = id
		song
	end

	def self.all
		sql = <<-SQL
			SELECT * FROM students
		SQL
		results = DB[:conn].execute(sql)
		results.map { |result| self.new_from_db(result) }
	end

	def self.find_by_name(name)
		sql = <<-SQL
			SELECT * FROM students WHERE name = ? LIMIT 1
		SQL
		result = DB[:conn].execute(sql, name)
		return nil if result.empty?
		self.new_from_db(result[0])
	end

	def self.all_students_in_grade_9
		self.all.filter { |student| student.grade == "9"}
	end

	def self.students_below_12th_grade
		self.all.filter { |student| student.grade.to_i < 12 }
	end

	def self.first_X_students_in_grade_10(x)
		self.all.filter { |student| student.grade == "10" }[0..x-1]
	end

	def self.first_student_in_grade_10
		self.first_X_students_in_grade_10(1)[0]
	end

	def self.all_students_in_grade_X(x)
		self.all.filter { |student| student.grade.to_i == x }
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
end
