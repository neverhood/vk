class Authenticated::PhotosController < Authenticated::BaseController
  before_filter :find_photo!, only: [ :destroy ]
  before_filter :find_group!, only: [ :index ]

  def destroy
    @photo.destroy
  end

  def create
    server_details = current_user_vk.photos.get_wall_upload_server
    file_path      = Rails.root.join('public', 'uploads', photo_params.original_filename).to_s

    begin
      with_temporary_file file_path, photo_params.open.read do
        uploaded_photo_details = VkontakteApi.upload(url: server_details[:upload_url], photo: [ file_path, photo_params.content_type ])
        saved_photo_details    = current_user_vk.photos.save_wall_photo(uploaded_photo_details).first

        @photo = current_user.photos.create(urls: saved_photo_details.slice(:src, :src_big, :src_small, :src_xbig),
                                            info: saved_photo_details.slice(:id, :owner_id, :pid, :aid))
      end

      render json: { photo: render_to_string(partial: 'photo', locals: { photo: @photo }) }, status: 202
    rescue
      render json: { error: I18n.t('flash.authenticated.photos.create.alert') }, status: 422
    end
  end

  def index
    @group
  end

  private

  def find_photo!
    @photo = current_user.photos.find(params[:id])
  end

  def find_group!
    @group = current_user.groups.find(params[:group_id])
  end

  def photo_params
    params.require(:photo)[:image]
  end

  def with_temporary_file path, content
    File.open(path, 'w') { |file| file.write content }
    yield
    File.delete path
  end
end
