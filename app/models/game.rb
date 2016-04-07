class Game < ActiveRecord::Base
  belongs_to :creator, class_name: :User, foreign_key: :creator_id
  has_many :game_attendees, dependent: :destroy
  has_many :attendees, through: :game_attendees, source: :user, dependent: :destroy
  has_many :posts, dependent: :destroy
  geocoded_by :address
  after_validation :geocode

  validates :date, presence: true
  validates :sport, presence: true
  validates :skill_level, presence: true
  
  scope :future, -> { select { |x| x if x.date > DateTime.now }}
  scope :by_date, -> { order(:date) }
  scope :sport_options, -> {sports.collect{|x| [x[:name],x[:id]] }}
  scope :skill_options, -> {skills.collect{|x| [x[:name],x[:id]] }}
  @@skills_list = [
    {
      id: 1,
      name: 'Beginner'
    },
    {
      id: 2,
      name: 'Intermediate'
    },
    {
      id: 3,
      name: 'Advanced'
    },
    {
      id: 4,
      name: 'We Wish We Were Pro'
    }
  ]

  def self.skills
    @@skills_list
  end

  def skill
    @@skills_list[self.skill_level-1][:name]
  end

  @@sports = [
    {
      id: 1,
      name: 'Basketball'
    },
    {
      id: 2,
      name: 'Baseball'
    },
    {
      id: 3,
      name: 'Kickball'
    },
    {
      id: 4,
      name: 'Hockey'
    },
    {
      id: 5,
      name: 'Soccer'
    }
  ]

  def self.sports
    @@sports
  end

  def sport_name
    @@sports[self.sport-1][:name]
  end

  def display_time
    self.date.strftime('%a %b %e, %l:%M %p')
  end
  
end
