class FeedbacksController < ApplicationController

  before_filter :signed_in_user,
                only:[:destroy,
                      :index,
                      :show,
                      :new,
                      :edit,
                      :update,
                      :create

                ]

  before_filter :json_signed_in_user,
                only:[
                ]

  before_filter :admin_user,
                only:[:destroy,
                      :index,
                      :show,
                      :new,
                      :edit,
                      :update,
                      :create

                ]



  # GET /feedbacks
  # GET /feedbacks.json
  def index
    @feedbacks = Feedback.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @feedbacks }
    end
  end

  # GET /feedbacks/1
  # GET /feedbacks/1.json
  def show
    @feedback = Feedback.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @feedback }
    end
  end

  # GET /feedbacks/new
  # GET /feedbacks/new.json
  def new
    @feedback = Feedback.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @feedback }
    end
  end

  # GET /feedbacks/1/edit
  def edit
    @feedback = Feedback.find(params[:id])
  end

  # POST /feedbacks
  # POST /feedbacks.json
  def create
    @feedback = Feedback.new(params[:feedback])

    respond_to do |format|
      if @feedback.save
        format.html { redirect_to @feedback, notice: 'Feedback was successfully created.' }
        format.json { render json: @feedback, status: :created, location: @feedback }
      else
        format.html { render action: "new" }
        format.json { render json: @feedback.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /feedbacks/1
  # PUT /feedbacks/1.json
  def update
    @feedback = Feedback.find(params[:id])

    respond_to do |format|
      if @feedback.update_attributes(params[:feedback])
        format.html { redirect_to @feedback, notice: 'Feedback was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @feedback.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /feedbacks/1
  # DELETE /feedbacks/1.json
  def destroy
    @feedback = Feedback.find(params[:id])
    @feedback.destroy

    respond_to do |format|
      format.html { redirect_to feedbacks_url }
      format.json { head :no_content }
    end
  end


  #***********************************
  # Json methods for the room users
  #***********************************

  # POST set new feedback - all option are optional
  # POST /feedbacks/json/create_feedback
  # POST /feedbacks/json/create_feedback.json
  # Form Parameters:
  #                :description
  #                :email   (optional)
  #                :name    (optional)
  #                :user_id (optional)
  #Return head
  #success    ->  head  201 create

  def json_create_feedback

    @feedback = Feedback.new()
    @feedback.name = params[:name] unless params[:name].nil?
    @feedback.email = params[:email] unless params[:email].nil?
    @feedback.description = params[:description] unless params[:description].nil?
    @feedback.user_id = params[:user_id] unless params[:user_id].nil?

    respond_to do |format|
      if @feedback.save
        format.json { render json: @feedback, status: :created, location: @feedback }
      else
        format.json { render json: @feedback.errors, status: :unprocessable_entity }
      end
    end
  end



end
