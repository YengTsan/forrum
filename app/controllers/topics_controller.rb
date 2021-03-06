class TopicsController < ApplicationController

  before_action :authenticate_user!, :except => [:index, :show]

  def index
    case params[ :order ]
    when "last_time"
      @topics = Topic.sorted_by_lasted_updated 
    when "num_of_comments"
      @topics = Topic.sorted_by_number_of_comments
    when "capital"
      @topics = Topic.sorted_by_topic_capital
    else
      @topics = Topic.all
    end
  end

  def new
    @topic = Topic.new
  end

  def create
    @topic = Topic.new( topic_params )
    @topic.user = current_user
    @topic.save

    redirect_to topics_path
  end

  def show
    @topic = Topic.find( params[:id] )
    @comments = Comment.find_comments_by_topic_id( params[:id] ) # 可以撈到這篇文章所有comments
    @comment = Comment.new # 可以在這個頁面直接創造一個新的comment
    @liked_users = LikeTopic.where( :topic_id => @topic ).map {|i| i.user}
  end

  def destroy
    @topic = Topic.find ( params[:id] )
    @topic.destroy
    redirect_to :back
  end

  def about
  end

  def user_profile
    @topics = current_user.topics
    @comments = current_user.comments
    @likes_topics = LikeTopic.where( :user => current_user ).map {|l| l.topic} # find the names of the topics liked by current_user
  end

  protected

  def topic_params
    params.require( :topic ).permit( :name, :content, :user_id , { :category_ids => [] }, :pic, :bootsy_image_gallery_id)
  end

end
