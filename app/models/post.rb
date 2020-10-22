class Post < ActiveRecord::Base

  validate :is_title_case 
  before_validation :make_title_case 
  belongs_to :author

  #put new code here

  private

  def is_title_case
    if title.split.any?{|w|w[0].upcase != w[0]}
      errors.add(:title, "Title must be in title case")
    end
  end

  def make_title_case
    self.title = self.title.titlecase
  end

  def self.by_author(author_id)
    where(author: author_id)
  end

  def index
    # provide a list of authors to the view for the filter control
    @authors = Author.all
   
    # filter the @posts list based on user input
    if !params[:author].blank?
      @posts = Post.by_author(params[:author])
    elsif !params[:date].blank?
      if params[:date] == "Today"
        @posts = Post.from_today
      else
        @posts = Post.old_news
      end
    else
      # if no filters are applied, show all posts
      @posts = Post.all
    end
  end

  def self.from_today
    where("created_at >=?", Time.zone.today.beginning_of_day)
  end
    
  def self.old_news
    where("created_at <?", Time.zone.today.beginning_of_day)
  end
end
