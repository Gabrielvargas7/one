class NotificationsController < ApplicationController
  before_filter :signed_in_user,
                only:[:destroy,
                      :index,
                      :show,
                      :new,
                      :edit,
                      :update,
                      :create
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


  # GET /notifications
  # GET /notifications.json
  def index
    @notifications = Notification.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @notifications }
    end
  end

  # GET /notifications/1
  # GET /notifications/1.json
  def show
    @notification = Notification.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @notification }
    end
  end

  # GET /notifications/new
  # GET /notifications/new.json
  def new

    @notification = Notification.new
    @current_user =  current_user

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @notification }
    end
  end

  # GET /notifications/1/edit
  def edit
    @notification = Notification.find(params[:id])
  end

  # POST /notifications
  # POST /notifications.json
  def create
    @notification = Notification.new(params[:notification])

    respond_to do |format|
      ActiveRecord::Base.transaction do
        begin

          @notification.save
          # after save, we can get the id
          users_notification_conditions ="notification_id = "+@notification.id.to_s+" ,notified = 'n'"

          UsersNotification.update_all(users_notification_conditions)

          format.html { redirect_to @notification, notice: 'Notification was successfully created and update all the users  with the new notification.' }
        rescue
          format.html { render action: "new" }
        end
      end

    end
  end

  # PUT /notifications/1
  # PUT /notifications/1.json
  def update
    @notification = Notification.find(params[:id])

    respond_to do |format|
      if @notification.update_attributes(params[:notification])
        format.html { redirect_to @notification, notice: 'Notification was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @notification.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /notifications/1
  # DELETE /notifications/1.json
  def destroy
    #@notification = Notification.find(params[:id])
    #@notification.destroy

    respond_to do |format|
      format.html { redirect_to notifications_url }
      format.json { head :no_content }
    end
  end

  #***********************************
  # Json methods for the room users
  #***********************************

  # Get all notification
  # GET 'notifications/json/index_notification_by_limit_by_offset.json'
  #Return head 200 OK
  def json_index_notification_by_limit_by_offset
    @notifications = Notification.order("updated_at desc").limit(params[:limit]).offset(params[:offset])
    respond_to do |format|
      format.json { render json: @notifications }
    end
  end



end
