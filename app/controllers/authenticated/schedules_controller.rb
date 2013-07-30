class Authenticated::SchedulesController < Authenticated::BaseController
  before_filter :find_schedule!, only: [ :destroy, :update ]
  before_filter :find_post!, only: [ :create, :index ]

  def index
    @schedules = @post.schedules

    render json: { schedules: render_to_string(partial: 'schedule', collection: @schedules) }, status: 200
  end

  def create
    @schedule = @post.schedules.create(schedule_params)

    respond_to do |format|
      if @schedule.persisted?
        format.html { redirect_to group_path(@post.group), notice: I18n.t('flash.authenticated.schedules.create.notice') }
        format.json { render json: { entry: render_to_string(partial: 'schedule', locals: { schedule: @schedule }) }, status: 202 }
      else
        format.html { redirect_to group_path(@post.group), alert: I18n.t('flash.authenticated.schedules.create.alert') }
        format.json { render json: { errors: @schedule.errors }, status: 422 }
      end
    end
  end

  def destroy
    @schedule.destroy

    respond_to do |format|
      format.html { redirect_to posts_path, notice: I18n.t('flash.authenticated.schedules.destroy.notice') }
      format.json { render nothing: true, status: 202 }
    end
  end

  def update
    # publish now!
  end

  private

  def find_schedule!
    @schedule = current_user.schedules.find(params[:id])
  end

  def find_post!
    @post = if action_name == 'index'
              @post = current_user.posts.find(params[:id])
            else
              @post = current_user.posts.find(schedule_params[:post_id])
            end
  end

  def schedule_params
    params.require(:schedule).permit(:post_at_date, :post_at_time, :post_id).tap do |attrs|
      if attrs[:post_at_date].present? and attrs['post_at_time(4i)'].present? and attrs['post_at_time(5i)'].present?
        month, day, year = attrs.delete(:post_at_date).split('/')

        attrs['post_at(1i)'], attrs['post_at(2i)'], attrs['post_at(3i)'], attrs['post_at(4i)'], attrs['post_at(5i)'] = year, month, day, attrs['post_at_time(4i)'], attrs['post_at_time(5i)']
        attrs.delete_if { |key, value| key =~ /post_at_time/ }
      else
        attrs.delete_if { |key, value| key =~ /post_at/ }
        attrs[:post_at] = Time.now
      end
    end
  end
end
