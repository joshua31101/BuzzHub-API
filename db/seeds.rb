# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'open-uri'
require 'nokogiri'

# All majors offered at Georgia Tech
# Web links to parse for course name, desc, and credit hours
web_link = 'http://www.catalog.gatech.edu/coursesaz/'
department_abbrs = [
  'acct',
  'ae',
  'as',
  'apph',
  'ase',
  'arbc',
  'arch',
  'biol',
  'bmej',
  'bmed',
  'bmem',
  'bc',
  'bcp',
  'cetl',
  'chbe',
  'chem',
  'chin',
  'cp',
  'cee',
  'coa',
  'coe',
  'cos',
  'cx',
  'cse',
  'cs',
  'coop',
  'ucga',
  'eas',
  'econ',
  'ecep',
  'ece',
  'engl',
  'fs',
  'free',
  'fren',
  'gt',
  'gtl',
  'grmn',
  'hp',
  'hs',
  'hin',
  'hist',
  'hts',
  'hum',
  'id',
  'isye',
  'inta',
  'il',
  'intn',
  'imba',
  'ipco',
  'ipfs',
  'ipin',
  'ipsa',
  'iac',
  'japn',
  'kor',
  'latn',
  'ls',
  'ling',
  'lcc',
  'lmc',
  'mgt',
  'mot',
  'mldr',
  'mse',
  'math',
  'me',
  'mp',
  'msl',
  'ml',
  'musi',
  'ns',
  'neur',
  'nre',
  'pers',
  'phil',
  'phys',
  'pol',
  'ptfe',
  'dopp',
  'psyc',
  'pubj',
  'pubp',
  'russ',
  'sci',
  'sls',
  'ss',
  'soc',
  'span'
]

p '@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@'
p '************** Fetching course name, title, credit hours, and desc **************'
p '@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@'

department_abbrs.each do |abbr|
  page = Nokogiri::HTML(open(web_link + abbr))
  subject = page.search('.page-title').text.split('(')
  department_name = subject[0].strip
  department_abbr = subject[1][0..subject[1].size-2]
  department = Department.create(name: department_name, abbr: department_abbr)
  p "creating department #{department_name} #{department_abbr}"

  _courses = page.search('.courseblock')
  # Fetch course name, title, credit hours, and desc
  _courses.each do |course|
    course_info = course.at('.courseblocktitle').text.split('.')
    course_desc = course.at('.courseblockdesc').text.gsub(/\n/, '')
    course_name = course_info[1].lstrip
    course_hours = course_info[2].gsub(/Credit|Hours|Hour/, '').strip
    _course_title = course_info[0]
    course_num = _course_title.split(/[[:space:]]/)[1]

    p "-- creating course #{department_abbr} #{course_num} #{course_name} - #{course_hours}"
    Course.create(
      department_id: department.id,
      d_abbr: department_abbr,
      number: course_num,
      name: course_name,
      hours: course_hours,
      desc: course_desc
    )
  end
end

p '@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@'
p '************** Create lecturers & managed courses **************'
p '@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@'

Course.all.each do |c|
  course_title = c.d_abbr + c.number.to_s
  page = Nokogiri::HTML(open("https://critique.gatech.edu/course.php?id=#{course_title}"))
  main_table = page.search('table').last
  trs = main_table.search('tr')

  p "Searching for lecturers in #{course_title}"

  (1..trs.count-1).each do |i|
    td = trs[i].search('td')
    lecturer_name = td[0].text.split(', ')
    avg_grade = td[2].text.to_f
    a_grade = td[3].text.to_i
    b_grade = td[4].text.to_i
    c_grade = td[5].text.to_i
    d_grade = td[6].text.to_i
    f_grade = td[7].text.to_i
    w_grade = td[8].text.to_i
  
    lecturer = Lecturer.find_or_create_by(
      last_name: lecturer_name[0],
      first_name: lecturer_name[1]
    )
    ManagedCourse.find_or_create_by(
      avg_gpa: avg_grade,
      gpa_a: a_grade,
      gpa_b: b_grade,
      gpa_c: c_grade,
      gpa_d: d_grade,
      gpa_f: f_grade,
      gpa_w: w_grade,
      lecturer_id: lecturer.id,
      course_id: c.id
    )
    p "Creating lecturer #{lecturer_name} with managed course #{c.name}"
  end
end


def get_prof_url(page)
  'http://www.ratemyprofessors.com/filter/professor/?page=' + page.to_s + '&filter=teacherlastname_sort_s+asc&query=*%3A*&queryoption=TEACHER&queryBy=schoolId&sid=361'
end

def get_review_url(tid)
  'http://www.ratemyprofessors.com/paginate/professors/ratings?tid=' + tid.to_s + '&page=1&max=1000&cache=false'
end

p '************* getting professors from RateMyProfessor *************'

page = 1
remaining = 1
while remaining > 0
  json_prof = JSON.load(open(get_prof_url(page)))

  professors = json_prof['professors']
  professors.each do |prof|
    fname = prof['tFname']
    lname = prof['tLname']
    tid = prof['tid']
    p "Fetching a prof #{fname} #{lname} #{tid}"

    lecturer = Lecturer.where(first_name: fname, last_name: lname).first
    if lecturer.present?
      json_reviews = JSON.load(open(get_review_url(tid)))
      ratings = json_reviews['ratings']
      ratings.each do |r|
        class_name = r['rClass']# e.g. CS1234
        comment = r['rComments']# comment or "No comments"
        num_starts_at = class_name.index(/\d/)
        break unless num_starts_at
        number = class_name[num_starts_at..class_name.size]
        break unless number.to_s.length < 5
        d_abbr = class_name[0..num_starts_at - 1]
        break unless (number.to_s + d_abbr.to_s).length < 9
        overall_rating = r['rOverall'].floor
        difficulty = r['rEasy'].floor
        date = r['rDate'].split('/')

        year = date[2].to_i
        month = date[0].to_i
        semester = if month < 6
          0
        elsif month < 8
          1
        else
          2
        end

        p "- review for #{class_name} #{date}, overall: #{overall_rating}, difficulty: #{difficulty}"
        c = Course.where(d_abbr: d_abbr, number: number).first
        if c.present?
          course = ManagedCourse.where(course_id: c.id, lecturer_id: lecturer.id).first
          if course.present?
            p '***** creating a review *****'
            Review.find_or_create_by(
              overall: overall_rating,
              difficulty: difficulty,
              desc: comment,
              year: year,
              semester: semester,
              managed_course_id: course.id
            )
          end
        end
      end
    end
  end
  remaining = json_prof['remaining']
  page += 1
end

p '------------ DONE -------------'
